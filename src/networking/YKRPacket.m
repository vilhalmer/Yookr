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
@synthesize encodedData, dictionary, type, flags, payloadLength;

- (id)initWithHeader:(NSData *)someData returningError:(NSError * __autoreleasing *)maybeError
{
    UInt32 packetMagic = 0;
    Byte packetType = 0;
    UInt32 packetLength = 0;
    
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
    //loc += sizeof(packetLength);
    
    payloadLength = @(packetLength);
    
    return self;
}

- (id)initWithDictionary:(NSDictionary *)aDictionary
                    type:(YKRPacketType)aType
                andFlags:(YKRPacketFlags)someFlags
          returningError:(NSError * __autoreleasing *)maybeError
{
    if (!(self = [super init])) return nil;
    
    dictionary = aDictionary;
    type = aType;
    flags = someFlags;
    NSLog(@"%d", type);
    
    // Now encode the packet:
    NSMutableData * packetData = [NSMutableData data];
    
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
    
    if (*maybeError) {
        NSLog(@"packet failed: %@", *maybeError);
        return nil;
    }
    
    Byte packetType = [self type] | ([self flags] << 4);
    UInt32 payloadDataLength = htonl((UInt32)[payloadJSONData length]);
    
    [packetData appendBytes:&MAGIC length:sizeof(MAGIC)];
    [packetData appendBytes:&packetType length:sizeof(packetType)];
    [packetData appendBytes:&payloadDataLength length:sizeof(payloadDataLength)];
    if (payloadJSONData) {
        [packetData appendData:payloadJSONData]; // Attach -dictionary encoded as JSON.
    }
    
    NSLog(@"packetdata = %@", packetData);
    
    encodedData = packetData;
    payloadLength = @(payloadDataLength);
    
    return self;
}

- (void)setPayload:(NSData *)payloadData returningError:(NSError * __autoreleasing *)maybeError
{
    if ([self type] != YKRPacketTypeJSON) {
        *maybeError = [NSError errorWithDomain:@"YKRPacketErrorDomain"
                                          code:5
                                      userInfo:@{@"NSLocalizedDescriptionKey" : @"Non-JSON packet cannot have payload."}];
        return;
    }
    
    NSError * payloadError;
    dictionary = [NSJSONSerialization JSONObjectWithData:payloadData
                                                 options:0
                                                   error:&payloadError];
    
    if (payloadError) {
        *maybeError = [NSError errorWithDomain:@"YKRPacketErrorDomain"
                                          code:3
                                      userInfo:@{@"NSLocalizedDescriptionKey" : @"JSON decoding failure",
                                                 @"NSUnderlyingErrorKey"      : payloadError}];
        return;
    }
    
    NSMutableData * completeData = [encodedData mutableCopy];
    [completeData appendData:payloadData];
    encodedData = [completeData copy];
}

#pragma mark - Plumbing

- (id)init
{
    @throw [NSException exceptionWithName:@"NOPE" reason:@"NOPE" userInfo:nil];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"{ type: %2x, flags: %2x, length: %ld, dictionary: %@ }",
            [self type], [self flags], [[self payloadLength] integerValue], [self dictionary]];
}

#pragma mark - Object subscripting

- (id)objectForKeyedSubscript:(id<NSCopying>)aKey
{
    return [[self dictionary] objectForKey:aKey];
}

@end
