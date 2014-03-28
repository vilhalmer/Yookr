//
//  YKRCardNode.m
//  Yookr
//
//  Created by Bill Doyle on 2014-03-26.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import "YKRCardNode.h"


@implementation YKRCardNode
{
    UITouch * currentTouch;
    CGPoint originalTouchLocation;
    SKAction * fadeIn;
}
@synthesize cardString;

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
                
            }
            
            [self runAction:fadeIn];
            currentTouch = nil;
        }
    }
}

#pragma mark - Plumbing

- (instancetype)initWithCardString:(NSString *)aCardString
{
    if (!(self = [super initWithImageNamed:[aCardString uppercaseString]])) return nil;
    
    cardString = aCardString;
    
    return self;
}

@end
