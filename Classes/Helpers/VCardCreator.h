//
//  VCardCreator.h
//  nimple-iOS
//
//  Created by Ben John on 17/08/14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NimpleCode.h"
#import "NimpleContact.h"

@interface VCardCreator : NSObject

+ (VCardCreator *)sharedInstance;

- (NSString *)createVCardFromNimpleCode:(NimpleCode *)code;
- (NSString *)createVCardFromNimpleContact:(NimpleContact *)contact;

@end
