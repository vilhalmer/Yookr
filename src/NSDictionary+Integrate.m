//
//  NSDictionary+Integrate.m
//  Yookr
//
//  Created by Bill Doyle on 2014-03-21.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import "NSDictionary+Integrate.h"

@implementation NSDictionary (Integrate)

- (NSDictionary *)dictionaryByIntegratingDictionary:(NSDictionary *)aSubDictionary
{
    if (!aSubDictionary || [aSubDictionary count] < 1) {
        return [self copy];
    }
    
    NSMutableDictionary * newDictionary = [self mutableCopy];
    
    [aSubDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id newObject, BOOL * stop) {
        id oldObject = [newDictionary objectForKey:key];
        
        if ([oldObject isKindOfClass:[NSDictionary class]] &&
            [newObject isKindOfClass:[NSDictionary class]]) {
            // This is a nested dictionary, and so is the object provided in the updated info. We need to call this
            // method on it with the matching object from aSubDictionary and then replace it.
            [newDictionary setObject:[oldObject dictionaryByIntegratingDictionary:newObject] forKey:key];
        }
        else {
            [newDictionary setObject:newObject forKey:key];
        }
    }];
    
    return [newDictionary copy];
}

@end
