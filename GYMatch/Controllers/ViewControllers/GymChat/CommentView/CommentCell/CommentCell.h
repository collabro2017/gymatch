//
//  CommentCell.h
//  GYMatch
//
//  Created by Ram on 09/05/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"

#define kCommentCell @"CommentCell"

@interface CommentCell : UITableViewCell
{
    __weak IBOutlet UIImageView *userImageView;
    __weak IBOutlet UILabel *messageLabel;
    __weak IBOutlet UILabel *userNameLabel;
    
    __weak IBOutlet UILabel *likeLabel;
    __weak IBOutlet UILabel *timeLabel;
    
    __weak IBOutlet UIView *whiteView;
    Comment *userComment;
}

- (void)fillWithComment:(Comment *)aComment;

@end
