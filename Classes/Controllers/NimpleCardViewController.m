//
//  NimpleCardViewController.m
//  nimple-iOS
//
//  Created by Guido Schmidt on 07.03.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "NimpleCardViewController.h"
#import "NimplePurchaseModel.h"
#import "VCardCreator.h"

@interface NimpleCardViewController () {
    __weak IBOutlet UILabel *_tutorialAddLabel;
    __weak IBOutlet UILabel *_tutorialEditLabel;
    
    __weak IBOutlet UINavigationItem *_navigationLabel;
    
    __weak IBOutlet UILabel *_websiteLabel;
    __weak IBOutlet UIImageView *_websiteIcon;
    
    __weak IBOutlet UILabel *_addressLabel;
    __weak IBOutlet UIImageView *_addressIcon;
    
    NimpleCode *_code;
}

@property (weak, nonatomic) IBOutlet UILabel *headerCard;

@end

@implementation NimpleCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _code = [NimpleCode sharedCode];
    [self localizeViewAttributes];
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([[NimplePurchaseModel sharedPurchaseModel] isPurchased]) {
        [self.cardSegmentedControl setHidden:NO];
        [self.cardSegmentedControl setSelectedSegmentIndex:[[NimpleCode sharedCode] dictionaryIndex]];
        [self.headerCard setHidden:NO];
        if (self.checkOwnProperties) {
            [self.headerCard setHidden:YES];
        }
    } else {
        [self.cardSegmentedControl setHidden:YES];
        [self.headerCard setHidden:YES];
    }
    [self updateView];
}

- (void)localizeViewAttributes
{
    _tutorialAddLabel.text = NimpleLocalizedString(@"tutorial_add_text");
    _tutorialEditLabel.text = NimpleLocalizedString(@"tutorial_edit_text");
    _navigationLabel.title = NimpleLocalizedString(@"nimple_card_label");
    self.headerCard.text = NimpleLocalizedString(@"header_card");
}

- (void)updateView
{
    if ([[NimplePurchaseModel sharedPurchaseModel] isPurchased]) {
        [self.headerCard setHidden:NO];
        if (self.checkOwnProperties) {
            [self.headerCard setHidden:YES];
        }
    } else {
        [self.headerCard setHidden:YES];
    }
    if (self.checkOwnProperties) {
        [self.nimpleCardView setHidden:TRUE];
        [self.welcomeView setHidden:FALSE];
        return;
    } else {
        [self.nimpleCardView setHidden:FALSE];
        [self.welcomeView setHidden:TRUE];
        [self fillNimpleCard];
    }
}

- (BOOL)checkOwnProperties
{
    return (_code.prename.length == 0 && _code.surname.length == 0);
}

