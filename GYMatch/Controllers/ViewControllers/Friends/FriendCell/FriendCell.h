//
//  FriendCell.h
//  GYMatch
//
//  Created by Ram Gautam on 10/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

#define kFriendCell @"FriendCell"
#define kFriendCelliPad @"FriendCell_iPad"

@class Friend;

@interface FriendCell : UITableViewCell{
    
}

@property(nonatomic, weak) IBOutlet UIImageView *userImageView;
@property(nonatomic, weak) IBOutlet UIImageView *locationImageView;
@property(nonatomic, weak) IBOutlet UILabel *userNameLabel;
@property(nonatomic, weak) IBOutlet UILabel *genderLabel;
@property(nonatomic, weak) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *onlineImageView;

@property (weak, nonatomic) IBOutlet UILabel *pref1Label;
@property (weak, nonatomic) IBOutlet UILabel *pref2Label;
@property (weak, nonatomic) IBOutlet UILabel *pref3Label;

- (id)initWithFriend:(Friend *)aFriend;

- (void)fillWithFriend:(Friend *)aFriend;

- (void)fillWithFBFriend:(NSDictionary<FBGraphUser> *)aFriend;

@end
