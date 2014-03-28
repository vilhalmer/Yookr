//
//  YKRClient.m
//  Yookr
//
//  Created by Bill Doyle on 2014-03-20.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import "YKRClient.h"
#import "GCDAsyncSocket.h"
#import "YKRPacket.h"
#import "YKRGame.h"


static NSUInteger tag_writeHello   = 1;
static NSUInteger tag_writeGoodbye = 2;
static NSUInteger tag_writeJSON    = 3;

static NSUInteger tag_readHeader  = 8;
static NSUInteger tag_readPayload = 9;

static NSInteger read_timeout  = -1;
static NSInteger write_timeout = -1;
static NSInteger connect_timeout = 15000;


@implementation YKRClient
{
    YKRSession * session;
    GCDAsyncSocket * socket;
    
    YKRPacket * previousPacket;
    YKRPacket * currentPacket;
}
@synthesize game, localPlayer;

- (void)connect
{
    if (socket && [socket isConnected]) return;
    
    socket = [[GCDAsyncSocket alloc] initWithDelegate:self
                                        delegateQueue:dispatch_get_main_queue()
                                          socketQueue:NULL];
    
    NSError * maybeError;
    [socket connectToAddress:[session sockaddr] withTimeout:connect_timeout error:&maybeError];
    
    if (maybeError) {
        NSLog(@"connect: %@", maybeError);
    }
}

- (void)disconnect
{
    NSError * __autoreleasing maybeError;
    YKRPacket * goodbye = [[YKRPacket alloc] initWithDictionary:nil
                                                           type:YKRPacketTypeGoodbye
                                                       andFlags:YKRPacketFlagsNone
                                                 returningError:&maybeError];
    if (maybeError) {
        NSLog(@"disconnect: %@", maybeError);
        NSLog(@"Forcing socket closed.");
        [self closeSocket];
        return;
    }
    
    NSData * goodbyeData = [goodbye encodedData];
    [socket writeData:goodbyeData withTimeout:write_timeout tag:tag_writeGoodbye];
}

- (void)closeSocket
{
    [socket disconnectAfterReadingAndWriting];
}

- (void)joinGame
{
    NSError * maybeError;
    YKRPacket * addSelfPacket = [[YKRPacket alloc] initWithDictionary:@{@"addPlayer" : [[NSUserDefaults standardUserDefaults] objectForKey:@"username"]}
                                                                 type:YKRPacketTypeJSON
                                                             andFlags:YKRPacketFlagsNone
                                                       returningError:&maybeError];
    if (maybeError) {
        NSLog(@"joinGame: %@", maybeError);
        return;
    }
    
    [socket writeData:[addSelfPacket encodedData] withTimeout:write_timeout tag:tag_writeJSON];
}

- (void)leaveGame
{
    NSError * maybeError;
    YKRPacket * addSelfPacket = [[YKRPacket alloc] initWithDictionary:@{@"addPlayer" : [[NSUserDefaults standardUserDefaults] objectForKey:@"username"]}
                                                                 type:YKRPacketTypeJSON
                                                             andFlags:YKRPacketFlagsNone
                                                       returningError:&maybeError];
    if (maybeError) {
        NSLog(@"leaveGame: %@", maybeError);
        return;
    }
    
    [socket writeData:[addSelfPacket encodedData] withTimeout:write_timeout tag:tag_writeJSON];
}

#pragma mark - GCDAsyncSocket delegate methods

- (void)socket:(GCDAsyncSocket *)aSocket didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"Connected!");
    /*
    YKRPacket * hello = [[YKRPacket alloc] initWithDictionary:nil
                                                         type:YKRPacketTypeHello
                                                     andFlags:YKRPacketFlagsNone
                                               returningError:&maybeError];
    NSData * helloData = [hello encodedData];
    
    if (maybeError) {
        NSLog(@"Couldn't encode HELLO, giving up.");
        [self disconnect];
        return;
    }
    
    [socket writeData:helloData withTimeout:write_timeout tag:tag_writeHello];
     */
    /// @todo: This shouldn't happen here, but has to until we rearrange the order data is sent from the server.
    [self joinGame];
    
    // Start the read loop:
    [socket readDataToLength:(packet_length * sizeof(Byte)) withTimeout:read_timeout tag:tag_readHeader];
}

