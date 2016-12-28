//
//  TopNavigationController.m
//  GYMatch
//
//  Created by Ram Gautam on 10/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "TopNavigationController.h"
#import "RequestsViewController.h"
#import "MessagesViewController.h"
#import "ChatViewController.h"
#import "EditProfileViewController.h"
#import "SpotlightsViewController.h"
#import "MBProgressHUD.h"
#import "LoginViewController.h"
#import "UserDataController.h"
#import "FriendDetailsViewController.h"
#import "SearchViewController.h"
#import "LocatorViewController.h"
#import "GymChatViewController.h"
#import "GTVViewController.h"
#import "MessageDataController.h"
#import "TopNavigationControllerDelegate.h"
#import "FriendTableViewController.h"
#import "calenderVC.h"
#import "MyCalendar.h"

static TopNavigationControllerDelegate *topDelegate;

@implementation UINavigationBar (MakeTranslucent)

-(void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    
    self.translucent = NO;
}
@end

@interface TopNavigationController ()

@end

@implementation TopNavigationController

+ (instancetype)sharedInstance
{
    static TopNavigationController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TopNavigationController alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
 
        if ([[[UIDevice currentDevice] systemVersion] integerValue] >= 7) {
            [self.navigationBar setTintColor:[UIColor whiteColor]];
            [self.navigationBar setBarTintColor:DEFAULT_NAV_COLOR];
            [[UINavigationBar appearance] setBackgroundColor:DEFAULT_NAV_COLOR];

        }else{
            [[UINavigationBar appearance] setTintColor:DEFAULT_NAV_COLOR];
            [[UINavigationBar appearance] setBackgroundColor:DEFAULT_NAV_COLOR];
        }
        
        self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],  NSFontAttributeName: [UIFont fontWithName:@"ProximaNova-Semibold" size:18.0f]};
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.friendNavigationBar = [[[NSBundle mainBundle]loadNibNamed:@"TopNavigationController" owner:self options:nil] objectAtIndex:0];
    [self addFriendNavigationBar];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)isProfileMenuViewHidden{
    return !isShowing;
}


- (void)addFriendNavigationBar{
    
    CGRect frame = self.friendNavigationBar.frame;
    frame.origin.y = -20;
    frame.origin.x = self.navigationBar.frame.size.width - frame.size.width;
    
    self.friendNavigationBar.frame = frame;
    
    [self.navigationBar addSubview:self.friendNavigationBar];
    
    [self.friendNavigationBar setHidden:YES];

}

- (void)removeFriendNavigationBar{
    [self.friendNavigationBar removeFromSuperview];
}


- (void)addLogoToNavigation{
    return;

}




