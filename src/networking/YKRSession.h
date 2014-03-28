//
//  YKRSession.h
//  Yookr
//
//  Created by Bill Doyle on 2014-02-15.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKRSession : NSObject

@property (readonly) NSData * sockaddr;
@property (readonly) NSString * gameType;
@property (readonly) NSString * name;
@property (readonly) NSString * hostUser;
@property (readonly) NSNumber * playerCount;
@property (readonly) NSNumber * gameSize;

#pragma mark - Plumbing

- (id)initWithService:(NSNetService *)aService;

- (BOOL)isEqual:(id)anObject;
- (BOOL)isEqualToService:(NSNetService *)aService;
- (NSUInteger)hash;

@end
