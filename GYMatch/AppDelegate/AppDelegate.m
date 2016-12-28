//
//  AppDelegate.m
//  GYMatch
//
//  Created by Ram Gautam on 10/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "AppDelegate.h"
#import "SplashViewController.h"
#import "Utility.h"
#import "FriendDetailsViewController.h"
#import "Crittercism.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>//naveen
#import "MessageDataController.h"
#import "MessagesViewController.h"
#import "LoginViewController.h"
#import "TopNavigationController.h"
#import "PayPalMobile.h"

#define CHATPUSH    100
#define FRIENDPUSH  101
#define ACCEPTPUSH  102

@implementation AppDelegate
@synthesize databasePath;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // dragon
    aryMonth = @[@"Jan",
                 @"Feb",
                 @"Mar",
                 @"Apr",
                 @"May",
                 @"Jun",
                 @"Jul",
                 @"Aug",
                 @"Sep",
                 @"Oct",
                 @"Nov",
                 @"Dec"];
    
    aryWeekday = @[@"Sun",
                 @"Mon",
                 @"Tue",
                 @"Wed",
                 @"Thu",
                 @"Fri",
                 @"Sat"];
    
    aryPeriod = @[@"1",
                  @"2",
                  @"3",
                  @"30",
                  @"60",
                  @"90"];

    
    aryTime = [[NSMutableArray alloc] init];
    for (int i = 0; i <= 47; i++) {
        if (i < 2) {
            [aryTime addObject:[NSString stringWithFormat:@"%02d:%02d AM", (int)i / 2 + 12, (int)i % 2 * 30]];
        } else if (i < 24) {
            [aryTime addObject:[NSString stringWithFormat:@"%02d:%02d AM", (int)i / 2, (int)i % 2 * 30]];
        } else if (i < 26) {
            [aryTime addObject:[NSString stringWithFormat:@"%02d:%02d PM", (int)i / 2, (int)i % 2 * 30]];
        } else if (i == 48) {
            [aryTime addObject:[NSString stringWithFormat:@"%02d:%02d AM", (int)i / 2 - 12, (int)i % 2 * 30]];
        } else {
            [aryTime addObject:[NSString stringWithFormat:@"%02d:%02d PM", (int)i / 2 - 12, (int)i % 2 * 30]];
        }
//        [aryTime addObject:[NSString stringWithFormat:@"%02d:%02d", (int)i / 2, (int)i % 2 * 30]];
    }
    //
    
    
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
    
//    [FBSession.activeSession closeAndClearTokenInformation];
//    [FBSession.activeSession close];
//    [FBSession setActiveSession:nil];

     //naveen
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(setLocationCoordinate) userInfo:self repeats:NO];
    // Show splash
    SplashViewController *splashVC = [[SplashViewController alloc]init];
//    LoginViewController* loginVC = [[LoginViewController alloc] init];
//    
    [self.window setRootViewController:splashVC];
    
//    [TopNavigationController addTabBarController];
//    [TopNavigationController addLoginNavigationController];
    // Set status bar white color
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    self.deviceToken = @""; // comment it after you uncomment below lines
 //yt 12 Aug
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    
//    [Crittercism enableWithAppID:@"53857d9b1787844702000001"];

    [self createPlistFileIfNotCreated]; /// to manage GYmatch "Make invisible" feature

    //Handle memory warning
    [self issuePeriodicLowMemoryWarningsInSimulator];
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMessages) name:@"updateTabBarBadge" object:nil];
//    if (IS_IPAD) {
//        [self performSelector:@selector(reloadMessages) withObject:nil afterDelay:0.5];
//    }
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.chatTimer = [NSTimer scheduledTimerWithTimeInterval:15 target:self  selector:@selector(reloadMessages) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.chatTimer forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
    });
    
    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : @"AY0q1sIbRZBV9lIopaPiXHTsSkcVyfyjrEQJtsCL851N8zk2x0sV2-AW7BCwja_ZxZYJfeP7LH_hI7kw",
                                                           PayPalEnvironmentSandbox : @"seller20161206@hotmail.com"}];
    
    return YES;
}


-(NSString *)getDBPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"gymatch.plist"];
    databasePath = writableDBPath;
    return writableDBPath;
}