+ (void)addTabBarController{
    
    topDelegate = [TopNavigationControllerDelegate new];

    if ([APP_DELEGATE loggedInUser].isDeleted > 0) {
        // View controllers
        EditProfileViewController *profileVC = [[EditProfileViewController alloc] init];
        
        // Navigation Controllers
        TopNavigationController *topNC1 = [[TopNavigationController alloc] initWithRootViewController:profileVC];
        
        [topNC1 setDelegate:topDelegate];
        
        [[APP_DELEGATE window] setRootViewController:topNC1];
    }
    else {
        // View controllers
        FriendTableViewController *friendsVC = [[FriendTableViewController alloc] init];
        MessagesViewController *messagesVC = [[MessagesViewController alloc] init];
        ChatViewController *chatVC = [[ChatViewController alloc] init];
        RequestsViewController *requestsVC = [[RequestsViewController alloc] init];
        [requestsVC view];

        SpotlightsViewController *spotlightsVC = [[SpotlightsViewController alloc] init];
        
        // Navigation Controllers
        TopNavigationController *topNC1 = [[TopNavigationController alloc] initWithRootViewController:friendsVC];
        
        TopNavigationController *topNC2 = [[TopNavigationController alloc] initWithRootViewController:messagesVC];
        TopNavigationController *topNC5;
        
        UIViewController *messVC = topNC2;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
            UISplitViewController *splitVC = [[UISplitViewController alloc] init];
            splitVC.delegate = topDelegate;
            messagesVC.delegate = chatVC;
            topNC5 = [[TopNavigationController alloc] initWithRootViewController:chatVC];
            [splitVC setViewControllers:@[topNC2, topNC5]];
            messVC = splitVC;
        }
      //   TopNavigationController *messVC = [[TopNavigationController alloc] initWithRootViewController:messVC1];

        TopNavigationController *topNC3 = [[TopNavigationController alloc] initWithRootViewController:requestsVC];
        TopNavigationController *topNC4 = [[TopNavigationController alloc] initWithRootViewController:spotlightsVC];

       // [messVC setDelegate:topDelegate];
        [topNC1 setDelegate:topDelegate];
        [topNC2 setDelegate:topDelegate];
        [topNC3 setDelegate:topDelegate];
        [topNC4 setDelegate:topDelegate];
        
        UITabBarItem *frinedsTBI;
        UITabBarItem *messagesTBI;
        UITabBarItem *requestsTBI;
        UITabBarItem *spotlightsTBI;
        
        if ([[[UIDevice currentDevice] systemVersion] integerValue] >= 7) {
            
            
            // Tab bar items
            frinedsTBI = [[UITabBarItem alloc] initWithTitle:@"Friends"
                                                       image:[UIImage imageNamed:@"friends"]
                                               selectedImage:[UIImage imageNamed:@"friends_active"]];
            messagesTBI = [[UITabBarItem alloc] initWithTitle:@"Messages"
                                                        image:[UIImage imageNamed:@"message"]
                                                selectedImage:[UIImage imageNamed:@"message_active"]];
            requestsTBI = [[UITabBarItem alloc] initWithTitle:@"Requests"
                                                        image:[UIImage imageNamed:@"requests"]
                                                selectedImage:[UIImage imageNamed:@"requests_active"]];
            spotlightsTBI = [[UITabBarItem alloc] initWithTitle:@"Spotlight"
                                                          image:[[UIImage imageNamed:@"spotlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                  selectedImage:[[UIImage imageNamed:@"spotlight_active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        }else{
            
            frinedsTBI = [[UITabBarItem alloc] initWithTitle:@"Friends"
                                                       image:[UIImage imageNamed:@"friends"]
                                                         tag:1];
            messagesTBI = [[UITabBarItem alloc] initWithTitle:@"Messages"
                                                        image:[UIImage imageNamed:@"message"]
                                                          tag:2];
            requestsTBI = [[UITabBarItem alloc] initWithTitle:@"Requests"
                                                        image:[UIImage imageNamed:@"requests"]
                                                          tag:3];
            spotlightsTBI = [[UITabBarItem alloc] initWithTitle:@"Spotlight"
                                                          image:[UIImage imageNamed:@"spotlight"]
                                                            tag:4];
            
            [frinedsTBI setFinishedSelectedImage:[UIImage imageNamed:@"friends_active"]
                     withFinishedUnselectedImage:[UIImage imageNamed:@"friends"]];
            
            [messagesTBI setFinishedSelectedImage:[UIImage imageNamed:@"message_active"]
                      withFinishedUnselectedImage:[UIImage imageNamed:@"message"]];
            
            [requestsTBI setFinishedSelectedImage:[UIImage imageNamed:@"requests_active"]
                      withFinishedUnselectedImage:[UIImage imageNamed:@"requests"]];
            
            [spotlightsTBI setFinishedSelectedImage:[UIImage imageNamed:@"spotlight_active"]
                        withFinishedUnselectedImage:[UIImage imageNamed:@"spotlight"]];
            
        }
        [frinedsTBI setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"ProximaNova-Semibold" size:12.0f]} forState:UIControlStateNormal];
        [messagesTBI setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"ProximaNova-Semibold" size:12.0f]} forState:UIControlStateNormal];
        [requestsTBI setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"ProximaNova-Semibold" size:12.0f]} forState:UIControlStateNormal];
        [spotlightsTBI setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"ProximaNova-Semibold" size:12.0f]} forState:UIControlStateNormal];
        
        [topNC1 setTabBarItem:frinedsTBI];
        [messVC setTabBarItem:messagesTBI];
        [topNC3 setTabBarItem:requestsTBI];
        [topNC4 setTabBarItem:spotlightsTBI];
        
        // Tab bar controller
        UITabBarController *tabBarController = [[UITabBarController alloc]init];
        tabBarController.viewControllers = @[topNC1, topNC3, messVC, topNC4];
        
        // Tint color
        if ([[[UIDevice currentDevice] systemVersion] integerValue] >= 7) {
            
            [tabBarController.tabBar setTintColor:[UIColor colorWithRed:0.0f
                                          green:(191.0f / 255.0f)
                                           blue:(77.0f / 255.0f)
                                          alpha:1.0f]];
        }else{
            [tabBarController.tabBar
             setTintColor:[UIColor whiteColor]];
        }
        
        [APP_DELEGATE setTabBarController:tabBarController];
        [[APP_DELEGATE window] setRootViewController:tabBarController];

        [[APP_DELEGATE tabBarController] setDelegate:APP_DELEGATE];

      
        MessageDataController *uDC = [MessageDataController new];
        [uDC unreadMessagesWithSuccess:^(NSInteger count) {
            
            if (count) {
                
                NSString *countString = [NSString stringWithFormat:@"%ld", (long)count];
                
                [messagesTBI setBadgeValue:countString];
            }
        } failure:^(NSError *error) {
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            
        }];
    }
    
    
