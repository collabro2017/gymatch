//
//  ChatViewController.h
//  GYMatch
//
//  Created by Ram Gautam on 11/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBubbleTableView.h"
#import "MessagesViewController.h"
#import "EnlargeViewController.h"

@interface ChatViewController : UIViewController
<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate,
UIBubbleTableViewDataSource, MessagesViewControllerDelegate>
{
    
    __weak IBOutlet UIBubbleTableView *messageTableView;
    __weak IBOutlet UITextField *messageTextField;
    __weak IBOutlet UIView *messageTFView;

    __weak IBOutlet UIView *messageView;
    
    __weak IBOutlet NSLayoutConstraint *textboxBottom;
    __weak IBOutlet UIBarButtonItem *textBarBtn; 

 //   __weak IBOutlet NSLayoutConstraint *tableTop;
    
    __weak IBOutlet UILabel *noMessagesLabel;
    BOOL isSendingInProcess;
}

@property(nonatomic, retain)Friend *user;
@property (nonatomic,retain)EnlargeViewController *vc;

@property(nonatomic) bool is_single;



@end
