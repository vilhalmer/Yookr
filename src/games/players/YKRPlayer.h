//
//  YKRPlayer.h
//  Yookr
//
//  Created by Bill Doyle on 2014-02-20.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YKRGameScene.h"

@protocol YKRPlayerDelegate;


@interface YKRPlayer : NSObject

@property (readonly) NSString * name;
@property (readwrite, weak) YKRGameScene * scene;

- (id)propertyForKey:(NSString *)key;
- (void)updateProperties:(NSDictionary *)someProperties;

#pragma mark - Plumbing

- (instancetype)initWithName:(NSString *)aName;

#pragma mark - Keyed subscripting methods

- (id)objectForKeyedSubscript:(id<NSCopying>)key;

@end
