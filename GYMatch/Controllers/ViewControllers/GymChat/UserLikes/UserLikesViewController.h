//
//  UserLikesViewController.h
//  GYMatch
//
//  Created by Dev on 11/12/15.
//  Copyright © 2015 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GymChat.h"

#define kUserLikesCell @"UserLikesCell"

@interface UserLikesViewController : UITableViewController

@property (nonatomic, retain)GymChat *gymChat;

@end
