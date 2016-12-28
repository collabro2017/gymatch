//
//  PaypalViewController.h
//  GYMatch
//
//  Created by osvinuser on 5/31/16.
//  Copyright © 2016 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayPalMobile.h"

@class RequestsViewController;

@interface PaypalViewController : UIViewController <PayPalPaymentDelegate, PayPalFuturePaymentDelegate, PayPalProfileSharingDelegate>

@property(nonatomic, retain) RequestsViewController *delegate;

- (void)payPaypal:(int)money;

@end
