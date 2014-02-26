//
//  YKRGame.h
//  Yookr
//
//  Created by Bill Doyle on 2014-02-20.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YKRPlayer.h"


@interface YKRGame : NSObject

+ (NSString *)typeName;

- (void)addPlayer:(YKRPlayer *)aPlayer;
- (void)removePlayer:(YKRPlayer *)aPlayer;

@end
