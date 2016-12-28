//
//  SessionCell.h
//  GYMatch
//
//  Created by Ram on 29/04/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSessionCell @"SessionCell"
#define kSessionCelliPad @"SessionCell_iPad"

@interface SessionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
