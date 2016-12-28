//
//  FBFriendCell.h
//  GYMatch
//
//  Created by Ram Gautam on 10/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

#define kFBFriendCell @"FBFriendCell"


@class Friend;

@interface FBFriendCell : UITableViewCell{
    NSDictionary<FBGraphUser> *fbFriend;
}

@property(nonatomic, weak) IBOutlet UIImageView *userImageView;
@property(nonatomic, weak) IBOutlet UILabel *userNameLabel;
@property(nonatomic, weak) IBOutlet UILabel *genderLabel;

- (id)initWithFriend:(Friend *)aFriend;

- (void)fillWithFriend:(Friend *)aFriend;

- (void)fillWithFBFriend:(NSDictionary<FBGraphUser> *)aFriend;

- (void)adjustWidth:(UILabel *)label;

@end
