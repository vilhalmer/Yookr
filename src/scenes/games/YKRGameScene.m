//
//  YKRGameScene.m
//  Yookr
//
//  Created by Bill Doyle on 2014-03-24.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import "YKRGameScene.h"
#import "YKRGame.h"

@implementation YKRGameScene
@synthesize game, localPlayer;

- (void)gameUpdated:(NSNotification *)aNotification
{
    // Redraw pile
}

- (void)playerUpdated:(NSNotification *)aNotification
{
    // Redraw hand
}

#pragma mark - Plumbing

- (UIInterfaceOrientationMask)sceneOrientation
{
    return UIInterfaceOrientationMaskLandscape;
}

- (id)init
{
    if ([self isMemberOfClass:[YKRGame class]]) {
        @throw [NSException exceptionWithName:@"NOPE" reason:@"NOPE" userInfo:nil];
    }
    
    if (!(self = [super init])) return nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gameUpdated:)
                                                 name:@"YKRGame_performedAction"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerUpdated:)
                                                 name:@"YKRPlayer_updatedProperties"
                                               object:nil];
    
    return self;
}

@end
