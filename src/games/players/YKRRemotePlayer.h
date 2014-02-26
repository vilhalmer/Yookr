//
//  YKRRemotePlayer.h
//  Yookr
//
//  Created by Bill Doyle on 2014-02-24.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import "YKRPlayer.h"
#import "GCDAsyncSocket.h"


@interface YKRRemotePlayer : YKRPlayer

@property (readonly) GCDAsyncSocket * socket;

- (id)initWithName:(NSString *)aName andSocket:(GCDAsyncSocket *)aSocket;

@end
