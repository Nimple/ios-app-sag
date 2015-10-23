//
//  NimpleProViewController.m
//  nimple-iOS
//
//  Created by Ben John on 28/02/15.
//  Copyright (c) 2015 nimple. All rights reserved.
//

#import "NimpleProViewController.h"
#import "NimplePurchaseModel.h"

@interface NimpleProViewController ()

@end

@implementation NimpleProViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self localizeViewAttributes];
}

- (void)localizeViewAttributes
{
    [self.proIntroText setText:NimpleLocalizedString(@"pro_intro_text")];
    [self.proFeatureA setText:NimpleLocalizedString(@"pro_feature_A")];
    [self.proFeatureB setText:NimpleLocalizedString(@"pro_feature_B")];
    [self.unlockProButton setTitle:NimpleLocalizedString(@"unlock_pro_button") forState: UIControlStateNormal];
    [self.restoreProButton setTitle:NimpleLocalizedString(@"restore_pro_button") forState: UIControlStateNormal];
}

#pragma mark - Buttons

- (IBAction)unlockProClicked:(id)sender
{
    NSLog(@"unlock pro clicked");
    [[NimplePurchaseModel sharedPurchaseModel] requestPurchase];
}

- (IBAction)restoreProClicked:(id)sender
{
    NSLog(@"restore pro clicked");
    [[NimplePurchaseModel sharedPurchaseModel] requestRestore];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
