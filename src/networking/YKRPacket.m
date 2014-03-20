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
@synthesize dictionary, type, flags;

#pragma mark - Plumbing

- (NSData *)encodeReturningError:(NSError * __autoreleasing *)maybeError
{
    NSMutableData * packet = [NSMutableData data];
    
    NSData * payloadJSONData;
    if ([self dictionary] && [[self dictionary] count] > 0) {
        BOOL debugMode = [[[NSUserDefaults standardUserDefaults] objectForKey:@"JSONDebugEnabled"] boolValue];
        
        NSError * __autoreleasing payloadError;
        payloadJSONData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                          options:((debugMode) ? NSJSONWritingPrettyPrinted : 0)
                                                            error:&payloadError];
        
        if (payloadError) {
            *maybeError = [NSError errorWithDomain:@"YKRPacketErrorDomain"
                                              code:4
                                          userInfo:@{@"NSLocalizedDescriptionKey" : @"Payload encoding error"}];
        }
    }
    
    if (maybeError) return nil;
    
    //UInt32 packetNumber = htonl(0);
    Byte packetType = [self type] | ([self flags] << 4);
    UInt32 payloadLength = htonl((UInt32)[payloadJSONData length]);
    
    [packet appendBytes:&MAGIC length:sizeof(MAGIC)];
    [packet appendBytes:&packetType length:sizeof(packetType)];
    [packet appendBytes:&payloadLength length:sizeof(payloadLength)];
    if (payloadJSONData) {
        [packet appendData:payloadJSONData]; // Attach -dictionary encoded as JSON.
    }
    
    return packet;
}

- (id)initWithEncodedData:(NSData *)someData returningError:(NSError * __autoreleasing *)maybeError
{
    UInt32 packetMagic = 0;
    Byte packetType = 0;
    UInt32 packetLength = 0;
    NSData * payload;
    
    NSInteger loc = 0;
    
    [someData getBytes:&packetMagic range:NSMakeRange(loc, sizeof(packetMagic))];
    loc += sizeof(packetMagic);
    if (packetMagic != MAGIC) {
        *maybeError = [NSError errorWithDomain:@"YKRPacketErrorDomain"
                                          code:1
                                      userInfo:@{@"NSLocalizedDescriptionKey" : @"Mismatched magic"}];
        return nil;
    }
    
    // Grab data if it's valid:
    [someData getBytes:&packetType range:NSMakeRange(loc, sizeof(packetType))];
    type = packetType & 0x0f;
    flags = (packetType & 0xf0) >> 4;
    loc += sizeof(packetType);
    
    [someData getBytes:&packetLength range:NSMakeRange(loc, sizeof(packetLength))];
    packetLength = ntohl(packetLength);
    loc += sizeof(packetLength);
    
    payload = [someData subdataWithRange:NSMakeRange(loc, [someData length] - loc)];
    
    if (![NSJSONSerialization isValidJSONObject:payload]) {
        *maybeError = [NSError errorWithDomain:@"YKRPacketErrorDomain"
                                          code:2
                                      userInfo:@{@"NSLocalizedDescriptionKey" : @"Invalid payload data"}];
        return nil;
    }
    
    NSError * payloadError;
    dictionary = [NSJSONSerialization JSONObjectWithData:payload
                                                 options:0
                                                   error:&payloadError];
    
    if (payloadError) {
        *maybeError = [NSError errorWithDomain:@"YKRPacketErrorDomain"
                                          code:3
                                      userInfo:@{@"NSLocalizedDescriptionKey" : @"JSON decoding failure",
                                                 @"NSUnderlyingErrorKey"      : payloadError}];
        return nil;
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary *)aDictionary type:(YKRPacketType)aType andFlags:(YKRPacketFlags)someFlags
{
    if (!(self = [super init])) return nil;
    
    dictionary = aDictionary;
    type = aType;
    flags = someFlags;
    
    return self;
}

- (id)init
{
    @throw [NSException exceptionWithName:@"NOPE" reason:@"NOPE" userInfo:nil];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"{ type: %2x, action: %2x, dictionary: %@ }",
            [self type], [self flags], [self dictionary]];
}

#pragma mark - Object subscripting

- (id)objectForKeyedSubscript:(id<NSCopying>)aKey
{
    return [[self dictionary] objectForKey:aKey];
}

@end