- (void)socket:(GCDAsyncSocket *)aSocket didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"read data: %@", data);
    NSError * __autoreleasing maybeError;
    
    if (tag == tag_readHeader) {
        previousPacket = currentPacket;
        currentPacket = [[YKRPacket alloc] initWithHeader:data returningError:&maybeError];
        
        if (maybeError) {
            NSLog(@"Received a broken packet!");
            NSLog(@"%@", maybeError);
            return;
        }
        
        NSLog(@"read header: %@", currentPacket);
        
        [socket readDataToLength:[[currentPacket payloadLength] integerValue]
                     withTimeout:read_timeout
                             tag:tag_readPayload];
    }
    else if (tag == tag_readPayload) {
        [currentPacket setPayload:data returningError:&maybeError];
        if (maybeError) {
            NSLog(@"Something went wrong setting the payload of the Packet.");
            NSLog(@"%@", maybeError);
            return;
        }
        
        // So we now have a complete packet object, and can play with the messages inside!
        NSLog(@"read payload: %@", currentPacket);
        NSDictionary * payload = [currentPacket dictionary];
        if ([payload[@"target"] isEqualToString:@"player"]) {
            [localPlayer updateProperties:payload[@"properties"]];
        }
        else if ([payload[@"target"] isEqualToString:@"game"]) {
            if (payload[@"addPlayer"]) {
                [game addPlayer:[[YKRPlayer alloc] initWithName:payload[@"addPlayer"]]];
            }
            
            if (payload[@"removePlayer"]) {
                YKRPlayer * player = [game playerNamed:payload[@"removePlayer"]];
                [game removePlayer:player];
            }
            
            if (payload[@"properties"]) {
                [game updateProperties:payload[@"properties"]];
            }
            
            if (payload[@"start"]) {
                
            }
        }
        
        [socket readDataToLength:(packet_length * sizeof(Byte))
                     withTimeout:read_timeout
                             tag:tag_readHeader];
    }
}

- (void)socket:(GCDAsyncSocket *)aSocket didWriteDataWithTag:(long)tag
{
    NSLog(@"wrote data");
    if (tag == tag_writeGoodbye) {
        [self closeSocket];
    }
}

- (NSTimeInterval)socket:(GCDAsyncSocket *)aSocket shouldTimeoutReadWithTag:(long)tag
                 elapsed:(NSTimeInterval)elapsed
               bytesDone:(NSUInteger)length
{
    return 0;
}

- (NSTimeInterval)socket:(GCDAsyncSocket *)aSocket shouldTimeoutWriteWithTag:(long)tag
                 elapsed:(NSTimeInterval)elapsed
               bytesDone:(NSUInteger)length
{
    NSLog(@"write timed out");
    if (tag == tag_writeGoodbye) {
        NSLog(@"Writing GOODBYE timed out, closing socket anyway.");
        [self closeSocket];
    }
    
    return 0;
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)aSocket withError:(NSError *)error
{
    if (error) {
        NSLog(@"probably timed out trying to connect.");
    }
    
    [socket setDelegate:nil];
}

#pragma mark - Remote game delegate methods

- (void)performAction:(NSDictionary *)anAction
{
    NSError * maybeError;
    YKRPacket * packet = [[YKRPacket alloc] initWithDictionary:anAction
                                                          type:YKRPacketTypeJSON
                                                      andFlags:YKRPacketFlagsNone
                                                returningError:&maybeError];
    
    if (maybeError) {
        NSLog(@"performAction: %@", maybeError);
        return;
    }
    
    [socket writeData:[packet encodedData] withTimeout:write_timeout tag:tag_writeJSON];
}

#pragma mark - Networking methods

- (BOOL)isHostingGame
{
    return YES;
}

#pragma mark - Plumbing

- (instancetype)initWithSession:(YKRSession *)aSession
{
    if (!(self = [super init])) return nil;
    
    session = aSession;
    
    return self;
}

@end
