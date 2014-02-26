//
//  YKRScene.h
//  Yookr
//
//  Created by Bill Doyle on 2014-02-15.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "YKRMainViewController.h"

@interface YKRScene : SKScene

@property (readwrite, weak) YKRMainViewController * viewController;

- (UIInterfaceOrientationMask)sceneOrientation;

@end
