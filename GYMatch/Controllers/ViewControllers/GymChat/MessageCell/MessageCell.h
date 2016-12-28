//
//  MessageCell.h
//  GYMatch
//
//  Created by Ram Gautam on 11/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GymChat.h"
#import "GymChatViewController.h"
#import "EnlargeViewController.h"

#define kMessageCell @"MessageCell"
#define kMessageCell_iPad @"MessageCell_iPad"

@interface MessageCell : UITableViewCell
<UIActionSheetDelegate, UIGestureRecognizerDelegate>
{
    __weak IBOutlet UIImageView *userImageView;
    __weak IBOutlet UIImageView *userBorderImageView;
    __weak IBOutlet UILabel *messageLabel;
    __weak IBOutlet UILabel *userNameLabel;
    
    __weak IBOutlet UILabel *level;
    __weak IBOutlet UILabel *commentLabel;
    __weak IBOutlet UILabel *likeLabel;
    __weak IBOutlet UILabel *addressLabel;
    __weak IBOutlet UILabel *timeLabel;
    __weak IBOutlet UILabel *gshareLabel;
    __weak IBOutlet UIImageView *myMessageImageView;
    
    __weak IBOutlet UIImageView *messageImageView;
    
    __weak IBOutlet UIView *whiteView;
    __weak IBOutlet UIView *moreView;

    __weak IBOutlet UIButton *enlargeBtn;
    
    __weak IBOutlet UIButton *likeButton;
    
    __weak IBOutlet UIButton *reportButton;
    __weak IBOutlet UIButton *chatInvisibleButton;
    __weak IBOutlet UIButton *deleteButton;
    GymChat *message;
}
@property (nonatomic, strong) EnlargeViewController *pictureView;
@property (nonatomic, strong) GymChatViewController *viewController;
@property(nonatomic, retain) NSIndexPath *myIndex;
@property (nonatomic,retain)EnlargeViewController *vc;

- (id)initWithMessage:(GymChat *)aMessage;

- (void)fillWithMessage:(GymChat *)aMessage;

- (CGFloat)height;

@end
