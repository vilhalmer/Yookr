//
//  YKRGame.m
//  Yookr
//
//  Created by Bill Doyle on 2014-02-20.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import "YKRGame.h"
#import "NSDictionary+Integrate.h"


@implementation YKRGame
{
    NSMapTable * playersByName;
}
@synthesize delegate;

- (void)performAction:(NSDictionary *)anAction
{
    NSDictionary * propertyChanges = [self processAction:anAction];
    properties = [[properties dictionaryByIntegratingDictionary:propertyChanges] mutableCopy];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"YKRGame_performedAction" object:self];
    [[self delegate] game:self didUpdateProperties:propertyChanges];
}

- (NSDictionary *)processAction:(NSDictionary *)anAction
{
    return nil;
}

#pragma mark - Info

+ (NSString *)typeName
{
    return @"OVERRIDE ME YOU IDIOT";
}

+ (BOOL)variableGameSize
{
    return YES;
}

- (NSUInteger)gameSize
{
    return gameSize;
}

- (void)setGameSize:(NSUInteger)aGameSize
{
    gameSize = aGameSize;
}

- (NSUInteger)playerCount
{
    return [players count];
}

- (void)addPlayer:(YKRPlayer *)aPlayer
{
    [players addObject:aPlayer];
    [playersByName setObject:aPlayer forKey:[aPlayer name]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"YKRGame_addedPlayer" object:self];
    [[self delegate] game:self addedPlayer:aPlayer];
}

- (void)removePlayer:(YKRPlayer *)aPlayer
{
    NSUInteger playerIndex = [players indexOfObject:aPlayer];
    if (playerIndex == NSNotFound) return;
    
    [players removeObjectAtIndex:playerIndex];
    [playersByName removeObjectForKey:[aPlayer name]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"YKRGame_removedPlayer" object:self];
    [[self delegate] game:self removedPlayer:aPlayer];
}

- (NSArray *)players
{
    return [players copy];
}

- (YKRPlayer *)playerNamed:(NSString *)aName
{
    return [playersByName objectForKey:aName];
}

#pragma mark - Properties

- (id)propertyForKey:(NSString *)aKey
{
    return [properties objectForKey:aKey];
}

- (void)setProperty:(id)anObject forKey:(NSString *)aKey
/// @private: For use in -processAction.
{
    [properties setObject:anObject forKey:aKey];
}

#pragma mark - Plumbing

- (id)init
{
    if ([self isMemberOfClass:[YKRGame class]]) {
        @throw [NSException exceptionWithName:@"NOPE" reason:@"NOPE" userInfo:nil];
    }
    
    if (!(self = [super init])) return nil;
    
    properties = [NSMutableDictionary dictionary];
    players = [NSMutableArray array];
    playersByName = [NSMapTable strongToWeakObjectsMapTable];
    
    return self;
}

#pragma mark - Keyed subscripting methods

- (id)objectForKeyedSubscript:(id<NSCopying>)key
{
    if (![[(NSObject *)key class] isKindOfClass:[NSString class]]) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:@"Key on Game must be an NSString."
                                     userInfo:nil];
    }
    
    return [self propertyForKey:(NSString *)key];
}

@end
