//
//  YKRSceneButton.m
//  Yookr
//
//  Created by Bill Doyle on 2014-02-15.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import "YKRSceneButton.h"

@implementation YKRSceneButton
{
    NSInvocation * action;
    
    UITouch * currentTouch;
    CGPoint originalTouchLocation;
    SKAction * fadeIn;
}

- (void)setTarget:(id)aTarget andAction:(SEL)anAction
{
    action = [NSInvocation invocationWithMethodSignature:[aTarget methodSignatureForSelector:anAction]];
    [action setTarget:aTarget];
    [action setSelector:anAction];
}

#pragma mark - Touch handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch * touch in touches) {
        currentTouch = touch;
        originalTouchLocation = [touch locationInNode:self];
        [self setAlpha:0.5];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch * touch in touches) {
        if ([touch isEqual:currentTouch]) {
            NSInteger xDist = [touch locationInNode:self].x - originalTouchLocation.x;
            NSInteger yDist = [touch locationInNode:self].y - originalTouchLocation.y;
            CGFloat distance = abs(sqrt((xDist * xDist) + (yDist * yDist)));
            
            if (![self containsPoint:[touch locationInNode:self]] && distance > 70) { // Thanks, @zwaldowski!
                [self runAction:fadeIn];
            }
            else {
                [self setAlpha:0.5];
            }
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch * touch in touches) {
        if ([touch isEqual:currentTouch]) {
            NSInteger xDist = [touch locationInNode:self].x - originalTouchLocation.x;
            NSInteger yDist = [touch locationInNode:self].y - originalTouchLocation.y;
            CGFloat distance = abs(sqrt((xDist * xDist) + (yDist * yDist)));
            
            if ([self containsPoint:[touch locationInNode:self]] || distance < 70) { // Only perform action if they haven't dragged.
                [action invoke];
            }
            
            [self runAction:fadeIn];
            currentTouch = nil;
        }
    }
}

#pragma mark - Plumbing

- (id)initWithFrame:(CGRect)aRect andTitle:(NSString *)aTitle
{
    if (!(self = [super init])) return nil;
    
    fadeIn = [SKAction fadeInWithDuration:0.2];
    
    CGRect buttonRect = CGRectMake(0, 0, aRect.size.width, aRect.size.height); // Make the path's origin neutral.
    CGPathRef buttonPath = CGPathCreateWithRoundedRect(buttonRect, 8, 8, NULL);
    
    [self setPath:buttonPath];
    [self setLineWidth:1.0];
    [self setStrokeColor:[UIColor whiteColor]];
    [self setAntialiased:NO]; // Ew, but alternately, ew.
    [self setPosition:CGPointMake(aRect.origin.x - (aRect.size.width / 2), aRect.origin.y - (aRect.size.height / 2))];
    
    SKLabelNode * textNode = [SKLabelNode labelNodeWithFontNamed:@"Cochin"];
    [textNode setText:aTitle];
    [textNode setFontSize:24.0];
    [textNode setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
    [textNode setPosition:CGPointMake(CGRectGetMidX(buttonRect), CGRectGetMidY(buttonRect))];
    
    [self addChild:textNode];
    [self setUserInteractionEnabled:YES];
    
    return self;
}

@end
