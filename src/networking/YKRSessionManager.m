//
//  YKRSessionManager.m
//  Yookr
//
//  Created by Bill Doyle on 2014-02-15.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import "YKRSessionManager.h"

@implementation YKRSessionManager
{
    NSMutableArray * availableSessions;
    NSNetServiceBrowser * serviceBrowser;
    
    NSMutableArray * resolvingSessions;
    
    BOOL searching;
}

- (void)beginScanningForSessions
{
    [serviceBrowser searchForServicesOfType:@"_DigitalDeck._tcp." inDomain:@""];
}

- (void)stopScanningForSessions
{
    [serviceBrowser stop];
}

- (NSArray *)availableSessions
{
    return [availableSessions copy];
}

- (NSArray *)availableSessionsOfType:(NSString *)gameType
/// @todo: This is horrible and I should feel horrible.
{
    NSMutableArray * sessions = [NSMutableArray array];
    for (YKRSession * aSession in availableSessions) {
        if ([[aSession gameType] isEqualToString:gameType]) {
            [sessions addObject:aSession];
        }
    }
    
    return sessions;
}

#pragma mark - NSNetServiceBrowserDelegate methods

- (void)netServiceBrowserWillSearch:(NSNetServiceBrowser *)aNetServiceBrowser
{
    searching = YES;
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)sender didNotSearch:(NSDictionary *)errorInfo
{
	NSLog(@"FUCK");
    NSLog(@"%@", errorInfo);
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)sender
           didFindService:(NSNetService *)netService
               moreComing:(BOOL)moreServicesComing
{
    [resolvingSessions addObject:netService];
    [netService setDelegate:self];
    [netService resolveWithTimeout:5.0];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)sender
         didRemoveService:(NSNetService *)netService
               moreComing:(BOOL)moreServicesComing
{
	for (YKRSession * aSession in availableSessions) {
        /// @todo: This is extremely inefficient.
        if ([aSession isEqualToService:netService]) {
            [availableSessions removeObject:aSession];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"YKRSessionManager_removeSession" object:self];
            break;
        }
    }
}

- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)sender
{
    searching = NO;
}

- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict
{
    [resolvingSessions removeObject:sender];
}

- (void)netServiceDidResolveAddress:(NSNetService *)sender
{
    [resolvingSessions removeObject:sender];
    
    YKRSession * newSession = [[YKRSession alloc] initWithService:sender];
    if ([availableSessions containsObject:newSession]) return;
    
    [availableSessions addObject:newSession];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"YKRSessionManager_newSession" object:self];
}

#pragma mark - Plumbing

+ (id)sharedSessionManager
{
    static dispatch_once_t pred;
    static YKRSessionManager * sharedInstance = nil;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    if (!(self = [super init])) return nil;
    
    availableSessions = [NSMutableArray array];
    resolvingSessions = [NSMutableArray array];
    
    serviceBrowser = [[NSNetServiceBrowser alloc] init];
	[serviceBrowser setDelegate:self];
    
    return self;
}

@end
