//
//  MyCalendar.m
//  GYMatch
//
//  Created by osvinuser on 24/05/16.
//  Copyright © 2016 xtreem. All rights reserved.
//

#import "MyCalendar.h"
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

#import "UserCalendarCell.h"
#import "TrainerCalendarCell.h"
#import "Friend.h"
#import "SpotlightsViewController.h"
#import "TopNavigationController.h"

@interface MyCalendar () <UITableViewDelegate, UITableViewDataSource> {
    
    IBOutlet UITableView *tableView_SessionTableView;
    NSMutableArray *calendarArray;
}

@end

@implementation MyCalendar

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    calendarArray = [[NSMutableArray alloc] init];
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc]
     initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
     target:self
     action:@selector(addBooking:)];
    
    [self load];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[[APP_DELEGATE tabBarController] tabBar] setHidden:YES];
}
- (void)addBooking:(id)sender {
//    SpotlightsViewController *spotlightViewC = [[SpotlightsViewController alloc]init];
//    spotlightViewC.singleTapBool = YES;
//    spotlightViewC.singleString = @"Trainer";
//    
//    [[[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:[[APP_DELEGATE tabBarController] selectedIndex]] friendNavigationBar] setHidden:YES];
    
//    if ([[[UIDevice currentDevice] systemVersion] integerValue] >= 7) {
//        
//        self.topViewController.navigationItem.title = @"";
//    }
//    [super pushViewController:viewController animated:NO];
//    [self.navigationController popToRootViewControllerAnimated:NO];
//    
//    [self.navigationController pushViewController:spotlightViewC animated:YES];
    [self.topNavigationController bookTrainerAction:NULL];
}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self.navigationItem setTitle:@"My Calendar"];
    tableView_SessionTableView.delegate = self;
    tableView_SessionTableView.dataSource = self;
    
    [(TopNavigationController *)[[APP_DELEGATE tabBarController] selectedViewController] hideProfileMenuOnlyCalendar];
}

- (void)load {
    [calendarArray removeAllObjects];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    // Dragon
    NSDictionary *requestDictionary = @{@"user_id": [NSString stringWithFormat:@"%d", (int)[APP_DELEGATE loggedInUser].ID]};
    SpotlightDataController *sDC = [SpotlightDataController new];
    [sDC getRegisteredBooking:requestDictionary withSuccess:^(NSDictionary *spotlight) {
    
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([spotlight[@"status"] isEqualToString:@"Success"]) {
                NSArray *array = spotlight[@"response"];
                for (int i = 0; i < array.count; i++) {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[array objectAtIndex:i]][@"Booking"];
                    
                    
                    UserDataController *uDC = [UserDataController new];
                    [uDC profileDetails:[NSString stringWithFormat:@"%@", dic[@"user_id"]].integerValue withSuccess:^(Friend *aFriend) {
                        Friend *frnd = aFriend;
                        dic[@"user_info"] = frnd;
                        
                        [calendarArray addObject:dic];
                        
                        if (i == array.count - 1) {
                            [self reloadTableView];
                        }
                    } failure:^(NSError *error) {
                    }];
                }
            } else {
                [self reloadTableView];
            }
        });
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}
- (void)reloadTableView {
    NSMutableArray *array = [NSMutableArray arrayWithArray:calendarArray];
    [calendarArray removeAllObjects];
    
    NSDateComponents *newComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute  fromDate:[NSDate date]];
    NSInteger currentDay = [newComponents day];
    NSInteger currentMonth = [newComponents month];
    NSInteger currentYear = [newComponents year];
    
    
    for (int i = 0; i < array.count; i++) {
        NSMutableDictionary *dictionary = [array objectAtIndex:i];
        NSString *strMultipleSession = dictionary[@"multiple_session_date"];
        
        NSMutableArray *aryMultipleSession = [NSMutableArray array];
        if (strMultipleSession.length > 0) {
            [strMultipleSession stringByReplacingOccurrencesOfString:@" " withString:@""];
            aryMultipleSession = [NSMutableArray arrayWithArray:[strMultipleSession componentsSeparatedByString:@","]];
        }
        int multipleSessionCount = (int)aryMultipleSession.count + 1;
        double time = 0;
        for (int j = 0; j < multipleSessionCount; j++) {
            NSMutableDictionary *userDic = [NSMutableDictionary dictionaryWithDictionary:dictionary];
            if (j == 0) {
                time = [self getCurrentDateInfoFromString:userDic[@"booking_date"] :userDic[@"start_time"]];
                
            } else {
                time = [self getCurrentDateInfoFromString:[aryMultipleSession objectAtIndex:j - 1] :userDic[@"multiple_session_start_time"]];
                userDic[@"booking_date"] = [aryMultipleSession objectAtIndex:j - 1];
                userDic[@"start_time"] = userDic[@"multiple_session_start_time"];
                userDic[@"end_time"] = userDic[@"multiple_session_end_time"];
            }
            
            BOOL isTrueDate = true;
            NSString *strDate = userDic[@"booking_date"];
            NSRange range = NSMakeRange(0, 4);
            NSInteger year = [strDate substringWithRange:range].integerValue;
            if (year < currentYear) {
                isTrueDate = false;
            } else if (year == currentYear) {
                range = NSMakeRange(5, 2);
                NSInteger month = [strDate substringWithRange:range].integerValue;
                if (month < currentMonth) {
                    isTrueDate = false;
                } else if (month == currentMonth) {
                    range = NSMakeRange(8, 2);
                    NSInteger date = [strDate substringWithRange:range].integerValue;
                    if (date < currentDay) {
                        isTrueDate = false;
                    }
                }
            }
            
            if (isTrueDate == true) {
                userDic[@"time"] = [NSString stringWithFormat:@"%f", time];
                
                BOOL isAdded = false;
                for (int k = 0; k < calendarArray.count; k++) {
                    NSDictionary *dic = [calendarArray objectAtIndex:k];
                    long beforeTime = ((NSString*)dic[@"time"]).integerValue;
                    if (beforeTime < time) {
                        continue;
                    } else {
                        [calendarArray insertObject:userDic atIndex:k];
                        isAdded = true;
                        break;
                    }
                }
                
                if (isAdded == false) {
                    [calendarArray addObject:userDic];
                }
            }
            
            if (i == array.count - 1 && j == multipleSessionCount - 1) {
                [tableView_SessionTableView reloadData];
            }
        }
    }
}

