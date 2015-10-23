//
//  EditInputViewCell.m
//  nimple-iOS
//
//  Created by Ben John on 14/08/14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "EditInputViewCell.h"

@interface EditInputViewCell () {
    NimpleCode *_code;
}
@end

@implementation EditInputViewCell

- (void)configureCell
{
    _code = [NimpleCode sharedCode];
}

- (void)updateCode
{
    if (self.inputField.text.length != 0) {
        [self animatePropertySwitchVisibilityTo: 1.0];
    } else {
        [self animatePropertySwitchVisibilityTo: 0.0];
    }
    
    if (self.section == 0) {
        if (self.index == 0) {
            _code.prename = self.inputField.text;
        } else if (self.index ==  1) {
            _code.surname = self.inputField.text;
        } else if (self.index == 2) {
            _code.cellPhone = self.inputField.text;
        } else if (self.index == 3) {
            _code.phone = self.inputField.text;
        } else if (self.index == 4) {
            _code.email = self.inputField.text;
        } else if (self.index == 5) {
            _code.website = self.inputField.text;
        }
    } else if (self.section == 1) {
        if (self.index == 0) {
            _code.company = self.inputField.text;
        } else if(self.index == 1) {
            _code.job = self.inputField.text;
        }
    }
}

#pragma mark - Listener

- (IBAction)propertySwitched:(id)sender
{
    if (self.section == 0) {
        if (self.index == 2) {
            _code.cellPhoneSwitch = [self.propertySwitch isOn];
        } else if (self.index == 3) {
            _code.phoneSwitch = [self.propertySwitch isOn];
        } else if (self.index == 4) {
            _code.emailSwitch = [self.propertySwitch isOn];
        } else if (self.index == 5) {
            _code.websiteSwitch = self.propertySwitch.isOn;
        }
    } else if (self.section == 1) {
        if (self.index == 0) {
            _code.companySwitch = [self.propertySwitch isOn];
        } else if (self.index == 1) {
            _code.jobSwitch = [self.propertySwitch isOn];
        }
    }
}

- (IBAction)editingChanged:(id)sender
{
    [self updateCode];
}

- (IBAction)editingDidEnd:(id)sender
{
    [self updateCode];
}

#pragma mark - Small helper

- (void)animatePropertySwitchVisibilityTo:(NSInteger)value
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [_propertySwitch setAlpha:value];
    [UIView commitAnimations];
}

@end
