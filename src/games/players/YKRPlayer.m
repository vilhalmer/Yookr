//
//  YKRPlayer.m
//  Yookr
//
//  Created by Bill Doyle on 2014-02-20.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import "YKRPlayer.h"
#import "NSDictionary+Integrate.h"


@implementation YKRPlayer
{
    NSDictionary * properties;
}
@synthesize name;

- (id)propertyForKey:(NSString *)key
{
    return [properties objectForKey:key];
}

- (void)updateProperties:(NSDictionary *)someProperties
{
    properties = [properties dictionaryByIntegratingDictionary:someProperties];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"YKRPlayer_updatedProperties" object:self];
}

#pragma mark - Plumbing

- (instancetype)initWithName:(NSString *)aName
{
    if (!(self = [super init])) return nil;
    
    name = aName;
    properties = [NSMutableDictionary dictionary];
    
    return self;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"NOPE" reason:@"NOPE" userInfo:nil];
}

#pragma mark - Keyed subscripting methods

- (id)objectForKeyedSubscript:(id<NSCopying>)key
{
    if (![[(NSObject *)key class] isKindOfClass:[NSString class]]) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:@"Key on Player must be an NSString."
                                     userInfo:nil];
    }
    
    return [self propertyForKey:(NSString *)key];
}

@end
