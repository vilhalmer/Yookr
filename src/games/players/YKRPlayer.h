//
//  YKRPlayer.h
//  Yookr
//
//  Created by Bill Doyle on 2014-02-20.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YKRPlayer : NSObject

@property (readonly) NSString * name;
- (NSArray *)hand;

- (id)initWithName:(NSString *)aName;

@end
