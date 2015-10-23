//
//  EditNimpleCodeTableViewController.m
//  nimple-iOS
//
//  Created by Ben John on 12/08/14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "EditNimpleCodeTableViewController.h"
#import "NimpleAppDelegate.h"
#import "Logging.h"

@interface EditNimpleCodeTableViewController () {
    __weak IBOutlet UINavigationItem *_editNimpleCode;
    __weak IBOutlet UILabel *_descriptionLabel;
    
    NimpleCode *_code;
}

@end

@implementation EditNimpleCodeTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _code = [NimpleCode sharedCode];
    [self localizeViewAttributes];
}

- (void)localizeViewAttributes
{
    _editNimpleCode.title = NimpleLocalizedString(@"edit_nimple_code_title");
    _descriptionLabel.text = NimpleLocalizedString(@"nimple_code_description");
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger cellCount = 0;
    if (section == 0)
        cellCount = 7;
    else if (section == 1)
        cellCount = 2;
    else if (section == 2)
        cellCount = 4;
    return cellCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2)
        return 60.0;
    else if (indexPath.section == 0 && indexPath.row == 6)
        return 86.0;
    else
        return 45.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditInputViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditInputViewCell"];
    cell.inputField.text = @"";
    cell.inputField.tintColor = [UIColor colorWithHue:38 saturation:100 brightness:74 alpha:1.0];
    cell.index = indexPath.item;
    cell.section = indexPath.section;
    [cell configureCell];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [cell.propertySwitch setHidden:YES];
            cell.inputField.placeholder = NimpleLocalizedString(@"firstname_label");
            cell.inputField.autocapitalizationType = UITextAutocapitalizationTypeWords;
            cell.inputField.text = _code.prename;
        }
        
        if (indexPath.row == 1) {
            [cell.propertySwitch setHidden:YES];
            [cell.inputField setPlaceholder:NimpleLocalizedString(@"lastname_label")];
            cell.inputField.autocapitalizationType = UITextAutocapitalizationTypeWords;
            [cell.inputField setText:_code.surname];
        }
        
        if (indexPath.row == 2) {
            [cell.propertySwitch setOn:_code.cellPhoneSwitch];
            [cell.inputField setKeyboardType:UIKeyboardTypePhonePad];
            [cell.inputField setPlaceholder:NimpleLocalizedString(@"mobilenumber_label")];
            cell.inputField.text = _code.cellPhone;
            if([_code.cellPhone length] == 0) {
                [cell.propertySwitch setAlpha:0.0];
                [cell.propertySwitch setOn:YES];
                _code.cellPhoneSwitch = YES;
            }
        }
        
        if (indexPath.row == 3) {
            [cell.propertySwitch setOn:_code.phoneSwitch];
            [cell.inputField setKeyboardType:UIKeyboardTypePhonePad];
            [cell.inputField setPlaceholder:NimpleLocalizedString(@"phonenumber_label")];
            cell.inputField.text = _code.phone;
            if([_code.phone length] == 0) {
                [cell.propertySwitch setAlpha:0.0];
                [cell.propertySwitch setOn:YES];
                _code.phoneSwitch = YES;
            }
        }
        
        if (indexPath.row == 4) {
            [cell.propertySwitch setOn:_code.emailSwitch];
            [cell.inputField setKeyboardType:UIKeyboardTypeEmailAddress];
            [cell.inputField setAutocorrectionType:UITextAutocorrectionTypeNo];
            [cell.inputField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            [cell.inputField setPlaceholder:NimpleLocalizedString(@"mail_label")];
            cell.inputField.text = _code.email;
            if(_code.email.length == 0) {
                [cell.propertySwitch setAlpha:0.0];
                [cell.propertySwitch setOn:YES];
                _code.emailSwitch = YES;
            }
        }
        
        if (indexPath.row == 5) {
            [cell.propertySwitch setOn:_code.websiteSwitch];
            cell.inputField.keyboardType = UIKeyboardTypeURL;
            cell.inputField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            [cell.inputField setPlaceholder:NimpleLocalizedString(@"website_label")];
            cell.inputField.text = _code.website;
            if (_code.website.length == 0) {
                [cell.propertySwitch setAlpha:0.0];
                [cell.propertySwitch setOn:YES];
                _code.websiteSwitch = YES;
            }
        }
        
        if (indexPath.row == 6) {
            EditAddressInputViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditAddressInputViewCell"];
            [cell configureCell];
            return cell;
        }
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [cell.propertySwitch setOn:_code.companySwitch];
            [cell.inputField setPlaceholder:NimpleLocalizedString(@"company_label")];
            [cell.inputField setText:_code.company];
            if (_code.company.length == 0) {
                [cell.propertySwitch setAlpha:0.0];
                [cell.propertySwitch setOn:YES];
                _code.companySwitch = YES;
            }
        }
        
        if (indexPath.row == 1) {
            [cell.propertySwitch setOn:_code.jobSwitch];
            [cell.inputField setPlaceholder:NimpleLocalizedString(@"job_label")];
            [cell.inputField setText:_code.job];
            if (_code.job.length == 0) {
                [cell.propertySwitch setAlpha:0.0];
                [cell.propertySwitch setOn:YES];
                _code.jobSwitch = YES;
            }
        }
    }
    
    if (indexPath.section == 2) {
        ConnectSocialProfileViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConnectSocialProfileCell" forIndexPath:indexPath];
        cell.index = indexPath.item;
        cell.section = indexPath.section;
        [cell configureCell];
        
        if (indexPath.row == 0) {
            [cell.propertySwitch setOn:_code.facebookSwitch];
            [cell.socialNetworkButton setImage:[UIImage imageNamed:@"ic_round_facebook"] forState:UIControlStateNormal];
            if (_code.facebookId.length == 0 || _code.facebookUrl.length == 0) {
                _code.facebookSwitch = YES;
                [cell.socialNetworkButton setAlpha:0.3];
                [cell.connectStatusButton setTitle:NimpleLocalizedString(@"facebook_label") forState:UIControlStateNormal];
                [cell.propertySwitch setAlpha:0.0];
                [cell.propertySwitch setOn:YES];
            } else {
                [cell.socialNetworkButton setAlpha:1.0];
                [cell.connectStatusButton setTitle:NimpleLocalizedString(@"connected_label") forState:UIControlStateNormal];
            }
        }
        
        if (indexPath.row == 1) {
            [cell.propertySwitch setOn:_code.twitterSwitch];
            [cell.socialNetworkButton setImage:[UIImage imageNamed:@"ic_round_twitter"] forState:UIControlStateNormal];
            
            if (_code.twitterId.length == 0 || _code.twitterUrl.length == 0) {
                _code.twitterSwitch = YES;
                [cell.socialNetworkButton setAlpha:0.3];
                [cell.connectStatusButton setTitle:NimpleLocalizedString(@"twitter_label") forState:UIControlStateNormal];
                [cell.propertySwitch setAlpha:0.0];
                [cell.propertySwitch setOn:YES];
            } else {
                [cell.socialNetworkButton setAlpha:1.0];
                [cell.connectStatusButton setTitle:NimpleLocalizedString(@"connected_label") forState:UIControlStateNormal];
            }
        }
        
        if (indexPath.row == 2) {
            [cell.propertySwitch setOn:_code.xingSwitch];
            
            NimpleAppDelegate *appDelegate = (NimpleAppDelegate *)[[UIApplication sharedApplication] delegate];
            
            [cell.socialNetworkButton setImage:[UIImage imageNamed:@"ic_round_xing"] forState:UIControlStateNormal];
            [cell setNetworkManager:appDelegate.networkManager];
            appDelegate.xingTableViewCell = cell;
            
            if (_code.xing.length == 0) {
                _code.xingSwitch = YES;
                [cell.socialNetworkButton setAlpha:0.3];
                [cell.connectStatusButton setTitle:NimpleLocalizedString(@"xing_label") forState:UIControlStateNormal];
                [cell.propertySwitch setAlpha:0.0];
                [cell.propertySwitch setOn:YES];
            } else {
                [cell.socialNetworkButton setAlpha:1.0];
                [cell.connectStatusButton setTitle:NimpleLocalizedString(@"connected_label") forState:UIControlStateNormal];
            }
        }
        
        if (indexPath.row == 3) {
            [cell.propertySwitch setOn:_code.linkedInSwitch];
            [cell.socialNetworkButton setImage:[UIImage imageNamed:@"ic_round_linkedin"] forState:UIControlStateNormal];
            
            if (_code.linkedIn.length == 0) {
                _code.linkedInSwitch = YES;
                [cell.socialNetworkButton setAlpha:0.3];
                [cell.connectStatusButton setTitle:NimpleLocalizedString(@"linkedin_label") forState:UIControlStateNormal];
                [cell.propertySwitch setAlpha:0.0];
                [cell.propertySwitch setOn:YES];
            } else {
                [cell.socialNetworkButton setAlpha:1.0];
                [cell.connectStatusButton setTitle:NimpleLocalizedString(@"connected_label") forState:UIControlStateNormal];
            }
        }
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName = @"";
    if (section == 0) {
        sectionName = NimpleLocalizedString(@"personal_label");
    } else if (section == 1) {
        sectionName = NimpleLocalizedString(@"business_label");
    } else if (section == 2) {
        sectionName = NimpleLocalizedString(@"social_label");
    }
    return sectionName;
}

#pragma mark - Callbacks

- (IBAction)done:(id)sender
{
    if (_code.prename.length == 0 || _code.surname.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NimpleLocalizedString(@"error_names") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [alertView show];
        });
    } else {
        [[Logging sharedLogging] sendNimpleCodeChangedEvent];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"nimpleCodeChanged" object:self];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
