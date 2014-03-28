//
//  YKRWarGame.m
//  Yookr
//
//  Created by Bill Doyle on 2014-03-28.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import "YKRWarGame.h"

@implementation YKRWarGame

- (NSDictionary *)processAction:(NSDictionary *)anAction
{
    /// @todo: Write some logic!
    return nil;
}

#pragma mark - Info

+ (NSString *)typeName
{
    return @"War";
}

+ (BOOL)variableGameSize
{
    return NO;
}

- (void)setGameSize:(NSUInteger)aGameSize
{
    NSLog(@"Attempted to set game size on War game");
}

- (id)init
{
    if (!(self = [super init])) return nil;
    
    gameSize = 2;
    
    return self;
}

@end