- (double)getCurrentDateInfoFromString:(NSString*)strDate :(NSString*)strTime {
    NSRange needleRange = NSMakeRange(0, 2);
    NSString *strHour = [strTime substringWithRange:needleRange];
    needleRange = NSMakeRange(3, 2);
    NSString* strMin = [strTime substringWithRange:needleRange];
    needleRange = NSMakeRange(6, 2);
    NSString *strTemp = [strTime substringWithRange:needleRange];
    if ([strHour isEqualToString:@"12"]) {
        if ([strTemp isEqualToString:@"PM"]) {
            strHour = @"0";
        } else {
            strHour = @"12";
        }
    } else if ([strTemp isEqualToString:@"PM"]) {
        strHour = [NSString stringWithFormat:@"%d", (int)strHour.integerValue + 12];
    }
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [formatter dateFromString:[NSString stringWithFormat:@"%@ %@:%@", strDate, strHour, strMin]];
    
    return [date timeIntervalSince1970];
}
#pragma mark -
#pragma mark - UITableView DataSource and delegate Method.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return calendarArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 215;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"cellIdentifier";
    
    TrainerCalendarCell *cell = (TrainerCalendarCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TrainerCalendarCell" owner:self options:nil];
        cell = (TrainerCalendarCell *)[nib objectAtIndex:0];
    }

    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    
    int row = (int)[indexPath row];
    NSDictionary *dictionary = [calendarArray objectAtIndex:row];
    Friend *aFriend = dictionary[@"user_info"];
    NSURL *imageURL = [NSURL URLWithString:aFriend.image];
    [cell.imvAvata setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"user_plus"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    cell.lblName.text = aFriend.name;

    
//    NSArray *aryMultipleSession = dictionary[@"star"];
//    int multipleSessionCount = (int)aryMultipleSession.count;
//    NSString *strMultipleSessionDate = @"";
//    for (int i = 0; i < multipleSessionCount; i++) {
//        if (i == 0) {
//            strMultipleSessionDate = [NSString stringWithFormat:@"%@, %@~%@", dictionary[@"booking_date"], dictionary[@"start_time"], dictionary[@"end_time"]];
//        } else {
////            strMultipleSessionDate = [NSString stringWithFormat:@"%@\U00002028%@", strMultipleSessionDate, [NSString stringWithFormat:@"%@, %@~%@", dictionary[@"booking_date"], dictionary[@"multiple_session_start_time"], dictionary[@"multiple_session_end_time"]]];
//            strMultipleSessionDate = [NSString stringWithFormat:@"%@, %@~%@", dictionary[@"booking_date"], dictionary[@"multiple_session_start_time"], dictionary[@"multiple_session_end_time"]];
//        }
//    }

//    [cell.lblSessions setNumberOfLines:multipleSessionCount];
    cell.lblSessions.text = [NSString stringWithFormat:@"%@, %@~%@", dictionary[@"booking_date"], dictionary[@"start_time"], dictionary[@"end_time"]];
//    float originHeight = cell.lblSessions.frame.size.height;
//    [cell.lblSessions sizeToFit];
//    float currentHeight = cell.lblSessions.frame.size.height;
//    cell.viewInfo.frame = CGRectMake(cell.viewInfo.frame.origin.x, cell.viewInfo.frame.origin.y + (multipleSessionCount - 1) * 10, cell.viewInfo.frame.size.width, cell.viewInfo.frame.size.height);
    
    
//    UILabel *lblSession = [viewSessions viewWithTag:1];
//    lblSession.text = [NSString stringWithFormat:@"%@, %@~%@", [APP_DELEGATE getCurrentDateInfoFromString:self.dictionary[@"booking_date"]], self.dictionary[@"start_time"], self.dictionary[@"end_time"]];
//    [lblSession setAdjustsFontSizeToFitWidth:YES];
//    NSArray *aryMultipleSession = self.dictionary[@"multiple_session_date"];
//    int multipleSessionCount = (int)aryMultipleSession.count;
//    for (int i = 0; i < multipleSessionCount; i++) {
//        UILabel *lblSession = [viewSessions viewWithTag:i + 2];
//        lblSession.text = [NSString stringWithFormat:@"%@, %@~%@", [APP_DELEGATE getCurrentDateInfoFromString:[aryMultipleSession objectAtIndex:i]], self.dictionary[@"multiple_session_start_time"], self.dictionary[@"multiple_session_end_time"]];
//        [lblSession setAdjustsFontSizeToFitWidth:YES];
//    }
//    for (int i = multipleSessionCount; i <= 8; i++) {
//        UILabel *lblSession = [viewSessions viewWithTag:i];
//        lblSession.text = @"";
//    }
    
    
    cell.lblBodyParts.text = dictionary[@"body_parts"];
    cell.lblWorkoutType.text = dictionary[@"workout_type"];
    cell.lblSkype.text = dictionary[@"skype_id"];
    int duration = (int)((NSString*)dictionary[@"duration"]).integerValue;
    if ([dictionary[@"training_hour_type"] isEqualToString:@"hour"]) {
        cell.lblSessionRate.text = [NSString stringWithFormat:@"%d hrs ~ %@", duration / 60, dictionary[@"rate"]];
    } else {
        cell.lblSessionRate.text = [NSString stringWithFormat:@"%d mins ~ %@", duration, dictionary[@"rate"]];
    }
    
//
//    
//    // userSelectedDate
//    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    // this is imporant - we set our input date format to match our input string
//    // if format doesn't match you'll get nil from your string, so be careful
//    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
//    
//    NSString *startDate = [dateFormatter stringFromDate:userSelectedDate];
//    
//    [cell.button_SelectedDate setTitle:startDate forState:UIControlStateNormal];
//    [cell.button_StartTime setTitle:getStartingTime forState:UIControlStateNormal];
//    
//    if (getTimeDuration.type == PersonalTrainingHourTypeHalf) {
//        
//        [cell.button_Duration setTitle:[NSString stringWithFormat:@"%ld min", (long)getTimeDuration.hour] forState:UIControlStateNormal];
//
//    } else {
//        
//        [cell.button_Duration setTitle:[NSString stringWithFormat:@"%ld hours", (long)getTimeDuration.hour] forState:UIControlStateNormal];
//
//    }
//    
//    
//    [cell.button_Rate setTitle:[NSString stringWithFormat:@"$ %.f", getTimeDuration.rate] forState:UIControlStateNormal];

    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    
    UIView *footerView = [UIView new];
    
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, tableView.frame.size.width - 15, 0.5)];
    subView.backgroundColor = [UIColor lightGrayColor];
    
    [footerView addSubview:subView];
    
    return footerView;
}


@end
