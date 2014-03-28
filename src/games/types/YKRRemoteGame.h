//
//  YKRRemoteGame.h
//  Yookr
//
//  Created by Bill Doyle on 2014-03-22.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import "YKRGame.h"

@protocol YKRRemoteGameDelegate;


@interface YKRRemoteGame : YKRGame

@property (readwrite, weak) id<YKRRemoteGameDelegate> remoteDelegate;
- (void)updateProperties:(NSDictionary *)someProperties;

@end


@protocol YKRRemoteGameDelegate <NSObject>

- (void)performAction:(NSDictionary *)anAction;

@end