-(void)createPlistFileIfNotCreated
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success = NO;
  //  NSError *error = nil;
     [self getDBPath];

    success = [fileManager fileExistsAtPath:databasePath];
    if (success)
    {
        NSLog(@"success");
        return;
    }
    else{
        NSDictionary *dict = [NSDictionary dictionary];
        [dict writeToFile:databasePath atomically:YES];
      /*  NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"gymatch.plist"];

        //   success = [fileManager createFileAtPath:defaultDBPath contents:nil attributes:nil];
        success = [fileManager  copyItemAtPath:defaultDBPath toPath:databasePath error:&error];
        if (!success) {
            // NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        } */
    }
}

-(void)setLocationCoordinate
{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [_locationManager requestAlwaysAuthorization];
    }
    [_locationManager startUpdatingLocation];
    // [self loadData];
   // [NSTimer scheduledTimerWithTimeInterval:1.4 target:self selector:@selector(loadData) userInfo:self repeats:NO];

}


// CLLocationManager Delegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
  //  NSLog(@"location info object=%@", [locations lastObject]);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"BackgroundMode"];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        [FBAppCall handleDidBecomeActive];
        [FBSDKAppEvents activateApp];//naveen
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"BackgroundMode"];

    
     [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    //[[NSURLCache sharedURLCache] removeAllCachedResponses];
}


#pragma mark - Facebook

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [self.instagram handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {

    BOOL isFacebookURL = NO;

    if (([[url description] rangeOfString:@"1374768389465961"].length > 0) || ([[[url description] lowercaseString]rangeOfString:@"facebook"].length > 0)) {
        isFacebookURL = YES;
    }

    if (isFacebookURL) {
        return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    }

    return [self.instagram handleOpenURL:url];


    // Instagram
//    if ([[url description]rangeOfString:@"com.inlyt.GOOBOND"].length > 0 || [[url description]rangeOfString:@"com.inlyt.goobond"].length > 0) {
//        
//        return
//    }
    
    //facebook sign-in
    
    // Note this handler block should be the exact same as the handler passed to any open calls.
//    [FBSession.activeSession setStateChangeHandler:
//     ^(FBSession *session, FBSessionState state, NSError *error) {
//         
//         // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
//         [APP_DELEGATE sessionStateChanged:session state:state error:error];
//     }];
    
}

// This method will handle ALL the session state changes in the app
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        // Show the user the logged-in UI
        //        [self userLoggedIn];
        
        
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
        //        [self userLoggedOut];
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            [self showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                //                [self showMessage:alertText withTitle:alertTitle];
                
                // Here we will handle all other errors with a generic error message.
                // We recommend you check our Handling Errors guide for more information
                // https://developers.facebook.com/docs/ios/errors/
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                [self showMessage:alertText withTitle:alertTitle];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        //        [self userLoggedOut];
    }
}

