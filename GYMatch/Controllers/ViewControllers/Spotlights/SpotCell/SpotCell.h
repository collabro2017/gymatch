//
//  SpotCell.h
//  GYMatch
//
//  Created by Ram Gautam on 11/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Spotlight.h"
#import "ProfileImageView.h"

#define kSpotCell @"SpotCell"
#define kSpotCell_iPad @"SpotCell_iPad"

@interface SpotCell : UITableViewCell{
    BOOL isLiked;
    
    IBOutletCollection(UIImageView) NSArray *starImageViews;
    
}

@property (weak, nonatomic) IBOutlet ProfileImageView *picImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (weak, nonatomic) IBOutlet UIImageView *locationIconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *onlineImageView;

@property (weak, nonatomic) IBOutlet UILabel *pref1Label;
@property (weak, nonatomic) IBOutlet UILabel *pref2Label;
@property (weak, nonatomic) IBOutlet UILabel *pref3Label;

- (void)fillWithSpotlight:(Spotlight *)aFriend;

@end
