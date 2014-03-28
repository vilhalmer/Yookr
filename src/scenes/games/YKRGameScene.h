//
//  YKRGameScene.h
//  Yookr
//
//  Created by Bill Doyle on 2014-03-24.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import "YKRScene.h"
#import "YKRSceneButton.h"
#import "YKRCardNode.h"

@class YKRGame;
@class YKRPlayer;


@interface YKRGameScene : YKRScene
/** @abstract **/

@property (readwrite, weak) YKRGame * game;
@property (readwrite, weak) YKRPlayer * localPlayer;

- (void)gameUpdated:(NSNotification *)aNotification;
/** Override this to handle notifications about the game's properties changing. **/
- (void)playerUpdated:(NSNotification *)aNotification;
/** Override this to handle notifications about the localPlayer's properties changing. **/

- (id)init;
/** @throws NOPE: This is an abstract class. **/

@end
