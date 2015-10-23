//
//  DisplayContactViewController.m
//  nimple-iOS
//
//  Created by Ben John on 21/04/14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "DisplayContactViewController.h"
#import "AddressBook/AddressBook.h"
#import "AddressBookUI/ABUnknownPersonViewController.h"
#import "NimplePurchaseModel.h"
#import "VCardCreator.h"
#import "Logging.h"

@interface DisplayContactViewController () {
    __weak IBOutlet UILabel *_websiteLabel;
    __weak IBOutlet UILabel *_addressLabel;
}

@property (weak, nonatomic) IBOutlet UILabel *cellPhoneLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation DisplayContactViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self localizeViewAttributes];
    [self updateView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([[NimplePurchaseModel sharedPurchaseModel] isPurchased]) {
        self.shareContactButton.hidden = NO;
    } else {
        self.shareContactButton.hidden = YES;
        
        // TODO maybe adjust
        NSLayoutConstraint *c = self.shareContactButton.constraints[0];
        c.constant = 0;
        
        [self.shareContactButton layoutIfNeeded];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self configureScrollView];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self saved];
}

- (void)localizeViewAttributes
{
    self.notesTextField.placeholder = NimpleLocalizedString(@"display_contact_notes_label");
    [self.saveToAddressBookButton setTitle:NimpleLocalizedString(@"add_to_addressbook_button") forState:UIControlStateNormal];
    [self.deleteContactButton setTitle:NimpleLocalizedString(@"delete_contact_button") forState:UIControlStateNormal];
    [self.shareContactButton setTitle:NimpleLocalizedString(@"share_contact") forState:UIControlStateNormal];
    self.navBar.title = NimpleLocalizedString(@"display_contact_title");
}

- (void)configureScrollView
{
    
}

