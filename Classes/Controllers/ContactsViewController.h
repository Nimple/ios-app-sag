//
//  ContactsViewController.h
//  nimple-iOS
//
//  Created by Guido Schmidt on 04.03.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "DisplayContactViewController.h"

@interface ContactsViewController : UITableViewController <DisplayContactViewControllerDelegate, MFMailComposeViewControllerDelegate>

@end
