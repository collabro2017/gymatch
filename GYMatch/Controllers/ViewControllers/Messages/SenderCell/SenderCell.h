//
//  SenderCell.h
//  GYMatch
//
//  Created by Ram on 01/04/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSenderCell @"SenderCell"

@interface SenderCell : UITableViewCell {
    
    __weak IBOutlet UIImageView *userImageView;
    __weak IBOutlet UILabel *usernameLabel;
    __weak IBOutlet UILabel *messageCountLabel;
    __weak IBOutlet UILabel *lastMessageLabel;
    __weak IBOutlet UILabel *timeLabel;
    __weak IBOutlet UIImageView *onlineImageView;
    __weak IBOutlet UIImageView *timeImageView;
    __weak IBOutlet UIImageView *borderImageView;
    __weak IBOutlet UIImageView *countImageView;
    
}
@property (assign) NSInteger senderIndex ;
-(void)addLineView;
- (void)fillWithFriend:(Friend *)aFriend;
-(void)resetCountLabel; 

@end
