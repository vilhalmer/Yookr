//
//  YKRNetworking.h
//  Yookr
//
//  Created by Bill Doyle on 2014-03-27.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YKRGame.h"


@protocol YKRNetworking <NSObject>

- (YKRGame *)game;
- (BOOL)isHostingGame;

@end
