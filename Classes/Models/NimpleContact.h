//
//  NimpleContact.h
//  nimple-iOS
//
//  Created by Ben John on 14/08/14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NimpleContact : NSManagedObject

// schema version 1.0
@property (nonatomic, retain) NSString *prename;
@property (nonatomic, retain) NSString *surname;

@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *job;
@property (nonatomic, retain) NSString *company;

@property (nonatomic, retain) NSString *facebook_URL;
@property (nonatomic, retain) NSString *facebook_ID;
@property (nonatomic, retain) NSString *twitter_URL;
@property (nonatomic, retain) NSString *twitter_ID;
@property (nonatomic, retain) NSString *xing_URL;
@property (nonatomic, retain) NSString *linkedin_URL;

@property (nonatomic, retain) NSDate *created;

// schema version 2.0
@property (nonatomic, retain) NSString *contactHash;
@property (nonatomic, retain) NSString *note;

// schema version 3.0
@property (nonatomic, retain) NSString *street;
@property (nonatomic, retain) NSString *postal;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *website;

// schema version 4.0
@property (nonatomic, retain) NSString *cellphone;

- (void)fillWithContact:(NimpleContact *)contact;
- (BOOL)hasAddress;

@end
