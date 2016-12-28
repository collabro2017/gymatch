//
//  calenderVC.m
//  GYMatch
//
//  Created by osvinuser on 24/05/16.
//  Copyright © 2016 xtreem. All rights reserved.
//

#import "calenderVC.h"
#import "Spotlight.h"
#import "Utility.h"
#import "SpotlightDataController.h"
#import "AFNetworking.h"
#import "PersonalTraining.h"
#import "SessionTableViewCell1.h"
#import "BookingNowSessionViewController.h"
#import "SessionDataController.h"
#import "Session.h"
#import "AddSession.h"
#import "TrainingSeesionTimeViewController.h"
#import "TrainingSeesionPeriodViewController.h"
#import "MutipleTrainingSeesionSelectDateViewController.h"
#import "AddBookNowViewController.h"
#import "AppDelegate.h"

@interface calenderVC () <UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource> {
    
  //  IBOutlet UIPickerView *PickerView_Timer;
    
    NSArray *weekDays;
    
    NSDate *userSelectedDate;

    IBOutlet UIView *view_StartTimeView;
    IBOutlet UIPickerView *PickerView_ShowOpeningTime;
    NSArray *arrayOpeningPicker;
    
    IBOutlet UIView *view_EndTimeView;
    IBOutlet UIPickerView *PickerView_ShowOpeningEndTime;
    NSArray *arrayOpeningEndPicker;

    IBOutlet UIView *view_DurationView;
    IBOutlet UIPickerView *pickerView_Duration;
    NSMutableArray *arrayDurationTime;

    NSString *getStartingTime;
    NSString *getEndingTime;
    NSString *getMultiStartingTime;
    NSString *getMultiEndingTime;
    NSInteger openingTime, endingTime;
    PersonalTraining *getTimeDuration;
    
    IBOutlet UIView *view_createSession;
    IBOutlet UITableView *tableView_SessionTableView;
    
    IBOutlet UIView *view_Sessions;
    IBOutlet UITableView *tableView_Sessions;
    NSArray *sessionArray;
    
    
    /// dragon ///
    NSMutableArray *aryMultipleSessionDates;
    
    __weak IBOutlet UILabel *lblCurrentDate;
    __weak IBOutlet UILabel *lblToday;
    __weak IBOutlet UILabel *lblTrainingSeesionBegin;
    __weak IBOutlet UILabel *lblTrainingSessionBeginTime;
    __weak IBOutlet UILabel *lblTrainingSessionEnd;
    __weak IBOutlet UILabel *lblTrainingSessionEndTime;
    __weak IBOutlet UILabel *lblMultipleTrainingSession;
    __weak IBOutlet UILabel *lblMultipleTrainingSessionValue;
    __weak IBOutlet UILabel *lblTrainingSessionPeriod;
    __weak IBOutlet UILabel *lblTrainingSessionPeriodValue;
    //////////////
}

@end

@implementation calenderVC
@synthesize array_Timer, aSpotlight, selectedType;

- (void)viewDidLoad {
    
    // alloc
    array_Timer = [NSMutableArray new];
    
    weekDays = @[@"Sunday",
                 @"Monday",
                 @"Tuesday",
                 @"Wednesday",
                 @"Thursday",
                 @"Friday",
                 @"Saturday"];
    
    [lblCurrentDate setText:[APP_DELEGATE getCurrentDateInfo:0]];
    
    getStartingTime = @"";
    getEndingTime = @"";
    getMultiStartingTime = @"";
    getMultiEndingTime = @"";
    
    aryMultipleSessionDates = [NSMutableArray arrayWithArray:@[@"0", @"0", @"0", @"0", @"0", @"0", @"0"]];
    
    
    /*
    NSArray *weekDays = [NSArray new];

    

    
    
    OperatingHour *hour = aSpotlight.operatingHours[0];
    
    NSLog(@"%@", weekDays[0]);
    NSLog(@"%@", [NSString stringWithFormat:@"%ld:00am", (long)hour.opening]);
    NSInteger closingHour;
    if (hour.closing > 12) {
        closingHour = hour.closing - 12;
        
        NSLog(@"%@",[NSString stringWithFormat:@"%ld:00pm", (long)closingHour]);
        
    }
    else{
        closingHour = hour.closing;
        
        NSLog(@"%@",[NSString stringWithFormat:@"%ld:00am", (long)closingHour]);

    }*/

    if (userSelectedDate == nil)
        userSelectedDate = [NSDate date];
    
    [super viewDidLoad];
    
}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self.navigationItem setTitle:@"Booking Now"];
//    self.navigationItem.rightBarButtonItem =
//        [[UIBarButtonItem alloc]
//         initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
//         target:self
//         action:@selector(Add:)];
    
//    [[(TopNavigationController *)[[APP_DELEGATE tabBarController] selectedViewController] friendNavigationBar] setHidden:YES];
    [(TopNavigationController *)[[APP_DELEGATE tabBarController] selectedViewController] hideProfileMenuOnlyCalendar];