//    [APP_DELEGATE setNavigationController:nil];
}


+ (void)addLoginNavigationController{
    
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    TopNavigationController *topNC = [[TopNavigationController alloc]initWithRootViewController:loginVC];
    
    [APP_DELEGATE setNavigationController:topNC];
    [[APP_DELEGATE window] setRootViewController:[APP_DELEGATE navigationController]];
    
}

- (void)showProfileMenu {
//    CGPoint center = profileMenuView.center;
//    center.x = self.view.center.x;
//    
//    profileMenuView.center = center;

    
//    CGRect frame = profileMenuView.frame;
//    
//    grayMenuView.layer.borderWidth = 1.0f;
//    grayMenuView.layer.cornerRadius = 6.0f;
//    grayMenuView.layer.borderColor = [[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0] CGColor];
//    
//    frame.origin.y = self.view.frame.size.height / 2.0f - 270.0f;
//    frame.size.height = 0;
//    frame.size.width = self.navigationBar.frame.size.width;
//    profileMenuView.frame = frame;
//    
//    
//    
//    frame.size.height = 540.0f;
//    [self.view addSubview:profileMenuView];
//    
//    [UIView animateWithDuration:0.3 animations:^{
//        profileMenuView.frame = frame;
//        
//    }];


    CNPGridMenuItem *fake1 = [[CNPGridMenuItem alloc] init];
    fake1.icon = [UIImage imageNamed:@"menu-locator"];
    fake1.title = @"a";

  /*  CNPGridMenuItem *fake2 = [[CNPGridMenuItem alloc] init];
    fake2.icon = [UIImage imageNamed:@"menu-locator"];
    fake2.title = @"s";

    CNPGridMenuItem *fake3 = [[CNPGridMenuItem alloc] init];
    fake3.icon = [UIImage imageNamed:@"menu-locator"];
    fake3.title = @"d";      */


    CNPGridMenuItem *profile = [[CNPGridMenuItem alloc] init];
    profile.icon = [UIImage imageNamed:@"menu-profile"];
    profile.title = @"My Profile";
    
    CNPGridMenuItem *search = [[CNPGridMenuItem alloc] init];
    search.icon = [UIImage imageNamed:@"menu-search"];
    search.title = @"Search";

    CNPGridMenuItem *locater= [[CNPGridMenuItem alloc] init];
    locater.icon = [UIImage imageNamed:@"menu-locator"];
    locater.title = @"Gym Locator";
    
    CNPGridMenuItem *gtv = [[CNPGridMenuItem alloc] init];
    gtv.icon = [UIImage imageNamed:@"menu-play"];
    gtv.title = @"G-TV";
    
    CNPGridMenuItem *mycalender = [[CNPGridMenuItem alloc] init];
    mycalender.icon = [UIImage imageNamed:@"mycalendar.png"];
    mycalender.title = @"My Calender";
    
    CNPGridMenuItem *bookTrainer = [[CNPGridMenuItem alloc] init];
    bookTrainer.icon = [UIImage imageNamed:@"booktrainer.png"];
    bookTrainer.title = @"Book Trainer";

    CNPGridMenuItem *joinGym = [[CNPGridMenuItem alloc] init];
    joinGym.icon = [UIImage imageNamed:@"joingym.png"];
    joinGym.title = @"Join Gym";

    CNPGridMenuItem *chat = [[CNPGridMenuItem alloc] init];
    chat.icon = [UIImage imageNamed:@"menu-chat"];
    chat.title = @"Gym Chat";

    CNPGridMenuItem *inACentury = [[CNPGridMenuItem alloc] init];
    inACentury.icon = [UIImage imageNamed:@"menu-logout"];
    inACentury.title = @"Log out";

    CNPGridMenu *gridMenu;
    gridMenu.blurEffectStyle = UIBlurEffectStyleDark;
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
         gridMenu = [[CNPGridMenu alloc] initWithMenuItems:@[fake1, fake1, profile, search, locater, chat,fake1, fake1, fake1, fake1, gtv,  inACentury,mycalender]];
    }
    else
    {
         gridMenu = [[CNPGridMenu alloc] initWithMenuItems:@[ profile, search, locater,chat,mycalender, bookTrainer,joinGym, gtv, inACentury]];
    }

    gridMenu.delegate = self;
    [self presentGridMenu:gridMenu animated:YES completion:^{
        NSLog(@"Grid Menu Presented");
    }];
    
    profileMenuButton.selected = !profileMenuButton.selected;
    [self showProfileMenuOnlyCalendar];
}

