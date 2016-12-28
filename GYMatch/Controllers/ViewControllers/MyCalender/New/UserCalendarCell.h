//
//  UserCalendarCell.h
//  GYMatch
//
//  Created by osvinuser on 5/30/16.
//  Copyright © 2016 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserCalendarCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *button_SelectedDate;

@property (strong, nonatomic) IBOutlet UIButton *button_StartTime;

@property (strong, nonatomic) IBOutlet UIButton *button_Duration;

@property (strong, nonatomic) IBOutlet UIButton *button_Rate;

@end
