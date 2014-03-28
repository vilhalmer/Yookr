//
//  YKRRemoteGame.m
//  Yookr
//
//  Created by Bill Doyle on 2014-03-22.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import "YKRRemoteGame.h"
#import "NSDictionary+Integrate.h"


@implementation YKRRemoteGame
@synthesize remoteDelegate;

- (void)updateProperties:(NSDictionary *)someProperties
{
    properties = [[properties dictionaryByIntegratingDictionary:someProperties] mutableCopy];
    // This notification is sent from here instead of performAction: on RemoteGames, because we don't know the
    // consequences of actions until the real Game calls us back with updated state.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"YKRGame_performedAction" object:self];
}

- (void)performAction:(NSDictionary *)someAction
{
    [[self remoteDelegate] performAction:someAction];
}

+ (NSString *)typeName
{
    return @"Remote Game";
}

@end