//    [[[APP_DELEGATE tabBarController] tabBar] setHidden:YES];
    
}
// MKC test
-(IBAction)Add:(id)sender
{
    NSLog(@"add clicked");
    if([[NSDate date] compare:userSelectedDate] == NSOrderedDescending){
        [[[UIAlertView alloc] initWithTitle:@"GYMatch" message:@"Please add session" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }else{
        //    SpotlightDetailsViewController *viewController = [[SpotlightDetailsViewController alloc] initWithSpotlight:spotLight];
        
        
        //[self.navigationController pushViewController:viewController animated:YES];
        AddSession *vc = [[AddSession alloc] init];
        vc.date = userSelectedDate;
        [self.navigationController pushViewController:vc animated:YES];
        [[[APP_DELEGATE tabBarController] tabBar] setHidden:YES];
        
    }
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date
{
    
    // when user want to add the new Date.
    if ([selectedType isEqualToString:SPOTLIGHT_TYPE_TRAINER] || [selectedType isEqualToString:SPOTLIGHT_TYPE_GYMSTAR]) {
    
        
        if ([[NSDate date] compare:date] == NSOrderedSame || [[NSDate date] compare:date] == NSOrderedDescending) {
            
            // show alert view for add date.
            [[[UIAlertView alloc] initWithTitle:@"GYMatch" message:@"Please choose a future date" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
            [calendar selectDate:userSelectedDate];
        } else {
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"EEEE"];
            bool haveSchedule = YES;
            for(int i = 0; i < 7; i++){
                OperatingHour *hour = aSpotlight.operatingHours[i];
                if ([weekDays[i] isEqualToString:[dateFormatter stringFromDate:date]]) {
                    if(hour.opening == hour.closing)
                    {
                        haveSchedule = NO;
                        break;
                    }
                }
            }
            if(haveSchedule){
                if (userSelectedDate.timeIntervalSince1970 != date.timeIntervalSince1970) {
                    getStartingTime = @"";
                    getEndingTime = @"";
                    getMultiStartingTime = @"";
                    getMultiEndingTime = @"";
                    [lblTrainingSessionBeginTime setText:@"00:00"];
                    [lblTrainingSessionEndTime setText:@"00:00"];
                    [lblMultipleTrainingSessionValue setText:@"Select Session"];
                    [lblTrainingSessionPeriod setText:@"Select Period"];
                    aryMultipleSessionDates = [NSMutableArray arrayWithArray:@[@"0", @"0", @"0", @"0", @"0", @"0", @"0"]];
                }
                userSelectedDate = date;
                
                // show alert view for add date.
//                UIAlertView *alertViewAdd = [[UIAlertView alloc] initWithTitle:@"GYMatch" message:@"Would you like to add this date?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
//                
//                alertViewAdd.tag = 1;
//                
//                // selected date by user.
//                
//                [alertViewAdd show];                
            }else{
                [[[UIAlertView alloc] initWithTitle:@"GYMatch" message:@"Please select another date" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                [calendar selectDate:userSelectedDate];
            }
        
        }
        
    } else {
        
        // when user want to check the sessions.
        if ([[NSDate date] compare:date] == NSOrderedSame || [[NSDate date] compare:date] == NSOrderedDescending) {
            
            // show alert view for add date.
            [[[UIAlertView alloc] initWithTitle:@"GYMatch" message:@"Please select future date" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
            [calendar selectDate:userSelectedDate];
            
        } else {
            userSelectedDate = date;
        }
    }
    
    
    
    
    
//    if ([[NSDate date] compare:date] == NSOrderedSame || [[NSDate date] compare:date] == NSOrderedDescending) {
//
//        UIAlertController * alert=   [UIAlertController
//                                      alertControllerWithTitle:@"GyMatch"
//                                      message:@"Please choose a future date"
//                                      preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction* yesButton = [UIAlertAction
//                                    actionWithTitle:@"Okay"
//                                    style:UIAlertActionStyleDefault
//                                    handler:^(UIAlertAction * action) {
//                                        
//                                    }];
//        
//        
//        [alert addAction:yesButton];
//        
//        
//        [self presentViewController:alert animated:YES completion:nil];
//
//        
//    } else {
//    
//        userSelectedDate = date;
//
//        UIAlertController * alert=   [UIAlertController
//                                      alertControllerWithTitle:@"GyMatch"
//                                      message:@"Would you like to add this date?"
//                                      preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction* yesButton = [UIAlertAction
//                                    actionWithTitle:@"Yes"
//                                    style:UIAlertActionStyleDefault
//                                    handler:^(UIAlertAction * action) {
//                                        
//                                        _view_starttime.hidden = NO;
//                                        
//                                        [self getOpeningTime:date];
//                                        
//                                    }];
//        
//        UIAlertAction* NoBtn = [UIAlertAction
//                                actionWithTitle:@"No"
//                                style:UIAlertActionStyleDefault
//                                handler:^(UIAlertAction * action)
//                                {
//                                    //Handel your yes please button action here
//                                    
//                                    
//                                }];
//        
//        
//        [alert addAction:yesButton];
//        [alert addAction:NoBtn];
//        
//        [self presentViewController:alert animated:YES completion:nil];
//    
//    }
    
 
    
}


#pragma mark 
#pragma mark -- UIAction Button
- (IBAction)btnSessionsClose:(id)sender {
    
    [view_Sessions removeFromSuperview];
}
- (IBAction)crossButton:(id)sender {
    
    [view_createSession removeFromSuperview];
}
- (IBAction)upsideButton:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSLog(@"%@", [dateFormatter stringFromDate:userSelectedDate]);
    
    
    SessionDataController *uDC = [SessionDataController new];
    [uDC sessionFor:[APP_DELEGATE loggedInUser].ID withDate:userSelectedDate withSuccess:^(NSArray *sessions) {
        
        sessionArray = sessions;
        
        
        if([sessionArray count] == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"No sessions found." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            [tableView_Sessions reloadData];
            [self.view addSubview:view_Sessions];
            
        }
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }];
    
    NSLog(@"upsideClicked!");
    view_Sessions.frame = CGRectMake(0, self.view.frame.size.height - 340, self.view.frame.size.width, 340);
}

- (IBAction)startTimeCancel:(id)sender {
    
    [view_StartTimeView removeFromSuperview];

}
- (IBAction)EndTimeCancel:(id)sender {
    
    [view_EndTimeView removeFromSuperview];
    
}
- (IBAction)duratiobTimeCancel:(id)sender {
    
    [view_DurationView removeFromSuperview];

}


- (IBAction)doneWithDate:(UIButton *)sender {
    // when user selected start time.
    if (sender.tag == 1) {
        
        getStartingTime = [self getStartTime];
        [lblTrainingSessionBeginTime setText:getStartingTime];
        [view_StartTimeView removeFromSuperview];
    
    } else if (sender.tag == 2) {
        float totleTime = 0.0;
        
        // when user selected duration.
        getTimeDuration = [self getDurationTime];
        
        if (getTimeDuration.type == PersonalTrainingHourTypeHalf) {
            if (getTimeDuration.hour > 60) {
                totleTime = getTimeDuration.hour / 60.0f;
            } else {
                totleTime = getTimeDuration.hour / 60.0f;
            }
            
        } else {
            
            totleTime = getTimeDuration.hour;
        }
        
        NSArray *array = [getStartingTime componentsSeparatedByString:@":"];
        float startTime = [[array lastObject] integerValue] > 0 ? [[array firstObject] integerValue] + 0.5 : [[array firstObject] integerValue];
        totleTime += startTime;
        
        int sTime = (int)[[array firstObject] integerValue];
        for(int i = 0; i < sessionArray.count; i++){
            Session *session = [sessionArray objectAtIndex:i];
            NSArray *tmpsessionArr1 = [session.starttime componentsSeparatedByString:@":"];
            NSArray *tmpsessionArr2 = [session.endtime componentsSeparatedByString:@":"];
            float tmpStart = [[tmpsessionArr1 objectAtIndex:1] integerValue] > 0 ? [[tmpsessionArr1 firstObject] integerValue] + 0.5 : [[tmpsessionArr1 firstObject] integerValue];
            float tmpend = [[tmpsessionArr2 objectAtIndex:1] integerValue] > 0 ? [[tmpsessionArr2 firstObject] integerValue] + 0.5 : [[tmpsessionArr2 firstObject] integerValue];
            if((startTime >= tmpStart && startTime < tmpend)
               || (totleTime > tmpStart && totleTime <= tmpend)
               || (startTime < tmpStart && totleTime > tmpend))
            {
                
                [[[UIAlertView alloc] initWithTitle:@"GYMatch" message:@"Slot already booked" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                return;
            }
        }
//        if (totleTime > endingTime) {
//            
//            [[[UIAlertView alloc] initWithTitle:@"GYMatch" message:@"Your time duration is great than end time" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
//            
//        } else
        {
            if (getTimeDuration.type == PersonalTrainingHourTypeHalf) {
                [lblTrainingSessionPeriodValue setText:[NSString stringWithFormat:@"%ld min", (long)(getTimeDuration.hour)]];
            } else {
                [lblTrainingSessionPeriodValue setText:[NSString stringWithFormat:@"%ld hours", (long)(getTimeDuration.hour)]];
            }
            
            [view_DurationView removeFromSuperview];
        }

    } else if (sender.tag == 6) {
        getEndingTime = [self getEndTime];
        [lblTrainingSessionEndTime setText:getEndingTime];
        [view_EndTimeView removeFromSuperview];
    }else {
    
        [view_DurationView removeFromSuperview];
        
        view_createSession.frame = CGRectMake(0, self.view.frame.size.height - 150, self.view.frame.size.width, 150);
        
        [tableView_SessionTableView reloadData];
        
        [self.view addSubview:view_createSession];
        
        
    }
    

//
//    NSString  *stringSelectedComponent = [arrayOpeningPicker objectAtIndex:component];
//
//    // set start time and end time
//    NSArray *array_Start = [stringSelectedComponent componentsSeparatedByString: @":"];
//    
//    
//    float value1 = [[array_Start lastObject] floatValue];
//    
//    float startTime = [[array_Start firstObject] intValue] + (value1 / 100) ;
//    
//    if (startTime > endTime || startTime == endTime) {
//    
//        NSLog(@"wrong time");
//        
//        [[[UIAlertView alloc] initWithTitle:@"GYMatch" message:@"Please select correct time duration!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//    
//    } else {
//        
//        NSLog(@"%ld", (long)aSpotlight.ID);
//        NSLog(@"%@", userSelectedDate);
//        
//        // date formate hours & min
//        NSDateFormatter *tempFormatter=[[NSDateFormatter alloc]init];
//        [tempFormatter setDateFormat:@"yyyy-MM-dd"];
//        
//        NSString *string_SelectedDate = [tempFormatter stringFromDate:userSelectedDate];
//        
//        
//        NSString *userId = [[NSUserDefaults standardUserDefaults] valueForKey:USER_ID_KEY];
//        
//        
//        NSDictionary *requestDictionary = @{@"user_id": userId,
//                                            @"trainer_id": [NSString stringWithFormat:@"%ld", (long)aSpotlight.ID],
//                                            @"booking_date": string_SelectedDate,
//                                            @"start_time": [NSString stringWithFormat:@"%@:00", stringSelectedComponent1],
//                                            @"end_time": [NSString stringWithFormat:@"%@:00", stringSelectedComponent2]
//                                            };
//        
//        
//        
//        SpotlightDataController *sDC = [SpotlightDataController new];
//        
//        [sDC bookingTrainer:requestDictionary withSuccess:^(NSDictionary *spotlight) {
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//                 [[[UIAlertView alloc] initWithTitle:@"GYMatch" message:[spotlight objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//                
//                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//            });
//
//            
//        } failure:^(NSError *error) {
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//                [[[UIAlertView alloc] initWithTitle:@"GYMatch" message:[NSString stringWithFormat:@"%@", error.localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//                
//                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//            });
//            
//        }];
//
//        NSLog(@"right time");
//        
//    }
    

}


- (NSString *)getStartTime {

    // get Data from componet.
    NSInteger component = [PickerView_ShowOpeningTime selectedRowInComponent:0];
    
    return [arrayOpeningPicker objectAtIndex:component];
    
}


- (PersonalTraining *)getDurationTime {

    // get Data from componet.
    NSInteger component = [pickerView_Duration selectedRowInComponent:0];
    
    return [arrayDurationTime objectAtIndex:component];
    
}

- (void)getHoursMinsAndRate {

    NSLog(@"%@",self.aSpotlight. fullPersonalTrainings);
    NSLog(@"%@",self.aSpotlight.halfPersonalTrainings);

    
    arrayDurationTime = [NSMutableArray new];
    BOOL Is60Min = false;
    for (PersonalTraining *personalTraining in self.aSpotlight. halfPersonalTrainings) {
        [arrayDurationTime addObject:personalTraining];
        if (personalTraining.hour == 60) {
            Is60Min = true;
        }
    }
    
    for (PersonalTraining *personalTraining in self.aSpotlight. fullPersonalTrainings) {
        if (Is60Min && personalTraining.hour==1) {
            continue;
        }
        [arrayDurationTime addObject:personalTraining];
    }
    
    [pickerView_Duration reloadAllComponents];
    
}




#pragma mark - UIAlertView Delegate.
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 1) {
    
        if (buttonIndex == 0) {
        
            NSLog(@"Add Date");
            [self getSelectedDateSessions];
            
        }
        
    }
    
}


-(void)getSelectedDateSessions
{
    // Dragon
    arrayOpeningPicker = [APP_DELEGATE getTimeArray];
    [PickerView_ShowOpeningTime reloadAllComponents];
    view_StartTimeView.frame = CGRectMake(0, self.view.frame.size.height - 260, self.view.frame.size.width, 260);
    [self.view addSubview:view_StartTimeView];
    
    
    
    // Dragon
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
////    NSLog(@"%@", [dateFormatter stringFromDate:userSelectedDate]);
//    SessionDataController *uDC = [SessionDataController new];
//    [uDC sessionFor:[APP_DELEGATE loggedInUser].ID withDate:userSelectedDate withSuccess:^(NSArray *sessions) {
//        sessionArray = sessions;
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        
//        [self getOpeningTime:userSelectedDate];
//        
//        view_StartTimeView.frame = CGRectMake(0, self.view.frame.size.height - 260, self.view.frame.size.width, 260);
//        [self.view addSubview:view_StartTimeView];
//        
//    } failure:^(NSError *error) {
//        
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alertView show];
//    }];

}
-(void)getSelectedDateSessionsEndTime
{
    arrayOpeningEndPicker = [APP_DELEGATE getTimeArray];
    [PickerView_ShowOpeningEndTime reloadAllComponents];
    
    view_EndTimeView.frame = CGRectMake(0, self.view.frame.size.height - 260, self.view.frame.size.width, 260);
    [self.view addSubview:view_EndTimeView];
    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    //    NSLog(@"%@", [dateFormatter stringFromDate:userSelectedDate]);
//    SessionDataController *uDC = [SessionDataController new];
//    [uDC sessionFor:[APP_DELEGATE loggedInUser].ID withDate:userSelectedDate withSuccess:^(NSArray *sessions) {
//        sessionArray = sessions;
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        [self getOpeningTimeEnd:userSelectedDate];
//        view_EndTimeView.frame = CGRectMake(0, self.view.frame.size.height - 260, self.view.frame.size.width, 260);
//        [self.view addSubview:view_EndTimeView];
//        
//    } failure:^(NSError *error) {
//        
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alertView show];
//    }];
}

/* Dragon
- (void)getOpeningTime:(NSDate *)date {
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    NSLog(@"%@", [dateFormatter stringFromDate:date]);
 
    for (int i = 0; i < 7; i ++) {
        
        OperatingHour *hour = aSpotlight.operatingHours[i];
        NSLog(@"%@", weekDays[i]);
        
        if ([weekDays[i] isEqualToString:[dateFormatter stringFromDate:date]]) {
            
            NSString *startTime;
            NSString *endTime;
            
            // hour.opening > 12 ? [NSString stringWithFormat:@"%ld:00 PM", (long)hour.opening - 12] :
            // hour.closing > 12 ? [NSString stringWithFormat:@"%ld:00 PM", (long)hour.closing - 12] :
            startTime = [NSString stringWithFormat:@"%ld:00", (long)hour.opening];
            endTime = [NSString stringWithFormat:@"%ld:00", (long)hour.closing];
            
            
            openingTime = hour.opening;
            endingTime = hour.closing;
            
            
            arrayOpeningPicker = [self startingDate:startTime endingDate:endTime];
            [PickerView_ShowOpeningTime reloadAllComponents];
            
        }
        
    }
    
}

- (NSMutableArray *)startingDate:(NSString *)startTimeString endingDate:(NSString *)endTimeString {
    // date formate hours & min
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"HH:mm";
    
    // start date
    NSDate *startTimeDate = [dateFormatter dateFromString:startTimeString];
    
    // end date
    NSDate *endTimeDate = [dateFormatter dateFromString:endTimeString];
    
    
    // set date components
    NSDateComponents *componentStartDate = [[NSCalendar currentCalendar] components:NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond
                                                                           fromDate:startTimeDate];
    
    NSDateComponents *componentEndDate = [[NSCalendar currentCalendar] components:NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond
                                                                         fromDate:endTimeDate];
    
    
    NSMutableArray *arrayTimeSlots = [NSMutableArray new];
    
    
    while (componentStartDate.hour < componentEndDate.hour) {
        
        NSString *timeString;
        
        if (arrayTimeSlots.count > 0) {
            
            if (componentStartDate.minute == 30) {
                
                componentStartDate.hour  += 1;
                componentStartDate.minute = 0;
                
            } else {
                
                componentStartDate.minute += 30;
                
            }
            
            timeString = componentStartDate.minute == 30 ? [NSString stringWithFormat:@"%ld:30", (long)componentStartDate.hour] : [NSString stringWithFormat:@"%ld:00", (long)componentStartDate.hour];
            
        } else {
            
            
            timeString = componentStartDate.minute == 30 ? [NSString stringWithFormat:@"%ld:30", (long)componentStartDate.hour] : [NSString stringWithFormat:@"%ld:00", (long)componentStartDate.hour];
            
        }
        
        [arrayTimeSlots addObject:timeString];
        
    }
    
    return arrayTimeSlots;
}
- (void)getOpeningTimeEnd:(NSDate *)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    NSLog(@"%@", [dateFormatter stringFromDate:date]);
    
    
    for (int i = 0; i < 7; i ++) {
        
        OperatingHour *hour = aSpotlight.operatingHours[i];
        NSLog(@"%@", weekDays[i]);
        
        if ([weekDays[i] isEqualToString:[dateFormatter stringFromDate:date]]) {
            
            NSString *startTime;
            NSString *endTime;
            
            // hour.opening > 12 ? [NSString stringWithFormat:@"%ld:00 PM", (long)hour.opening - 12] :
            // hour.closing > 12 ? [NSString stringWithFormat:@"%ld:00 PM", (long)hour.closing - 12] :
            startTime = [NSString stringWithFormat:@"%ld:00", (long)hour.opening];
            endTime = [NSString stringWithFormat:@"%ld:00", (long)hour.closing];
            
            openingTime = hour.opening;
            endingTime = hour.closing;
            
            arrayOpeningEndPicker = [self startingDateEnd:startTime endingDate:endTime];
            [PickerView_ShowOpeningEndTime reloadAllComponents];
            
        }
        
    }
    
}

- (NSMutableArray *)startingDateEnd:(NSString *)startTimeString endingDate:(NSString *)endTimeString {
    // Dragon
    return [APP_DELEGATE getTimeArray];
    
    // date formate hours & min
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"HH:mm";
    
    // start date
    NSDate *startTimeDate = [dateFormatter dateFromString:startTimeString];
    
    // end date
    NSDate *endTimeDate = [dateFormatter dateFromString:endTimeString];
    
    
    // set date components
    NSDateComponents *componentStartDate = [[NSCalendar currentCalendar] components:NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond
                                                                           fromDate:startTimeDate];
    
    NSDateComponents *componentEndDate = [[NSCalendar currentCalendar] components:NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond
                                                                         fromDate:endTimeDate];
    
    
    NSMutableArray *arrayTimeSlots = [NSMutableArray new];
    
    
    while (componentStartDate.hour < componentEndDate.hour) {
        
        NSString *timeString;
        
        if (arrayTimeSlots.count > 0) {
            
            if (componentStartDate.minute == 30) {
                
                componentStartDate.hour  += 1;
                componentStartDate.minute = 0;
                
            } else {
                
                componentStartDate.minute += 30;
                
            }
            
            timeString = componentStartDate.minute == 30 ? [NSString stringWithFormat:@"%ld:30", (long)componentStartDate.hour] : [NSString stringWithFormat:@"%ld:00", (long)componentStartDate.hour];
            
        } else {
            
            
            timeString = componentStartDate.minute == 30 ? [NSString stringWithFormat:@"%ld:30", (long)componentStartDate.hour] : [NSString stringWithFormat:@"%ld:00", (long)componentStartDate.hour];
            
        }
    
        [arrayTimeSlots addObject:timeString];
        
    }
    
    
    for (int i = (int)arrayTimeSlots.count - 1; i >= 0; i--) {
        NSDate *currentTimeString = [dateFormatter dateFromString:[arrayTimeSlots objectAtIndex:i]];
        NSDate *sessionStartTimeString = [dateFormatter dateFromString:getStartingTime];
        if (currentTimeString.timeIntervalSince1970 <= sessionStartTimeString.timeIntervalSince1970)
            [arrayTimeSlots removeObjectAtIndex:i];
    }
    
    return arrayTimeSlots;
}
 */
- (NSString *)getEndTime {
    
    // get Data from componet.
    NSInteger component = [PickerView_ShowOpeningEndTime selectedRowInComponent:0];
    
    return [arrayOpeningEndPicker objectAtIndex:component];
    
}
/*
- (NSMutableArray *)startingDate:(NSString *)startTimeString endingDate:(NSString *)endTimeString {
    
    // date formate hours & min
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"HH:mm";
    
    // start date
    NSDate *startTimeDate = [dateFormatter dateFromString:startTimeString];
    
    // end date
    NSDate *endTimeDate = [dateFormatter dateFromString:endTimeString];
    NSDateComponents *componentStartDate = [[NSCalendar currentCalendar] components:NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond
                                                                           fromDate:startTimeDate];
    
    NSDateComponents *componentEndDate = [[NSCalendar currentCalendar] components:NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond
                                                                         fromDate:endTimeDate];
    NSMutableArray *arrayTimeSlots = [NSMutableArray new];
    
    
    if(sessionArray.count > 0){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"HH:mm:ss";
        // set date components
        bool isAdded = false;
        NSDateComponents *tmpStartDate;
        NSDateComponents *tmpEndDate;
        
        
        
        while (componentStartDate.hour < componentEndDate.hour) {
            
            NSString *timeString;
            isAdded = NO;
            if (arrayTimeSlots.count > 0) {
                
                if (componentStartDate.minute == 30) {
                    
                    componentStartDate.hour  += 1;
                    componentStartDate.minute = 0;
                    
                } else {
                    
                    componentStartDate.minute += 30;
                    
                }
                for(int i = 0; i < sessionArray.count; i++){
                    Session *session = [sessionArray objectAtIndex:i];
                    NSDate *oldstartTimeDate = [dateFormatter dateFromString:session.starttime];
                    NSDate *oldendTimeDate = [dateFormatter dateFromString:session.endtime];
                    if(componentStartDate.date >= oldstartTimeDate && componentStartDate.date < oldendTimeDate)
                    {
                        isAdded = YES;
                        break;
                    }
//                    tmpStartDate = [[NSCalendar currentCalendar] components:NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond
//                                                                   fromDate:oldstartTimeDate];
//                    tmpEndDate = [[NSCalendar currentCalendar] components:NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond
//                                                                   fromDate:oldendTimeDate];//
//                    if(((componentStartDate.hour > tmpStartDate.hour) && (componentStartDate.hour < tmpEndDate.hour))
//                       || ((componentStartDate.hour == tmpStartDate.hour) && (componentStartDate.minute == tmpStartDate.minute))
//                       || ((componentStartDate.hour == tmpEndDate.hour) && (componentStartDate.minute < tmpEndDate.minute))
//                       || ((componentStartDate.hour == tmpStartDate.hour) && (componentStartDate.minute > tmpStartDate.minute) && (componentStartDate.hour <= tmpEndDate.hour))){
//                        isAdded = YES;
//                        break;
//                    }
                }
                if(!isAdded){
                    timeString = componentStartDate.minute == 30 ? [NSString stringWithFormat:@"%ld:30", (long)componentStartDate.hour] : [NSString stringWithFormat:@"%ld:00", (long)componentStartDate.hour];
                    [arrayTimeSlots addObject:timeString];
                }
                
            } else {
                
                if (componentStartDate.minute == 30) {
                    
                    componentStartDate.hour  += 1;
                    componentStartDate.minute = 0;
                    
                } else {
                    
                    componentStartDate.minute += 30;
                    
                }

                
                for(int i = 0; i < sessionArray.count; i++){
                    
                    Session *session = [sessionArray objectAtIndex:i];
                    NSDate *oldstartTimeDate = [dateFormatter dateFromString:session.starttime];
                    NSDate *oldendTimeDate = [dateFormatter dateFromString:session.endtime];
                    
                    tmpStartDate = [[NSCalendar currentCalendar] components:NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond
                                                                   fromDate:oldstartTimeDate];
                    tmpEndDate = [[NSCalendar currentCalendar] components:NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond
                                                                 fromDate:oldendTimeDate];
                    
                    if(((componentStartDate.hour > tmpStartDate.hour) && (componentStartDate.hour < tmpEndDate.hour))
                       || ((componentStartDate.hour == tmpStartDate.hour) && (componentStartDate.minute == tmpStartDate.minute))
                       || ((componentStartDate.hour == tmpEndDate.hour) && (componentStartDate.minute < tmpEndDate.minute))
                       || ((componentStartDate.hour == tmpStartDate.hour) && (componentStartDate.minute > tmpStartDate.minute) && (componentStartDate.hour <= tmpEndDate.hour))){
                        isAdded = YES;
                        break;
                    }

                }
                if(!isAdded){
                    timeString = componentStartDate.minute == 30 ? [NSString stringWithFormat:@"%ld:30", (long)componentStartDate.hour] : [NSString stringWithFormat:@"%ld:00", (long)componentStartDate.hour];
                    [arrayTimeSlots addObject:timeString];
                }
                
            }
            
        }
    }else{
        
        // set date components
        NSDateComponents *componentStartDate = [[NSCalendar currentCalendar] components:NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond
                                                                               fromDate:startTimeDate];
        
        NSDateComponents *componentEndDate = [[NSCalendar currentCalendar] components:NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond
                                                                             fromDate:endTimeDate];
        while (componentStartDate.hour < componentEndDate.hour) {
            
            NSString *timeString;
            
            if (arrayTimeSlots.count > 0) {
                
                if (componentStartDate.minute == 30) {
                    
                    componentStartDate.hour  += 1;
                    componentStartDate.minute = 0;
                    
                } else {
                    
                    componentStartDate.minute += 30;
                    
                }
                
                timeString = componentStartDate.minute == 30 ? [NSString stringWithFormat:@"%ld:30", (long)componentStartDate.hour] : [NSString stringWithFormat:@"%ld:00", (long)componentStartDate.hour];
                
            } else {
                
                
                timeString = componentStartDate.minute == 30 ? [NSString stringWithFormat:@"%ld:30", (long)componentStartDate.hour] : [NSString stringWithFormat:@"%ld:00", (long)componentStartDate.hour];
                
            }
            
            [arrayTimeSlots addObject:timeString];
            
        }

    }
    
    
    return arrayTimeSlots;
}

*/

#pragma mark - 
#pragma mark - UITableView DataSource and delegate Method.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 111) {
        return sessionArray.count;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"cellIdentifier";
    
    SessionTableViewCell1 *cell = (SessionTableViewCell1 *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SessionTableViewCell1" owner:self options:nil];
        cell = (SessionTableViewCell1 *)[nib objectAtIndex:0];
    }

    
    if (tableView.tag == 111) {
        Session *session = [sessionArray objectAtIndex:indexPath.row];
        
        [cell.button_SelectedDate setTitle:session.bookingdate forState:UIControlStateNormal];
        [cell.button_StartTime setTitle:session.starttime forState:UIControlStateNormal];
        
        [cell.button_Duration setTitle:[NSString stringWithFormat:@"%ld %@", (long)session.duration, session.trainingType] forState:UIControlStateNormal];
        
        [cell.button_Rate setTitle:[NSString stringWithFormat:@"%@", session.rate] forState:UIControlStateNormal];
        
        return cell;
    }

    
    // userSelectedDate
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    
    NSString *startDate = [dateFormatter stringFromDate:userSelectedDate];
    
    [cell.button_SelectedDate setTitle:startDate forState:UIControlStateNormal];
    [cell.button_StartTime setTitle:getStartingTime forState:UIControlStateNormal];
    
    if (getTimeDuration.type == PersonalTrainingHourTypeHalf) {
        
        [cell.button_Duration setTitle:[NSString stringWithFormat:@"%ld min", (long)getTimeDuration.hour] forState:UIControlStateNormal];

    } else {
        
        [cell.button_Duration setTitle:[NSString stringWithFormat:@"%ld hours", (long)getTimeDuration.hour] forState:UIControlStateNormal];

    }
    
    
    [cell.button_Rate setTitle:[NSString stringWithFormat:@"$ %.f", getTimeDuration.rate] forState:UIControlStateNormal];

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag == 111) {
        // Add payment
        
        return;
    }
    /*
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    
    NSString *startDate = [dateFormatter stringFromDate:userSelectedDate];
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)[APP_DELEGATE loggedInUser].ID] forKey:@"user_id"];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)self.aSpotlight.ID] forKey:@"trainer_id"];
    [dict setObject:startDate forKey:@"date"];
    [dict setObject:getStartingTime forKey:@"starttime"];
    
    if (getTimeDuration.type == PersonalTrainingHourTypeHalf) {
    
        [dict setObject:[NSString stringWithFormat:@"%ld min", (long)getTimeDuration.hour] forKey:@"duration"];

    } else {
    
        [dict setObject:[NSString stringWithFormat:@"%ld hour", (long)getTimeDuration.hour] forKey:@"duration"];

    }
    
    [dict setObject:[NSString stringWithFormat:@"$ %.f", getTimeDuration.rate] forKey:@"rate"];
    
    
    // open booking now session view controller.
    BookingNowSessionViewController *bookingNowSessionCV = [[BookingNowSessionViewController alloc] initWithNibName:@"BookingNowSessionViewController" bundle:[NSBundle mainBundle]];
    
    bookingNowSessionCV.dict_SessionInfo = dict;
    
    [self.navigationController pushViewController:bookingNowSessionCV animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self crossButton:nil];*/
    
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    
    UIView *footerView = [UIView new];
    
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, tableView.frame.size.width - 15, 0.5)];
    subView.backgroundColor = [UIColor lightGrayColor];
    
    [footerView addSubview:subView];
    
    return footerView;
}


#pragma mark -
#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView.tag == 6)
        return arrayOpeningEndPicker.count;
    return pickerView.tag == 1 ? arrayOpeningPicker.count : arrayDurationTime.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (pickerView.tag == 1) {
    
        return  arrayOpeningPicker[row];
        
    } else if (pickerView.tag == 6) {
        return  arrayOpeningEndPicker[row];
    } else {
        PersonalTraining *personalTraining = arrayDurationTime[row];
        
        if (personalTraining.type == PersonalTrainingHourTypeHalf) {
        
            return [NSString stringWithFormat:@"%ld min", (long)personalTraining.hour];
            
        } else {
        
            return [NSString stringWithFormat:@"%ld hour", (long)personalTraining.hour];

        }
        
    }
    
}

