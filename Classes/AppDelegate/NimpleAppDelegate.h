//
//  NimpleAppDelegate.h
//  nimple-iOS
//
//  Created by Ben John on 14/08/14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>
#import <FacebookSDK/FacebookSDK.h>
#import <NSDictionary+BDBOAuth1Manager.h>
#import "ConnectSocialProfileViewCell.h"

@interface NimpleAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, readwrite) BDBOAuth1SessionManager *networkManager;
@property (atomic) ConnectSocialProfileViewCell *xingTableViewCell;

- (NSURL *)applicationDocumentsDirectory;

@end
