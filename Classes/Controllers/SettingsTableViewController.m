//
//  SettingsTableViewController.m
//  nimple-iOS
//
//  Created by Ben John on 23/03/14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "SettingsTableViewController.h"

@interface SettingsTableViewController () {
    __weak IBOutlet UILabel *_faqLabel;
    __weak IBOutlet UILabel *_legalLabel;
    __weak IBOutlet UILabel *_disclaimerLabel;
    __weak IBOutlet UILabel *_imprintLabel;
    
    __weak IBOutlet UILabel *_facebookLabel;
    __weak IBOutlet UILabel *_twitterLabel;
    __weak IBOutlet UILabel *_shareLabel;
    __weak IBOutlet UILabel *_feedbackLabel;
    
    __weak IBOutlet UINavigationItem *_settingsLabel;
}
@end

@implementation SettingsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self localizeViewAttributes];
}

- (void)localizeViewAttributes
{
    _faqLabel.text = NimpleLocalizedString(@"settings_faq");
    _legalLabel.text = NimpleLocalizedString(@"settings_legal");
    _disclaimerLabel.text = NimpleLocalizedString(@"settings_disclaimer");
    _imprintLabel.text = NimpleLocalizedString(@"settings_imprint");
    
    _facebookLabel.text = NimpleLocalizedString(@"settings_facebook");
    _twitterLabel.text = NimpleLocalizedString(@"settings_twitter");
    _shareLabel.text = NimpleLocalizedString(@"settings_share");
    _feedbackLabel.text = NimpleLocalizedString(@"settings_feedback");
    
    _settingsLabel.title = NimpleLocalizedString(@"settings_title");
}

#pragma mark - Tap Gesture Action

- (IBAction)faqClicked:(id)sender
{
    NSString* language = [NSLocale preferredLanguages][0];
    if ([language isEqualToString:@"de"]) {
        NSURL *url = [NSURL URLWithString:@"http://www.nimple.de/faq/"];
        [[UIApplication sharedApplication] openURL:url];
    } else {
        NSURL *url = [NSURL URLWithString:@"http://www.appstronauten.com/faq_en/"];
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (IBAction)twitterClicked:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"https://twitter.com/Nimpleapp"];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)termsClicked:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"http://www.nimple.de/terms/"];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)disclaimerClicked:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"http://www.nimple.de/disclaimer/"];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)impressumClicked:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"http://www.nimple.de/imprint/"];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)visitFacebookClicked:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"http://www.nimple.de/facebook/"];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)shareNimpleClicked:(id)sender
{
    NSString *text = NimpleLocalizedString(@"settings.share-text");
    
    NSString* language = [NSLocale preferredLanguages][0];
    NSURL *url;
    if ([language isEqualToString:@"de"]) {
        url = [NSURL URLWithString:@"http://www.nimple.de"];
    } else {
        url = [NSURL URLWithString:@"http://www.nimpleapp.com"];
    }
    
    UIImage *image = [UIImage imageNamed:@"ic_nimple"];
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[text, url, image] applicationActivities:nil];
    [controller setValue:NimpleLocalizedString(@"settings.share-header") forKey:@"subject"];
    controller.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeAddToReadingList, UIActivityTypeAirDrop];
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)feedbackClicked:(id)sender
{
    NSString *recipient = NimpleLocalizedString(@"mail_first_contact_label");
    NSString *topic = NimpleLocalizedString(@"settings.feedback-header");
    NSString *text = NimpleLocalizedString(@"settings.feedback-text");
    
    MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
    [mailVC setMailComposeDelegate:self];
    
    if ([MFMailComposeViewController canSendMail]) {
        [mailVC setToRecipients:@[recipient]];
        [mailVC setSubject:topic];
        [mailVC setMessageBody:text isHTML:NO];
        [self presentViewController:mailVC animated:YES completion:nil];
    }
}

#pragma mark - MailComposeViewDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
