//
//  TeamChatViewController.h
//  GYMatch
//
//  Created by User on 12/16/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileImageView.h"

#define kInnerCircleCell @"InnerCircleCell"

@interface TeamChatViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate> {
    __weak IBOutlet UICollectionView *albumCollectionView;
    __weak IBOutlet UITextField *messageTextField;
    __weak IBOutlet UIToolbar *toolBar;
}

@property (weak, nonatomic) IBOutlet UIView *messageView;

@end