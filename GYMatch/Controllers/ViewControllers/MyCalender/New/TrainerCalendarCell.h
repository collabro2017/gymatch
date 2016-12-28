//
//  TrainerCalendarCell.h
//  GYMatch
//
//  Created by osvinuser on 5/30/16.
//  Copyright © 2016 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ProfileImageView.h"

@interface TrainerCalendarCell : UITableViewCell

@property (weak, nonatomic) IBOutlet ProfileImageView *imvAvata;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIView *viewSessions;
@property (weak, nonatomic) IBOutlet UILabel *lblSessions;
@property (weak, nonatomic) IBOutlet UIView *viewInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblBodyParts;
@property (weak, nonatomic) IBOutlet UILabel *lblWorkoutType;
@property (weak, nonatomic) IBOutlet UILabel *lblSkype;
@property (weak, nonatomic) IBOutlet UILabel *lblSessionRate;

@end
