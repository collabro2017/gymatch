//
//  TeamMsgViewController.h
//  GYMatch
//
//  Created by User on 12/16/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBubbleTableView.h"
#import "MessagesViewController.h"

@interface TeamMsgViewController : UIViewController
<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate,
UIBubbleTableViewDataSource, MessagesViewControllerDelegate>
{
    int groupID;
    __weak IBOutlet UIBubbleTableView *messageTableView;
    __weak IBOutlet UITextField *messageTextField;
    
    __weak IBOutlet UIView *messageView;
    
    __weak IBOutlet NSLayoutConstraint *textboxBottom;
    
    __weak IBOutlet NSLayoutConstraint *tableTop;
    
    __weak IBOutlet UILabel *noMessagesLabel;
    __weak IBOutlet UIScrollView *scrollView;
}

@property(nonatomic, retain)NSMutableArray *userArray;
@property(nonatomic) bool is_single;
- (id)initWithGroup:(int)group_id;

@end

