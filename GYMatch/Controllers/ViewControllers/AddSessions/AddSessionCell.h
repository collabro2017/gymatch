//
//  AddSessionCell.h
//  GYMatch
//
//  Created by bluesky on 03/07/16.
//  Copyright © 2016 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddSessionCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblStartTime;
@property (strong, nonatomic) IBOutlet UILabel *lblDuration;
@property (strong, nonatomic) IBOutlet UILabel *lblRate;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;

@property (weak, nonatomic) IBOutlet UIButton *bttPay;

@end