- (void)updateView
{
    NSLog(@"Display contact %@", self.nimpleContact);
    
    NSString* name = [NSString stringWithFormat:@"%@ %@", self.nimpleContact.prename, self.nimpleContact.surname];
    self.nameLabel.text = name;
    self.phoneLabel.text = self.nimpleContact.phone;
    self.emailLabel.text = self.nimpleContact.email;
    self.companyLabel.text = self.nimpleContact.company;
    self.jobLabel.text = self.nimpleContact.job;
    _websiteLabel.text = self.nimpleContact.website;
    self.cellPhoneLabel.text = self.nimpleContact.cellphone;
    
    // address
    if (self.nimpleContact.hasAddress) {
        if (self.nimpleContact.street.length > 0) {
            NSString *address = [[NSString alloc] initWithFormat:@"%@\n%@ %@", self.nimpleContact.street, self.nimpleContact.postal, self.nimpleContact.city];
            _addressLabel.text = address;
        } else {
            NSString *address = [[NSString alloc] initWithFormat:@"%@ %@\n", self.nimpleContact.postal, self.nimpleContact.city];
            _addressLabel.text = address;
        }
    } else {
        _addressLabel.text = @"";
    }
    
    // timestamp and notes
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:NimpleLocalizedString(@"date_format")];
    NSString *formattedDate = [dateFormatter stringFromDate:self.nimpleContact.created];
    NSString* language = [NSLocale preferredLanguages][0];
    if ([language isEqualToString:@"de"]) {
        self.timestampLabel.text = [NSString stringWithFormat:@"%@ Uhr", formattedDate];
    } else {
        self.timestampLabel.text = [NSString stringWithFormat:@"%@", formattedDate];
    }
    self.notesTextField.text = self.nimpleContact.note;
    
    // social networks
    if ((self.nimpleContact.facebook_URL.length != 0 || self.nimpleContact.facebook_ID.length != 0)) {
        [self.facebookIcon setAlpha:1.0];
        [self.facebookURL setTitle:self.nimpleContact.facebook_URL forState:UIControlStateNormal];
    } else {
        [self.facebookIcon setAlpha:0.2];
        [self.facebookURL setTitle:NimpleLocalizedString(@"detail_facebook_label") forState:UIControlStateNormal];
    }
    
    if ((self.nimpleContact.twitter_URL.length != 0 || self.nimpleContact.twitter_ID.length != 0)) {
        [self.twitterIcon setAlpha:1.0];
        [self.twitterURL setTitle:self.nimpleContact.twitter_URL forState:UIControlStateNormal];
    } else {
        [self.twitterIcon setAlpha:0.2];
        [self.twitterURL setTitle:NimpleLocalizedString(@"detail_twitter_label") forState:UIControlStateNormal];
    }
    
    if (self.nimpleContact.xing_URL.length != 0) {
        [self.xingIcon setAlpha:1.0];
        [self.xingURL setTitle:self.nimpleContact.xing_URL forState:UIControlStateNormal];
    } else {
        [self.xingIcon setAlpha:0.2];
        [self.xingURL setTitle:NimpleLocalizedString(@"detail_xing_label") forState:UIControlStateNormal];
    }
    
    if (self.nimpleContact.linkedin_URL.length != 0) {
        [self.linkedinIcon setAlpha:1.0];
        [self.linkedinURL setTitle:self.nimpleContact.linkedin_URL forState:UIControlStateNormal];
    } else {
        [self.linkedinIcon setAlpha:0.2];
        [self.linkedinURL setTitle:NimpleLocalizedString(@"detail_linkedin_label") forState:UIControlStateNormal];
    }
    
    // Initalize action sheets
    self.actionSheetDelete = [[UIActionSheet alloc] initWithTitle:NimpleLocalizedString(@"msg_box_delete_contact_title") delegate:self
                                                cancelButtonTitle:NimpleLocalizedString(@"msg_box_delete_contact_activity2") destructiveButtonTitle:NimpleLocalizedString(@"msg_box_delete_contact_activity1") otherButtonTitles: nil];
    
    self.actionSheetAddressbook = [[UIActionSheet alloc] initWithTitle:NimpleLocalizedString(@"msg_box_save_contact_title") delegate:self cancelButtonTitle:NimpleLocalizedString(@"msg_box_save_contact_activity2") destructiveButtonTitle:NimpleLocalizedString(@"msg_box_save_contact_activity1") otherButtonTitles: nil];
    
    // initialize on tap recognizer for mail and phone labels
    UITapGestureRecognizer *phoneTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneButtonClicked:)];
    phoneTapGestureRecognizer.numberOfTapsRequired = 1;
    [self.phoneLabel addGestureRecognizer:phoneTapGestureRecognizer];
    self.phoneLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *mailTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mailButtonClicked:)];
    mailTapGestureRecognizer.numberOfTapsRequired = 1;
    [self.emailLabel addGestureRecognizer:mailTapGestureRecognizer];
    self.emailLabel.userInteractionEnabled = YES;
}

#pragma mark - Actions

- (IBAction)websiteClicked:(id)sender
{
    if([_websiteLabel.text length] == 0) {
        return;
    }
    NSLog(@"%@", _websiteLabel.text);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_websiteLabel.text]];
}

- (IBAction)addressClicked:(id)sender
{
    if([_addressLabel.text length] == 0) {
        return;
    }
    NSString *addressString = [[_addressLabel.text stringByReplacingOccurrencesOfString:@" " withString:@"+"] stringByReplacingOccurrencesOfString:@"\n" withString:@"+"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.apple.com/?q=%@", addressString]];
    NSLog(@"%@", _addressLabel.text);
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark - Callbacks

- (void) saved
{
    self.nimpleContact.note = self.notesTextField.text;
    [_delegate contactShouldBeSaved];
}

- (IBAction)saveClicked:(id)sender
{
    [self saved];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveToAddressBookButtonClicked:(id)sender
{
    [self.actionSheetAddressbook showInView:self.view];
}

- (IBAction)shareContactButtonClicked:(id)sender
{
    if ([[NimplePurchaseModel sharedPurchaseModel] isPurchased]) {
        NSString *vcard = [[VCardCreator sharedInstance] createVCardFromNimpleContact:self.nimpleContact];
        
        // send mail with attachment
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer addAttachmentData:[vcard dataUsingEncoding:NSUTF8StringEncoding] mimeType:@"text/vcard" fileName:@"contact.vcf"];
        [self.navigationController presentViewController:mailer animated:YES completion:nil];
    }
}

- (IBAction)deleteContactButtonClicked:(id)sender
{
    [self.actionSheetDelete showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == self.actionSheetDelete && buttonIndex == 0) {
        [_delegate contactShouldBeDeleted:self.nimpleContact];
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (actionSheet == self.actionSheetAddressbook && buttonIndex == 0) {
        [self checkForAccess];
    }
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Button Handling
// Opens the browser with the linkedin url
- (IBAction)linkedinButtonClicked:(id)sender
{
    if (self.nimpleContact.linkedin_URL.length != 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.nimpleContact.linkedin_URL]];
    }
}

// Opens the browser with the xing url
- (IBAction)xingButtonClicked:(id)sender
{
    if (self.nimpleContact.xing_URL.length != 0) {
        NSString *newXingUrl = [self.nimpleContact.xing_URL substringFromIndex:29];
        NSString *finalCallUrl = [NSString stringWithFormat:@"https://touch.xing.com/users/%@", newXingUrl];
        NSLog(@"%@", finalCallUrl);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:finalCallUrl]];
    }
}

