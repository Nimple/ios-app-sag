//
//  NimplePurchaseModel.m
//  nimple-iOS
//
//  Created by Ben John on 28/02/15.
//  Copyright (c) 2015 nimple. All rights reserved.
//

#import "NimplePurchaseModel.h"

#define kNimpleProVersionProductIdentifier @"nimple.ios.pro"

@interface NimplePurchaseModel()

@property NSUserDefaults *defaults;

@end

@implementation NimplePurchaseModel

#pragma mark - Initialization

+ (id)sharedPurchaseModel
{
    static id sharedPurchaseModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPurchaseModel = [[self alloc] init];
    });
    return sharedPurchaseModel;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.defaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

#pragma mark - Purchase process

- (void)requestRestore
{
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void)requestPurchase
{
    if ([SKPaymentQueue canMakePayments]) {
        SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:kNimpleProVersionProductIdentifier]];
        productsRequest.delegate = self;
        [productsRequest start];
    }
}

- (void)purchased
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNimpleProVersionProductIdentifier];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNimplePurchasedNotification object:self];
}

- (BOOL)isPurchased
{
    return [self.defaults boolForKey:kNimpleProVersionProductIdentifier];
}

- (void)purchase:(SKProduct *)product
{
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma mark - SKProductsRequestDelegate delegate methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    if (response.products.count > 0) {
        [self purchase:response.products[0]];
    }
}

#pragma mark - SKPaymentTransactionObserver delegate methods

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStateDeferred:
                NSLog(@"Transaction state -> Deferred");
                break;
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"Transaction state -> Purchasing");
                break;
            case SKPaymentTransactionStatePurchased:
                NSLog(@"Transaction state -> Purchased");
                [self purchased];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"Transaction state -> Restored");
                [self purchased];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"Transaction state -> Failed (%@)", transaction.error.description);
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
        }
    }
}

@end
