//
//  YKRSceneButton.h
//  Yookr
//
//  Created by Bill Doyle on 2014-02-15.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface YKRSceneButton : SKShapeNode

- (void)setTarget:(id)aTarget andAction:(SEL)anAction;

- (id)initWithFrame:(CGRect)aRect andTitle:(NSString *)aTitle;

@end
