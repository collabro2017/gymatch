//
//  AddSession.m
//  GYMatch
//
//  Created by bluesky on 03/07/16.
//  Copyright © 2016 xtreem. All rights reserved.
//

#import "AddSession.h"
#import "SessionDataController.h"
#import "AddSessionCell.h"
#import "SessionTableViewCell1.h"
#import "Session.h"
#import "BookingNowSessionViewController.h"

#define kPayPalEnvironment PayPalEnvironmentNoNetwork
@interface AddSession ()
@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;
@property(nonatomic) int selectedIndexforPay;
@end

@implementation AddSession

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"Sessions"];
    // Do any additional setup after loading the view from its nib.
    
    [self getSessions];
    _tblSession.delegate = self;
    [_tblSession reloadData];
    
    [self initPaypal];
}
- (void)setPayPalEnvironment:(NSString *)environment {
    self.environment = environment;
    [PayPalMobile preconnectWithEnvironment:environment];
}
- (void)getSessions {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    SessionDataController *uDC = [SessionDataController new];
    [uDC sessionFor:[APP_DELEGATE loggedInUser].ID withDate:_date withSuccess:^(NSArray *sessions) {
        
        arrSessions = sessions;
        
        [_tblSession reloadData];
        
        if([arrSessions count] == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"No sessions found." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            
        }
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark
#pragma mark - UITableView Delegate and Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 108;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrSessions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"addSessionCell";
    
    AddSessionCell *cell = (AddSessionCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AddSessionCell" owner:self options:nil];
        
        cell = (AddSessionCell *)[nib objectAtIndex:0];
    }
    
    Session *session = [arrSessions objectAtIndex:indexPath.row];
    
    //[cell.button_SelectedDate setTitle:session.date forState:UIControlStateNormal];
    [cell.lblStartTime setText:session.starttime];
    
    [cell.lblDuration setText:[NSString stringWithFormat:@"%ld %@", (long)session.duration, session.trainingType]];
    
    [cell.lblRate setText:session.rate];
    
    [cell.lblDate setText:session.bookingdate];
    
    if(session.isAccepted == 0){
        [cell.bttPay setEnabled:NO];
        [cell.bttPay setTitle:@"Not accepted" forState:UIControlStateNormal];
    }else{
        [cell.bttPay setEnabled:YES];
        [cell.bttPay setTag:indexPath.row];
        [cell.bttPay addTarget:self action:@selector(payPaypal_clicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    // show setting body part
    Session *session = [arrSessions objectAtIndex:indexPath.row];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
//    
//    NSString *startDate = [dateFormatter stringFromDate:session.date];
   
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)[APP_DELEGATE loggedInUser].ID] forKey:@"user_id"];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)session.trainer_id] forKey:@"trainer_id"];
    [dict setObject:session.bookingdate forKey:@"date"];
    [dict setObject:session.starttime forKey:@"starttime"];
    [dict setObject:[NSString stringWithFormat:@"%ld %@", (long)session.duration, session.trainingType] forKey:@"duration"];
    
    [dict setObject:session.rate forKey:@"rate"];
    
    // open booking now session view controller.
    BookingNowSessionViewController *bookingNowSessionCV = [[BookingNowSessionViewController alloc] initWithNibName:@"BookingNowSessionViewController" bundle:[NSBundle mainBundle]];
    
    bookingNowSessionCV.dict_SessionInfo = dict;
    bookingNowSessionCV.isSessionView = true;
    bookingNowSessionCV.BodyName = session.bodyParts;
    bookingNowSessionCV.WorkoutName = session.workoutType;
    bookingNowSessionCV.SkypeName = session.skypeId;
    
    [self.navigationController pushViewController:bookingNowSessionCV animated:YES];
}



//for paypal
//paypal function

- (BOOL)acceptCreditCards {
    return self.payPalConfig.acceptCreditCards;
}

- (void)setAcceptCreditCards:(BOOL)acceptCreditCards {
    self.payPalConfig.acceptCreditCards = acceptCreditCards;
}
-(void)initPaypal
{
    
    // Set up payPalConfig
    _payPalConfig = [[PayPalConfiguration alloc] init];
#if HAS_CARDIO
    // You should use the PayPal-iOS-SDK+card-Sample-App target to enable this setting.
    // For your apps, you will need to link to the libCardIO and dependent libraries. Please read the README.md
    // for more details.
    _payPalConfig.acceptCreditCards = YES;
#else
    _payPalConfig.acceptCreditCards = NO;
#endif
    _payPalConfig.merchantName = @"Awesome Shirts, Inc.";
    _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    
    // Setting the languageOrLocale property is optional.
    //
    // If you do not set languageOrLocale, then the PayPalPaymentViewController will present
    // its user interface according to the device's current language setting.
    //
    // Setting languageOrLocale to a particular language (e.g., @"es" for Spanish) or
    // locale (e.g., @"es_MX" for Mexican Spanish) forces the PayPalPaymentViewController
    // to use that language/locale.
    //
    // For full details, including a list of available languages and locales, see PayPalPaymentViewController.h.
    
    _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
    
    
    // Setting the payPalShippingAddressOption property is optional.
    //
    // See PayPalConfiguration.h for details.
    
    //    _payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    self.environment = kPayPalEnvironment;
}

