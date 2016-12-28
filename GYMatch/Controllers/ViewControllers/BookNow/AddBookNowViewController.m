//
//  AddBookNowViewController.m
//  GYMatch
//
//  Created by osvinuser on 5/31/16.
//  Copyright © 2016 xtreem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddBookNowViewController.h"
#import "SessionTableViewCell1.h"
#import "SpotlightDataController.h"
#import "Constants.h"

@interface AddBookNowViewController () <UITextFieldDelegate, UIAlertViewDelegate> {

    __weak IBOutlet UITextField *txtTrainingSessionPeriod;
    __weak IBOutlet UITextField *txtDateAndDay;
    __weak IBOutlet UITextField *txtTrainingSessionTime;
    __weak IBOutlet UITextField *txtBookedSessions;
    __weak IBOutlet UITextField *txtSessionRate;
    
    __weak IBOutlet UIButton *bttDate;
    __weak IBOutlet UIButton *bttTime;
    __weak IBOutlet UIButton *bttDuration;
    __weak IBOutlet UIButton *bttCost;
    
    IBOutlet UIView *viewCell;
    
    // variables.
    IBOutlet UIScrollView *scrollView_Main;
    
    
    IBOutlet UISwitch *swichButton_SkypeID;
    IBOutlet UITextField *textField_SkypeID;
    IBOutlet UITextField *textField1_WorkOut;
    IBOutlet UITextField *textField2_WorkOut;
    
    IBOutlet UIButton *checkButton;
    
    // policy view.
    IBOutlet UIView *view_subViewPolicy;
    IBOutlet UIView *view_Policy;
    IBOutlet UITextView *textView_Policy;
    
    // list views
    IBOutlet UIView *view_SubView;
    IBOutlet UITableView *tableView_subView;
    
    // label title.
    IBOutlet UILabel *label_SubViewTitle;
    __weak IBOutlet UIButton *bttSendRequest;
    
    // array of sub table view
    NSArray *array_BodyParts;
    NSArray *array_WorkOut;
    
    NSArray *subTableView;
    
    // TextField
    UITextField *txtField_Selected;
    NSMutableArray *PartsCellSelected;
    NSMutableArray *PartsCellSelected1;
    
    PayPalConfiguration *payPalConfig;
    int totalMoney;
}

@end

