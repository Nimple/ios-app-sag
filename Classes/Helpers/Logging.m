//
//  Logging.m
//  nimple-iOS
//
//  Created by Ben John on 24/04/14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "Logging.h"
#import "NimpleAppDelegate.h"

// dev token
//#define MIXPANEL_TOKEN @"6e3eeca24e9b2372e8582b381295ca0c"

// prod token
#define MIXPANEL_TOKEN @"c0d8c866df9c197644c6087495151c7e"

// hash of flyer contact
#define FLYER_CONTACT_HASH @"9d2b064c3d89c867916c5329f079fa66"

@implementation Logging

+ (id)sharedLogging
{
    static id sharedLogging = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLogging = [[self alloc] init];
    });
    return sharedLogging;
}

- (id)init
{
    self = [super init];
    if (self) {
        [Mixpanel sharedInstanceWithToken:MIXPANEL_TOKEN];
        [self sendApplicationStartedEvent];
    }
    
    return self;
}

#pragma mark - Sending events block

- (void)sendApplicationStartedEvent
{
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"app started"];
}

- (void)sendContactAddedEvent:(NimpleContact*)nimpleContact
{
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    NSString *isFlyerContact = @"false";
    
    if ([nimpleContact.contactHash isEqualToString:FLYER_CONTACT_HASH]) {
        isFlyerContact = @"true";
    }
    
    NSLog(@"isFlyerContact = %@", isFlyerContact);
    
    NSDictionary *properties = @{
                                 @"has phone number": [self checkForEmptyStringAndFormatOutput:nimpleContact.phone],
                                 @"has mail address": [self checkForEmptyStringAndFormatOutput:nimpleContact.email],
                                 @"has company": [self checkForEmptyStringAndFormatOutput:nimpleContact.company],
                                 @"has job title": [self checkForEmptyStringAndFormatOutput:nimpleContact.job],
                                 @"has website": [self checkForEmptyStringAndFormatOutput:nimpleContact.website],
                                 @"has address": [self checkBoolAndFormatOutput:nimpleContact.hasAddress],
                                 @"has facebook": [self checkForEmptyStringAndFormatOutput:nimpleContact.facebook_URL],
                                 @"has twitter": [self checkForEmptyStringAndFormatOutput:nimpleContact.twitter_URL],
                                 @"has xing": [self checkForEmptyStringAndFormatOutput:nimpleContact.xing_URL],
                                 @"has linkedin": [self checkForEmptyStringAndFormatOutput:nimpleContact.linkedin_URL],
                                 @"is flyer contact": isFlyerContact
                                 };
    [mixpanel track:@"contact scanned" properties:properties];
}

- (void)sendContactTransferredEvent
{
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"contact saved in adress book"];
}

- (void)sendNimpleCodeChangedEvent
{
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    NimpleCode *code = [NimpleCode sharedCode];
    
    NSDictionary *properties = @{
                                 @"has phone number": [self checkForEmptyStringAndFormatOutput:code.cellPhone],
                                 @"has mail address": [self checkForEmptyStringAndFormatOutput:code.email],
                                 @"has company": [self checkForEmptyStringAndFormatOutput:code.company],
                                 @"has job title": [self checkForEmptyStringAndFormatOutput:code.job],
                                 @"has website": [self checkForEmptyStringAndFormatOutput:code.website],
                                 @"has address": [self checkBoolAndFormatOutput:code.hasAddress],
                                 @"has facebook": [self checkForEmptyStringAndFormatOutput:code.facebookUrl],
                                 @"has twitter": [self checkForEmptyStringAndFormatOutput:code.twitterUrl],
                                 @"has xing": [self checkForEmptyStringAndFormatOutput:code.xing],
                                 @"has linkedin": [self checkForEmptyStringAndFormatOutput:code.linkedIn]
                                 };
    [mixpanel track:@"nimple code edited" properties:properties];
}

#pragma mark - Small helper

- (NSString *)checkBoolAndFormatOutput:(BOOL)state
{
    if (state) {
        return @"true";
    } else {
        return @"false";
    }
}

- (NSString *)checkForEmptyStringAndFormatOutput:(NSString*)needle
{
    if(needle.length == 0) {
        return @"false";
    } else {
        return @"true";
    }
}

@end
