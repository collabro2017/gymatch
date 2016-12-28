//
//  UserLikesCell.m
//  GYMatch
//
//  Created by Dev on 11/12/15.
//  Copyright © 2015 xtreem. All rights reserved.
//

#import "UserLikesCell.h"
#import "UIImageView+WebCache.h"
#import "Utility.h"
#import "MBProgressHUD.h"
#import "UserDataController.h"
#import "FriendDetailsViewController.h"

@implementation UserLikesCell
@synthesize userImageView, userNameLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillWithLikes:(Likes *)aLike {
    UITapGestureRecognizer *singleTapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserProfile)];
    singleTapImage.numberOfTapsRequired = 1;
    [self setUserInteractionEnabled:YES];
    [self addGestureRecognizer:singleTapImage];
    
    userLikes = aLike;
    
    NSURL *imageURL = [NSURL URLWithString:[aLike.userImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [userImageView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"user_plus"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    userNameLabel.text = (aLike.name == nil || [aLike.name isEqualToString:@""]) ? aLike.username : aLike.name;
    
    self.tag = aLike.ID;
    
}

- (void)showUserProfile {
    AppDelegate *appdelgate = (AppDelegate*)[[UIApplication sharedApplication]delegate ];
    [MBProgressHUD showHUDAddedTo:appdelgate.window animated:YES];
    UserDataController *userDC = [UserDataController new];
    NSLog(@"%ld",userLikes.userID);
    [userDC profileDetails:userLikes.userID withSuccess:^(Friend *aFriend)
     {
         [MBProgressHUD hideAllHUDsForView:appdelgate.window animated:YES];
         FriendDetailsViewController *fdvc = [[FriendDetailsViewController alloc]init];
         [fdvc setAFriend:aFriend];
         
         [(UINavigationController *)[[APP_DELEGATE tabBarController] selectedViewController] pushViewController:fdvc animated:YES];
         
         [[[APP_DELEGATE tabBarController] tabBar] setHidden:YES];
     }
                   failure:^(NSError *error) {
                       [MBProgressHUD hideAllHUDsForView:appdelgate.window animated:YES];
                       UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                       [alertView show];
                   }];
}

@end
