//
//  MessageCell.m
//  GYMatch
//
//  Created by Ram Gautam on 11/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "MessageCell.h"
#import "UIImageView+WebCache.h"
#import "Utility.h"
#import "MessageDataController.h"
#import "CommentViewController.h"
#import "MBProgressHUD.h"
#import "ReportViewController.h"
#import "UserDataController.h"
#import "UserLikesViewController.h"
#import "FriendDetailsViewController.h"


@implementation MessageCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    [moreView setHidden: YES];
    // Configure the view for the selected state
}

- (void)awakeFromNib{
    //    whiteView.layer.cornerRadius = 2.0f;
    //    [(UIView *)whiteView.subviews[0] layer].cornerRadius = 2.0f;
    
}

- (id)initWithMessage:(GymChat *)aMessage{
    self = [super init];
    if (self) {
        [self fillWithMessage:aMessage];
    }
    return self;
}

- (void)fillWithMessage:(GymChat *)aMessage{


    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatorSingleTapped)];
    singleTap.numberOfTapsRequired = 1;
    [messageImageView setUserInteractionEnabled:YES];
    [messageImageView addGestureRecognizer:singleTap];

    UITapGestureRecognizer *singleTapLike = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showLikedUsers:)];
    singleTapLike.numberOfTapsRequired = 1;
    [likeLabel setUserInteractionEnabled:YES];
    [likeLabel addGestureRecognizer:singleTapLike];
    
    UITapGestureRecognizer *singleTapComment = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentButtonPressed:)];
    singleTapComment.numberOfTapsRequired = 1;
    [commentLabel setUserInteractionEnabled:YES];
    [commentLabel addGestureRecognizer:singleTapComment];
    
    if (userImageView) {
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatorSingleTapped2)];
        singleTap.numberOfTapsRequired = 1;
        [userImageView setUserInteractionEnabled:YES];
        [userImageView addGestureRecognizer:singleTap];
    }

    message = aMessage;
    // Set text / message.

    CGFloat fontSize = 15.0f;
    CGFloat timeFont = 10.0f;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        fontSize = 20.0f;
        timeFont = 15.0f;
    }
    messageLabel.text = aMessage.text;
    messageLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:fontSize];

    if (aMessage.type == MessageTypeText) {
        [messageLabel setHidden:NO];
        [messageImageView setHidden:YES];
    }
    else if (aMessage.type == MessageTypeImage)
    {
        [messageImageView setHidden:NO];
        [messageImageView sd_setImageWithURL:[NSURL URLWithString:aMessage.image]];
    }
    
    NSString *likeString;
    
    if (aMessage.isLike) {
        likeString = @"Unlike";
        [likeButton setImage:[UIImage imageNamed:@"unlikebtn"] forState:UIControlStateNormal];
    }
    else {
        likeString = @"Like";
        [likeButton setImage:[UIImage imageNamed:@"likebtn"] forState:UIControlStateNormal];
    }
    [likeButton setTitle:likeString forState:UIControlStateNormal];
    userNameLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:18.0f];
    addressLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:12.0f];
    timeLabel.font = [UIFont fontWithName:@"ProximaNova-Light" size:timeFont];
    
    NSURL *imageURL = [NSURL URLWithString:[aMessage.userImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [userImageView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"user_plus"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    timeLabel.text = [Utility friendlyStringFromDate:aMessage.date];
   // timeLabel.textColor = [UIColor whiteColor];

    NSString *likeStr = @"Like";
    NSString *commentStr = @"Comment";

    if (aMessage.totalLikes > 1) {

        likeStr = @"Likes";
    }

    if (aMessage.totalComments > 1) {

        commentStr = @"Comments";
    }

    //NSString *msg = [NSString stringWithFormat:@"%ld %@ . %ld %@", (long)aMessage.totalLikes,likeStr, (long)aMessage.totalComments,commentStr];
    
    likeLabel.text =  [NSString stringWithFormat:@"%ld %@ .", (long)aMessage.totalLikes,likeStr];
    commentLabel.text = [NSString stringWithFormat:@"%ld %@", (long)aMessage.totalComments,commentStr];
    //[NSString stringWithFormat:@"%ld", (long)aMessage.totalLikes];
    //commentLabel.text = [NSString stringWithFormat:@"%ld", (long)aMessage.totalComments];
    
    userNameLabel.text = (aMessage.name == nil || [aMessage.name isEqualToString:@""]) ? aMessage.username : aMessage.name;
    //    userNameLabel.font = [UIFont fontWithName:@"ProximaNova-Light" size:19.0f];
    
    userNameLabel  .font = [UIFont fontWithName:@"ProximaNova-Semibold" size:18.0f];
    
    self.tag = aMessage.ID;
    
    userImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    userImageView.layer.borderWidth = 2.5f;
    userImageView.layer.cornerRadius = userImageView.frame.size.width / 2;
    userImageView.layer.masksToBounds = YES;
    userBorderImageView.layer.borderColor = [[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.00f] CGColor];
    userBorderImageView.layer.borderWidth = 1.f;
    userBorderImageView.layer.cornerRadius = userBorderImageView.frame.size.width / 2;
    userBorderImageView.layer.masksToBounds = YES;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        moreView.layer.borderWidth = 0.5f;
        moreView.layer.borderColor = [[UIColor colorWithRed:0.85f green:0.85f blue:0.85f alpha:1.0f] CGColor];
        
        CGFloat cellSize = 35.0f;
        CGRect moreViewFrame = moreView.frame;
        
        if(message.userID == [APP_DELEGATE loggedInUser].ID)
        {
            [reportButton setHidden:YES];
            [deleteButton setHidden:NO];
            CGRect deleteFrame = deleteButton.frame;
            deleteFrame.origin.y = 0;
            deleteButton.frame = deleteFrame;
            moreViewFrame.size.height = 2*cellSize;
        }
        else
        {
            [reportButton setHidden:NO];
            [deleteButton setHidden:YES];
            moreViewFrame.size.height = 2*cellSize;
        }
        
        CGRect chatInvisibleFrame = chatInvisibleButton.frame;
        chatInvisibleFrame.origin.y = 36;
        chatInvisibleButton.frame = chatInvisibleFrame;
        moreView.frame = moreViewFrame;
    }
}


- (CGFloat)height {
    return myMessageImageView.frame.size.height + 10.0f;
}

- (void)deleteGymChat{
    
    MessageDataController *mDC = [MessageDataController new];
    
    __weak UIView *view = [[(UINavigationController *)[[APP_DELEGATE tabBarController] selectedViewController] topViewController] view];
    
    [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    [mDC deleteGymChat:self.tag withSuccess:^{
        [MBProgressHUD hideAllHUDsForView:view animated:YES];
        [[(UINavigationController *)[[APP_DELEGATE tabBarController] selectedViewController] topViewController] performSelectorOnMainThread:@selector(loadData) withObject:nil waitUntilDone:YES];
    } failure:^(NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
        [MBProgressHUD hideAllHUDsForView:view animated:YES];
    }];
}

- (void)deleteGymChat2{

    MessageDataController *mDC = [MessageDataController new];

    __weak UIView *view = [[(UINavigationController *)[[APP_DELEGATE tabBarController] selectedViewController] topViewController] view];

    [MBProgressHUD showHUDAddedTo:view animated:YES];

    [mDC deleteGymChat:self.tag withSuccess:^{
        [MBProgressHUD hideAllHUDsForView:view animated:YES];
        [[(UINavigationController *)[[APP_DELEGATE tabBarController] selectedViewController] topViewController] performSelectorOnMainThread:@selector(loadData) withObject:nil waitUntilDone:YES];
    } failure:^(NSError *error) {

        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];

        [MBProgressHUD hideAllHUDsForView:view animated:YES];
    }];
}


#pragma mark - IBActions

- (IBAction)likeButtonPressed:(UIButton *)sender {
    [moreView setHidden: YES];
    __weak UIView *view = [[(UINavigationController *)[[APP_DELEGATE tabBarController] selectedViewController] topViewController] view];
    MessageDataController *mDC = [MessageDataController new];
    [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    [mDC likeGymChat:self.tag like:!message.isLike withSuccess:^{
        [MBProgressHUD hideAllHUDsForView:view animated:YES];
        
        if (!message.isLike) {
            [likeButton setTitle:@"Unlike" forState:UIControlStateNormal];
            [likeButton setImage:[UIImage imageNamed:@"unlikebtn"] forState:UIControlStateNormal];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Thank you for the Like!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
        else
            [likeButton setTitle:@"Like" forState:UIControlStateNormal];
        [likeButton setImage:[UIImage imageNamed:@"likebtn"] forState:UIControlStateNormal];
        
        [[(UINavigationController *)[[APP_DELEGATE tabBarController] selectedViewController] topViewController] performSelectorOnMainThread:@selector(loadData) withObject:nil waitUntilDone:YES];
    } failure:^(NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
        [MBProgressHUD hideAllHUDsForView:view animated:YES];
    }];
    
}

- (IBAction)gshareButtonPressed:(UIButton *)sender {
    [moreView setHidden: YES];
    __weak UIView *view = [[(UINavigationController *)[[APP_DELEGATE tabBarController] selectedViewController] topViewController] view];
    MessageDataController *mDC = [MessageDataController new];
    [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    [mDC likeGymChat:self.tag like:!message.isLike withSuccess:^{
        [MBProgressHUD hideAllHUDsForView:view animated:YES];
        
        if (!message.isLike) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Thank you for the G-Share!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
        gshareLabel.text = [NSString stringWithFormat:@"%d", gshareLabel.text.intValue+1];
    } failure:^(NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
        [MBProgressHUD hideAllHUDsForView:view animated:YES];
    }];
    
}

- (void)gshareAdd {
    gshareLabel.text = [NSString stringWithFormat:@"%d", gshareLabel.text.intValue+1];
}


- (IBAction)commentButtonPressed:(UIButton *)sender {
    [moreView setHidden: YES];
    GymChat *gymChat = [[GymChat alloc] init];
    gymChat.ID = self.tag;
    CommentViewController *cVC = [CommentViewController new];
    cVC.gymChat = gymChat;
    //    cVC.gymChatCell = self;
    [(UINavigationController *)[[APP_DELEGATE tabBarController] selectedViewController] pushViewController:cVC animated:YES];
}


- (void)showLikedUsers:(id)sender {
    [moreView setHidden: YES];
    GymChat *gymChat = [[GymChat alloc] init];
    gymChat.ID = self.tag;
    UserLikesViewController *cVC = [UserLikesViewController new];
    cVC.gymChat = gymChat;
    //    cVC.gymChatCell = self;
    [(UINavigationController *)[[APP_DELEGATE tabBarController] selectedViewController] pushViewController:cVC animated:YES];
}

- (IBAction)moreButtonPressed:(UIButton *)sender {
    
  //  NSString *title;
    
    moreView.layer.borderWidth = 0.5f;
    moreView.layer.borderColor = [[UIColor colorWithRed:0.85f green:0.85f blue:0.85f alpha:1.0f] CGColor];

    CGFloat cellSize = 35.0f;
    CGRect moreViewFrame = moreView.frame;

    if(message.userID == [APP_DELEGATE loggedInUser].ID)
    {
        [reportButton setHidden:YES];
        [deleteButton setHidden:NO];
        CGRect deleteFrame = deleteButton.frame;
        deleteFrame.origin.y = 0;
        deleteButton.frame = deleteFrame;
        moreViewFrame.size.height = 2*cellSize;
    }
    else
    {
        [reportButton setHidden:NO];
        [deleteButton setHidden:YES];
        moreViewFrame.size.height = 2*cellSize;
    }

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        CGRect chatInvisibleFrame = chatInvisibleButton.frame;
        chatInvisibleFrame.origin.y = 36;
        chatInvisibleButton.frame = chatInvisibleFrame;
    }
    
    moreView.frame = moreViewFrame;


    if (moreView.hidden) {
        [moreView setHidden:NO];
    } else {
        [moreView setHidden:YES];
    }
    //    if ([userNameLabel.text isEqualToString:[[APP_DELEGATE loggedInUser] username]] || [userNameLabel.text isEqualToString:[[APP_DELEGATE loggedInUser] firstName]]) {
    //        title = @"Delete";
    //    }else{
    //        title = @"Report";
    //    }
    //
    //    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:title, nil];
    //
    //    [actionSheet showFromRect:sender.frame inView:self animated:YES];
    
}

- (IBAction)onUnmatch:(id)sender
{
    [moreView setHidden: YES];

    if(message.userID == [APP_DELEGATE loggedInUser].ID)
    {

        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Are you sure you want to Delete the post?"] delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        alertView.tag = 20;
        [alertView show];

    }
    else
    {

        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"You can delete your own posts."] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];

    }


}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if(buttonIndex == 0) {
        if(alertView.tag == 1512)
        {
            NSLog(@"%@",_myIndex);
            [_viewController deleteMessageAtIndex:_myIndex];
        }

    }

    else if(buttonIndex == 1) {
        switch (alertView.tag)
        {
            case 10:
            {
                NSLog(@"message id = %ld",(long)message.ID);

                UserDataController *uDC = [UserDataController new];
                [uDC respond:message.ID withResponse:@"block" withSuccess:^{
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"User %@ blocked.", userNameLabel.text] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alertView show];
                } failure:^(NSError *error) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alertView show];
                }];
            }

            case 20:
            {
                /*[moreView setHidden:TRUE];

                AppDelegate *appdelgate = (AppDelegate*)[[UIApplication sharedApplication]delegate ];
                [MBProgressHUD showHUDAddedTo:appdelgate.window animated:YES];
                UserDataController *uDC = [UserDataController new];
                [uDC respond:message.ID withResponse:@"unmatch" withSuccess:^{
                    [MBProgressHUD hideAllHUDsForView:appdelgate.window animated:YES];
                    //                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"User %@ unmatched.", message.name] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    //                        [alertView setTag:30];
                    //                        [alertView show];

                    [[[APP_DELEGATE tabBarController] viewControllers][0] popToRootViewControllerAnimated:NO];
                    [[APP_DELEGATE tabBarController] setSelectedIndex:0];
                } failure:^(NSError *error) {
                    [MBProgressHUD hideAllHUDsForView:appdelgate.window animated:YES];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alertView show];
                }];*/

                [self deleteGymChat2];
            }
                break;

            case 30:
            {
                [[[APP_DELEGATE tabBarController] viewControllers][0] popToRootViewControllerAnimated:NO];
                [[APP_DELEGATE tabBarController] setSelectedIndex:0];
            }

            default:
                break;
        }
    }
}