// dragon //
- (IBAction)actionSelectTrainingSessionBegin:(id)sender {
//    TrainingSeesionTimeViewController *fPVC = [TrainingSeesionTimeViewController new];
//    fPVC.delegate = self;
//    [fPVC setType:Training_Seesion_Begin_Time];
//    fPVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
//    fPVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    [self presentViewController:fPVC animated:NO completion:^{
//    }];
    if ([[NSDate date] compare:userSelectedDate] == NSOrderedSame || [[NSDate date] compare:userSelectedDate] == NSOrderedDescending) {
        [[[UIAlertView alloc] initWithTitle:@"GYMatch" message:@"Please choose a future date" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    [self getSelectedDateSessions];
}
- (IBAction)actionSelectTrainingSessionEnd:(id)sender {
//    TrainingSeesionTimeViewController *fPVC = [TrainingSeesionTimeViewController new];
//    fPVC.delegate = self;
//    [fPVC setType:Training_Seesion_End_Time];
//    fPVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
//    fPVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    [self presentViewController:fPVC animated:NO completion:^{
//    }];
    if ([[NSDate date] compare:userSelectedDate] == NSOrderedSame || [[NSDate date] compare:userSelectedDate] == NSOrderedDescending) {
        [[[UIAlertView alloc] initWithTitle:@"GYMatch" message:@"Please choose a future date" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    
    // Dragon
    [self getSelectedDateSessionsEndTime];
}
- (IBAction)actionSelectMultipleTrainingSession:(id)sender {
    if ([[NSDate date] compare:userSelectedDate] == NSOrderedSame || [[NSDate date] compare:userSelectedDate] == NSOrderedDescending) {
        [[[UIAlertView alloc] initWithTitle:@"GYMatch" message:@"Please choose a future date" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    
    MutipleTrainingSeesionSelectDateViewController *fPVC = [MutipleTrainingSeesionSelectDateViewController new];
    fPVC.delegate = self;
    [fPVC setInitDate:userSelectedDate];
    fPVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    fPVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:fPVC animated:NO completion:^{
        
    }];
}
- (IBAction)actionSelectTrainingSessionPeriod:(id)sender {
    if ([[NSDate date] compare:userSelectedDate] == NSOrderedSame || [[NSDate date] compare:userSelectedDate] == NSOrderedDescending) {
        [[[UIAlertView alloc] initWithTitle:@"GYMatch" message:@"Please choose a future date" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    
//    TrainingSeesionPeriodViewController *fPVC = [TrainingSeesionPeriodViewController new];
//    fPVC.delegate = self;
//    fPVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
//    fPVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    [self presentViewController:fPVC animated:NO completion:^{
//    }];
    
//    if (getStartingTime.length <= 0) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
//                                                            message:@"Please select Training Session Begin."
//                                                           delegate:nil
//                                                  cancelButtonTitle:nil
//                                                  otherButtonTitles:@"Ok", nil];
//        [alertView show];
//        return;
//    } else if (getEndingTime.length <= 0) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
//                                                            message:@"Please check Training Session End."
//                                                           delegate:nil
//                                                  cancelButtonTitle:nil
//                                                  otherButtonTitles:@"Ok", nil];
//        [alertView show];
//        return;
//    }
    
    [self getHoursMinsAndRate];
    
    view_DurationView.frame = CGRectMake(0, self.view.frame.size.height - 260, self.view.frame.size.width, 260);
    
    [self.view addSubview:view_DurationView];
}
- (void)showMultipleSessionStartTime {
    TrainingSeesionTimeViewController *fPVC = [TrainingSeesionTimeViewController new];
    fPVC.delegate = self;
    [fPVC setType:Multiple_Training_Seesion_Begin_Time];
    fPVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    fPVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:fPVC animated:NO completion:^{
        
    }];
}
- (void)showMultipleSessionEndTime {
    TrainingSeesionTimeViewController *fPVC = [TrainingSeesionTimeViewController new];
    fPVC.delegate = self;
    [fPVC setType:Multiple_Training_Seesion_End_Time];
    fPVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    fPVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:fPVC animated:NO completion:^{
        
    }];
}
- (void)updateMultipleSessionDate {
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *startDate = [dateFormatter stringFromDate:userSelectedDate];
    NSDate *selectedDate = [dateFormatter dateFromString:startDate];
    NSTimeInterval secondsBetween = [selectedDate timeIntervalSinceDate:currentDate];
    int numberOfDays = secondsBetween / 86400;
    
    for (int i = 0; i < aryMultipleSessionDates.count; i++) {
        NSString *strItem = [aryMultipleSessionDates objectAtIndex:i];
        if ([strItem isEqualToString:@"1"]) {
            NSString *strMultipleDate = [NSString stringWithFormat:@"%@, %@~%@", [APP_DELEGATE getCurrentDateInfo:numberOfDays + i + 2], getMultiStartingTime, getMultiEndingTime];
            [lblMultipleTrainingSessionValue setText:strMultipleDate];
            break;
        }
    }
}
- (IBAction)actionAddBookNow:(id)sender {
    if ([[NSDate date] compare:userSelectedDate] == NSOrderedDescending) {
        [[[UIAlertView alloc] initWithTitle:@"GYMatch" message:@"Please choose a future date" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    } else if (getStartingTime.length <= 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"Please select Training Session Begin."
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Ok", nil];
        [alertView show];
        return;
    } else if (getEndingTime.length <= 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"Please check Training Session End."
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Ok", nil];
        [alertView show];
        return;
    } else if ([self isCorrectData:getStartingTime :getEndingTime] == NO) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"Please reselect Training Session Begin and Training Session End."
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Ok", nil];
        [alertView show];
        return;
//    } else if (getMultiStartingTime.length <= 0) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
//                                                            message:@"Please select Multiple Training Session."
//                                                           delegate:nil
//                                                  cancelButtonTitle:nil
//                                                  otherButtonTitles:@"Ok", nil];
//        [alertView show];
//        return;
//    } else if (getMultiEndingTime.length <= 0) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
//                                                            message:@"Please check Multiple Training Session End."
//                                                           delegate:nil
//                                                  cancelButtonTitle:nil
//                                                  otherButtonTitles:@"Ok", nil];
//        [alertView show];
//        return;
//    } else if (strMultiStartTimeIndex > strMultiEndTimeIndex) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
//                                                            message:@"Please reselect Multiple Training Session Begin and Multiple Training Session End."
//                                                           delegate:nil
//                                                  cancelButtonTitle:nil
//                                                  otherButtonTitles:@"Ok", nil];
//        [alertView show];
//        return;
    } else if (getTimeDuration.hour == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"Please select Training Session Period."
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Ok", nil];
        [alertView show];
        return;
    }


//if (strPeriodTimeIndex < 0) {
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
//                                                        message:@"Please select Training Session Period."
//                                                       delegate:nil
//                                              cancelButtonTitle:nil
//                                              otherButtonTitles:@"Ok", nil];
//    [alertView show];
//    return;

//    BOOL isMultipleSession = false;
//    for (int i = 0; i < aryMultipleSessionDates.count; i++) {
//        NSString *strItem = [aryMultipleSessionDates objectAtIndex:i];
//        if ([strItem isEqualToString:@"0"] == false) {
//            isMultipleSession = true;
//            break;
//        }
//    }
//    
//    if (isMultipleSession == false) {
//        if (strStartTimeIndex < 0) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
//                                                                message:@"Please select Training Session Begin."
//                                                               delegate:nil
//                                                      cancelButtonTitle:nil
//                                                      otherButtonTitles:@"Ok", nil];
//            [alertView show];
//            return;
//        } else if (strEndTimeIndex < 0) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
//                                                                message:@"Please check Training Session End."
//                                                               delegate:nil
//                                                      cancelButtonTitle:nil
//                                                      otherButtonTitles:@"Ok", nil];
//            [alertView show];
//            return;
//        } else if (strStartTimeIndex > strEndTimeIndex) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
//                                                                message:@"Please check Training Session Begin and Training Session End."
//                                                               delegate:nil
//                                                      cancelButtonTitle:nil
//                                                      otherButtonTitles:@"Ok", nil];
//            [alertView show];
//            return;
//        }
//    } else {
//        if (strMultiStartTimeIndex < 0) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
//                                                                message:@"Please select Multiple Training Session Begin."
//                                                               delegate:nil
//                                                      cancelButtonTitle:nil
//                                                      otherButtonTitles:@"Ok", nil];
//            [alertView show];
//            return;
//        } else if (strMultiEndTimeIndex < 0) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
//                                                                message:@"Please check Multiple Training Session End."
//                                                               delegate:nil
//                                                      cancelButtonTitle:nil
//                                                      otherButtonTitles:@"Ok", nil];
//            [alertView show];
//            return;
//        } else if (strMultiStartTimeIndex > strMultiEndTimeIndex) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
//                                                                message:@"Please check Multiple Training Session Begin and Multiple Training Session End."
//                                                               delegate:nil
//                                                      cancelButtonTitle:nil
//                                                      otherButtonTitles:@"Ok", nil];
//            [alertView show];
//        }
//    }
//    
//    if (strPeriodTimeIndex < 0) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
//                                                            message:@"Please select Training Session Period."
//                                                           delegate:nil
//                                                  cancelButtonTitle:nil
//                                                  otherButtonTitles:@"Ok", nil];
//        [alertView show];
//        return;
//    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    
    NSString *startDate = [dateFormatter stringFromDate:userSelectedDate];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)[APP_DELEGATE loggedInUser].ID] forKey:@"user_id"];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)self.aSpotlight.user_id] forKey:@"trainer_id"];     // dragon1
    [dict setObject:startDate forKey:@"date"];
    [dict setObject:getStartingTime forKey:@"starttime"];
    [dict setObject:getEndingTime forKey:@"endtime"];
    [dict setObject:getMultiStartingTime forKey:@"multistarttime"];
    [dict setObject:getMultiEndingTime forKey:@"multiendtime"];
    [dict setObject:aryMultipleSessionDates forKey:@"multisessions"];
    
    if (getTimeDuration.type == PersonalTrainingHourTypeHalf) {
        
        [dict setObject:[NSString stringWithFormat:@"%d min", (int)getTimeDuration.hour] forKey:@"duration"];
        
    } else {
        
        [dict setObject:[NSString stringWithFormat:@"%d hour", (int)getTimeDuration.hour] forKey:@"duration"];
        
    }
    
    [dict setObject:[NSString stringWithFormat:@"$ %.f", getTimeDuration.rate] forKey:@"rate"];
    
    
    // open booking now session view controller.
    AddBookNowViewController *bookingNowSessionCV = [[AddBookNowViewController alloc] initWithNibName:@"AddBookNowViewController" bundle:[NSBundle mainBundle]];
    
    bookingNowSessionCV.dict_SessionInfo = dict;
    
    [self.navigationController pushViewController:bookingNowSessionCV animated:YES];
    
}
- (void)setSessionTime:(int)type :(NSString*)time {
    if (type == Training_Seesion_Begin_Time) {
        getStartingTime = time;
        [lblTrainingSessionBeginTime setText:getStartingTime];
    } else if (type == Training_Seesion_End_Time) {
        getEndingTime = time;
        [lblTrainingSessionEndTime setText:getEndingTime];
    } else if (type == Multiple_Training_Seesion_Begin_Time) {
        getMultiStartingTime = time;
    } else if (type == Multiple_Training_Seesion_End_Time) {
        getMultiEndingTime = time;
    }
}
- (void)setMultipleSessionDate:(NSMutableArray*)array {
    aryMultipleSessionDates = [NSMutableArray arrayWithArray:array];
}
- (BOOL)isCorrectData:(NSString*)strStartTimeValue :(NSString*)strEndTimeValue {
    if ([self getRealTime:strStartTimeValue] >= [self getRealTime:strEndTimeValue])
        return NO;
    
    return YES;
}
- (int)getRealTime:(NSString*)time {
    if ([time isEqualToString:@"12:00 AM"])
        return 0;
    else if ([time isEqualToString:@"12:30 AM"])
        return 30;
    else if ([time isEqualToString:@"12:00 PM"])
        return 1200;
    else if ([time isEqualToString:@"12:30 PM"])
        return 1230;
    NSRange needleRange = NSMakeRange(0, 2);
    int hour = (int)[time substringWithRange:needleRange].integerValue;
    needleRange = NSMakeRange(3, 2);
    int min = (int)[time substringWithRange:needleRange].integerValue;
    needleRange = NSMakeRange(6, 2);
    NSString *str = [time substringWithRange:needleRange];
    if ([str isEqualToString:@"PM"]) {
        hour += 12;
    }
    return hour * 100 + min;
}
////////////


@end