@implementation AddBookNowViewController
@synthesize dict_SessionInfo;
@synthesize isSessionView;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // set navigation title
    self.title = @"BOOK NOW";
    
    
    // when button is not selected.
    UIImage *image = [[UIImage imageNamed:@"uncheck"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [checkButton setBackgroundImage:image forState:UIControlStateNormal];
    
    // add image right side on textField.
    [textField1_WorkOut setRightViewMode:UITextFieldViewModeAlways];
    textField1_WorkOut.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightImageTextField"]];
    
    [textField2_WorkOut setRightViewMode:UITextFieldViewModeAlways];
    textField2_WorkOut.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightImageTextField"]];
    
    
    [bttDate setTitle:[dict_SessionInfo objectForKey:@"date"] forState:UIControlStateNormal];
    [bttTime setTitle:[dict_SessionInfo objectForKey:@"starttime"] forState:UIControlStateNormal];
    [bttDuration setTitle:[dict_SessionInfo objectForKey:@"duration"] forState:UIControlStateNormal];
    
    NSArray *aryMulti = [dict_SessionInfo objectForKey:@"multisessions"];
    int bookedDates = 1;
    for (int i = 0; i < aryMulti.count; i++) {
        if ([[aryMulti objectAtIndex:i] isEqualToString:@"1"] == true) {
            bookedDates++;
        }
    }
    NSString *strRate = [dict_SessionInfo objectForKey:@"rate"];
    strRate = [strRate stringByReplacingOccurrencesOfString:@"$" withString:@""];
    strRate = [strRate stringByReplacingOccurrencesOfString:@" " withString:@""];
    float rate = strRate.floatValue;
    totalMoney = rate * bookedDates;
    [bttCost setTitle:[NSString stringWithFormat:@"$ %d", totalMoney] forState:UIControlStateNormal];
    
    
    [txtTrainingSessionPeriod setText:[dict_SessionInfo objectForKey:@"duration"]];
    
    [scrollView_Main setContentSize:[UIScreen mainScreen].bounds.size];
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *selectedDate = [dateFormatter dateFromString:[dict_SessionInfo objectForKey:@"date"]];
    NSTimeInterval secondsBetween = [selectedDate timeIntervalSinceDate:currentDate];
    int numberOfDays = secondsBetween / 86400;
    [txtDateAndDay setText:[APP_DELEGATE getCurrentDateInfo:numberOfDays + 2]];
    
    NSString *strDate = [NSString stringWithFormat:@"%@~%@", [dict_SessionInfo objectForKey:@"starttime"], [dict_SessionInfo objectForKey:@"endtime"]];
    [txtTrainingSessionTime setText:strDate];
    
    for (int i = 0; i < aryMulti.count; i++) {
        if ([[aryMulti objectAtIndex:i] isEqualToString:@"1"] == true) {
            NSString *strMultipleDate = [NSString stringWithFormat:@"%@, %@~%@, ...", [APP_DELEGATE getCurrentDateInfo:numberOfDays + i + 2], [dict_SessionInfo objectForKey:@"multistarttime"], [dict_SessionInfo objectForKey:@"multiendtime"]];
            [txtBookedSessions setText:strMultipleDate];
            break;
        }
    }

    [txtSessionRate setText:[dict_SessionInfo objectForKey:@"rate"]];
    [txtSessionRate setText:[NSString stringWithFormat:@"$ %d", totalMoney]];
    
    if(isSessionView){
        [textField1_WorkOut setText:_BodyName];
        [textField2_WorkOut setText:_WorkoutName];
        [textField_SkypeID setText:_SkypeName];
        [bttSendRequest setEnabled:YES];
        isSessionView = NO;
    }else{
        [bttSendRequest setEnabled:YES];
        
    }
    
    // set data in array
    array_BodyParts = @[@"Arms",
                        @"Chest",
                        @"Abs",
                        @"Back",
                        @"Shoulder",
                        @"Legs",
                        @"Glutes",
                        @"Full Body"];
    
    array_WorkOut = @[@"Endurance",
                      @"Cardio",
                      @"Kettlebell",
                      @"Crossfit",
                      @"Circuit",
                      @"Body Weight",
                      @"Pirates",
                      @"Yoga",
                      @"Bench Press",
                      @"Deadlifts",
                      @"Squats",
                      @"All Muscle Groups"];
    PartsCellSelected = [NSMutableArray array];
    PartsCellSelected1 = [NSMutableArray array];
    
     [self initPaypal];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)setPayPalEnvironment:(NSString *)environment {

    [PayPalMobile preconnectWithEnvironment:environment];
}

#pragma mark
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    // return NO to not change text
    if (textField.text.length == 0 && [string  isEqualToString:@" "]) {
        
        return false;

    }
    
    return true;
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField; {

    // return NO to disallow editing.
    if (textField == textField1_WorkOut || textField == textField2_WorkOut) {
        
        label_SubViewTitle.text = textField == textField1_WorkOut ? @"Body Parts" : @"Workout Types";
        
        subTableView = textField == textField1_WorkOut ? array_BodyParts : array_WorkOut;
        
        txtField_Selected = textField == textField1_WorkOut ? textField1_WorkOut : textField2_WorkOut;
        
        [self openSubView];
        
        return NO;
        
    }
    
    return YES;
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
    
}


#pragma mark 
#pragma mark - IBActions

- (IBAction)cancellationPolicyButton:(id)sender {
    
    // Add policy view.
    view_Policy.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self.view addSubview:view_Policy];
    
}

- (IBAction)crossButton:(id)sender {
    
    // remove sub view.
    [view_Policy removeFromSuperview];
    
}

