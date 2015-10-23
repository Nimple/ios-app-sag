//
//  NimpleProViewController.h
//  nimple-iOS
//
//  Created by Ben John on 28/02/15.
//  Copyright (c) 2015 nimple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NimpleProViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *proIntroText;
@property (weak, nonatomic) IBOutlet UILabel *proFeatureA;
@property (weak, nonatomic) IBOutlet UILabel *proFeatureB;
@property (weak, nonatomic) IBOutlet UIButton *unlockProButton;
@property (weak, nonatomic) IBOutlet UIButton *restoreProButton;

@end
