//
//  YKRPacket.m
//  Yookr
//
//  Created by Bill Doyle on 2014-02-24.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import "YKRPacket.h"


UInt32 MAGIC = htonl(0x444c4447);


@implementation YKRPacket
@synthesize data, type, action;

#pragma mark - NSCoding

- (NSData *)encode
{
    NSMutableData * packet = [NSMutableData data];
    
    //UInt32 packetNumber = htonl(0);
    Byte packetType = [self type] | ([self action] << 4);
    UInt32 payloadLength = htonl((UInt32)[[self data] length]);
    
    [packet appendBytes:&MAGIC length:sizeof(MAGIC)];
    [packet appendBytes:&packetType length:sizeof(packetType)];
    [packet appendBytes:&payloadLength length:sizeof(payloadLength)];
    [packet appendData:[self data]];
    
    return packet;
}

#pragma mark - Plumbing

- (id)initWithEncodedData:(NSData *)someData
{
    UInt32 packetMagic = 0;
    Byte packetType = 0;
    UInt32 packetLength = 0;
    NSData * payload;
    
    NSInteger loc = 0;
    
    [someData getBytes:&packetMagic range:NSMakeRange(loc, sizeof(packetMagic))];
    loc += sizeof(packetMagic);
    if (packetMagic != MAGIC) return nil;
    
    // Grab data if it's valid:
    [someData getBytes:&packetType range:NSMakeRange(loc, sizeof(packetType))];
    type = packetType & 0x0f;
    action = (packetType & 0xf0) >> 4;
    loc += sizeof(packetType);
    
    [someData getBytes:&packetLength range:NSMakeRange(loc, sizeof(packetLength))];
    packetLength = ntohl(packetLength);
    loc += sizeof(packetLength);
    
    payload = [someData subdataWithRange:NSMakeRange(loc, [someData length] - loc)];
    [self setData:payload];
    
    return self;
}

- (id)initWithData:(id)someData type:(YKRPacketType)aType action:(YKRPacketAction)anAction
{
    if (!(self = [super init])) return nil;
    
    data = someData;
    type = aType;
    action = anAction;
    
    return self;
}

- (id)init
{
    @throw [NSException exceptionWithName:@"NOPE" reason:@"NOPE" userInfo:nil];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"{ type: %2x, action: %2x, data: %@ }", [self type], [self action], [self data]];
}

@end