- (void)showMessage:(NSString *)text withTitle:(NSString *)title
{
    [[[UIAlertView alloc] initWithTitle:title
                                message:text
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}


#pragma mark - Push Notifications

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)aDeviceToken
{
	NSLog(@"My token is: %@", aDeviceToken);
    self.deviceToken = [[[[aDeviceToken description]
                           stringByReplacingOccurrencesOfString: @"<" withString: @""]
                          stringByReplacingOccurrencesOfString: @">" withString: @""]
                         stringByReplacingOccurrencesOfString: @" " withString: @""];
    self.deviceToken = [self.deviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[NSUserDefaults standardUserDefaults] setObject:self.deviceToken forKey:@"device_token"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    NSLog(@"-------%@", userInfo);
    self.senderInfo = [userInfo mutableCopy];
    NSString* userID = [userInfo objectForKey:@"userID"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewPush" object:nil];

    NSString* senderName = [[userInfo objectForKey:@"others"] objectForKey:@"senderUsername"];
    NSString* senderID = [[userInfo objectForKey:@"others"] objectForKey:@"senderID"];
    NSString* pushType = [[userInfo objectForKey:@"others"] objectForKey:@"type"];
   
    NSString* msg = [[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"body"];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults boolForKey:@"BackgroundMode"]) {
        [defaults setBool:NO forKey:@"BackgroundMode"];
        
        if ([pushType isEqualToString:@"chat"]) {
            if([defaults boolForKey:@"isChatView"]){
                NSInteger currentFriendID = [defaults integerForKey:@"currentSelectedFriendID"];
                if (currentFriendID != [senderID integerValue]) {
                
                    [notiAV dismissWithClickedButtonIndex:(-1) animated:NO];
                    notiAV = [[UIAlertView alloc] initWithTitle:senderName message:msg delegate:self cancelButtonTitle:@"Close" otherButtonTitles:@"Reply",nil];
                    notiAV.tag = CHATPUSH;
                    [notiAV show];
                }
                else{
                    TopNavigationController *nav = (TopNavigationController  *)self.tabBarController.viewControllers[2];
                    [nav gridMenuDidTapOnBackground:nav.gridMenu];

                }
                
            }
            else {
                [notiAV dismissWithClickedButtonIndex:(-1) animated:NO];
                notiAV = [[UIAlertView alloc] initWithTitle:senderName message:msg delegate:self cancelButtonTitle:@"Close" otherButtonTitles:@"Reply",nil];
                notiAV.tag = CHATPUSH;
                [notiAV show];

            }
        }
        else if ([pushType isEqualToString:@"friend"]){
            NSLog(@"Friend Request push notification!");
            UIAlertView* av = [[UIAlertView alloc] initWithTitle:senderName message:[NSString stringWithFormat:@"%@ added you as a friend.", senderName] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            av.tag = FRIENDPUSH;
            [av show];
        }
        else if ([pushType isEqualToString:@"accept"]){
            NSLog(@"Friend Request accept push notification!");
            UIAlertView* av = [[UIAlertView alloc] initWithTitle:senderName message:[NSString stringWithFormat:@"%@ accepted you as a friend.", senderName] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            av.tag = ACCEPTPUSH;
            [av show];

        }
        
        
        
    }
    else {
        if ([pushType isEqualToString:@"chat"]) {
            
            UserDataController *userDC = [UserDataController new];
            //Reference point
            UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
            while (topController.presentedViewController) {
                topController = topController.presentedViewController;
            }
            
            [userDC profileDetails:[senderID integerValue]
                       withSuccess:^(Friend *aFriend) {
                           ChatViewController* chatVC = [[ChatViewController alloc] init];
                           chatVC.user = aFriend;
                           dispatch_async(dispatch_get_main_queue(), ^{
                               TopNavigationController *nav = (TopNavigationController  *)self.tabBarController.viewControllers[2];
                               
                               if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad)
                               {
                                   [nav gridMenuDidTapOnBackground:nav.gridMenu];

                                   if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isChatView"]) {
                                       NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                                       NSInteger currentFriendID = [defaults integerForKey:@"currentSelectedFriendID"];
                                       if (currentFriendID != [senderID integerValue]){
                                           [(UINavigationController *)[[APP_DELEGATE tabBarController] selectedViewController] pushViewController:chatVC animated:YES];
                                           [[[APP_DELEGATE tabBarController] tabBar] setHidden:YES];
                                       }
                                   } else{
                                       
                                       [(UINavigationController *)[[APP_DELEGATE tabBarController] selectedViewController] pushViewController:chatVC animated:YES];
                                       [[[APP_DELEGATE tabBarController] tabBar] setHidden:YES];
                                   }
                                   
                               }
                               else
                               {
                                   UISplitViewController *split = (UISplitViewController *)self.tabBarController.viewControllers[2];
                                   TopNavigationController *nav = (TopNavigationController *)split.viewControllers[0];
                                   MessagesViewController *msg = (MessagesViewController *)nav.viewControllers[0];
                                   if ([self.tabBarController selectedIndex] != 2)
                                   {
                                       
                                       if (![nav isProfileMenuViewHidden]){
                                           [nav hideProfileMenu];
                                           
                                       }
                                       [msg setSelectedFriend:aFriend];
                                       
                                       [self.tabBarController setSelectedIndex:2];
                                       if ([self.tabBarController selectedIndex] != 2)
                                       {
                                           
                                           //                                       if (![nav isProfileMenuViewHidden])
                                           [nav gridMenuDidTapOnBackground:nav.gridMenu];
                                           
                                       }
                                       
                                   }
                                   else
                                   {
                                       
                                   }
                                   
                               }
                               
                               
                           });
                           
                           
                        } failure:^(NSError *error) {
                           
//                           UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                           [alertView show];
//                           
//                           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                       }];
        }
        else if ([pushType isEqualToString:@"friend"]){
            [TopNavigationController addTabBarController];
            TopNavigationController *nav = (TopNavigationController  *)self.tabBarController.viewControllers[1];
            RequestsViewController *rVC = nav.viewControllers[0];
            [rVC friendTypeButtonPressed:rVC.friendsButtons[0]];
            [[self tabBarController] setSelectedIndex:1];
        }
        else if ([pushType isEqualToString:@"accept"]){
            
        }

    }

}


- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
    self.deviceToken = @"";
}

- (void)loadBreadcumb
{
    if ([[[APP_DELEGATE breadcumb] pathComponents][0] isEqualToString:@"friend"]) {
        
        FriendDetailsViewController *fdvc = [[FriendDetailsViewController alloc]init];
        Friend *friend = [Friend new];
        friend.ID = [[[APP_DELEGATE breadcumb] pathComponents][0] integerValue];
        [fdvc setAFriend:friend];
        //    [[[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:0] friendNavigationBar] setHidden:YES];
        
        [self.navigationController pushViewController:fdvc animated:YES];
        
        [[[APP_DELEGATE tabBarController] tabBar] setHidden:YES];
        
    }
    else if ([[[APP_DELEGATE breadcumb] pathComponents][0] isEqualToString:@"spotlight"]) {
        
        [[[APP_DELEGATE tabBarController] tabBar] setHidden:NO];
        [[APP_DELEGATE tabBarController] setSelectedIndex:3];
        [[[APP_DELEGATE tabBarController] viewControllers][3] popToRootViewControllerAnimated:NO];
    }
    
}

#pragma mark UITabBarControllerDelegate Methods-

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navController = (UINavigationController *)viewController;
        [navController popToRootViewControllerAnimated:NO];
    }
}

#pragma mark - Handle Memory Warnings
- (void)issuePeriodicLowMemoryWarningsInSimulator {
    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidReceiveMemoryWarningNotification object:[UIApplication sharedApplication]];
    [[[UIApplication sharedApplication] delegate] applicationDidReceiveMemoryWarning:[UIApplication sharedApplication]];
    [self performSelector:@selector(issuePeriodicLowMemoryWarningsInSimulator) withObject:nil afterDelay:300];
}

