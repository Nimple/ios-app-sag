//
//  NimpleContact.m
//  nimple-iOS
//
//  Created by Ben John on 14/08/14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "NimpleContact.h"

@implementation NimpleContact

// schema version 1.0
@dynamic prename;
@dynamic surname;

@dynamic phone;
@dynamic email;
@dynamic job;
@dynamic company;

@dynamic facebook_URL;
@dynamic facebook_ID;
@dynamic twitter_URL;
@dynamic twitter_ID;
@dynamic xing_URL;
@dynamic linkedin_URL;

@dynamic created;

// schema version 2.0
@dynamic contactHash;
@dynamic note;

// schema version 3.0
@dynamic street;
@dynamic postal;
@dynamic city;
@dynamic website;

// schema version 4.0
@dynamic cellphone;

- (void)fillWithContact:(NimpleContact *)contact
{
    self.prename = contact.prename;
    self.surname = contact.surname;
    
    self.phone = contact.phone;
    self.cellphone = contact.cellphone;
    self.email = contact.email;
    self.job = contact.job;
    self.company = contact.company;
    
    self.facebook_URL = contact.facebook_URL;
    self.facebook_ID = contact.facebook_ID;
    self.twitter_URL = contact.twitter_URL;
    self.twitter_ID = contact.twitter_ID;
    self.xing_URL = contact.xing_URL;
    self.linkedin_URL = contact.linkedin_URL;
    
    self.created = contact.created;
    
    self.contactHash = contact.contactHash;
    self.note = contact.note;
    
    self.street = contact.street;
    self.postal = contact.postal;
    self.city = contact.city;
    self.website = contact.website;
}

- (BOOL)hasAddress
{
    return self.street.length > 0 || self.postal.length > 0 || self.city.length > 0;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<NimpleContact: %@ %@, Created: %@>", self.prename, self.surname, self.created];
}

@end
