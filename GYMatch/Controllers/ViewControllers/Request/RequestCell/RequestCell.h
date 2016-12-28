//
//  RequestCell.h
//  GYMatch
//
//  Created by Ram Gautam on 10/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "RequestsViewController.h"

#define kRequestCell @"RequestCell"
#define kRequestCell_iPad @"RequestCell_iPad"

@class Friend;
@class RequestsViewController;

@interface RequestCell : UITableViewCell<UIAlertViewDelegate>{
    
    __weak IBOutlet UILabel *genderLabel;
}

@property(nonatomic, weak) IBOutlet UIImageView *userImageView;
@property(nonatomic, weak) IBOutlet UILabel *userNameLabel;

@property(nonatomic, weak) IBOutlet UIImageView *userLocationImageView;
@property(nonatomic, weak) IBOutlet UILabel *locationLabel;

@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UIButton *declineButton;
@property (weak, nonatomic) IBOutlet UIButton *unblockButton;
@property (nonatomic, retain) NSDictionary *dictionary;
@property (nonatomic, retain) RequestsViewController *delegate;

@property(weak, nonatomic)RequestsViewController *viewController;

- (id)initWithFriend:(Friend *)aFriend;

- (void)fillWithFriend:(Friend *)aFriend;

- (void)fillWithFBFriend:(NSDictionary<FBGraphUser> *)aFriend;

@end
