//
//  YKRSession.m
//  Yookr
//
//  Created by Bill Doyle on 2014-02-15.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import "YKRSession.h"

@implementation YKRSession
{
    NSNetService * service;
}
@synthesize sockaddr, gameType, hostUser, name, playerCount, gameSize;

#pragma mark - Plumbing

- (id)initWithService:(NSNetService *)aService
{
    if (!(self = [super init])) return nil;
    
    NSDictionary * txtData = [NSNetService dictionaryFromTXTRecordData:[aService TXTRecordData]];
    if ([[aService addresses] count] > 0) {
        sockaddr = [aService addresses][0];
    }
    name = [aService name];
    gameType = [[NSString alloc] initWithData:txtData[@"gameType"] encoding:NSUTF8StringEncoding];
    hostUser = [[NSString alloc] initWithData:txtData[@"hostUser"] encoding:NSUTF8StringEncoding];
    playerCount = [NSNumber numberWithInteger:[[[NSString alloc] initWithData:txtData[@"playerCount"]
                                                                     encoding:NSUTF8StringEncoding] integerValue]];
    gameSize = [NSNumber numberWithInteger:[[[NSString alloc] initWithData:txtData[@"gameSize"]
                                                                  encoding:NSUTF8StringEncoding] integerValue]];
    
    service = aService;
    
    return self;
}

- (BOOL)isEqual:(id)anObject
{
    if (!([anObject isKindOfClass:[self class]])) return NO;
    YKRSession * aSession = (YKRSession *)anObject;
    
    BOOL same = YES;
    same &= [[aSession gameType] isEqualToString:[self gameType]];
    same &= [[aSession hostUser] isEqualToString:[self hostUser]];
    same &= [[aSession name] isEqualToString:[self name]];
    same &= [[aSession playerCount] isEqualToNumber:[self playerCount]];
    same &= [[aSession gameSize] isEqualToNumber:[self gameSize]];
    
    return same;
}

- (BOOL)isEqualToService:(NSNetService *)aService
{
    return [aService isEqual:service];
}

- (NSUInteger)hash
{
    return [[self gameType] hash]
         ^ [[self hostUser] hash]
         ^ [[self name] hash]
         ^ [[self playerCount] hash]
         ^ [[self gameSize] hash];
}

@end
