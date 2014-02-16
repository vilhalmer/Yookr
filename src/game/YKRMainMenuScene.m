//
//  YKRMainMenuScene.m
//  Yookr
//
//  Created by Bill Doyle on 2014-02-12.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import "YKRMainMenuScene.h"
#import "YKRSceneButton.h"

@implementation YKRMainMenuScene
{
    YKRSceneButton * playButton;
    YKRSceneButton * settingsButton;
    YKRSceneButton * helpButton;
}

- (id)initWithSize:(CGSize)size
{
    if (!(self = [super initWithSize:size])) return nil;
    
    [self setBackgroundColor:[SKColor colorWithRed:0.10 green:0.56 blue:0.20 alpha:1.0]];
    
    SKLabelNode * myLabel = [SKLabelNode labelNodeWithFontNamed:@"Cochin"];
    [myLabel setText:@"YOOKR"];
    [myLabel setFontSize:48.0];
    [myLabel setPosition:CGPointMake(CGRectGetMidX([self frame]), CGRectGetMaxY([self frame]) - 100)];
    
    SKLabelNode * labelShadow = [myLabel copy];
    [labelShadow setFontColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5]];
    [labelShadow setPosition:CGPointMake([labelShadow position].x, [labelShadow position].y + 1)];
    
    [self addChild:labelShadow];
    [self addChild:myLabel];
    
    // Set up buttons:
    playButton = [[YKRSceneButton alloc] initWithFrame:CGRectMake(CGRectGetMidX([self frame]), CGRectGetMidY([self frame]), 200, 40) andTitle:@"Play"];
    [playButton setTarget:self andAction:@selector(displaySessions)];
    settingsButton = [[YKRSceneButton alloc] initWithFrame:CGRectMake(CGRectGetMidX([self frame]), CGRectGetMidY([self frame]) - 50, 200, 40) andTitle:@"Settings"];
    helpButton = [[YKRSceneButton alloc] initWithFrame:CGRectMake(CGRectGetMidX([self frame]), CGRectGetMidY([self frame]) - 100, 200, 40) andTitle:@"Help"];
    
    [self addChild:playButton];
    [self addChild:settingsButton];
    [self addChild:helpButton];
    
    return self;
}

- (void)displaySessions
{
    [[self viewController] performSegueWithIdentifier:@"segueToSessionTableViewController" sender:nil];
}

- (void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
}

@end
