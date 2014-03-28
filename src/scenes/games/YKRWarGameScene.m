//
//  YKRWarGameScene.m
//  Yookr
//
//  Created by Bill Doyle on 2014-03-28.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import "YKRWarGameScene.h"


@implementation YKRWarGameScene

- (void)update:(NSTimeInterval)currentTime
{
    
}

- (void)didMoveToView:(SKView *)view
{
    [self removeAllChildren];
    
    YKRSceneButton * playButton = [[YKRSceneButton alloc] initWithFrame:CGRectMake(CGRectGetMidX([self frame]), CGRectGetMidY([self frame]), 100, 40)
                                                               andTitle:@"Play"];
    YKRCardNode * leftCard = [[YKRCardNode alloc] initWithCardString:@"9C"];
    YKRCardNode * rightCard = [[YKRCardNode alloc] initWithCardString:@"KH"];
    
    [self addChild:playButton];
    [self addChild:leftCard];
    [self addChild:rightCard];
}

#pragma mark - Plumbing

- (id)init
{
    if (!(self = [super init])) return nil;
    
    return self;
}

@end