- (IBAction)sendRequestButton:(id)sender {
    
//    [self payPaypal_clicked:nil];
//    return;
    if ([self skypeIDValidation]) {
        
        NSString *durationValue = [[[[dict_SessionInfo objectForKey:@"duration"] componentsSeparatedByString:@" "] lastObject] isEqualToString:@"min"] ? [[[dict_SessionInfo objectForKey:@"duration"] componentsSeparatedByString:@" "] firstObject] : [NSString stringWithFormat:@"%d",[[[[dict_SessionInfo objectForKey:@"duration"] componentsSeparatedByString:@" "] firstObject] intValue] * 60];
        
        NSString *trainingHourType = [[[[dict_SessionInfo objectForKey:@"duration"] componentsSeparatedByString:@" "] lastObject] isEqualToString:@"min"] ? @"min" : @"hour";
        
        NSMutableArray *aryMultipleSessionDates = [NSMutableArray array];
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *selectedDate = [dateFormatter dateFromString:[dict_SessionInfo objectForKey:@"date"]];
        NSTimeInterval secondsBetween = [selectedDate timeIntervalSinceDate:currentDate];
        int numberOfDays = secondsBetween / 86400;
        NSArray *aryMulti = [dict_SessionInfo objectForKey:@"multisessions"];
        for (int i = 0; i < aryMulti.count; i++) {
            if ([[aryMulti objectAtIndex:i] isEqualToString:@"1"] == true) {
                NSString *strMultipleDate = [NSString stringWithFormat:@"%@", [APP_DELEGATE getDateValue:numberOfDays + i + 2]];
                [aryMultipleSessionDates addObject:strMultipleDate];
            }
        }
        
        NSDictionary *requestDictionary = @{@"user_id": [dict_SessionInfo objectForKey:@"user_id"],
                                            @"trainer_id": [dict_SessionInfo objectForKey:@"trainer_id"],
//                                            @"trainer_id": @"560",
                                            @"booking_date": [dict_SessionInfo objectForKey:@"date"],
                                            @"start_time": [dict_SessionInfo objectForKey:@"starttime"],
                                            @"duration": durationValue,
                                            @"training_hour_type": trainingHourType,
                                            @"rate": [NSString stringWithFormat:@"$ %d", totalMoney],
                                            @"is_skype":  swichButton_SkypeID.on ? [NSNumber numberWithInt:1] : [NSNumber numberWithInt:0],
                                            @"skype_id": textField_SkypeID.text,
                                            @"body_parts": textField1_WorkOut.text,
                                            @"workout_type": textField2_WorkOut.text,
                                            @"end_time" : [dict_SessionInfo objectForKey:@"endtime"],
                                            @"multiple_session_start_time" : [dict_SessionInfo objectForKey:@"multistarttime"],
                                            @"multiple_session_end_time" : [dict_SessionInfo objectForKey:@"multiendtime"],
                                            @"multiple_session_date" : aryMultipleSessionDates,
                                            };
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        SpotlightDataController *sDC = [SpotlightDataController new];
        
        [sDC sendBookingRequest:requestDictionary withSuccess:^(NSDictionary *spotlight) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertViewAdd = [[UIAlertView alloc] initWithTitle:@"GYMatch" message:[spotlight objectForKey:@"Message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                alertViewAdd.tag = 1;
                [alertViewAdd show];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            });
        } failure:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[UIAlertView alloc] initWithTitle:@"GYMatch" message:[NSString stringWithFormat:@"%@", error.localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            });
        }];
    }
}


- (IBAction)swichButton_SkypeID:(UISwitch *)sender {
    
    if (sender.on) {
    
        textField_SkypeID.enabled = true;
        textField_SkypeID.placeholder = @"Skype ID";
        
    } else {
    
        textField_SkypeID.enabled = false;
        textField_SkypeID.text = @"";
        textField_SkypeID.placeholder = @"";

    }
    
}