#pragma mark - Receive Single Payment

- (IBAction)payPaypal_clicked:(id)sender {
    // Remove our last completed payment, just for demo purposes.
    self.resultText = nil;
    _selectedIndexforPay = (int)[sender tag];
    Session *session = [arrSessions objectAtIndex:_selectedIndexforPay];
    NSString *cost = [session.rate stringByReplacingOccurrencesOfString:@"$" withString:@""];
    // Note: For purposes of illustration, this example shows a payment that includes
    //       both payment details (subtotal, shipping, tax) and multiple items.
    //       You would only specify these if appropriate to your situation.
    //       Otherwise, you can leave payment.items and/or payment.paymentDetails nil,
    //       and simply set payment.amount to your total charge.
    
    // Optional: include multiple items
    PayPalItem *item1 = [PayPalItem itemWithName:@"Pay for GYMatch"
                            withQuantity:1
                               withPrice:[NSDecimalNumber decimalNumberWithString:cost]
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
    self.payPalConfig.acceptCreditCards = self.acceptCreditCards;
    
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                                                configuration:self.payPalConfig
                                                                                                     delegate:self];
    [self presentViewController:paymentViewController animated:YES completion:nil];
}

#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    NSLog(@"PayPal Payment Success!");
    self.resultText = [completedPayment description];
    //    [self showSuccess];
    
    [self sendCompletedPaymentToServer:completedPayment]; // Payment was processed successfully; send to server for verification and fulfillment
    [self dismissViewControllerAnimated:YES completion:nil];
    Session *session = [arrSessions objectAtIndex:_selectedIndexforPay];
    session.isAccepted = 1;
    [_tblSession reloadData];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    NSLog(@"PayPal Payment Canceled");
    self.resultText = nil;
    //    self.successView.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Proof of payment validation

- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {
    // TODO: Send completedPayment.confirmation to server
    NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
}


#pragma mark - Authorize Future Payments

- (IBAction)getUserAuthorizationForFuturePayments:(id)sender {
    
    PayPalFuturePaymentViewController *futurePaymentViewController = [[PayPalFuturePaymentViewController alloc] initWithConfiguration:self.payPalConfig delegate:self];
    [self presentViewController:futurePaymentViewController animated:YES completion:nil];
}


#pragma mark PayPalFuturePaymentDelegate methods

- (void)payPalFuturePaymentViewController:(PayPalFuturePaymentViewController *)futurePaymentViewController
                didAuthorizeFuturePayment:(NSDictionary *)futurePaymentAuthorization {
    NSLog(@"PayPal Future Payment Authorization Success!");
    self.resultText = [futurePaymentAuthorization description];
    //    [self showSuccess];
    
    [self sendFuturePaymentAuthorizationToServer:futurePaymentAuthorization];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalFuturePaymentDidCancel:(PayPalFuturePaymentViewController *)futurePaymentViewController {
    NSLog(@"PayPal Future Payment Authorization Canceled");
    //    self.successView.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendFuturePaymentAuthorizationToServer:(NSDictionary *)authorization {
    // TODO: Send authorization to server
    NSLog(@"Here is your authorization:\n\n%@\n\nSend this to your server to complete future payment setup.", authorization);
}


#pragma mark - Authorize Profile Sharing

- (IBAction)getUserAuthorizationForProfileSharing:(id)sender {
    
    NSSet *scopeValues = [NSSet setWithArray:@[kPayPalOAuth2ScopeOpenId, kPayPalOAuth2ScopeEmail, kPayPalOAuth2ScopeAddress, kPayPalOAuth2ScopePhone]];
    
    PayPalProfileSharingViewController *profileSharingPaymentViewController = [[PayPalProfileSharingViewController alloc] initWithScopeValues:scopeValues configuration:self.payPalConfig delegate:self];
    [self presentViewController:profileSharingPaymentViewController animated:YES completion:nil];
}


#pragma mark PayPalProfileSharingDelegate methods

- (void)payPalProfileSharingViewController:(PayPalProfileSharingViewController *)profileSharingViewController
             userDidLogInWithAuthorization:(NSDictionary *)profileSharingAuthorization {
    NSLog(@"PayPal Profile Sharing Authorization Success!");
    self.resultText = [profileSharingAuthorization description];
    //    [self showSuccess];
    
    [self sendProfileSharingAuthorizationToServer:profileSharingAuthorization];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)userDidCancelPayPalProfileSharingViewController:(PayPalProfileSharingViewController *)profileSharingViewController {
    NSLog(@"PayPal Profile Sharing Authorization Canceled");
    //    self.successView.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendProfileSharingAuthorizationToServer:(NSDictionary *)authorization {
    // TODO: Send authorization to server
    NSLog(@"Here is your authorization:\n\n%@\n\nSend this to your server to complete profile sharing setup.", authorization);
}

@end
