//
//  TeamCell.m
//  GYMatch
//
//  Created by Ram on 08/05/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "TeamCell.h"
#import "UIImageView+WebCache.h"
#import "Utility.h"

@implementation TeamCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillWithTeam:(Team *)member{
    
    userNameLabel.text = member.name;
    NSURL *imageURL = [NSURL URLWithString:[member.image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [_profileImageView setImageWithURL:imageURL placeholderImage:[Utility placeHolderImage] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    positionLabel.text = member.designation;
}

@end