- (void)fillNimpleCard
{
    [self.nameLabel setText:[NSString stringWithFormat:@"%@ %@", _code.prename, _code.surname]];
    [self.jobLabel setText:_code.job];
    [self.companyLabel setText:_code.company];
    [self.phoneLabel setText:_code.phone];
    [self.mobilePhoneLabel setText:_code.cellPhone];
    [self.emailLabel setText:_code.email];
    _websiteLabel.text = _code.website;
    
    if (_code.hasAddress) {
        if (_code.addressStreet > 0) {
            NSString *address = [[NSString alloc] initWithFormat:@"%@\n%@ %@", _code.addressStreet, _code.addressPostal, _code.addressCity];
            _addressLabel.text = address;
        } else {
            NSString *address = [[NSString alloc] initWithFormat:@"%@ %@\n", _code.addressPostal, _code.addressCity];
            _addressLabel.text = address;
        }
    } else {
        _addressLabel.text = @"";
    }
    
    if ((_code.facebookUrl.length != 0 || _code.facebookId.length != 0) && _code.facebookSwitch) {
        [self.facebookIcon setAlpha:1.0];
    } else {
        [self.facebookIcon setAlpha:0.2];
    }
    
    if ((_code.twitterUrl.length != 0 || _code.twitterId.length != 0) && _code.twitterSwitch) {
        [self.twitterIcon setAlpha:1.0];
    } else {
        [self.twitterIcon setAlpha:0.2];
    }
    
    if (_code.xing.length != 0 && _code.xingSwitch) {
        [self.xingIcon setAlpha:1.0];
    } else {
        [self.xingIcon setAlpha:0.2];
    }
    
    if (_code.linkedIn.length != 0 && _code.linkedInSwitch) {
        [self.linkedinIcon setAlpha:1.0];
    } else {
        [self.linkedinIcon setAlpha:0.2];
    }
    
    if (!_code.addressSwitch) {
        [_addressLabel setAlpha:0.2];
        [_addressIcon setAlpha:0.2];
    } else {
        [_addressLabel setAlpha:1.0];
        [_addressIcon setAlpha:1.0];
    }
    
    if (!_code.websiteSwitch) {
        [_websiteLabel setAlpha:0.2];
        [_websiteIcon setAlpha:0.2];
    } else {
        [_websiteLabel setAlpha:1.0];
        [_websiteIcon setAlpha:1.0];
    }
    
    if (!_code.phoneSwitch) {
        [self.phoneLabel setAlpha:0.2];
        [self.phoneIcon setAlpha:0.2];
    } else {
        [self.phoneLabel setAlpha:1.0];
        [self.phoneIcon setAlpha:1.0];
    }
    
    if (!_code.cellPhoneSwitch) {
        [self.mobilePhoneLabel setAlpha:0.2];
        [self.mobilePhoneIcon setAlpha:0.2];
    } else {
        [self.mobilePhoneLabel setAlpha:1.0];
        [self.mobilePhoneIcon setAlpha:1.0];
    }
    
    if (!_code.emailSwitch) {
        [self.emailLabel setAlpha:0.2];
        [self.emailIcon setAlpha:0.2];
    } else {
        [self.emailLabel setAlpha:1.0];
        [self.emailIcon setAlpha:1.0];
    }
    
    if (!_code.companySwitch) {
        [self.companyLabel setAlpha:0.2];
        [self.companyIcon setAlpha:0.2];
    } else {
        [self.companyLabel setAlpha:1.0];
        [self.companyIcon setAlpha:1.0];
    }
    
    if (!_code.jobSwitch) {
        [self.jobLabel setAlpha:0.2];
        [self.jobIcon setAlpha:0.2];
    } else {
        [self.jobLabel setAlpha:1.0];
        [self.jobIcon setAlpha:1.0];
    }
}

#pragma mark - Share card

- (IBAction)shareCardButtonClicked:(id)sender
{
    if ([[NimplePurchaseModel sharedPurchaseModel] isPurchased]) {
        NSString *string = [[VCardCreator sharedInstance] createVCardFromNimpleCode:_code];
        NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
        
        // send mail with attachment
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer addAttachmentData:data mimeType:@"text/vcard" fileName:@"contact.vcf"];
        [self presentViewController:mailer animated:YES completion:nil];
    }
}

#pragma mark - Share Card

- (IBAction)shareCard:(id)sender
{
    if ([[NimplePurchaseModel sharedPurchaseModel] isPurchased]) {
        NSString *vcard = [[VCardCreator sharedInstance] createVCardFromNimpleCode:_code];
        
        // send mail with attachment
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer addAttachmentData:[vcard dataUsingEncoding:NSUTF8StringEncoding] mimeType:@"text/vcard" fileName:@"contact.vcf"];
        [self.navigationController presentViewController:mailer animated:YES completion:nil];
    }
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Handles the nimpleCodeChanged notifaction

- (void)handleChangedNimpleCode:(NSNotification *)note
{
    NSLog(@"Nimple code changed received in NimpleCardViewController");
    [self updateView];
}

#pragma mark - Segmented control handling multiple nimple cards

- (IBAction)segmentedControlValueChanged:(id)sender
{
    [_code switchToDictionaryWithIndexInteger:self.cardSegmentedControl.selectedSegmentIndex];
    [self updateView];
}


@end
