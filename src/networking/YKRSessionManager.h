//
//  YKRSessionManager.h
//  Yookr
//
//  Created by Bill Doyle on 2014-02-15.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKRSessionManager : NSObject

- (void)scanForSessions;
/** Re-scans the network for advertised sessions, updates -availableSessions. **/

- (NSArray *)availableSessions;
/** @return: An array of detected network sessions. May not be up-to-date, call -scanForSessions to update. **/

@end
