//
//  NimpleModel.h
//  nimple-iOS
//
//  Created by Ben John on 14/08/14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NimpleContact.h"

@interface NimpleModel : NSObject

+ (NimpleModel *)sharedModel;

- (void)save;

- (void)createExampleContact;
- (NimpleContact *)getTemporaryContact;
- (NimpleContact *)getEntityForNewContact;
- (void)deleteContact:(NimpleContact *)contact;
- (NSArray *)contacts;
- (BOOL)doesContactExistWithHash:(NSString *)contactHash;

@end
