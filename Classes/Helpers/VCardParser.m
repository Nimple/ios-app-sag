//
//  VCardParser.m
//  nimple-iOS
//
//  Created by Ben John on 21/04/14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "VCardParser.h"
#import "Crypto.h"

@implementation VCardParser

+ (NimpleContact *)getContactFromCard:(NSString*)card {
    NimpleContact* contact = [[NimpleModel sharedModel]getTemporaryContact];
    
    NSArray *lines = [card componentsSeparatedByString:@"\n"];
    
    NSLog(@"Tokenize VCARD.");
    NSLog(@"%lu lines found in vCard", (unsigned long)[lines count]);
    NSLog(@"Lines are %@", lines);
    
    NSString *role = @"";
    NSString *title = @"";
    
    for (NSString *line in lines) {
        // in order to have a clean db entry
        NSString *newLine = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (newLine.length < 3) {
            continue;
        }
        
        if([newLine hasPrefix:@"N:"]) {
            newLine = [newLine substringFromIndex:2];
            NSArray *names = [newLine componentsSeparatedByString:@";"];
            if(names.count > 1) {
                contact.prename = names[1];
                contact.surname = names[0];
            } else {
                break;
            }
        } else if ([newLine hasPrefix:@"EMAIL"]) {
            NSString *email = [newLine substringFromIndex:[newLine rangeOfString:@":" options:NSBackwardsSearch].location + 1];
            contact.email = email;
        } else if ([newLine hasPrefix:@"TEL;HOME"] || [newLine hasPrefix:@"TEL;Home"] || [newLine hasPrefix:@"TEL;home"]) {
            NSString *phone = [newLine substringFromIndex:[newLine rangeOfString:@":" options:NSBackwardsSearch].location + 1];
            contact.phone = phone;
        } else if ([newLine hasPrefix:@"TEL;CELL"] || [newLine hasPrefix:@"TEL;Cell"] || [newLine hasPrefix:@"TEL;cell"]) {
            NSString *cellphone = [newLine substringFromIndex:[newLine rangeOfString:@":" options:NSBackwardsSearch].location + 1];
            contact.cellphone = cellphone;
        } else if ([newLine hasPrefix:@"ORG:"]) {
            // handle organisation
            // take care of multiple units
            NSString *company = [newLine substringFromIndex:4];
            
            if ([newLine rangeOfString:@";"].location != NSNotFound) {
                NSArray *orgs = [company componentsSeparatedByString:@";"];
                
                NSMutableString *company = [NSMutableString string];
                for(NSString *org in orgs) {
                    [company appendString:[NSString stringWithFormat:@"%@\n", org]];
                }
                contact.company = company;
            } else {
                contact.company = company;
            }
        } else if ([newLine hasPrefix:@"TITLE"]) {
            title = [newLine substringFromIndex:[newLine rangeOfString:@":" options:NSBackwardsSearch].location + 1];
        } else if ([newLine hasPrefix:@"ROLE"]) {
            role = [newLine substringFromIndex:[newLine rangeOfString:@":" options:NSBackwardsSearch].location + 1];
        } else if ([newLine hasPrefix:@"URL"]) {
            NSString *url = [newLine substringFromIndex:4];
            
            // parse urls
            if([newLine rangeOfString:@"facebook"].location != NSNotFound) {
                contact.facebook_URL = url;
            } else if([newLine rangeOfString:@"twitter"].location != NSNotFound) {
                contact.twitter_URL = url;
            } else if([newLine rangeOfString:@"xing"].location != NSNotFound) {
                contact.xing_URL = url;
            } else if([newLine rangeOfString:@"linkedin"].location != NSNotFound) {
                contact.linkedin_URL = url;
            } else {
                // assuming private website
                contact.website = url;
            }
        } else if ([newLine hasPrefix:@"X-FACEBOOK-ID:"]) {
            contact.facebook_ID = [newLine substringFromIndex:14];
        } else if ([newLine hasPrefix:@"X-TWITTER-ID:"]) {
            contact.twitter_ID = [newLine substringFromIndex:13];
        } else if ([newLine rangeOfString:@"ADR;"].location != NSNotFound) {
            if ([newLine rangeOfString:@":"].location == NSNotFound) {
                continue;
            }
            NSString *adr = [newLine substringFromIndex:[newLine rangeOfString:@":"].location];
            NSArray *adrValues = [adr componentsSeparatedByString:@";"];
            if (adrValues.count < 5) {
                continue;
            }
            // 0;1;2street;3city;4state;5zip;6country
            NSString *street = adrValues[2];
            NSString *postal = adrValues[5];
            NSString *city = adrValues[3];
            
            contact.street = street;
            contact.postal = postal;
            contact.city = city;
        } else if ([newLine hasPrefix:@"END:VCARD"]) {
            break;
        } else {
            // unrecognized line;
        }
    }
    
    // check for ROLE instead of TITLE
    if (role.length > 0 && title.length == 0) {
        contact.job = role;
    } else {
        contact.job = title;
    }
    
    contact.created = [NSDate date];
    contact.note = @"";
    contact.contactHash = [Crypto calculateMd5OfString:card];
    
    NSLog(@"Contact parsed: %@", contact);
    return contact;
}

@end
