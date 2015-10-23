//
//  ContactTableViewCell.h
//  nimple-iOS
//
//  Created by Ben John on 17/08/14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NimpleContact.h"

@interface ContactTableViewCell : UITableViewCell

- (void)configureCellWithContact:(NimpleContact *)contact;

@end
