//
//  NimpleCodeReaderController.m
//  nimple-iOS
//
//  Created by Guido Schmidt on 28.02.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "BarCodeReaderController.h"
#import "NimpleModel.h"
#import "NimpleContact.h"
#import "VCardParser.h"
#import "Logging.h"

@interface BarCodeReaderController () {
    __weak IBOutlet UINavigationItem *_scannerLabel;
    __weak IBOutlet UIView *_readerView;
    
    NimpleModel *_model;
    BOOL _isProcessing;
    BOOL _isReading;
    AVCaptureSession *_session;
    AVCaptureVideoPreviewLayer *_previewLayer;
}
@end

@implementation BarCodeReaderController

- (void)viewDidLoad {
    [super viewDidLoad];
    _model = [NimpleModel sharedModel];
    [self localizeViewAttributes];
    [self startScanner];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startScanner];
    [self checkForCamera];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self stopScanner];
}

- (void)localizeViewAttributes
{
    _scannerLabel.title = NimpleLocalizedString(@"scanner_label");
}

#pragma mark - Check for Camera access

- (void)checkForCamera
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusDenied || status == AVAuthorizationStatusRestricted) {
        [self showCameraAlert];
    } else if (status == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (!granted){
                [self showCameraAlert];
            }
        }];
    }
}

#pragma mark - Alert views

- (void)showCameraAlert
{
    [[[UIAlertView alloc] initWithTitle:NimpleLocalizedString(@"alertview_camera_permission_title") message:NimpleLocalizedString(@"alertview_camera_permission_text") delegate:self cancelButtonTitle:NimpleLocalizedString(@"alertview_camera_permission_button") otherButtonTitles:nil] show];
}

- (void)showRightCodeAlert
{
    [[[UIAlertView alloc] initWithTitle:NimpleLocalizedString(@"msg_box_right_code_header") message:NimpleLocalizedString(@"msg_box_right_code_text") delegate:self cancelButtonTitle:NimpleLocalizedString(@"msg_box_right_code_activity") otherButtonTitles:nil] show];
}

- (void)showWrongCodeAlert
{
    [[[UIAlertView alloc] initWithTitle:NimpleLocalizedString(@"msg_box_wrong_code_header") message:NimpleLocalizedString(@"msg_box_wrong_code_text") delegate:self cancelButtonTitle:NimpleLocalizedString(@"msg_box_wrong_code_activity") otherButtonTitles:nil] show];
}

- (void)showDuplicatedContactAlert
{
    [[[UIAlertView alloc] initWithTitle:nil message:NimpleLocalizedString(@"msg_box_duplicated_contact_title") delegate:self cancelButtonTitle:NimpleLocalizedString(@"msg_box_duplicated_code_activity") otherButtonTitles:nil] show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex) {
        [self.tabBarController setSelectedIndex:2];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Scanner control

- (void)startScanner
{
    if (_isReading) {
        return;
    }
    
    _isReading = YES;
    NSError *error;
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo] error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return;
    }
    
    _session = [[AVCaptureSession alloc] init];
    [_session addInput:input];
    
    AVCaptureMetadataOutput *metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_session addOutput:metadataOutput];
    [metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    metadataOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
    _previewLayer.drawsAsynchronously = YES;
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _previewLayer.frame = _readerView.frame;
    
    [_readerView.layer addSublayer:_previewLayer];
    [_session startRunning];
}

- (void)stopScanner
{
    if (_session != nil) {
        [_session stopRunning];
        [_previewLayer removeFromSuperlayer];
        _session = nil;
        _isReading = NO;
    }
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void) captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (_isProcessing) {
        return;
    }
    
    // valid qrcode found
    if (metadataObjects != nil && [metadataObjects count] == 1) {
        _isProcessing = YES;
        [self stopScanner];
        
        AVMetadataMachineReadableCodeObject *metadataObj = metadataObjects[0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            NimpleContact *contact = [VCardParser getContactFromCard:metadataObj.stringValue];
            
            // check for valid vcard on the basis of prename/surname
            if(contact.prename.length == 0 || contact.surname.length == 0) {
                [self showWrongCodeAlert];
                return;
            }
            [self saveContact:contact];
        }
    }
}

#pragma mark - Saving contact

- (void)saveContact:(NimpleContact *)contact
{
    if (![_model doesContactExistWithHash:contact.contactHash]) {
        NimpleContact *newContact = [_model getEntityForNewContact];
        [newContact fillWithContact:contact];
        [_model save];
        [[Logging sharedLogging] sendContactAddedEvent:newContact];
        [self showRightCodeAlert];
    } else {
        [self showDuplicatedContactAlert];
    }
}

@end