- (void)reloadMessages {
    
    MessageDataController *uDC = [MessageDataController new];
    
    if ([APP_DELEGATE loggedInUser].ID != 0) {
        [uDC unreadMessagesWithUserID:[APP_DELEGATE loggedInUser].ID withSuccess:^(NSInteger count) {
            NSLog(@"Unread counts: %ld", (long)count);
            if (count) {
                NSString *countString = [NSString stringWithFormat:@"%ld", (long)count];
                UITabBarItem *messagesTBI = [[[APP_DELEGATE tabBarController] viewControllers][2] tabBarItem];
                [messagesTBI setBadgeValue:countString];
            }
        } failure:^(NSError *error) {
            
//            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alertView show];
        }];
    }
}

- (void)invalidateChatTimer
{
    [self.chatTimer invalidate];
    self.chatTimer = nil;
}

#pragma mark - UIAlertView -

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == CHATPUSH) {
        UserDataController* userDC = [UserDataController new];
        UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
        while (topController.presentedViewController) {
            topController = topController.presentedViewController;
        }
        if (buttonIndex == 1) {
            {//Reference point
                
                NSMutableDictionary* tmp = [self.senderInfo mutableCopy];
                NSString* senderID = [[tmp objectForKey:@"others"] objectForKey:@"senderID"];
                
                [userDC profileDetails:[senderID integerValue]
                           withSuccess:^(Friend *aFriend) {
                               ChatViewController* chatVC = [[ChatViewController alloc] init];
                               chatVC.user = aFriend;
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   TopNavigationController *nav = (TopNavigationController  *)self.tabBarController.viewControllers[2];


                                   if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad)
                                   {
                                       int tmp = [self.tabBarController selectedIndex];
                                       TopNavigationController *navSelected = (TopNavigationController  *)self.tabBarController.viewControllers[tmp];
                                       [navSelected gridMenuDidTapOnBackground:nav.gridMenu];
                                           

                                       
                                       
                                       if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isChatView"]) {
                                           NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                                           NSInteger currentFriendID = [defaults integerForKey:@"currentSelectedFriendID"];
                                           if (currentFriendID != [senderID integerValue]){
                                               [(UINavigationController *)[[APP_DELEGATE tabBarController] selectedViewController] pushViewController:chatVC animated:YES];
                                               [[[APP_DELEGATE tabBarController] tabBar] setHidden:YES];
                                           }
                                       } else{
                                       
                                           [(UINavigationController *)[[APP_DELEGATE tabBarController] selectedViewController] pushViewController:chatVC animated:YES];
                                           [[[APP_DELEGATE tabBarController] tabBar] setHidden:YES];
                                       }
                                       
                                   }
                                   else
                                   {
                                       int tmp = [self.tabBarController selectedIndex];
                                       if (tmp != 2)
                                       {
                                           TopNavigationController *navSelected = (TopNavigationController  *)self.tabBarController.viewControllers[tmp];
                                           [navSelected gridMenuDidTapOnBackground:nav.gridMenu];
                                           
                                       }
                                       
                                       UISplitViewController *split = (UISplitViewController *)self.tabBarController.viewControllers[2];
                                       TopNavigationController *nav = (TopNavigationController *)split.viewControllers[0];
                                       MessagesViewController *msg = (MessagesViewController *)nav.viewControllers[0];
                                       if ([self.tabBarController selectedIndex] != 2)
                                       {
                                           
                                           if (![nav isProfileMenuViewHidden]){
                                               [nav hideProfileMenu];
                                               
                                           }
                                           [msg setSelectedFriend:aFriend];
                                           
                                           [self.tabBarController setSelectedIndex:2];
                                           if ([self.tabBarController selectedIndex] != 2)
                                           {
                                               
                                               //                                       if (![nav isProfileMenuViewHidden])
                                               [nav gridMenuDidTapOnBackground:nav.gridMenu];
                                               
                                           }

                                       }
                                       else
                                       {
                                           
                                       }
                                       
                                   }
                                   
                                   
                               });
                               
                               
                           } failure:^(NSError *error) {
                               
//                               UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                               [alertView show];
                               
//                                                  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                           }];
                
            }
            
        }

    }
    else if (alertView.tag == FRIENDPUSH){
        if (buttonIndex == 1) {
            [TopNavigationController addTabBarController];
            TopNavigationController *nav = (TopNavigationController  *)self.tabBarController.viewControllers[1];
            RequestsViewController *rVC = nav.viewControllers[0];
            [rVC friendTypeButtonPressed:rVC.friendsButtons[0]];
            [[self tabBarController] setSelectedIndex:1];
        }
    
    }
}

