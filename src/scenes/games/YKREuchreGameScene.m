//
//  YKREuchreScene.m
//  Yookr
//
//  Created by Bill Doyle on 2014-03-20.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import "YKREuchreGameScene.h"

@implementation YKREuchreGameScene

- (void)update:(NSTimeInterval)currentTime
{
    
}

- (void)didMoveToView:(SKView *)view
{
    
}

#pragma mark - Plumbing

- (id)initWithSize:(CGSize)size
{
    if (!(self = [super initWithSize:size])) return nil;
    
    NSLog(@"%lf, %lf", size.width, size.height);
    [self setBackgroundColor:[SKColor colorWithRed:0.10 green:0.56 blue:0.20 alpha:1.0]];
    SKSpriteNode * card = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
    [card setSize:CGSizeMake(209, 304)];
    [card setPosition:CGPointMake(0, 0)];
    //[self addChild:card];
    
    SKLabelNode * myLabel = [SKLabelNode labelNodeWithFontNamed:@"Cochin"];
    [myLabel setText:@"Digital Deck"];
    [myLabel setFontSize:48.0];
    [myLabel setPosition:CGPointMake(-1, -1)];
    [myLabel setFontColor:[UIColor whiteColor]];
    [self addChild:myLabel];
    
    return self;
}

@end
