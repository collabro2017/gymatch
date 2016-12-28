//
//  TopNavigationController.h
//  GYMatch
//
//  Created by Ram Gautam on 10/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNPGridMenu.h"

@interface TopNavigationController : UINavigationController <CNPGridMenuDelegate>
{
    
    IBOutlet UIButton *profileMenuButton;
    IBOutlet UIView *profileMenuView;
    IBOutlet UIView *grayMenuView;
    BOOL isShowing;

    
}
//@property (strong, nonatomic) IBOutlet UIImageView *gymLogoImageView;

@property(nonatomic, strong) IBOutlet UIView *friendNavigationBar;
@property (nonatomic, strong) CNPGridMenu *gridMenu;

+ (instancetype)sharedInstance;

- (void)addFriendNavigationBar;
-(void)addReactivateView; 

- (void)removeFriendNavigationBar;

+ (void)addTabBarController;
+ (void)addLoginNavigationController;

- (void)hideProfileMenu;
- (BOOL)isProfileMenuViewHidden;
- (void)hideProfileMenuOnlyCalendar;
- (void)showProfileMenuOnlyCalendar;

- (void)addLogoToNavigation;
- (IBAction)muProfileButtonPressed:(UIButton *)sender;
+ (void)logout;

- (IBAction)bookTrainerAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *myProfileButton;

@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@property (weak, nonatomic) IBOutlet UIButton *gymLocatorButton;

@property (weak, nonatomic) IBOutlet UIButton *gtvButton;

@property (weak, nonatomic) IBOutlet UIButton *gymChatButton;

@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@end
