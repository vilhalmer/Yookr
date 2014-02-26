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


@implementation YKRServer
{
    GCDAsyncSocket * serverSocket;
    NSMutableArray * clientSockets;
    NSNetService * service;
    
    NSInteger retries;
    
    YKRGame * game;
}

- (BOOL)startServerWithGame:(YKRGame *)aGame error:(NSError * __autoreleasing *)maybeError
{
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
    return dispatch_get_main_queue();
}

- (void)socket:(GCDAsyncSocket *)aSocket didAcceptNewSocket:(GCDAsyncSocket *)newSocket
/// This is where we initially process clients as they attach. The rest is in socket:didReadData:port:.
{
    NSLog(@"Accepted New Socket from %@:%hu", [newSocket connectedHost], [newSocket connectedPort]);
    [clientSockets addObject:newSocket];
    [newSocket readDataToLength:(17 * sizeof(Byte)) withTimeout:5.0 tag:1];
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    YKRPacket * packet = [[YKRPacket alloc] initWithEncodedData:data];
    if (tag == 1) { // This should be a "Hello" type packet.
        NSLog(@"%@", packet);
    }
}

- (void)socket:(GCDAsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    
}

- (void)socket:(GCDAsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    
}

- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutReadWithTag:(long)tag
                 elapsed:(NSTimeInterval)elapsed
               bytesDone:(NSUInteger)length
{
    return 0;
}

- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutWriteWithTag:(long)tag
                 elapsed:(NSTimeInterval)elapsed
               bytesDone:(NSUInteger)length
{
    return 0;
}

- (void)socketDidCloseReadStream:(GCDAsyncSocket *)sock
{
    
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
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
    
    return self;
}

@end
