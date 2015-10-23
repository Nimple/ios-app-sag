//
//  ContactTableViewCell.m
//  nimple-iOS
//
//  Created by Ben John on 17/08/14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "ContactTableViewCell.h"

@interface ContactTableViewCell () {
    __weak IBOutlet UILabel *_nameLabel;
    __weak IBOutlet UILabel *_jobCompanyLabel;
    __weak IBOutlet UIButton *_phoneButton;
    __weak IBOutlet UIButton *_emailButton;
    __weak IBOutlet UIButton *_facebookButton;
    __weak IBOutlet UIButton *_twitterButton;
    __weak IBOutlet UIButton *_xingButton;
    __weak IBOutlet UIButton *_linkedinButton;
    
    NimpleContact *_contact;
}
@end

@implementation ContactTableViewCell

- (void)configureCellWithContact:(NimpleContact *)contact
{
    _contact = contact;
    [self updateView];
}

- (void)updateView
{
    _nameLabel.text = [NSString stringWithFormat:@"%@ %@", _contact.prename, _contact.surname];
    
    if ([_contact.website isEqualToString:@"http://www.nimple.de"]) {
        [_phoneButton setTitle:_contact.website forState:UIControlStateNormal];
    } else if (_contact.cellphone) {
        [_phoneButton setTitle:_contact.cellphone forState:UIControlStateNormal];
    } else {
        [_phoneButton setTitle:_contact.phone forState:UIControlStateNormal];
    }
    
    [_emailButton setTitle:_contact.email forState:UIControlStateNormal];
    
    if (_contact.job.length > 0 && _contact.company.length > 0) {
        _jobCompanyLabel.text = [NSString stringWithFormat:@"%@ (%@)", _contact.company, _contact.job];
    } else if (_contact.job.length > 0) {
        _jobCompanyLabel.text = _contact.job;
    } else {
        _jobCompanyLabel.text = _contact.company;
    }
    
    if (_contact.facebook_ID.length == 0 && _contact.facebook_URL.length == 0) {
        _facebookButton.alpha = 0.2;
    } else {
        _facebookButton.alpha = 1.0;
    }
    
    if (_contact.twitter_ID.length == 0 && _contact.twitter_URL.length == 0) {
        _twitterButton.alpha = 0.2;
    } else {
        _twitterButton.alpha = 1.0;
    }
    
    if (_contact.xing_URL.length == 0) {
        _xingButton.alpha = 0.2;
    } else {
        _xingButton.alpha = 1.0;
    }
    
    if (_contact.linkedin_URL.length == 0) {
        _linkedinButton.alpha = 0.2;
    } else {
        _linkedinButton.alpha = 1.0;
    }
}

@end
