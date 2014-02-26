//
//  YKRPlayer.m
//  Yookr
//
//  Created by Bill Doyle on 2014-02-20.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import "YKRPlayer.h"


@implementation YKRPlayer
{
    NSMutableArray * hand;
}
@synthesize name;

- (NSArray *)hand
{
    return [hand copy];
}

#pragma mark - Plumbing

- (id)initWithName:(NSString *)aName
{
    if (!(self = [super init])) return nil;
    
    name = aName;
    hand = [NSMutableArray array];
    
    return self;
}

- (id)init
{
    @throw [NSException exceptionWithName:@"NOPE" reason:@"NOPE" userInfo:nil];
}

@end
