//
//  YKRGameManager.m
//  Yookr
//
//  Created by Bill Doyle on 2014-02-20.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import "YKRGameManager.h"
#import "YKREuchreGame.h"
#import "YKREuchreGameScene.h"
#import "YKRWarGame.h"
#import "YKRWarGameScene.h"


@implementation YKRGameManager
{
    NSMutableDictionary * gameClassesByGameType;
    NSMutableDictionary * gameSceneClassesByGameType;
}

- (YKRGame *)gameOfType:(NSString *)aTypeName
{
    return [[gameClassesByGameType objectForKey:aTypeName] new];
}

- (YKRGameScene *)sceneForGameType:(NSString *)aGameType
{
    return [[gameSceneClassesByGameType objectForKey:aGameType] new];
}

- (NSArray *)gameTypes
{
    return [gameClassesByGameType allKeys];
}

#pragma mark - Plumbing

- (id)init
{
    if (!(self = [super init])) return nil;
    
    gameClassesByGameType = [NSMutableDictionary dictionary];
    gameSceneClassesByGameType = [NSMutableDictionary dictionary];
    
    // Let's grab all of the game classes that we want to make accessible:
    [gameClassesByGameType setObject:[YKREuchreGame class] forKey:[[YKREuchreGame class] typeName]];
    [gameSceneClassesByGameType setObject:[YKREuchreGameScene class] forKey:[[YKREuchreGame class] typeName]];
    /*
    [gameClassesByGameType setObject:[YKRWarGame class] forKey:[[YKRWarGame class] typeName]];
    [gameSceneClassesByGameType setObject:[YKRWarGameScene class] forKey:[[YKRWarGame class] typeName]];
    */
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
