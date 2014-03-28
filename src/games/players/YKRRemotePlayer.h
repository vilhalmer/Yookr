//
//  YKRRemotePlayer.h
//  Yookr
//
//  Created by Bill Doyle on 2014-02-24.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import "YKRPlayer.h"
#import "GCDAsyncSocket.h"

@protocol YKRRemotePlayerDelegate;


@interface YKRRemotePlayer : YKRPlayer

@property (readonly) GCDAsyncSocket * socket;
@property (readwrite, weak) id<YKRRemotePlayerDelegate> remoteDelegate;

- (instancetype)initWithName:(NSString *)aName andSocket:(GCDAsyncSocket *)aSocket;

@end


@protocol YKRRemotePlayerDelegate <NSObject>

- (void)updateProperties:(NSDictionary *)someProperties ofRemotePlayer:(YKRRemotePlayer *)aPlayer;

@end