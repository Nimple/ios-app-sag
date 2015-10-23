//
//  EditAddressInputViewCell.m
//  nimple-iOS
//
//  Created by Ben John on 12/08/14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "EditAddressInputViewCell.h"

@interface EditAddressInputViewCell () {
    __weak IBOutlet UITextField *_streetTextField;
    __weak IBOutlet UITextField *_postalTextField;
    __weak IBOutlet UITextField *_cityTextField;
    __weak IBOutlet UISwitch *_propertySwitch;
    
    NimpleCode *_code;
}
@end

@implementation EditAddressInputViewCell

- (void)configureCell
{
    _code = [NimpleCode sharedCode];
    [self localizeViewAttributes];
    [self updateView];
    [self configurePropertySwitch];
}

- (void)localizeViewAttributes
{
    _streetTextField.placeholder = NimpleLocalizedString(@"street_label");
    _postalTextField.placeholder = NimpleLocalizedString(@"postal_label");
    _cityTextField.placeholder = NimpleLocalizedString(@"city_label");
}

- (void)updateView
{
    if (!_code.hasAddress && _code.addressSwitch == NO) {
        _code.addressSwitch = YES;
    }
    _streetTextField.text = _code.addressStreet;
    _postalTextField.text = _code.addressPostal;
    _cityTextField.text = _code.addressCity;
}

- (void)configurePropertySwitch
{
    if (![self isFilled]) {
        [_propertySwitch setAlpha:0.0];
    } else {
        [_propertySwitch setAlpha:1.0];
    }
    [_propertySwitch setOn:_code.addressSwitch];
}

- (BOOL)isFilled
{
    if (_streetTextField.text.length != 0)
        return true;
    if (_postalTextField.text.length != 0)
        return true;
    if (_cityTextField.text.length != 0)
        return true;
    return false;
}

#pragma mark - Control for ui elements

- (IBAction)propertySwitched:(id)sender
{
    _code.addressSwitch = _propertySwitch.isOn;
}

- (IBAction)editingChanged:(id)sender
{
    [self updateCode];
}

- (IBAction)editingDidEnd:(id)sender
{
    [self updateCode];
}

- (void)updateCode
{
    if ([self isFilled]) {
        [self animatePropertySwitchVisibilityTo:1.0];
    } else {
        [self animatePropertySwitchVisibilityTo:0.0];
    }
    
    _code.addressStreet = _streetTextField.text;
    _code.addressPostal = _postalTextField.text;
    _code.addressCity = _cityTextField.text;
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