- (void)hideProfileMenu{
    CGRect frame = profileMenuView.frame;
    frame.size.height = 0;
    [UIView animateWithDuration:0.3 animations:^{
        profileMenuView.frame = frame;
        profileMenuButton.selected = NO;
    } completion:^(BOOL finished) {
        [profileMenuView removeFromSuperview];
    }];

}
-(void)hideProfileMenuOnlyCalendar{
    [profileMenuButton setHidden:YES];
}
-(void)showProfileMenuOnlyCalendar{
    [profileMenuButton setHidden:NO];
}

#pragma mark - IBActions

- (IBAction)logoutButtonPressed:(UIButton *)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    UserDataController *uDC = [UserDataController new];
    
    [uDC logoutSuccess:^{
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for(NSHTTPCookie *cookie in [storage cookies])
        {
            NSString *domainName = [cookie domain];
            NSRange domainRange = [domainName rangeOfString:@"facebook"];
            if(domainRange.length > 0)
            {
                [storage deleteCookie:cookie];
            }
        }

        ACAccountStore *store = [[ACAccountStore alloc] init];
        NSArray *fbAccounts = [store accountsWithAccountType:[store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook]];
        for (ACAccount *fb in fbAccounts) {
            [store renewCredentialsForAccount:fb completion:^(ACAccountCredentialRenewResult renewResult, NSError *error) {

            }];
        }

        [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGOUTCALL" object:nil];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGOUTCALLREQUEST" object:nil];

        [TopNavigationController addLoginNavigationController];
        [APP_DELEGATE setTabBarController:nil];
        [APP_DELEGATE invalidateChatTimer];
        
        [uDC forgetUser];
        [FBSession.activeSession closeAndClearTokenInformation];
        [FBSession.activeSession close];
        [FBSession setActiveSession:nil];

        
    } failure:^(NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
    }];
    
}

