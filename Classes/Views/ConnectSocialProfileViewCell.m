//
//  ConnectSocialProfileViewCell.m
//  nimple-iOS
//
//  Created by Guido Schmidt on 03.03.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#define XING_CONSUMER_KEY @"247e95c9f304f6c5aaff"
#define XING_CONSUMER_SECRET @"cebe8869323e6d227257361eeabf05046c243721"

#import "ConnectSocialProfileViewCell.h"
#import "NimpleAppDelegate.h"

@interface ConnectSocialProfileViewCell ()

@property NimpleCode *code;

@end

@implementation ConnectSocialProfileViewCell

- (void)configureCell
{
    self.code = [NimpleCode sharedCode];
}

- (IBAction)propertySwitched:(id)sender
{
    if (self.section == 2) {
        if (self.index == 0) {
            self.code.facebookSwitch = [self.propertySwitch isOn];
        }
        if (self.index == 1) {
            self.code.twitterSwitch = [self.propertySwitch isOn];
        }
        if (self.index == 2) {
            self.code.xingSwitch = [self.propertySwitch isOn];
        }
        if (self.index == 3) {
            self.code.linkedInSwitch = [self.propertySwitch isOn];
        }
    }
}

#pragma mark - Action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        // facebook is handled in FBLoginView
        if(self.index == 1) {
            [self.socialNetworkButton setAlpha:0.3];
            [self animatePropertySwitchVisibilityTo:0.0];
            [self.connectStatusButton setTitle:NimpleLocalizedString(@"twitter_label") forState:UIControlStateNormal];
            self.code.twitterId = @"";
            self.code.twitterUrl = @"";
        }
        if (self.index == 2) {
            [self deauthorizeWithCompletion:^{
                [self.socialNetworkButton setAlpha:0.3];
                [self animatePropertySwitchVisibilityTo:0.0];
                [self.connectStatusButton setTitle:NimpleLocalizedString(@"xing_label") forState:UIControlStateNormal];
                self.code.xing = @"";
            }];
        }
        if (self.index == 3) {
            [self.socialNetworkButton setAlpha:0.3];
            [self animatePropertySwitchVisibilityTo:0.0];
            [self.connectStatusButton setTitle:NimpleLocalizedString(@"linkedin_label") forState:UIControlStateNormal];
            self.code.linkedIn = @"";
        }
    }
}

#pragma mark - Alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
    }
}

#pragma mark - Handle social networks

- (IBAction)connectButtonClicked:(id)sender
{
    NSString *destructiveTitle = NimpleLocalizedString(@"msg_box_social_logout_activity1");
    NSString *cancelTitle = NimpleLocalizedString(@"msg_box_social_logout_activity2");
    
    // initialize dialogs for user-interaction
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:cancelTitle destructiveButtonTitle:destructiveTitle otherButtonTitles: nil];
    self.alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    if (self.index == 0) {
        [self handleFacebook];
    }
    if (self.index == 1) {
        [self handleTwitter];
    }
    if (self.index == 2) {
        [self handleXing];
    }
    if (self.index == 3) {
        [self handleLinkedIn];
    }
}

#pragma mark - Handle facebook

- (void)handleFacebook
{
    self.fbLoginView = [[FBLoginView alloc] init];
    self.fbLoginView.readPermissions = @[@"public_profile"];
    [self addSubview:self.fbLoginView];
    [self.fbLoginView setHidden:YES];
    self.fbLoginView.delegate = self;
    
    for (id object in self.fbLoginView.subviews) {
        if ([[object class] isSubclassOfClass:[UIButton class]]) {
            UIButton* button = (UIButton*)object;
            [button sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
    }
}

#pragma mark - FBLoginViewDelegate

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    [self.socialNetworkButton setAlpha:0.3];
    [self animatePropertySwitchVisibilityTo:0.0];
    [self.connectStatusButton setTitle:NimpleLocalizedString(@"facebook_label") forState:UIControlStateNormal];
    self.code.facebookId = @"";
    self.code.facebookUrl = @"";
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    self.code.facebookId = [user objectForKey:@"id"];
    self.code.facebookUrl = user.link;
    [self.socialNetworkButton setAlpha:1.0];
    [self.connectStatusButton setTitle:NimpleLocalizedString(@"connected_label") forState:UIControlStateNormal];
    [self animatePropertySwitchVisibilityTo:1.0];
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error
{
    NSString *alertMessage, *alertTitle;
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

#pragma mark - Handle twitter

- (void)handleTwitter
{
    if (self.code.twitterId.length == 0) {
        self.twitterAcount = [[ACAccountStore alloc] init];
        ACAccountType *accountType = [self.twitterAcount accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        [self.twitterAcount requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
            if (granted == YES) {
                NSArray* accountsArray = [self.twitterAcount accountsWithAccountType:accountType];
                if ([accountsArray count] > 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.socialNetworkButton setAlpha:1.0];
                        [self.connectStatusButton setTitle:NimpleLocalizedString(@"connected_label") forState:UIControlStateNormal];
                        [self animatePropertySwitchVisibilityTo:1.0];
                    });
                    ACAccount *twitterAccount = [accountsArray lastObject];
                    NSString *twitter_URL = [NSString stringWithFormat:@"https://twitter.com/%@", twitterAccount.username];
                    NSString *twitter_ID = [[twitterAccount valueForKey:@"properties"] valueForKey:@"user_id"];
                    self.code.twitterId = twitter_ID;
                    self.code.twitterUrl = twitter_URL;
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.alertView.title = NimpleLocalizedString(@"twitter_not_found_alert_title");
                        self.alertView.message = NimpleLocalizedString(@"twitter_not_found_alert_message");
                        [self.alertView show];
                    });
                }
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.alertView.title = NimpleLocalizedString(@"twitter_not_allowed_alert_title");
                    self.alertView.message = NimpleLocalizedString(@"twitter_not_allowed_alert_message");
                    [self.alertView show];
                });
            }
        }];
    } else {
        self.actionSheet.title = NimpleLocalizedString(@"msg_box_social_logout_twitter_title");
        [self.actionSheet showInView:self.superview.superview];
    }
}