- (NSString*)getCurrentDateInfo:(int)addDate {
    NSDate *date = [NSDate date]; // your date from the server will go here.
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = addDate;
    NSDate *newDate = [calendar dateByAddingComponents:components toDate:date options:0];
    
    NSDateComponents *newComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday  fromDate:newDate];
    NSInteger day = [newComponents day];
    NSInteger month = [newComponents month] - 1;
//    NSInteger year = [components year];
    NSInteger weekday = [newComponents weekday] - 1;
    NSString *strDateInfo = [NSString stringWithFormat:@"%@, %@ %d", [aryWeekday objectAtIndex:weekday], [aryMonth objectAtIndex:month], (int)day];
    return strDateInfo;
}
- (NSString*)getDateValue:(int)addDate {
    NSDate *date = [NSDate date]; // your date from the server will go here.
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = addDate;
    NSDate *newDate = [calendar dateByAddingComponents:components toDate:date options:0];
    
    NSDateComponents *newComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday  fromDate:newDate];
    NSInteger day = [newComponents day];
    NSInteger month = [newComponents month];
    NSInteger year = [newComponents year];
    NSString *strDateInfo = [NSString stringWithFormat:@"%04d-%02d-%02d", (int)year, (int)month, (int)day];
    return strDateInfo;
}
- (NSString*)getCurrentDateInfoFromString:(NSString*)str {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter dateFromString:str];
    
    NSDateComponents *newComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday  fromDate:date];
    NSInteger day = [newComponents day];
    NSInteger month = [newComponents month] - 1;
    //    NSInteger year = [components year];
    NSInteger weekday = [newComponents weekday] - 1;
    NSString *strDateInfo = [NSString stringWithFormat:@"%@, %@ %d", [aryWeekday objectAtIndex:weekday], [aryMonth objectAtIndex:month], (int)day];
    return strDateInfo;
}
- (NSArray*)getTimeArray {
    return [NSArray arrayWithArray:aryTime];
}
- (NSString*)getTimeValue:(int)index {
    if (index >= aryTime.count)
        return @"";
    
    return [aryTime objectAtIndex:index];
}
- (NSArray*)getPeriodArray {
    return [NSArray arrayWithArray:aryPeriod];
}
- (NSString*)getPeriodValue:(int)index {
    if (index >= aryPeriod.count)
        return @"";
    
    return [aryPeriod objectAtIndex:index];
}
- (NSString*)getValue:(NSUInteger)component :(NSUInteger)row {
    if (component == 1) {
        return [NSString stringWithFormat:@"%02d", (int)row + 1];
    } else if (component == 2) {
        if (row == 0) {
            return @"00";
        } else {
            return @"30";
        }
    } else if (component == 3) {
        if (row == 0) {
            return @"AM";
        } else {
            return @"PM";
        }
    } else {
        return @"";
    }
}
@end