+ (void)logout {
    
    UserDataController *uDC = [UserDataController new];
    
    [uDC logoutSuccess:^{

         [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGOUTCALL" object:nil];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGOUTCALLREQUEST" object:nil];

        [TopNavigationController addLoginNavigationController];
        [APP_DELEGATE setTabBarController:nil];
        
        [uDC forgetUser];
        [FBSession.activeSession closeAndClearTokenInformation];
        
    } failure:^(NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
    }];
}

- (IBAction)muProfileButtonPressed:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self showProfileMenu];
    }
    else {
        [self hideProfileMenu];
    }
    //[sender setHidden:YES];
}

- (IBAction)userProfileButtonPressed:(UIButton *)sender {
    
    [self hideProfileMenu];
    
    for (id vc in [[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:[[APP_DELEGATE tabBarController] selectedIndex]] viewControllers]) {
        
        if ([vc isMemberOfClass:[FriendDetailsViewController class]]) {
            if([(FriendDetailsViewController *)vc aFriend].ID == [APP_DELEGATE loggedInUser].ID){
                
            [[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:[[APP_DELEGATE tabBarController] selectedIndex]] popToViewController:vc animated:YES];
            return;
            }
        }
    }
    
    [self popToRootViewControllerAnimated:NO];
    
    FriendDetailsViewController *fdvc = [[FriendDetailsViewController alloc]init];
    [fdvc setAFriend:[APP_DELEGATE loggedInUser]];
    //    [[[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:[[APP_DELEGATE tabBarController] selectedIndex]] friendNavigationBar] setHidden:YES];
    
    [self pushViewController:fdvc animated:NO];
    
    [[[APP_DELEGATE tabBarController] tabBar] setHidden:YES];
}


- (IBAction)searchButtonPressed:(UIButton *)sender {

    [self hideProfileMenu];
    for (id vc in [[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:[[APP_DELEGATE tabBarController] selectedIndex]] viewControllers]) {
        
        if ([vc isMemberOfClass:[SearchViewController class]]) {
                [[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:[[APP_DELEGATE tabBarController] selectedIndex]] popToViewController:vc animated:YES];
                return;
        }
    }
    
    [self popToRootViewControllerAnimated:NO];
    
    SearchViewController *fdvc = [[SearchViewController alloc]init];
//    [[[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:[[APP_DELEGATE tabBarController] selectedIndex]] friendNavigationBar] setHidden:YES];
    [self pushViewController:fdvc animated:NO];
    
    [[[APP_DELEGATE tabBarController] tabBar] setHidden:YES];
}


- (IBAction)gymLocatorButtonPressed:(UIButton *)sender {
    
    [self hideProfileMenu];
    for (id vc in [[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:[[APP_DELEGATE tabBarController] selectedIndex]] viewControllers]) {
        
        if ([vc isMemberOfClass:[LocatorViewController class]]) {
            
            [[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:[[APP_DELEGATE tabBarController] selectedIndex]] popToViewController:vc animated:YES];
            return;
            
        }
        
    }
    
    [self popToRootViewControllerAnimated:NO];

    LocatorViewController *fdvc = [[LocatorViewController alloc]init];
    
//    [[[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:[[APP_DELEGATE tabBarController] selectedIndex]] friendNavigationBar] setHidden:YES];
    
    [self pushViewController:fdvc animated:NO];
    
    [[[APP_DELEGATE tabBarController] tabBar] setHidden:YES];
}