// Opens the browser with the twitter url
- (IBAction)twitterButtonClicked:(id)sender
{
    if (self.nimpleContact.twitter_URL.length != 0) {
        NSURL *url = [NSURL URLWithString:self.nimpleContact.twitter_URL];
        [[UIApplication sharedApplication] openURL:url];
    }
}

// Opens the browser with the facebook url
- (IBAction)facebookButtonClicked:(id)sender
{
    if(self.nimpleContact.facebook_URL.length == 0) {
        return;
    }
    
    UIApplication *app = [UIApplication sharedApplication];
    NSURL *facebookURL = [NSURL URLWithString:[NSString stringWithFormat:@"fb://profile/%@",self.nimpleContact.facebook_ID]];
    if ([app canOpenURL:facebookURL]) {
        [app openURL:facebookURL];
        return;
    } else
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.nimpleContact.facebook_URL]];
}

// Delegates calling a phone number to the phone app
- (IBAction)phoneButtonClicked:(id)sender
{
    if (self.nimpleContact.phone.length == 0) {
        return;
    }
    
    UIDevice *device = [UIDevice currentDevice];
    
    if ([self.nimpleContact.phone isEqualToString:@"http://www.nimple.de"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.nimpleContact.phone]];
    } else if ([[device model] isEqualToString:@"iPhone"]) {
        NSString *phoneNumber = [@"tel://" stringByAppendingString:self.nimpleContact.phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    } else {
        UIAlertView *warning =[[UIAlertView alloc] initWithTitle:@"Note" message:@"Error: Phone Calls does not work on an iPad" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warning show];
    }
}

- (IBAction)cellPhoneClicked:(id)sender
{
    if (self.nimpleContact.phone.length == 0) {
        return;
    }
    
    UIDevice *device = [UIDevice currentDevice];
    
    if ([self.nimpleContact.phone isEqualToString:@"http://www.nimple.de"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.nimpleContact.phone]];
    } else if ([[device model] isEqualToString:@"iPhone"]) {
        NSString *phoneNumber = [@"tel://" stringByAppendingString:self.nimpleContact.phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    } else {
        UIAlertView *warning =[[UIAlertView alloc] initWithTitle:@"Note" message:@"Error: Phone Calls does not work on an iPad" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warning show];
    }
}


- (IBAction)mailButtonClicked:(id)sender
{
    if (self.nimpleContact.cellphone.length == 0) {
        return;
    }
    
    UIDevice *device = [UIDevice currentDevice];
    
    if ([[device model] isEqualToString:@"iPhone"]) {
        NSString *phoneNumber = [@"tel://" stringByAppendingString:self.nimpleContact.cellphone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    } else {
        UIAlertView *warning =[[UIAlertView alloc] initWithTitle:@"Note" message:@"Error: Phone Calls does not work on an iPad" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warning show];
    }
}

#pragma mark - AddressBook Handling

- (void)unknownPersonViewController:(ABUnknownPersonViewController *)unknownCardViewController didResolveToPerson:(ABRecordRef)person
{
    [unknownCardViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)addToAddressBook
{
    ABUnknownPersonViewController *addPersonView = [[ABUnknownPersonViewController alloc] init];
    addPersonView.unknownPersonViewDelegate = self;
    addPersonView.displayedPerson = [self prepareNimpleContactForAddressBook];
    addPersonView.allowsAddingToAddressBook = YES;
    addPersonView.allowsActions = YES;
    [[Logging sharedLogging] sendContactTransferredEvent];
    [self.navigationController pushViewController:addPersonView animated:YES];
}

- (void)checkForAccess
{
    // Request authorization to Address Book
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    // First time access has been granted, add the contact
                    [self addToAddressBook];
                } else {
                    // User denied access
                    // Display an alert telling user the contact could not be added
                    [self showAlertViewAddressBook];
                }
            });
        });
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        // The user has previously given access, add the contact
        [self addToAddressBook];
    } else {
        // The user has previously denied access
        // Send an alert telling user to change privacy setting in settings app
        [self showAlertViewAddressBook];
    }
}