#pragma mark - Handle xing

- (void)handleXing
{
    // Introduce table view cell to app delegate, which handles the URL-opening in the browser
    self.networkManager = [[BDBOAuth1SessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.xing.com/"] consumerKey:XING_CONSUMER_KEY consumerSecret:XING_CONSUMER_SECRET];
    NimpleAppDelegate *appDelegate = (NimpleAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (!appDelegate.xingTableViewCell) {
        appDelegate.xingTableViewCell = self;
    }
    if (self.networkManager) {
        appDelegate.networkManager = self.networkManager;
    }
    if ([self.networkManager isAuthorized]) {
        self.actionSheet.title = NimpleLocalizedString(@"msg_box_social_logout_xing_title");
        [self.actionSheet showInView:self.superview.superview];
    } else {
        [self authorizeXing];
    }
}

- (void)authorizeXing
{
    [self.networkManager fetchRequestTokenWithPath:@"/v1/request_token" method:@"POST" callbackURL:[NSURL URLWithString:@"oauth://xing"] scope:nil success:^(BDBOAuth1Credential *requestToken) {
        NSString *authURL = [NSString stringWithFormat:@"https://api.xing.com/v1/authorize?oauth_token=%@", requestToken.token];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL]];
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        dispatch_async(dispatch_get_main_queue(), ^ {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not acquire OAuth request token. Please try again later." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
        });
    }];
}

- (void)deauthorizeWithCompletion:(void (^)(void))completion
{
    NimpleAppDelegate *appDelegate = (NimpleAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.networkManager deauthorize];
    [appDelegate.networkManager.requestSerializer removeAccessToken];
    
    if (completion) {
        completion();
    }
}

#pragma mark - Handle linkedin

- (void)handleLinkedIn
{
    if (self.code.linkedIn.length == 0) {
        self.linkedInClient = [self linkedInClient];
        [self.linkedInClient getAuthorizationCode:^(NSString *code) {
            [self.linkedInClient getAccessToken:code success:^(NSDictionary *accessTokenData) {
                NSString *accessToken = accessTokenData[@"access_token"];
                [self.linkedInClient GET:[NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~?oauth2_access_token=%@&format=json", accessToken] parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *result) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.socialNetworkButton setAlpha:1.0];
                        [self.connectStatusButton setTitle:NimpleLocalizedString(@"connected_label") forState:UIControlStateNormal];
                        [self animatePropertySwitchVisibilityTo:1.0];
                    });
                    NSDictionary *profileRequest = [result valueForKey:@"siteStandardProfileRequest"];
                    NSString *url = [profileRequest valueForKey:@"url"];
                    url = [url substringToIndex:[url rangeOfString:@"&"].location];
                    self.code.linkedIn = url;
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"failed to fetch current user %@", error);
                }];
            } failure:^(NSError *error) {
                NSLog(@"Quering accessToken failed %@", error);
            }];
        }                      cancel:^{
            NSLog(@"Authorization was cancelled by user");
        }                     failure:^(NSError *error) {
            NSLog(@"Authorization failed %@", error);
        }];
    } else {
        self.actionSheet.title = NimpleLocalizedString(@"msg_box_social_logout_linkedin_title");
        [self.actionSheet showInView:self.superview.superview];
    }
}

- (LIALinkedInHttpClient *)linkedInClient
{
    LIALinkedInApplication *application = [LIALinkedInApplication applicationWithRedirectURL:@"http://www.nimple.de" clientId:@"77pixj2vchhmrj" clientSecret:@"XDzQSRgsL1BOO8nm" state:@"DCEEFWF45453sdffef424" grantedAccess:@[@"r_basicprofile"]];
    UITableView *tableView = (UITableView *) self.superview.superview;
    EditNimpleCodeTableViewController *viewController = (EditNimpleCodeTableViewController *) tableView.dataSource;
    return [LIALinkedInHttpClient clientForApplication:application presentingViewController:viewController];
}

#pragma mark - Small helper

- (void)animatePropertySwitchVisibilityTo:(NSInteger)value
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [_propertySwitch setAlpha:value];
    [UIView commitAnimations];
}

@end
