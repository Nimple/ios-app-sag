//
//  ContactsViewController.m
//  nimple-iOS
//
//  Created by Guido Schmidt on 04.03.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "ContactsViewController.h"
#import "ContactTableViewCell.h"
#import "NimpleContact.h"
#import "NimpleModel.h"
#import "VCardCreator.h"

@interface ContactsViewController () {
    __weak IBOutlet UINavigationItem *_navigationLabel;
    
    NimpleModel *_model;
    NSArray *_contacts;
}

@property (strong, nonatomic) IBOutlet UIBarButtonItem *exportContactsButton;

@end

@implementation ContactsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _model = [NimpleModel sharedModel];
    [self localizeViewAttributes];
    [self configureTableView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateView];
}

- (void)localizeViewAttributes
{
    _navigationLabel.title = NimpleLocalizedString(@"contacts_title");
}

- (void)configureTableView
{
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 10.0f)];
}

- (void)updateView
{
    _contacts = [_model contacts];
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"DetailView"]) {
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        NimpleContact *contact = _contacts[indexPath.row];
        DisplayContactViewController *displayContactViewController = segue.destinationViewController;
        displayContactViewController.delegate = self;
        displayContactViewController.nimpleContact = contact;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_contacts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell" forIndexPath:indexPath];
    [cell configureCellWithContact:_contacts[indexPath.row]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - Export Contacts

- (IBAction)exportContacts:(id)sender
{
    NSMutableString *bigvcard = [NSMutableString new];
    for (NimpleContact* contact in _contacts) {
        NSString *vcard = [[VCardCreator sharedInstance] createVCardFromNimpleContact:contact];
        [bigvcard appendString:vcard];
    }
    
    // send mail with attachment
    MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
    mailer.mailComposeDelegate = self;
    [mailer addAttachmentData:[bigvcard dataUsingEncoding:NSUTF8StringEncoding] mimeType:@"text/vcard" fileName:@"contacts.vcf"];
    [self.navigationController presentViewController:mailer animated:YES completion:nil];
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - DisplayContactViewDelegate

- (void)contactShouldBeSaved
{
    [_model save];
}

- (void)contactShouldBeDeleted:(NimpleContact *)contact
{
    [_model deleteContact:contact];
    [self updateView];
}

@end