- (void)showAlertViewAddressBook
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:NimpleLocalizedString(@"contacts_no_access_title") message:NimpleLocalizedString(@"contacts_no_access_text") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [message show];
}

#pragma mark - Saving contact to address book

- (ABRecordRef)prepareNimpleContactForAddressBook
{
    ABRecordRef result = NULL;
    CFErrorRef error = NULL;
    
    result = ABPersonCreate();
    if (result == NULL) {
        NSLog(@"Failed to create a new person.");
        return NULL;
    }
    
    ABRecordSetValue(result, kABPersonFirstNameProperty, (__bridge CFTypeRef) self.nimpleContact.prename, &error);
    ABRecordSetValue(result, kABPersonLastNameProperty, (__bridge CFTypeRef) self.nimpleContact.surname, &error);
    
    if (self.nimpleContact.phone.length > 0 && ![self.nimpleContact.phone isEqualToString:@"http://www.nimple.de"]) {
        ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef) self.nimpleContact.phone, kABPersonPhoneMainLabel, nil);
        ABRecordSetValue(result, kABPersonPhoneProperty, multiPhone, nil);
    }
    
    if (self.nimpleContact.cellphone) {
        ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef) self.nimpleContact.cellphone, kABPersonPhoneMobileLabel, nil);
        ABRecordSetValue(result, kABPersonPhoneProperty, multiPhone, nil);
    }
    
    if (self.nimpleContact.email.length > 0) {
        ABMutableMultiValueRef multiMail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(multiMail, (__bridge CFTypeRef) self.nimpleContact.email, kABHomeLabel, nil);
        ABRecordSetValue(result, kABPersonEmailProperty, multiMail, nil);
    }
    
    if (self.nimpleContact.website.length > 0) {
        ABMutableMultiValueRef multiUrl = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(multiUrl, (__bridge CFTypeRef) self.nimpleContact.website, kABPersonHomePageLabel, NULL);
        ABRecordSetValue(result, kABPersonURLProperty, multiUrl, nil);
    }
    
    if (self.nimpleContact.hasAddress) {
        ABMutableMultiValueRef multiAddress = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
        NSMutableDictionary *address = [[NSMutableDictionary alloc] init];
        address[(NSString *)kABPersonAddressStreetKey] = self.nimpleContact.street;
        address[(NSString *)kABPersonAddressCityKey] = self.nimpleContact.city;
        address[(NSString *)kABPersonAddressZIPKey] = self.nimpleContact.postal;
        ABMultiValueAddValueAndLabel(multiAddress, (__bridge CFTypeRef) address, kABWorkLabel, NULL);
        ABRecordSetValue(result, kABPersonAddressProperty, multiAddress, nil);
    }
    
    if (self.nimpleContact.job.length > 0) {
        ABRecordSetValue(result, kABPersonJobTitleProperty, (__bridge CFTypeRef) self.nimpleContact.job, &error);
    }
    
    if (self.nimpleContact.company.length > 0) {
        ABRecordSetValue(result, kABPersonOrganizationProperty, (__bridge CFTypeRef) self.nimpleContact.company, &error);
    }
    
    if (self.nimpleContact.note.length > 0) {
        ABRecordSetValue(result, kABPersonNoteProperty, (__bridge CFTypeRef) self.nimpleContact.note, &error);
    }
    
    return result;
}

@end