- (IBAction)onReport:(id)sender {
    [moreView setHidden: YES];
    [self reportUser];
}

- (IBAction)onInvisible:(id)sender
{
    [moreView setHidden: YES];
}

- (IBAction)onDelete:(id)sender
{
     [moreView setHidden: YES];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
    alertView.tag = 1512;
    alertView.delegate = self;
    [alertView show];
}

-(IBAction) profileBtnPressed:(id)sender{
    
    AppDelegate *appdelgate = (AppDelegate*)[[UIApplication sharedApplication]delegate ];
    [MBProgressHUD showHUDAddedTo:appdelgate.window animated:YES];
    UserDataController *userDC = [UserDataController new];
    
    [userDC profileDetails:message.userID withSuccess:^(Friend *aFriend)
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


-(void)avatorSingleTapped
{
//    NSLog(@"Single Gesture is called");
//    _pictureView = [[EnlargeViewController alloc] initWithNibName:@"AvatorViewController" bundle:nil];
//
//    _pictureView.image = messageImageView.image;
//    //[self.navigationController pushViewController:_pictureView animated:NO];
//    [self.viewController.view addSubview:_pictureView.view];
//    [_pictureView.view setFrame:[[UIScreen mainScreen] bounds]];
//    CATransition* transition = [CATransition animation];
//    transition.duration = 0.5f;
//    transition.type = kCATransitionFade;
//    transition.subtype = kCATransitionFromRight;
//    [_pictureView.view.window.layer addAnimation:transition forKey:kCATransition];
    
    
    NSLog(@"MessageCell Gesture is called");
    _vc = [[EnlargeViewController alloc] initWithNibName:@"AvatorViewController" bundle:nil];
    
    _vc.image = messageImageView.image;
    UIImage *img = messageImageView.image;
    if (img !=nil && !CGSizeEqualToSize(img.size, CGSizeZero)) {
        [_vc.view setFrame:[[UIScreen mainScreen] bounds]];
        CATransition* transition = [CATransition animation];
        transition.duration = 0.5f;
        transition.type = kCATransitionFade;
        transition.subtype = kCATransitionFromRight;
        [_vc.view.window.layer addAnimation:transition forKey:kCATransition];
        
        [self.viewController presentViewController:_vc animated:NO completion:nil];
    }
}

-(void)avatorSingleTapped2
{

    [self profileBtnPressed:nil];
}

#pragma mark - Action Sheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            if ([userNameLabel.text isEqualToString:[[APP_DELEGATE loggedInUser] username]] || [userNameLabel.text isEqualToString:[[APP_DELEGATE loggedInUser] firstName]]) {
                [self deleteGymChat];
            }else{
                // Report
                [self reportUser];
            }
            break;
            
        default:
            break;
    }
}

- (void)reportUser{
    
    ReportViewController *rVC = [ReportViewController new];
    rVC.userID = message.userID;
    [(UINavigationController *)[[APP_DELEGATE tabBarController] selectedViewController] pushViewController:rVC animated:YES];
}

@end
