//
//  Crypto.m
//  nimple-iOS
//
//  Created by Ben John on 25/04/14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "Crypto.h"
#import <CommonCrypto/CommonDigest.h>

@implementation Crypto

+ (NSString*) calculateMd5OfString:(NSString*) input {
    const char *inputString = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(inputString, (CC_LONG) strlen(inputString), result);
    return [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x", result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7], result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
}

@end