- (IBAction)button_Check:(UIButton *)sender {
    
    sender.selected  = ! sender.selected;
    
    if (sender.selected) {
        
        UIImage *image = [[UIImage imageNamed:@"uncheck"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [checkButton setBackgroundImage:image forState:UIControlStateNormal];
        
    } else {
            
        UIImage *image = [[UIImage imageNamed:@"check"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [checkButton setBackgroundImage:image forState:UIControlStateNormal];

    }
    
}

- (BOOL)skypeIDValidation {

    if (swichButton_SkypeID.on) {
        
        if (textField_SkypeID.text.length > 0) {
            
            return [self bodyPartsValidation];
            
        } else {
            
            [[[UIAlertView alloc] initWithTitle:@"GYMatch" message:@"Please enter your Skype ID. If you do not want a Skype session then turn off the switch button." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            
            return NO;
            
        }
        
    } else {
        
        return [self bodyPartsValidation];
    }
    
}

- (BOOL)bodyPartsValidation {

    // textfield1_workout using for body parts.
    if (textField1_WorkOut.text.length > 0) {
    
        return [self workoutValidation];
        
    } else {
    
        [[[UIAlertView alloc] initWithTitle:@"GYMatch" message:@"Please select the body part." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        
        return NO;
    }
    
}

- (BOOL)workoutValidation {

    if (textField2_WorkOut.text.length > 0) {

        return [self cancellationPolicyValication];
        
    } else {
    
        [[[UIAlertView alloc] initWithTitle:@"GYMatch" message:@"Please select the workout type." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        
        return NO;
        
    }
    
}

- (BOOL)cancellationPolicyValication {

    if (checkButton.selected) {
    
        return YES;
        
    } else {
    
        [[[UIAlertView alloc] initWithTitle:@"GYMatch" message:@"Please select the cancellation policy." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];

        return NO;
    }
    
}

#pragma mark - UIAlertView Delegate.
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 1) {
        
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
    }
    
}


#pragma mark 
#pragma mark - UITableView Delegate and Data Source 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (tableView == tableView_subView) {
        
        return 1;

    } else {
    
        return 1;
    
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if  (tableView == tableView_subView) {
        
        return subTableView.count;
    
    } else {
    
        return 1;
    
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (tableView == tableView_subView) {
        
        static NSString *cellIdentifier = @"cellIdentifierSubTabelView";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        /*
         *   If the cell is nil it means no cell was available for reuse and that we should
         *   create a new one.
         */
        if (cell == nil) {
            
            /*
             *   Actually create a new cell (with an identifier so that it can be dequeued).
             */
    
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"];
            
        }
    
        cell.textLabel.text = [subTableView objectAtIndex:indexPath.row];
        if(txtField_Selected == textField1_WorkOut){
            if([PartsCellSelected containsObject:indexPath]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }else{
            if([PartsCellSelected1 containsObject:indexPath]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        return cell;
    }else{
        return nil;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(txtField_Selected == textField1_WorkOut){
        if([PartsCellSelected containsObject:indexPath]){
            [PartsCellSelected removeObject:indexPath];
        }else{
            [PartsCellSelected addObject:indexPath];
        }
    }else{
        if([PartsCellSelected1 containsObject:indexPath]){
            [PartsCellSelected1 removeObject:indexPath];
        }else{
            [PartsCellSelected1 addObject:indexPath];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView_subView reloadData];
    
}



- (void)openSubView {

    view_SubView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self.view addSubview:view_SubView];
    
    [tableView_subView reloadData];

}

- (IBAction)DoneSelected:(id)sender {
    
    NSString *tmpStr = @"";
    if(txtField_Selected == textField1_WorkOut){
        for(int i = 0; i < PartsCellSelected.count; i++){
            NSIndexPath *ii = [PartsCellSelected objectAtIndex:i];
            if(i == 0){
                tmpStr = [NSString stringWithFormat:@"%@", [subTableView objectAtIndex:ii.row]];
            }else{
                tmpStr = [NSString stringWithFormat:@"%@,%@", tmpStr, [subTableView objectAtIndex:ii.row]];
            }
        }
    }else{
        for(int i = 0; i < PartsCellSelected1.count; i++){
            NSIndexPath *ii = [PartsCellSelected1 objectAtIndex:i];
            if(i == 0){
                tmpStr = [NSString stringWithFormat:@"%@", [subTableView objectAtIndex:ii.row]];
            }else{
                tmpStr = [NSString stringWithFormat:@"%@,%@", tmpStr, [subTableView objectAtIndex:ii.row]];
            }
        }
        
    }
    txtField_Selected.text = tmpStr;
    [view_SubView removeFromSuperview];
    
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

- (IBAction)payPaypal_clicked:(id)sender {

    NSString *cost = [[dict_SessionInfo objectForKey:@"rate"] stringByReplacingOccurrencesOfString:@"$" withString:@""];
    cost = [cost stringByReplacingOccurrencesOfString:@" " withString:@""];

    PayPalItem *item1 = [PayPalItem itemWithName:@"Pay for GYMatch"
                                    withQuantity:1
                                       withPrice:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f", totalMoney]]
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
    [self presentViewController:paymentViewController animated:YES completion:nil];
}

#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    NSLog(@"PayPal Payment Success!");

    [self sendCompletedPaymentToServer:completedPayment]; // Payment was processed successfully; send to server for verification and fulfillment
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
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
    [self presentViewController:futurePaymentViewController animated:YES completion:nil];
}


#pragma mark PayPalFuturePaymentDelegate methods

- (void)payPalFuturePaymentViewController:(PayPalFuturePaymentViewController *)futurePaymentViewController
                didAuthorizeFuturePayment:(NSDictionary *)futurePaymentAuthorization {
    NSLog(@"PayPal Future Payment Authorization Success!");
    
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
    
    PayPalProfileSharingViewController *profileSharingPaymentViewController = [[PayPalProfileSharingViewController alloc] initWithScopeValues:scopeValues configuration:payPalConfig delegate:self];
    [self presentViewController:profileSharingPaymentViewController animated:YES completion:nil];
}


#pragma mark PayPalProfileSharingDelegate methods

- (void)payPalProfileSharingViewController:(PayPalProfileSharingViewController *)profileSharingViewController
             userDidLogInWithAuthorization:(NSDictionary *)profileSharingAuthorization {
    NSLog(@"PayPal Profile Sharing Authorization Success!");
    
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
