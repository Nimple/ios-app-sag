//
//  NimpleCode.h
//  nimple-iOS
//
//  Created by Ben John on 15/08/14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NimpleCodeDictionaryKey @"dictionary"

#define NimpleCodePrenameKey @"prename"
#define NimpleCodeSurnameKey @"surname"
#define NimpleCodeCellPhoneKey @"cellphone"
#define NimpleCodePhoneKey @"phone"
#define NimpleCodeEmailKey @"email"
#define NimpleCodeJobKey @"job"
#define NimpleCodeCompanyKey @"company"

#define NimpleCodeAddressStreetKey @"street"
#define NimpleCodeAddressPostalKey @"postal"
#define NimpleCodeAddressCityKey @"city"
#define NimpleCodeWebsiteKey @"website"

#define NimpleCodeFacebookUrlKey @"facebook_URL"
#define NimpleCodeFacebookIdKey @"facebook_ID"
#define NimpleCodeTwitterUrlKey @"twitter_URL"
#define NimpleCodeTwitterIdKey @"twitter_ID"
#define NimpleCodeXingKey @"xing_URL"
#define NimpleCodeLinkedInKey @"linkedin_URL"

#define NimpleCodeCellPhoneSwitch @"cellphone_switch"
#define NimpleCodePhoneSwitch @"phone_switch"
#define NimpleCodeEmailSwitch @"email_switch"
#define NimpleCodeJobSwitch @"job_switch"
#define NimpleCodeCompanySwitch @"company_switch"
#define NimpleCodeAddressSwitch @"address_switch"
#define NimpleCodeWebsiteSwitch @"website_switch"
#define NimpleCodeFacebookSwitch @"facebook_switch"
#define NimpleCodeTwitterSwitch @"twitter_switch"
#define NimpleCodeXingSwitch @"xing_switch"
#define NimpleCodeLinkedInSwitch @"linkedin_switch"

@interface NimpleCode : NSObject

+ (NimpleCode *)sharedCode;

- (void)switchToDictionaryWithIndexInteger:(NSInteger)index;
- (void)switchToDictionaryWithIndexString:(NSString *)index;
- (NSInteger)dictionaryIndex;

- (void)setPrename:(NSString *)prename;
- (NSString *)prename;
- (void)setSurname:(NSString *)surname;
- (NSString *)surname;
- (void)setCellPhone:(NSString *)cellPhone;
- (NSString *)cellPhone;
- (void)setPhone:(NSString *)cellPhone;
- (NSString *)phone;
- (void)setEmail:(NSString *)email;
- (NSString *)email;
- (void)setJob:(NSString *)job;
- (NSString *)job;
- (void)setCompany:(NSString *)company;
- (NSString *)company;

- (BOOL)hasAddress;
- (void)setAddressStreet:(NSString *)street;
- (NSString *)addressStreet;
- (void)setAddressPostal:(NSString *)postal;
- (NSString *)addressPostal;
- (void)setAddressCity:(NSString *)city;
- (NSString *)addressCity;

- (void)setWebsite:(NSString *)website;
- (NSString *)website;

- (void)setFacebookUrl:(NSString *)facebookUrl;
- (NSString *)facebookUrl;
- (void)setFacebookId:(NSString *)facebookId;
- (NSString *)facebookId;
- (void)setTwitterUrl:(NSString *)twitterUrl;
- (NSString *)twitterUrl;
- (void)setTwitterId:(NSString *)twitterId;
- (NSString *)twitterId;
- (void)setXing:(NSString *)xing;
- (NSString *)xing;
- (void)setLinkedIn:(NSString *)linkedIn;
- (NSString *)linkedIn;

- (void)setCellPhoneSwitch:(BOOL)state;
- (BOOL)cellPhoneSwitch;

- (void)setPhoneSwitch:(BOOL)state;
- (BOOL)phoneSwitch;

- (void)setEmailSwitch:(BOOL)state;
- (BOOL)emailSwitch;

- (void)setJobSwitch:(BOOL)state;
- (BOOL)jobSwitch;

- (void)setCompanySwitch:(BOOL)state;
- (BOOL)companySwitch;

- (void)setAddressSwitch:(BOOL)state;
- (BOOL)addressSwitch;

- (void)setWebsiteSwitch:(BOOL)state;
- (BOOL)websiteSwitch;

- (void)setFacebookSwitch:(BOOL)state;
- (BOOL)facebookSwitch;

- (void)setTwitterSwitch:(BOOL)state;
- (BOOL)twitterSwitch;

- (void)setXingSwitch:(BOOL)state;
- (BOOL)xingSwitch;

- (void)setLinkedInSwitch:(BOOL)state;
- (BOOL)linkedInSwitch;

@end
