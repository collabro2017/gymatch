//
//  TeamCell.h
//  GYMatch
//
//  Created by Ram on 08/05/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Team.h"

#define kTeamCell @"TeamCell"

@interface TeamCell : UITableViewCell{
    
    //__weak IBOutlet UIImageView *userImageView;
    __weak IBOutlet UILabel *userNameLabel;
    __weak IBOutlet UILabel *genderLabel;
    __weak IBOutlet UILabel *locationLabel;
    __weak IBOutlet UILabel *positionLabel;
}

@property (nonatomic, weak) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;


- (void)fillWithTeam:(Team *)member;

@end
