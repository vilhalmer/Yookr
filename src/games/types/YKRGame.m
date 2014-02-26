//
//  YKRGame.m
//  Yookr
//
//  Created by Bill Doyle on 2014-02-20.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import "YKRGame.h"

@implementation YKRGame
{
    NSMutableArray * players;
}

+ (NSString *)typeName
{
    return @"OVERRIDE ME YOU IDIOT";
}

- (void)addPlayer:(YKRPlayer *)aPlayer
{
    [players addObject:aPlayer];
}

- (void)removePlayer:(YKRPlayer *)aPlayer
{
    [players removeObject:aPlayer];
}

- (id)init
/// @throws NSException: This is an abstract class.
{
    @throw [NSException exceptionWithName:@"NOPE" reason:@"NOPE" userInfo:nil];
}

@end
