//
//  SingleChatViewController.h
//  GYMatch
//
//  Created by User on 12/26/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kInnerCircleCell @"InnerCircleCell"

@interface SingleChatViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate> {
    __weak IBOutlet UICollectionView *albumCollectionView;
    __weak IBOutlet UITextField *messageTextField;
    __weak IBOutlet UIToolbar *toolBar;
    NSInteger curveKB;
}


@property (weak, nonatomic) IBOutlet UIView *messageView;

@end
