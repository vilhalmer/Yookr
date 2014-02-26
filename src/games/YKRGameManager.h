//
//  YKRGameManager.h
//  Yookr
//
//  Created by Bill Doyle on 2014-02-20.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YKRGame.h"


@interface YKRGameManager : NSObject

- (YKRGame *)gameOfType:(NSString *)aTypeName;
- (NSArray *)gameTypes;

#pragma mark - Plumbing

+ (id)sharedManager;

@end
