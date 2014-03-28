//
//  YKRServer.m
//  Yookr
//
//  Created by Bill Doyle on 2014-02-24.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import "YKRServer.h"
#import "YKRPacket.h"
#import "YKRRemotePlayer.h"


static NSUInteger tag_writeHello   = 1;
static NSUInteger tag_writeGoodbye = 2;
static NSUInteger tag_writeJSON    = 3;

static NSUInteger tag_readHeader  = 8;
static NSUInteger tag_readPayload = 9;

static NSInteger read_timeout  = -1;
static NSInteger write_timeout = -1;

@implementation YKRServer
{
    GCDAsyncSocket * serverSocket;
    dispatch_queue_t socketQueue;
    NSMutableArray * clientSockets;
    NSNetService * service;
    
    NSMapTable * currentPackets;
    NSMapTable * previousPackets;
    
    NSInteger retries;
    
    YKRGame * game;
}

- (BOOL)startServerWithGame:(YKRGame *)aGame error:(NSError * __autoreleasing *)maybeError
{
    game = aGame;
    [game setDelegate:self];
    
    // Set up the socket:
    serverSocket = [[GCDAsyncSocket alloc] initWithDelegate:self
                                              delegateQueue:dispatch_get_main_queue()];
    [serverSocket acceptOnPort:0 error:maybeError];
    if (maybeError) return NO;
    
    [self startBroadcasting];
    
    return YES;
}

- (void)stopServer
/// @todo: Clean up, send GOODBYE to all clients.
{
    [self stopBroadcasting];
    [serverSocket disconnect];
    serverSocket = nil;
}

- (void)startBroadcasting
/// Broadcasts the server's availability using Bonjour.
{
    if (service) return;
    
    service = [[NSNetService alloc] initWithDomain:@"local."
                                              type:@"_DigitalDeck._tcp."
                                              name:nil
                                              port:[serverSocket localPort]];
    
    NSDictionary * txtRecord = @{ @"hostUser"    : [[NSUserDefaults standardUserDefaults] objectForKey:@"username"],
                                  @"gameType"    : [[game class] typeName],
                                  @"playerCount" : @([game playerCount]),
                                  @"gameSize"    : @([game gameSize])
                                };
    [service setTXTRecordData:[NSNetService dataFromTXTRecordDictionary:txtRecord]];
    [service setDelegate:self];
    [service publish];
}

- (void)stopBroadcasting
/// Ends the availability broadcast.
{
    if (service) {
        [service stop];
        service = nil;
    }
}

#pragma mark - GCDAsyncSocket delegate methods

- (dispatch_queue_t)newSocketQueueForConnectionFromAddress:(NSData *)address onSocket:(GCDAsyncSocket *)socket
{
    if (!socketQueue) {
        socketQueue = dispatch_queue_create("co.unsquared.Yookr.serverSocketQueue", DISPATCH_QUEUE_SERIAL);
    }
    
    return socketQueue;
}

- (void)socket:(GCDAsyncSocket *)socket didAcceptNewSocket:(GCDAsyncSocket *)newSocket
/// This is where we initially process clients as they attach. The rest is in socket:didReadData:withTag:.
{
    NSLog(@"Accepted New Socket from %@:%hu", [newSocket connectedHost], [newSocket connectedPort]);
    [clientSockets addObject:newSocket];
    [newSocket readDataToLength:(packet_length * sizeof(Byte)) withTimeout:read_timeout tag:tag_readHeader];
}

- (void)socket:(GCDAsyncSocket *)socket didReadData:(NSData *)data withTag:(long)tag
{
    NSError * __autoreleasing maybeError;
    YKRPacket * currentPacket = [currentPackets objectForKey:socket];
    
    if (tag == tag_readHeader) {
        [previousPackets setObject:currentPacket forKey:socket];
        currentPacket = [[YKRPacket alloc] initWithHeader:data returningError:&maybeError];
        [currentPackets setObject:currentPacket forKey:socket];
        
        if (maybeError) {
            NSLog(@"Received a broken packet!");
            NSLog(@"%@", maybeError);
            return;
        }
        
        if ([currentPacket type] == YKRPacketTypeJSON) {
            /// @todo: I am going to hell for this control flow.
            [socket readDataToLength:[[currentPacket payloadLength] integerValue]
                         withTimeout:read_timeout
                                 tag:tag_readPayload];
            return;
        }
    }
    else if (tag == tag_readPayload) {
        [currentPacket setPayload:data returningError:&maybeError];
        if (maybeError) {
            NSLog(@"Something went wrong setting the payload of the Packet.");
            NSLog(@"%@", maybeError);
            return;
        }
        
        // So we now have a complete packet object, and can play with the messages inside!
        NSLog(@"%@", currentPacket);
        [game performAction:[currentPacket dictionary]];
        
    }
    
    [socket readDataToLength:(packet_length * sizeof(Byte)) withTimeout:read_timeout tag:tag_readHeader];
}