- (IBAction)gtvButtonPressed:(UIButton *)sender {
    
    [self hideProfileMenu];
    for (id vc in [[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:[[APP_DELEGATE tabBarController] selectedIndex]] viewControllers]) {
        
        if ([vc isMemberOfClass:[GTVViewController class]]) {
            
            [[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:[[APP_DELEGATE tabBarController] selectedIndex]] popToViewController:vc animated:YES];
            return;
            
        }
        
    }
    
    [self popToRootViewControllerAnimated:NO];

    GTVViewController *fdvc = [[GTVViewController alloc]init];
    
//    [[[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:[[APP_DELEGATE tabBarController] selectedIndex]] friendNavigationBar] setHidden:YES];
    
    [self pushViewController:fdvc animated:NO];
    
    [[[APP_DELEGATE tabBarController] tabBar] setHidden:YES];
    
}

- (IBAction)gymChatButtonPressed:(UIButton *)sender {
    
    [self hideProfileMenu];
    
    for (id vc in [[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:[[APP_DELEGATE tabBarController] selectedIndex]] viewControllers]) {
        
        if ([vc isMemberOfClass:[GymChatViewController class]]) {
            
            [[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:[[APP_DELEGATE tabBarController] selectedIndex]] popToViewController:vc animated:YES];
            return;
        }
    }
    
    [self popToRootViewControllerAnimated:NO];
    

    GymChatViewController *fdvc = [[GymChatViewController alloc]init];
    
//    [[[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:[[APP_DELEGATE tabBarController] selectedIndex]] friendNavigationBar] setHidden:YES];
    
    [self pushViewController:fdvc animated:NO];
    
    [[[APP_DELEGATE tabBarController] tabBar] setHidden:YES];
}

- (IBAction)gymTalkButtonPressed:(UIButton *)sender {

    [self hideProfileMenu];

    for (id vc in [[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:[[APP_DELEGATE tabBarController] selectedIndex]] viewControllers]) {

        if ([vc isMemberOfClass:[GymChatViewController class]]) {

            [[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:[[APP_DELEGATE tabBarController] selectedIndex]] popToViewController:vc animated:YES];
            return;
        }
    }

    [self popToRootViewControllerAnimated:NO];


    GymChatViewController *fdvc = [[GymChatViewController alloc]init];

    //    [[[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:[[APP_DELEGATE tabBarController] selectedIndex]] friendNavigationBar] setHidden:YES];

    [self pushViewController:fdvc animated:NO];

    [[[APP_DELEGATE tabBarController] tabBar] setHidden:YES];
}


- (IBAction)gNotesButtonPressed:(UIButton *)sender {

    [self hideProfileMenu];

    for (id vc in [[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:[[APP_DELEGATE tabBarController] selectedIndex]] viewControllers]) {

        if ([vc isMemberOfClass:[GymChatViewController class]]) {

            [[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:[[APP_DELEGATE tabBarController] selectedIndex]] popToViewController:vc animated:YES];
            return;
        }
    }

    [self popToRootViewControllerAnimated:NO];


    GymChatViewController *fdvc = [[GymChatViewController alloc]init];

    //    [[[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:[[APP_DELEGATE tabBarController] selectedIndex]] friendNavigationBar] setHidden:YES];

    [self pushViewController:fdvc animated:NO];

    [[[APP_DELEGATE tabBarController] tabBar] setHidden:YES];
}


- (IBAction)bookTrainerAction:(id)sender {

    [self hideProfileMenu];
    /*
    for (id vc in [[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:[[APP_DELEGATE tabBarController] selectedIndex]] viewControllers]) {
        
        if ([vc isMemberOfClass:[SpotlightsViewController class]]) {
            
            [[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:[[APP_DELEGATE tabBarController] selectedIndex]] popToViewController:vc animated:YES];
            return;
        }
    }
    */
    [self popToRootViewControllerAnimated:NO];
    
    
    SpotlightsViewController *spotlightViewC = [[SpotlightsViewController alloc]init];
    spotlightViewC.singleTapBool = YES;
    spotlightViewC.singleString = @"Trainer";
    
    //    [[[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:[[APP_DELEGATE tabBarController] selectedIndex]] friendNavigationBar] setHidden:YES];
    
    [self pushViewController:spotlightViewC animated:NO];
    
    [[[APP_DELEGATE tabBarController] tabBar] setHidden:YES];
    
}

