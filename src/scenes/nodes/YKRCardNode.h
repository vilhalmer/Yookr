//
//  YKRCardNode.h
//  Yookr
//
//  Created by Bill Doyle on 2014-03-26.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface YKRCardNode : SKSpriteNode

@property (readonly) NSString * cardString;

- (instancetype)initWithCardString:(NSString *)aCardString;

@end
