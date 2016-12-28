//
//  PaypalViewController.m
//  GYMatch
//
//  Created by osvinuser on 5/31/16.
//  Copyright © 2016 xtreem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaypalViewController.h"
#import "SessionTableViewCell1.h"
#import "SpotlightDataController.h"
#import "Constants.h"

@interface PaypalViewController () <UITextFieldDelegate, UIAlertViewDelegate> {

    PayPalConfiguration *payPalConfig;
    int totalMoney;
}

@end

@implementation PaypalViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
     [self initPaypal];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)setPayPalEnvironment:(NSString *)environment {

    [PayPalMobile preconnectWithEnvironment:environment];
}
//for paypal
//paypal function

- (BOOL)acceptCreditCards {
    return payPalConfig.acceptCreditCards;
}

- (void)setAcceptCreditCards:(BOOL)acceptCreditCards {
    payPalConfig.acceptCreditCards = acceptCreditCards;
}
-(void)initPaypal
{
    
    // Set up payPalConfig
    payPalConfig = [[PayPalConfiguration alloc] init];
#if HAS_CARDIO
    // You should use the PayPal-iOS-SDK+card-Sample-App target to enable this setting.
    // For your apps, you will need to link to the libCardIO and dependent libraries. Please read the README.md
    // for more details.
    payPalConfig.acceptCreditCards = YES;
#else
    payPalConfig.acceptCreditCards = NO;
#endif
    payPalConfig.merchantName = @"Awesome Shirts, Inc.";
    payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];

    payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
}

#pragma mark - Receive Single Payment

- (void)payPaypal:(int)money {
    totalMoney = money;
    PayPalItem *item1 = [PayPalItem itemWithName:@"Pay for GYMatch"
                                    withQuantity:1
                                       withPrice:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", totalMoney]]
                                    withCurrency:@"USD"
                                         withSku:@""];
    NSArray *items = @[item1];
    NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
    
    // Optional: include payment details
    NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"0"];
    NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"0"];
    //    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
    //                                                                               withShipping:shipping
    //                                                                                    withTax:tax];
    
    NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
    
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = total;
    payment.currencyCode = @"USD";
    payment.shortDescription = @"GYMatch";
    payment.items = items;  // if not including multiple items, then leave payment.items as nil
    //    payment.paymentDetails = paymentDetails; // if not including payment details, then leave payment.paymentDetails as nil
    
    if (!payment.processable) {
        // This particular payment will always be processable. If, for
        // example, the amount was negative or the shortDescription was
        // empty, this payment wouldn't be processable, and you'd want
        // to handle that here.
    }
    
    // Update payPalConfig re accepting credit cards.
    
    payPalConfig.acceptCreditCards = self.acceptCreditCards;
    
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                                                configuration:payPalConfig
                                                                                                     delegate:self];
    

    

    [self.delegate presentViewController:paymentViewController animated:YES completion:nil];
}

#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    NSLog(@"PayPal Payment Success!");
    [self.delegate payResult:YES];
    [self sendCompletedPaymentToServer:completedPayment]; // Payment was processed successfully; send to server for verification and fulfillment
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    [self.delegate payResult:NO];
    NSLog(@"PayPal Payment Canceled");
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Proof of payment validation

- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {
    // TODO: Send completedPayment.confirmation to server
    NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
}


#pragma mark - Authorize Future Payments

- (IBAction)getUserAuthorizationForFuturePayments:(id)sender {
    
    PayPalFuturePaymentViewController *futurePaymentViewController = [[PayPalFuturePaymentViewController alloc] initWithConfiguration:payPalConfig delegate:self];
    [self.delegate presentViewController:futurePaymentViewController animated:YES completion:nil];
}


#pragma mark PayPalFuturePaymentDelegate methods

- (void)payPalFuturePaymentViewController:(PayPalFuturePaymentViewController *)futurePaymentViewController
                didAuthorizeFuturePayment:(NSDictionary *)futurePaymentAuthorization {
    NSLog(@"PayPal Future Payment Authorization Success!");
    [self.delegate payResult:YES];
    [self sendFuturePaymentAuthorizationToServer:futurePaymentAuthorization];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalFuturePaymentDidCancel:(PayPalFuturePaymentViewController *)futurePaymentViewController {
    NSLog(@"PayPal Future Payment Authorization Canceled");
    //    self.successView.hidden = YES;
    [self.delegate payResult:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendFuturePaymentAuthorizationToServer:(NSDictionary *)authorization {
    // TODO: Send authorization to server
    NSLog(@"Here is your authorization:\n\n%@\n\nSend this to your server to complete future payment setup.", authorization);
}


#pragma mark - Authorize Profile Sharing

- (IBAction)getUserAuthorizationForProfileSharing:(id)sender {
    
    NSSet *scopeValues = [NSSet setWithArray:@[kPayPalOAuth2ScopeOpenId, kPayPalOAuth2ScopeEmail, kPayPalOAuth2ScopeAddress, kPayPalOAuth2ScopePhone]];
    
    PayPalProfileSharingViewController *profileSharingPaymentViewController = [[PayPalProfileSharingViewController alloc] initWithScopeValues:scopeValues configuration:payPalConfig delegate:self];
    [self.delegate presentViewController:profileSharingPaymentViewController animated:YES completion:nil];
}


#pragma mark PayPalProfileSharingDelegate methods

- (void)payPalProfileSharingViewController:(PayPalProfileSharingViewController *)profileSharingViewController
             userDidLogInWithAuthorization:(NSDictionary *)profileSharingAuthorization {
    NSLog(@"PayPal Profile Sharing Authorization Success!");
    [self.delegate payResult:NO];
    [self sendProfileSharingAuthorizationToServer:profileSharingAuthorization];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)userDidCancelPayPalProfileSharingViewController:(PayPalProfileSharingViewController *)profileSharingViewController {
    NSLog(@"PayPal Profile Sharing Authorization Canceled");
    [self.delegate payResult:NO];
    //    self.successView.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendProfileSharingAuthorizationToServer:(NSDictionary *)authorization {
    // TODO: Send authorization to server
    NSLog(@"Here is your authorization:\n\n%@\n\nSend this to your server to complete profile sharing setup.", authorization);
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