- (IBAction)gymStudioAction:(id)sender {
    
    [self hideProfileMenu];
    /*
    for (id vc in [[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:[[APP_DELEGATE tabBarController] selectedIndex]] viewControllers]) {
        
        if ([vc isMemberOfClass:[SpotlightsViewController class]]) {
            
            [[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:[[APP_DELEGATE tabBarController] selectedIndex]] popToViewController:vc animated:YES];
            return;
        }
    }
    */
    [self popToRootViewControllerAnimated:NO];
    
    
    SpotlightsViewController *spotlightViewC = [[SpotlightsViewController alloc]init];
    spotlightViewC.singleTapBool = YES;
    spotlightViewC.singleString = @"Gym/Studio";
    
    //    [[[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:[[APP_DELEGATE tabBarController] selectedIndex]] friendNavigationBar] setHidden:YES];
    
    [self pushViewController:spotlightViewC animated:NO];
    
    [[[APP_DELEGATE tabBarController] tabBar] setHidden:YES];
    
}

- (IBAction)showCalenderAction:(id)sender {
    
    [self hideProfileMenu];
    
    for (id vc in [[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:[[APP_DELEGATE tabBarController] selectedIndex]] viewControllers]) {
        
        if ([vc isMemberOfClass:[MyCalendar class]]) {
            
            [[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:[[APP_DELEGATE tabBarController] selectedIndex]] popToViewController:vc animated:YES];
            return;
        }
    }
    
    [self popToRootViewControllerAnimated:NO];
    
    
    MyCalendar *fdvc = [[MyCalendar alloc] init];
    fdvc.topNavigationController = self;
        
    [self pushViewController:fdvc animated:NO];
    
    [[[APP_DELEGATE tabBarController] tabBar] setHidden:YES];
    
}





- (IBAction)closeButtonPressed:(UIButton *)sender {
    
    [self hideProfileMenu];
    
//    [[[APP_DELEGATE tabBarController] tabBar] setHidden:YES];
    
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if ([[[UIDevice currentDevice] systemVersion] integerValue] >= 7) {
        
        self.topViewController.navigationItem.title = @"";
    }
    [super pushViewController:viewController animated:animated];
    
}


- (void)gridMenuDidTapOnBackground:(CNPGridMenu *)menu {
    [self dismissGridMenuAnimated:YES completion:^{
        NSLog(@"Grid Menu Dismissed With Background Tap");
    }];
}

- (void)gridMenu:(CNPGridMenu *)menu didTapOnItem:(CNPGridMenuItem *)item {
    
    BOOL dismiss = YES;
    
    if ([item.title isEqualToString: @"My Profile"]) {
        [self userProfileButtonPressed:nil];
    }else if ([item.title isEqualToString: @"Search"]) {
        [self searchButtonPressed:nil];
    }else if ([item.title isEqualToString: @"Gym Locator" ]) {
        [self gymLocatorButtonPressed:nil];
    }else if ([item.title isEqualToString: @"G-TV"]) {
        [self gtvButtonPressed:nil];
    }else if ([item.title isEqualToString: @"Gym Chat"]) {
        [self gymTalkButtonPressed:nil];
    }else if ([item.title isEqualToString: @"Log out"]) {
        [self logoutButtonPressed:nil];
    } else if ([item.title isEqualToString: @"Book Trainer"]) {
        [self bookTrainerAction:nil];
    } else if ([item.title isEqualToString: @"Join Gym"]) {
        [self gymStudioAction:nil];
    }else if ([item.title isEqualToString: @"My Calender"]) {
        [self showCalenderAction:nil];
    }
    
    if(dismiss)
    [self dismissGridMenuAnimated:YES completion:^{
        
    }];
}

@end
