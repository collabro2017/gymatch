//
//  GymChatViewController.h
//  GYMatch
//
//  Created by Ram Gautam on 11/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GymChatViewController : UIViewController
<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    __weak IBOutlet UITableView *messageTableView;
    __weak IBOutlet UITextField *messageTextField;
    
    __weak IBOutlet UIView *messageView;
    
    __weak IBOutlet UIButton *instagramButton;

    __weak IBOutlet UIView *containView;

    __weak IBOutlet UIButton *gymChatBtn, *photoBtn;

    __weak NSTimer *timer;
    __weak GymChatViewController *weakSelf;

}

@property(nonatomic, assign)NSInteger userID;
-(void)enableGymChatAgain;
-(void)deleteMessageAtIndex:(NSIndexPath*)indexPath;



@end
