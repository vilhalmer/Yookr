//
//  YKREuchreGame.m
//  Yookr
//
//  Created by Bill Doyle on 2014-02-20.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import "YKREuchreGame.h"


@implementation YKREuchreGame

- (NSDictionary *)processAction:(NSDictionary *)anAction
{
    /// @todo: Write some logic!
    return nil;
}

#pragma mark - Info

+ (NSString *)typeName
{
    return @"Euchre";
}

+ (BOOL)variableGameSize
{
    return NO;
}

- (void)setGameSize:(NSUInteger)aGameSize
{
    NSLog(@"Attempted to set game size on Euchre game");
}

- (id)init
{
    if (!(self = [super init])) return nil;
    
    gameSize = 4;
    
    return self;
}

@end
