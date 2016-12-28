//
//  DayCell.h
//  GYMatch
//
//  Created by Ram on 29/04/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDayCell @"DayCell"
#define kDayCell_iPad @"DayCell_iPad"

@interface DayCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *toTimeLabel;

@end
