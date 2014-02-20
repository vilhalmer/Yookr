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
    NSMutableArray * playerNames;
}
@synthesize ip, gameType, hostUser, name, playerCount;

- (NSArray *)playerNames
{
    return [playerNames copy];
}

#pragma mark - Plumbing

- (id)initWithService:(NSNetService *)aService
{
    if (!(self = [super init])) return nil;
    
    NSDictionary * txtData = [NSNetService dictionaryFromTXTRecordData:[aService TXTRecordData]];
    ip = [aService addresses][0];
    gameType = [[NSString alloc] initWithData:txtData[@"gameType"] encoding:NSUTF8StringEncoding];
    hostUser = [[NSString alloc] initWithData:txtData[@"hostUser"] encoding:NSUTF8StringEncoding];
    playerCount = [NSNumber numberWithInteger:[[[NSString alloc] initWithData:txtData[@"playerCount"] encoding:NSUTF8StringEncoding] integerValue]];
    name = [aService name];
    
    return self;
}

- (BOOL)isEqual:(id)anObject
{
    if (!([anObject isKindOfClass:[self class]])) return NO;
    YKRSession * aSession = (YKRSession *)anObject;
    
    BOOL same = YES;
    same &= [[aSession ip] isEqual:[self ip]];
    same &= [[aSession gameType] isEqualToString:[self gameType]];
    same &= [[aSession hostUser] isEqualToString:[self hostUser]];
    same &= [[aSession name] isEqualToString:[self name]];
    same &= [[aSession playerCount] isEqualToNumber:[self playerCount]];
    
    return same;
}

- (NSUInteger)hash
{
    return [[self ip] hash]
         ^ [[self gameType] hash]
         ^ [[self hostUser] hash]
         ^ [[self name] hash]
         ^ [[self playerCount] hash];
}

@end
