//
//  VCardParser.h
//  nimple-iOS
//
//  Created by Ben John on 21/04/14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NimpleModel.h"

@interface VCardParser : NSObject

+ (NimpleContact *)getContactFromCard:(NSString*)card;

@end
