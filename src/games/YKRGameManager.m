//
//  YKRGameManager.m
//  Yookr
//
//  Created by Bill Doyle on 2014-02-20.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import "YKRGameManager.h"
#import "YKREuchreGame.h"


@implementation YKRGameManager
{
    NSMutableDictionary * gameClassesByName;
}

- (YKRGame *)gameOfType:(NSString *)aTypeName
{
    return [[gameClassesByName objectForKey:aTypeName] new];
}

- (NSArray *)gameTypes
{
    return [gameClassesByName allKeys];
}

#pragma mark - Plumbing

- (id)init
{
    if (!(self = [super init])) return nil;
    
    gameClassesByName = [NSMutableDictionary dictionary];
    
    // Let's grab all of the game classes that we want to make accessible:
    [gameClassesByName setObject:[YKREuchreGame class] forKey:[YKREuchreGame typeName]];
    
    return self;
}

+ (id)sharedManager
{
    static dispatch_once_t pred;
    static YKRGameManager * sharedInstance = nil;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

@end