- (void)socket:(GCDAsyncSocket *)socket didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    
}

- (void)socket:(GCDAsyncSocket *)socket didWriteDataWithTag:(long)tag
{
    
}

- (void)socket:(GCDAsyncSocket *)socket didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    
}

- (NSTimeInterval)socket:(GCDAsyncSocket *)socket shouldTimeoutReadWithTag:(long)tag
                 elapsed:(NSTimeInterval)elapsed
               bytesDone:(NSUInteger)length
{
    return 0;
}

- (NSTimeInterval)socket:(GCDAsyncSocket *)socket shouldTimeoutWriteWithTag:(long)tag
                 elapsed:(NSTimeInterval)elapsed
               bytesDone:(NSUInteger)length
{
    return 0;
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)socket withError:(NSError *)err
{
    
}

#pragma mark - NSNetService delegate methods

- (void)netServiceDidPublish:(NSNetService *)sender
{
    NSLog(@"published");
}

- (void)netService:(NSNetService *)sender didNotPublish:(NSDictionary *)errorDict
{
    NSLog(@"shit's broke yo");
    NSLog(@"%@", errorDict);
}

#pragma mark - Networking methods

- (YKRGame *)game
{
    return game;
}

- (BOOL)isHostingGame
{
    return YES;
}

#pragma mark - Game delegate methods

- (void)game:(YKRGame *)aGame didUpdateProperties:(NSDictionary *)someProperties
{
    NSDictionary * payload = @{ @"target"     : @"game",
                                @"properties" : someProperties };
    
    NSError * maybeError;
    YKRPacket * packet = [[YKRPacket alloc] initWithDictionary:payload
                                                          type:YKRPacketTypeJSON
                                                      andFlags:YKRPacketFlagsNone
                                                returningError:&maybeError];
    
    if (maybeError) {
        NSLog(@"%@", maybeError);
        return;
    }
    
    // Send the updated game properties to all clients:
    for (GCDAsyncSocket * clientSocket in clientSockets) {
        [clientSocket writeData:[packet encodedData] withTimeout:write_timeout tag:tag_writeJSON];
    }
}

- (void)game:(YKRGame *)aGame addedPlayer:(YKRPlayer *)aPlayer
{
    NSDictionary * payload = @{ @"target" : @"game",
                                @"addPlayer" : [aPlayer name]};
    
    NSError * maybeError;
    YKRPacket * packet = [[YKRPacket alloc] initWithDictionary:payload
                                                          type:YKRPacketTypeJSON
                                                      andFlags:YKRPacketFlagsNone
                                                returningError:&maybeError];
    
    for (GCDAsyncSocket * clientSocket in clientSockets) {
        [clientSocket writeData:[packet encodedData] withTimeout:write_timeout tag:tag_writeJSON];
    }
}

- (void)game:(YKRGame *)aGame removedPlayer:(YKRPlayer *)aPlayer
{
    NSDictionary * payload = @{ @"target" : @"game",
                                @"removePlayer" : [aPlayer name]};
    
    NSError * maybeError;
    YKRPacket * packet = [[YKRPacket alloc] initWithDictionary:payload
                                                          type:YKRPacketTypeJSON
                                                      andFlags:YKRPacketFlagsNone
                                                returningError:&maybeError];
    
    for (GCDAsyncSocket * clientSocket in clientSockets) {
        [clientSocket writeData:[packet encodedData] withTimeout:write_timeout tag:tag_writeJSON];
    }
}

#pragma mark - Remote player delegate methods

- (void)updateProperties:(NSDictionary *)someProperties ofRemotePlayer:(YKRRemotePlayer *)aPlayer
{
    NSDictionary * payload = @{ @"target"     : @"player",
                                @"properties" : someProperties };
    
    NSError * maybeError;
    YKRPacket * packet = [[YKRPacket alloc] initWithDictionary:payload
                                                          type:YKRPacketTypeJSON
                                                      andFlags:YKRPacketFlagsNone
                                                returningError:&maybeError];
    
    if (maybeError) {
        NSLog(@"%@", maybeError);
        return;
    }
    
    /// @todo: Pull this out of the shipping version.
    if (![clientSockets containsObject:[aPlayer socket]]) {
        NSLog(@"GHOST SOCKET LOL AAAAAAAA");
        return;
    }
    
    [[aPlayer socket] writeData:[packet encodedData] withTimeout:write_timeout tag:tag_writeJSON];
}

#pragma mark - Plumbing

- (id)init
{
    if (!(self = [super init])) return nil;
    
    clientSockets = [NSMutableArray array];
    retries = 3;
    currentPackets = [NSMapTable weakToStrongObjectsMapTable];
    previousPackets = [NSMapTable weakToStrongObjectsMapTable];
    
    return self;
}

@end
