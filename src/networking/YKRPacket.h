//
//  YKRPacket.h
//  Yookr
//
//  Created by Bill Doyle on 2014-02-24.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(Byte, YKRPacketType) {
    YKRPacketTypeNone        = 0x00,
    YKRPacketTypeHello       = 0x01,
    YKRPacketTypeAcknowledge = 0x02,
    YKRPacketTypeGoodbye     = 0x03,
    YKRPacketTypeJSON        = 0x0f
};

typedef NS_ENUM(short, YKRPacketFlags) {
    YKRPacketFlagsNone = 0x00
};


@interface YKRPacket : NSObject

@property (readonly) NSDictionary * dictionary;
@property (readonly) YKRPacketType type;
@property (readonly) YKRPacketFlags flags;

- (NSData *)encodeReturningError:(NSError * __autoreleasing *)maybeError;

#pragma mark - Object subscripting

- (id)objectForKeyedSubscript:(id<NSCopying>)aKey;

#pragma mark - Plumbing

- (id)initWithDictionary:(NSDictionary *)aDictionary type:(YKRPacketType)aType andFlags:(YKRPacketFlags)someFlags;
- (id)initWithEncodedData:(NSData *)data returningError:(NSError * __autoreleasing *)maybeError;

@end
