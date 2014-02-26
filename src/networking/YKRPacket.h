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

typedef NS_ENUM(short, YKRPacketAction) {
    YKRPacketFlagsNone = 0x00
};


@interface YKRPacket : NSObject

@property (strong, nonatomic) id data;
@property (assign, nonatomic) YKRPacketType type;
@property (assign, nonatomic) YKRPacketAction action;

- (NSData *)encode;

#pragma mark - Plumbing

- (id)initWithData:(id)data type:(YKRPacketType)type action:(YKRPacketAction)action;
- (id)initWithEncodedData:(NSData *)data;

@end
