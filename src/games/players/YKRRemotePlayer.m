//
//  YKRRemotePlayer.m
//  Yookr
//
//  Created by Bill Doyle on 2014-02-24.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import "YKRRemotePlayer.h"


@implementation YKRRemotePlayer
@synthesize socket, remoteDelegate;

- (void)updateProperties:(NSDictionary *)someProperties
{
    [super updateProperties:someProperties];
    [[self remoteDelegate] updateProperties:someProperties ofRemotePlayer:self];
}

#pragma mark - Plumbing

- (instancetype)initWithName:(NSString *)aName andSocket:(GCDAsyncSocket *)aSocket
{
    if (!(self = [super initWithName:aName])) return nil;
    
    socket = aSocket;
    
    return nil;
}

@end
