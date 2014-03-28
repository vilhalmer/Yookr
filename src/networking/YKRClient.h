//
//  YKRClient.h
//  Yookr
//
//  Created by Bill Doyle on 2014-03-20.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YKRScene.h"
#import "YKRSession.h"
#import "YKRRemoteGame.h"
#import "YKRNetworking.h"


@interface YKRClient : NSObject <YKRNetworking, YKRRemoteGameDelegate>

@property (readwrite) YKRRemoteGame * game;
@property (readwrite, weak) YKRPlayer * localPlayer;

- (void)connect;
- (void)disconnect;

- (void)joinGame;

#pragma mark - Remote game delegate methods

- (void)performAction:(NSDictionary *)anAction;

#pragma mark - Networking methods

- (BOOL)isHostingGame;

#pragma mark - Plumbing

- (instancetype)initWithSession:(YKRSession *)aSession;

@end
