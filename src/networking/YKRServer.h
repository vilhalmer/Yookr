//
//  YKRServer.h
//  Yookr
//
//  Created by Bill Doyle on 2014-02-24.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YKRGame.h"
#import "GCDAsyncSocket.h"


@interface YKRServer : NSObject <NSNetServiceDelegate>

- (BOOL)startServerWithGame:(YKRGame *)aGame error:(NSError * __autoreleasing *)maybeError;
- (void)stopServer;

@end
