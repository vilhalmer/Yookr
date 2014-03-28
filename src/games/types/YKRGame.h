//
//  YKRGame.h
//  Yookr
//
//  Created by Bill Doyle on 2014-02-20.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YKRPlayer.h"

@protocol YKRGameDelegate;


@interface YKRGame : NSObject
/** @abstract **/
{
    @protected
    NSMutableArray * players;
    NSMutableDictionary * properties;
    NSUInteger gameSize;
}

@property (readwrite, weak) id<YKRGameDelegate> delegate;

- (void)performAction:(NSDictionary *)anAction;
/** A template method. Subclasses should override the methods below to perform actual work. **/

- (NSDictionary *)processAction:(NSDictionary *)anAction;
/** @private
 ** Subclasses should override this method to perform the actual game logic.
 ** @return: A dictionary representing the diff of the game's public properties after the action was taken. **/

#pragma mark - Info

+ (NSString *)typeName;
+ (BOOL)variableGameSize;
/** @return: Whether or not this type of game allows the size to be set. **/

- (NSUInteger)gameSize;
- (void)setGameSize:(NSUInteger)aGameSize;
/** Subclasses that do not allow a variable game size should silently ignore attempts to use this method. **/

- (NSUInteger)playerCount;

- (void)addPlayer:(YKRPlayer *)aPlayer;
- (void)removePlayer:(YKRPlayer *)aPlayer;
- (NSArray *)players;
- (YKRPlayer *)playerNamed:(NSString *)aName;

#pragma mark - Properties

- (id)propertyForKey:(NSString *)aKey;

#pragma mark - Plumbing

- (id)init;
/** @throws NOPE: This is an abstract class. **/

@end


@protocol YKRGameDelegate <NSObject>

- (void)game:(YKRGame *)aGame addedPlayer:(YKRPlayer *)aPlayer;
- (void)game:(YKRGame *)aGame removedPlayer:(YKRPlayer *)aPlayer;
- (void)game:(YKRGame *)aGame didUpdateProperties:(NSDictionary *)someProperties;

@end