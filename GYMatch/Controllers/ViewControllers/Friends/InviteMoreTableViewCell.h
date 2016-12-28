//
//  TableViewCell.h
//  GYMatch
//
//  Created by iPHTech2 on 16/10/15.
//  Copyright (c) 2015 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

#define kInviteMoreFriendCell @"FBInviteMoreFriendCell"

@interface InviteMoreTableViewCell : UITableViewCell<FBSDKAppInviteDialogDelegate>


-(IBAction)inviteMoreFriends:(id)sender;

@end
