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
}

- (void)beginScanningForSessions
{
    [serviceBrowser searchForServicesOfType:@"_yookr._tcp." inDomain:@"local."];
}

- (void)stopScanningForSessions
{
    [serviceBrowser stop];
}

- (NSArray *)availableSessions
{
    return [availableSessions copy];
}

#pragma mark - NSNetServiceBrowserDelegate methods

- (void)netServiceBrowserWillSearch:(NSNetServiceBrowser *)aNetServiceBrowser
{
    NSLog(@"commencing to be look for thing");
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)sender didNotSearch:(NSDictionary *)errorInfo
{
	NSLog(@"FUCK");
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
        if ([aSession isEqualToService:netService]) {
            [availableSessions removeObject:aSession];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"YKRSessionManager_removeSession" object:self];
            break;
        }
    }
}

- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)sender
{
	NSLog(@"search ended");
}

- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict
{
	NSLog(@"couldn't resolve, server is probably dead");
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
