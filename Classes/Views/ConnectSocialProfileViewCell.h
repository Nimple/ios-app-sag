//
//  ConnectSocialProfileViewCell.h
//  nimple-iOS
//
//  Created by Guido Schmidt on 03.03.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import <IOSLinkedInAPI/LIALinkedInApplication.h>
#import <IOSLinkedInAPI/LIALinkedInHttpClient.h>
#import <BDBOAuth1Manager/BDBOAuth1SessionManager.h>
#import "EditNimpleCodeTableViewController.h"

@interface ConnectSocialProfileViewCell : UITableViewCell <FBLoginViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate>

@property NSInteger index;
@property NSInteger section;

@property (weak, nonatomic) IBOutlet UIButton *socialNetworkButton;
@property (weak, nonatomic) IBOutlet UIButton *connectStatusButton;
@property (weak, nonatomic) IBOutlet UISwitch *propertySwitch;

@property (strong, atomic) UIActionSheet *actionSheet;
@property (strong, atomic) UIAlertView *alertView;
@property (strong, atomic) FBLoginView *fbLoginView;
@property (nonatomic) ACAccountStore *twitterAcount;
@property (nonatomic) BDBOAuth1SessionManager *networkManager;
@property (nonatomic) LIALinkedInHttpClient *linkedInClient;

- (void)configureCell;
- (void)animatePropertySwitchVisibilityTo:(NSInteger)value;
- (void)authorizeXing;
- (void)deauthorizeWithCompletion:(void (^)(void))completion;
- (LIALinkedInHttpClient *)linkedInClient;

@end
