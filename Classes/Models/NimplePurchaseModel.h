//
//  NimplePurchaseModel.h
//  nimple-iOS
//
//  Created by Ben John on 28/02/15.
//  Copyright (c) 2015 nimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

#define kNimplePurchasedNotification @"kNimplePurchasedNotification"

@interface NimplePurchaseModel : NSObject <SKPaymentTransactionObserver, SKProductsRequestDelegate>

+ (NimplePurchaseModel *)sharedPurchaseModel;

- (void)requestPurchase;
- (void)requestRestore;
- (BOOL)isPurchased;

@end
