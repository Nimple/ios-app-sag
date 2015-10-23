//
//  NimpleCodeViewController.m
//  nimple-iOS
//
//  Created by Guido Schmidt on 28.02.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "NimpleCodeViewController.h"
#import "NimpleCode.h"
#import "NimplePurchaseModel.h"
#import "VCardCreator.h"

static NSMutableDictionary *VCARD_TEMPLATE_DIC;

@interface NimpleCodeViewController () {
    __weak IBOutlet UILabel *_tutorialAddLabel;
    __weak IBOutlet UILabel *_tutorialEditLabel;
    __weak IBOutlet UINavigationItem *_navigationLabel;
    __weak IBOutlet UILabel *_barcodeNoteLabel;
    __weak IBOutlet UIImageView *_nimpleCodeImage;
    __weak IBOutlet UIView *_welcomeView;
    
    NimpleCode *_code;
}

@property (weak, nonatomic) IBOutlet UILabel *shareCodeLabel;

@end

@implementation NimpleCodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _code = [NimpleCode sharedCode];
    [self localizeViewAttributes];
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([[NimplePurchaseModel sharedPurchaseModel] isPurchased]) {
        [self.codeSegmentedControl setHidden:NO];
        [self.codeSegmentedControl setSelectedSegmentIndex:[[NimpleCode sharedCode] dictionaryIndex]];
        if (![self emptyNimpleCode]) {
            self.shareCodeLabel.hidden = NO;
        } else {
            self.shareCodeLabel.hidden = YES;
        }
    } else {
        [self.codeSegmentedControl setHidden:YES];
        self.shareCodeLabel.hidden = YES;
    }
    [self updateView];
}

-(void)localizeViewAttributes
{
    _tutorialAddLabel.text = NimpleLocalizedString(@"tutorial_add_text");
    _tutorialEditLabel.text = NimpleLocalizedString(@"tutorial_edit_text");
    _navigationLabel.title = NimpleLocalizedString(@"nimple_code_title");
    _barcodeNoteLabel.text = NimpleLocalizedString(@"nimple_code_footer");
    self.shareCodeLabel.text = NimpleLocalizedString(@"header_code");
}

- (void)updateView
{
    if ([[NimplePurchaseModel sharedPurchaseModel] isPurchased]) {
        if (![self emptyNimpleCode]) {
            self.shareCodeLabel.hidden = NO;
        } else {
            self.shareCodeLabel.hidden = YES;
        }
    } else {
        self.shareCodeLabel.hidden = YES;
    }
    if ([self emptyNimpleCode]) {
        _welcomeView.hidden = NO;
        _nimpleCodeImage.hidden = YES;
        _barcodeNoteLabel.hidden = YES;
    } else {
        _welcomeView.hidden = YES;
        _nimpleCodeImage.hidden = NO;
        _barcodeNoteLabel.hidden = NO;
        [self updateQRCode];
    }
}

- (BOOL)emptyNimpleCode
{
    return _code.surname.length == 0 && _code.prename.length == 0;
}

#pragma mark - Notification Center

- (void)handleChangedNimpleCode:(NSNotification *)note
{
    NSLog(@"Nimple code changed received in NimpleCodeViewController");
    [self updateView];
}

#pragma mark - QR-Code share

- (IBAction)codeTapped:(id)sender
{
    if ([[NimplePurchaseModel sharedPurchaseModel] isPurchased]) {
        NSArray *activityItems = @[_nimpleCodeImage.image];
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        [self presentViewController:activityVC animated:TRUE completion:nil];
    }
}


#pragma mark - QR-Code generation

- (void)updateQRCode
{
    NSString *string = [[VCardCreator sharedInstance] createVCardFromNimpleCode:_code];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    [filter setValue:data forKey:@"inputMessage"];
    [filter setValue:@"L" forKey:@"inputCorrectionLevel"];
    CIImage *output = [filter valueForKey:kCIOutputImageKey];
    CGImageRef result = [context createCGImage:output fromRect:[output extent]];
    
    UIImage *generatedCodeImage = [self convertToUIImage:result];
    generatedCodeImage = [self upscaleQRCode:generatedCodeImage];
    [self replaceCodeWithImage:generatedCodeImage];
}

- (UIImage *)convertToUIImage:(CGImageRef)image
{
    return [UIImage imageWithCGImage:image scale:1.0 orientation: UIImageOrientationUp];
}

- (UIImage *)upscaleQRCode:(UIImage *)image
{
    return [self resizeImage:image withQuality:kCGInterpolationNone rate:16.0];
}

- (void)replaceCodeWithImage:(UIImage *)image
{
    _nimpleCodeImage.image = image;
}

#pragma mark - Small helper

- (UIImage *)resizeImage:(UIImage *)image withQuality:(CGInterpolationQuality)quality rate:(CGFloat)rate
{
    UIImage *resized = nil;
    CGFloat width = image.size.width * rate;
    CGFloat height = image.size.height * rate;
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, quality);
    [image drawInRect:CGRectMake(0, 0, width, height)];
    resized = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resized;
}

#pragma mark - Handles segmented control selection

- (IBAction)segmentedControlValueChanged:(UISegmentedControl *)sender
{
    [_code switchToDictionaryWithIndexInteger:self.codeSegmentedControl.selectedSegmentIndex];
    [self updateView];
}

@end
