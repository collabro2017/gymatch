//
//  CommentCell.m
//  GYMatch
//
//  Created by Ram on 09/05/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "CommentCell.h"
#import "UIImageView+WebCache.h"
#import "Utility.h"
#import "MBProgressHUD.h"
#import "UserDataController.h"
#import "FriendDetailsViewController.h"

@implementation CommentCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)fillWithComment:(Comment *)aMessage{
    UITapGestureRecognizer *singleTapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserProfile)];
    singleTapImage.numberOfTapsRequired = 1;
    [userImageView setUserInteractionEnabled:YES];
    [userImageView addGestureRecognizer:singleTapImage];
    
    UITapGestureRecognizer *singleTapName = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserProfile)];
    singleTapName.numberOfTapsRequired = 1;
    [userNameLabel setUserInteractionEnabled:YES];
    [userNameLabel addGestureRecognizer:singleTapName];
    
    userComment = aMessage;
    messageLabel.text = aMessage.content;
    
    NSURL *imageURL = [NSURL URLWithString:[aMessage.userImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [userImageView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"user_plus"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    timeLabel.text = [Utility friendlyStringFromDate:aMessage.date];
    userNameLabel.text = (aMessage.name == nil || [aMessage.name isEqualToString:@""]) ? aMessage.username : aMessage.name;
    
    //[messageLabel sizeToFit];
    
    self.tag = aMessage.ID;
    
}

- (void)showUserProfile {
    AppDelegate *appdelgate = (AppDelegate*)[[UIApplication sharedApplication]delegate ];
    [MBProgressHUD showHUDAddedTo:appdelgate.window animated:YES];
    UserDataController *userDC = [UserDataController new];
    NSLog(@"%ld",userComment.userID);
    [userDC profileDetails:userComment.userID withSuccess:^(Friend *aFriend)
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
