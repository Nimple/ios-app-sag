//
//  EditNimpleCodeTableViewController.h
//  nimple-iOS
//
//  Created by Ben John on 12/08/14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditInputViewCell.h"
#import "EditAddressInputViewCell.h"
#import "ConnectSocialProfileViewCell.h"

@interface EditNimpleCodeTableViewController : UITableViewController <UITextFieldDelegate>

- (IBAction)done:(id)sender;

@end
