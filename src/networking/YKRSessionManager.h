//
//  YKRSessionManager.h
//  Yookr
//
//  Created by Bill Doyle on 2014-02-15.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YKRSession.h"

@interface YKRSessionManager : NSObject <NSNetServiceBrowserDelegate, NSNetServiceDelegate>

- (void)beginScanningForSessions;
- (void)stopScanningForSessions;

- (NSArray *)availableSessions;
/** @return: An array of detected network sessions. **/
- (NSArray *)availableSessionsOfType:(NSString *)gameType;

+ (id)sharedSessionManager;

@end
