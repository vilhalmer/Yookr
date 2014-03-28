//
//  YKRServer.h
//  Yookr
//
//  Created by Bill Doyle on 2014-02-24.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

#import "YKRGame.h"
#import "YKRRemoteGame.h"
#import "YKRRemotePlayer.h"
#import "YKRNetworking.h"


@interface YKRServer : NSObject <NSNetServiceDelegate, YKRGameDelegate, YKRRemotePlayerDelegate, YKRNetworking>

- (BOOL)startServerWithGame:(YKRGame *)aGame error:(NSError * __autoreleasing *)maybeError;
- (void)stopServer;

#pragma mark - Game delegate methods

- (void)game:(YKRGame *)aGame addedPlayer:(YKRPlayer *)aPlayer;
- (void)game:(YKRGame *)aGame removedPlayer:(YKRPlayer *)aPlayer;
- (void)game:(YKRGame *)aGame didUpdateProperties:(NSDictionary *)someProperties;

#pragma mark - Networking methods

- (YKRGame *)game;
- (BOOL)isHostingGame;

@end
