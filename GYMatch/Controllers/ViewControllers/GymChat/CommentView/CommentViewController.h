//
//  CommentViewController.h
//  GYMatch
//
//  Created by Ram on 09/05/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GymChat.h"

@interface CommentViewController : UIViewController<UITextFieldDelegate>{
    __weak IBOutlet UITextField *messageTextField;
    __weak IBOutlet UITableView *messageTableView;
    __weak NSTimer *timer;
    __weak CommentViewController *weakSelf;
}

@property (nonatomic, retain)GymChat *gymChat;
@property (nonatomic, weak)UITableViewCell *gymChatCell;

@end
