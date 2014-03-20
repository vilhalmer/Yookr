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


NSUInteger tag_read = 'READ';
NSUInteger tag_writeAcknowledge = 'ACKN';

NSUInteger timeout_write = 500;

@implementation YKRServer
{
    GCDAsyncSocket * serverSocket;
    NSMutableArray * clientSockets;
    NSNetService * service;
    
    NSData * ackData;
    
    NSInteger retries;
    
    YKRGame * __weak game;
}

- (BOOL)startServerWithGame:(YKRGame *)aGame error:(NSError * __autoreleasing *)maybeError
{
    game = aGame;
    
    // Set up the socket:
    serverSocket = [[GCDAsyncSocket alloc] initWithDelegate:self
                                              delegateQueue:dispatch_get_main_queue()];
    [serverSocket acceptOnPort:0 error:maybeError];
    if (maybeError) return NO;
    
    // Broadcast the server's availability:
    service = [[NSNetService alloc] initWithDomain:@"local."
                                              type:@"_DigitalDeck._tcp."
                                              name:[[NSUserDefaults standardUserDefaults] objectForKey:@"serviceName"]
                                              port:[serverSocket localPort]];
    [service setDelegate:self];
    [service publish];
    
    return YES;
}

- (void)stopServer
{
    [service stop];
    service = nil;
    [serverSocket disconnect];
    serverSocket = nil;
}

#pragma mark - GCDAsyncSocket delegate methods

- (dispatch_queue_t)newSocketQueueForConnectionFromAddress:(NSData *)address onSocket:(GCDAsyncSocket *)sock
{
    return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
}

- (void)socket:(GCDAsyncSocket *)aSocket didAcceptNewSocket:(GCDAsyncSocket *)newSocket
/// This is where we initially process clients as they attach. The rest is in socket:didReadData:port:.
{
    NSLog(@"Accepted New Socket from %@:%hu", [newSocket connectedHost], [newSocket connectedPort]);
    [clientSockets addObject:newSocket];
    [newSocket readDataToLength:(17 * sizeof(Byte)) withTimeout:5.0 tag:tag_read];
}

- (void)socket:(GCDAsyncSocket *)socket didConnectToHost:(NSString *)host port:(uint16_t)port
{
    
}

- (void)socket:(GCDAsyncSocket *)socket didReadData:(NSData *)data withTag:(long)tag
{
    NSError * maybeError;
    YKRPacket * packet = [[YKRPacket alloc] initWithEncodedData:data returningError:&maybeError];
    
    if (maybeError) {
        NSLog(@"Received a broken packet!");
        NSLog(@"%@", maybeError);
        return;
    }
    
    // Go ahead and acknowledge that we've received the packet:
    [socket writeData:ackData withTimeout:timeout_write tag:tag_writeAcknowledge];
    
    if ([packet type] == YKRPacketTypeHello) {
        NSLog(@"HELLO from %@", [socket connectedHost]);
    }
    if ([packet type] == YKRPacketTypeJSON) {
        NSLog(@"%@", packet);
    }
    if ([packet type] == YKRPacketTypeGoodbye) {
        NSLog(@"GOODBYE from %@", [socket connectedHost]);
        [clientSockets removeObject:socket];
    }
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

- (void)socketDidCloseReadStream:(GCDAsyncSocket *)sock
{
    
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)socket withError:(NSError *)err
{
    
}

- (void)socketDidSecure:(GCDAsyncSocket *)sock
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

#pragma mark - Plumbing

- (id)init
{
    if (!(self = [super init])) return nil;
    
    clientSockets = [NSMutableArray array];
    retries = 3;
    
    YKRPacket * ack = [[YKRPacket alloc] initWithDictionary:nil
                                                       type:YKRPacketTypeAcknowledge
                                                   andFlags:YKRPacketFlagsNone];
    NSError * maybeError;
    ackData = [ack encodeReturningError:&maybeError];
    if (maybeError) {
        NSLog(@"Unable to create ACK packet data. Couldn't create server.");
        return nil;
    }
    
    return self;
}

@end
