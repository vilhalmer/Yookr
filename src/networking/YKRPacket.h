//
//  YKRPacket.h
//  Yookr
//
//  Created by Bill Doyle on 2014-02-24.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import <Foundation/Foundation.h>


static NSUInteger packet_length = 9;

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

@property (readonly) NSData * encodedData;
@property (readonly) NSDictionary * dictionary;
@property (readonly) YKRPacketType type;
@property (readonly) YKRPacketFlags flags;
@property (readonly) NSNumber * payloadLength;

- (void)setPayload:(NSData *)payloadData returningError:(NSError * __autoreleasing *)maybeError;
/** Call this after receiving the payload of a Packet that was created with -initWithHeader:… 
 ** on such a Packet, -dictionary is nil until this is set. **/

#pragma mark - Object subscripting

- (id)objectForKeyedSubscript:(id<NSCopying>)aKey;

#pragma mark - Plumbing

- (id)initWithHeader:(NSData *)data returningError:(NSError * __autoreleasing *)maybeError;
- (id)initWithDictionary:(NSDictionary *)aDictionary
                    type:(YKRPacketType)aType
                andFlags:(YKRPacketFlags)someFlags
          returningError:(NSError * __autoreleasing *)maybeError;

@end
