//
//  SenderCell.m
//  GYMatch
//
//  Created by Ram on 01/04/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "SenderCell.h"
#import "UIImageView+WebCache.h"
#import "Utility.h"

@implementation SenderCell
@synthesize senderIndex ;

- (void)awakeFromNib
{
    // Initialization code
    
    
    CGFloat multiple = 1;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        multiple = 1.1;
    }
    
    
     usernameLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:16.0f*multiple];
     lastMessageLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:14.0f*multiple];
//    lastMessageLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:16.0f];
//    lastMessageLabel.font = [UIFont fontWithName:@"ProximaNova-Light" size:16.0f];
//    messageCountLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:13.0f];
}

-(void)addLineView {
    
        CGRect lineFrame ;

          switch (self.senderIndex) {
              case 0:
                  //lineFrame = CGRectMake(userImageView.center.x, self.frame.size.height-userImageView.frame.origin.y-2, 1, self.frame.size.height+2);
                  
                  lineFrame = CGRectMake(userImageView.center.x, self.frame.size.height-userImageView.frame.origin.y-2, 1, self.frame.size.height-(self.frame.size.height-userImageView.frame.origin.y-2));  // Gourav June 10

                break;
                
            case -1:
                lineFrame = CGRectMake(userImageView.center.x, -1, 1, userImageView.frame.origin.y+2);
                break;
                
            default:
                lineFrame = CGRectMake(userImageView.center.x, -1, 1, self.frame.size.height+2);
                break;
        }
        
        UIView *lineView = [[UIView alloc]initWithFrame:lineFrame];
        [lineView setBackgroundColor:[UIColor colorWithRed:208.0/255.0 green:208.0/255.0 blue:208.0/255.0 alpha:255.0/255.0]];
        [self addSubview:lineView];
        [self sendSubviewToBack:lineView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)resetCountLabel
{
    [countImageView setHidden:YES];
    [messageCountLabel setHidden:YES];
    messageCountLabel.text = @"0";
}


- (void)fillWithFriend:(Friend *)aFriend{
    
    self.tag = aFriend.ID;

    usernameLabel.text = (![aFriend.name isEqualToString:@""]) ? aFriend.name : aFriend.username;
    if (aFriend.unreadSentMessageCount == 0) {
       messageCountLabel.hidden = YES;
        countImageView.hidden = YES;
    }
    else{
        messageCountLabel.hidden = NO;
        countImageView.hidden = NO;
    }
    NSLog(@"sender count is : %ld" , (long)aFriend.unreadSentMessageCount );
    messageCountLabel.text = [NSString stringWithFormat:@"%ld", (long)aFriend.unreadSentMessageCount];
    timeLabel.text = [Utility friendlyStringFromDate:aFriend.lastMessage.date];
    if (timeLabel.text.length == 0) timeImageView.hidden = YES;
    
    if (aFriend.unreadSentMessageCount > 0) {
        if (aFriend.lastMessage.type == MessageTypeText) {
            lastMessageLabel.text = aFriend.lastMessage.content;
        }
        else {
            lastMessageLabel.text = @"[Image]";
        }
    }
    else {
        lastMessageLabel.text = aFriend.lastMessage.content;
    }
    
    onlineImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"avail-%lD", (long)aFriend.isOnline]];
    
    NSURL *imageURL = [NSURL URLWithString:[aFriend.image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [userImageView setImageWithURL:imageURL placeholderImage:[Utility placeHolderImage] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

//    userImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
//    userImageView.layer.borderWidth = 2.5f;
//    userImageView.layer.cornerRadius = userImageView.frame.size.width / 2.0f;
//    userImageView.layer.masksToBounds = YES;
//    
//    borderImageView.layer.borderColor = [[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.00f] CGColor];
//    borderImageView.layer.borderWidth = 1.f;
//    borderImageView.layer.cornerRadius = borderImageView.frame.size.width / 2;
//    borderImageView.layer.masksToBounds = YES;
    
}

@end
