//
//  BookingNowSessionViewController.m
//  GYMatch
//
//  Created by osvinuser on 5/31/16.
//  Copyright © 2016 xtreem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookingNowSessionViewController.h"
#import "SessionTableViewCell1.h"
#import "SpotlightDataController.h"


@interface BookingNowSessionViewController () <UITextFieldDelegate, UIAlertViewDelegate> {

    
    __weak IBOutlet UIButton *bttDate;
    __weak IBOutlet UIButton *bttTime;
    __weak IBOutlet UIButton *bttDuration;
    __weak IBOutlet UIButton *bttCost;
    
    
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
}

@end

@implementation BookingNowSessionViewController
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
    [bttCost setTitle:[dict_SessionInfo objectForKey:@"rate"] forState:UIControlStateNormal];
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
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

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
    
    
    if ([self skypeIDValidation]) {
        
        NSString *durationValue = [[[[dict_SessionInfo objectForKey:@"duration"] componentsSeparatedByString:@" "] lastObject] isEqualToString:@"min"] ? [[[dict_SessionInfo objectForKey:@"duration"] componentsSeparatedByString:@" "] firstObject] : [NSString stringWithFormat:@"%d",[[[[dict_SessionInfo objectForKey:@"duration"] componentsSeparatedByString:@" "] firstObject] intValue] * 60];
        
        NSString *trainingHourType = [[[[dict_SessionInfo objectForKey:@"duration"] componentsSeparatedByString:@" "] lastObject] isEqualToString:@"min"] ? @"min" : @"hour";
        
        NSDictionary *requestDictionary = @{@"user_id": [dict_SessionInfo objectForKey:@"user_id"],
                                            @"trainer_id": [dict_SessionInfo objectForKey:@"trainer_id"],
                                            @"booking_date": [dict_SessionInfo objectForKey:@"date"],
                                            @"start_time": [dict_SessionInfo objectForKey:@"starttime"],
                                            @"duration": durationValue,
                                            @"training_hour_type": trainingHourType,
                                            @"rate": [dict_SessionInfo objectForKey:@"rate"],
                                            @"is_skype":  swichButton_SkypeID.on ? [NSNumber numberWithInt:1] : [NSNumber numberWithInt:0],
                                            @"skype_id": textField_SkypeID.text,
                                            @"body_parts": textField1_WorkOut.text,
                                            @"workout_type": textField2_WorkOut.text,
                                            };

        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        SpotlightDataController *sDC = [SpotlightDataController new];
        
        [sDC bookingTrainer:requestDictionary withSuccess:^(NSDictionary *spotlight) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIAlertView *alertViewAdd = [[UIAlertView alloc] initWithTitle:@"GYMatch" message:[spotlight objectForKey:@"Message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                alertViewAdd.tag = 1;
                
                // selected date by user.
                
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
