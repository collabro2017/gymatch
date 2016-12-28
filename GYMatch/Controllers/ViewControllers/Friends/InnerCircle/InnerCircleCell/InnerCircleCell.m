//
//  InnerCircleCell.m
//  GYMatch
//
//  Created by Ram Gautam on 11/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "InnerCircleCell.h"
#import "UIImageView+WebCache.h"
#import "Utility.h"

@implementation InnerCircleCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (void)fillWithPhoto:(Friend *)aFriend{
    
    self.nameLabel.text = aFriend.username;
    
    // Gourav june 25 start
    if (aFriend.ID == GYMATCH_UNIVERSAL_ID) // Gourav june 25
    {
        self.nameLabel.text = @"GYMatch";
    }
    // Gourav june 25 end
    
    self.avatarView.image = [UIImage imageNamed:[NSString stringWithFormat:@"avail-%lD", aFriend.isOnline]];
    
    NSURL *imageURL = [NSURL URLWithString:[aFriend.image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [self.imageView setImageWithURL:imageURL placeholderImage:[Utility placeHolderImage] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    self.imageView.layer.cornerRadius = self.imageView.frame.size.width / 2.0f;
    self.imageView.layer.borderWidth = 4.0f;
    self.imageView.layer.borderColor = [[UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:0.7] CGColor];
    self.imageView.layer.masksToBounds = YES;
}

@end
