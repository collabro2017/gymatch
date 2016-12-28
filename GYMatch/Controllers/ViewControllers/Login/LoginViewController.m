//
//  LoginViewController.m
//  GYMatch
//
//  Created by Ram Gautam on 10/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "EditProfileViewController.h"
#import "UserDataController.h"
#import "User.h"
#import "MBProgressHUD.h"
#import "ForgotPassViewController.h"
#import "Utility.h"
#import "SpotlightDataController.h"
#import "AppDelegate.h"

@interface LoginViewController (){
    BOOL lauchFlag;
    NSInteger retryCount;
    id FBresultData;
}

@end

@implementation LoginViewController

- (void)dealloc{
    [self removeKBN];
}

- (id)init{
    
    NSString *nibName = @"LoginViewController";
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        nibName = @"LoginViewController_iPad";
    }
    
    self = [self initWithNibName:nibName bundle:[NSBundle mainBundle]];
    
    if (self) {
        [usernameTextField setEmailField:YES];
        [passwordTextField setRequired:YES];
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[APP_DELEGATE navigationController] addLogoToNavigation];
    lauchFlag = 0;
    [APP_DELEGATE setAutomaticPushAfterRegister:NO];
    [[[APP_DELEGATE navigationController] navigationBar] setHidden:YES];
    
    [self decorate];
    
    textFieldsView.layer.cornerRadius = 3.0f;
    
    [self registerKBN];
}


- (void)decorate
{
    CGFloat multiplier = 1.0f;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        multiplier = 1.5f;
    }
    
    rememberMeCheckButton.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:12.0f * multiplier];
    
    forgotPasswordButton.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:12.0f * multiplier];
    fbLoginButton.titleLabel.font  = [UIFont fontWithName:@"ProximaNova-Regular" size:14.0f * multiplier];
    loginButton.titleLabel.font    = [UIFont fontWithName:@"ProximaNova-Regular" size:14.0f * multiplier];
    registerButton.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:14.0f * multiplier];

    
    notMemberLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:18.0f * multiplier];

    usernameTextField.font = [UIFont fontWithName:@"ProximaNova-Regular" size:13.0f * multiplier];
    passwordTextField.font = [UIFont fontWithName:@"ProximaNova-Regular" size:13.0f * multiplier];
    
    usernameTextField.layer.borderWidth  = 0;
    passwordTextField.layer.borderWidth  = 0;
    usernameTextField.layer.cornerRadius = 0;
    passwordTextField.layer.cornerRadius = 0;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:PASSWORD]; 
    [[NSUserDefaults standardUserDefaults] synchronize];


  /*  // for testing only
    usernameTextField.text = @"Mike P";// @"Karan"; //@"Mike P";// @"Leila"; //@"Gari";
    passwordTextField.text = @"123456";
    [self performSelector:@selector(loginButtonPressed:) withObject:nil afterDelay:0.1f]; */

}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [[APP_DELEGATE navigationController] setNavigationBarHidden:YES animated:YES];
    
    
//    if (lauchFlag) {
//        [loginLogoImageView setHidden:NO];
//        [[APP_DELEGATE navigationController].gymLogoImageView setHidden:YES];
//        
//    }else{
//        [loginLogoImageView setHidden:YES];
//        [self performSelector:@selector(showLogo) withObject:nil afterDelay:0.5];
//        lauchFlag = 1;
////        [[APP_DELEGATE navigationController].gymLogoImageView setHidden:YES];
//    }

    if([APP_DELEGATE automaticPushAfterRegister])
    {
        [APP_DELEGATE setAutomaticPushAfterRegister:NO];
         [TopNavigationController addLoginNavigationController];
    }
}

- (void)showLogo{
    [loginLogoImageView setHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBActions

- (IBAction)forgotPassButtonPressed:(id)sender {
    [self.view endEditing:YES];
    ForgotPassViewController *fPVC = [ForgotPassViewController new];
    
    [[APP_DELEGATE navigationController] setNavigationBarHidden:NO animated:YES];
    [self.navigationController pushViewController:fPVC animated:YES];
}

- (IBAction)loginButtonPressed:(id)sender{
    
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:API_URL_BASE]];
    for (NSHTTPCookie *cookie in cookies)
    {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Login Successful"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Ok", nil];
    
    if (![self validateInputInView:self.view]){
        
        [alertView setMessage:@"Invalid information please review and try again!"];
        [alertView setTitle:@"Login Failed"];
        
        [alertView show];
        
    }else{
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        User *user = [User new];
        user.username = usernameTextField.text;
        user.password = passwordTextField.text;
        [[NSUserDefaults standardUserDefaults] setObject:passwordTextField.text forKey:PASSWORD];
        [[NSUserDefaults standardUserDefaults] synchronize];
        user.isRemeberOn = rememberMeCheckButton.selected;
        
        UserDataController *uDC = [UserDataController new];
        uDC.user = user;
        
        [uDC loginWithSuccess:^(User *user) {
            
            [APP_DELEGATE setLoggedInUser:user];
                        
             // NSLog(@"%@",user.password);
            [uDC profileDetails:user.ID withSuccess:^(Friend *aFriend) {
                
                User *tempUser = (User *)aFriend;
                tempUser.username = [APP_DELEGATE loggedInUser].username;
                // tempUser.password = [APP_DELEGATE loggedInUser].password;
                
                NSDictionary *req = @{@"user_id": [NSString stringWithFormat:@"%ld", (long)user.ID]};
                SpotlightDataController *sDC = [SpotlightDataController new];
                [sDC getUserType:req withSuccess:^(NSDictionary *spotlight) {
                    ((AppDelegate*)[UIApplication sharedApplication].delegate).strUserType = [NSString stringWithFormat:@"%@", spotlight[@"user_type"]];
                } failure:^(NSError *error) {
                    
                }];
                
                [APP_DELEGATE setLoggedInUser:tempUser];
                MessageDataController *mDC = [MessageDataController new];
                
                if ([APP_DELEGATE loggedInUser].ID != 0) {                 
                    
                    [mDC unreadMessagesWithUserID:[APP_DELEGATE loggedInUser].ID withSuccess:^(NSInteger count) {
                        NSLog(@"Unread counts: %ld", (long)count);
                        if (count) {
                            NSString *countString = [NSString stringWithFormat:@"%ld", (long)count];
                            UITabBarItem *messagesTBI = [[[APP_DELEGATE tabBarController] viewControllers][2] tabBarItem];
                            [messagesTBI setBadgeValue:countString];
                        }
                    } failure:^(NSError *error) {
                        
                        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alertView show];
                    }];
                }

                
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
                if (rememberMeCheckButton.selected) {
                    [uDC rememberUser:user];
                }else{
                    [uDC forgetUser];
                }
                
                [TopNavigationController addTabBarController];
                
            } failure:^(NSError *error) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:PASSWORD];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [alertView setMessage:@"Please try later!"];
                [alertView setTitle:nil];
                [alertView show];
                
            }];
            
        } failure:^(NSError *error) {
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSString *msg = error.localizedDescription;
            if(error.code == -1003)
                msg = @"The Internet connection appears to be offline.";
            [alertView setMessage:msg];
            [alertView setTitle:@"Login Failed"];
            [alertView show];
            
        }];
    }
}


-(void)loginAfterRegistrationWithUserName:(NSString*)userName andPassword:(NSString*)password
{
    usernameTextField.text = userName;
    passwordTextField.text = password;
    [self loginButtonPressed:nil];
}

- (IBAction)registerButtonPressed:(UIButton *)sender {
    [self.view endEditing:YES];
    RegisterViewController *rVC = [[RegisterViewController alloc] init];
    rVC.isFromFacebook = false;
    rVC.lVCont = self; 
//    [loginLogoImageView setHidden:YES];
//    [[APP_DELEGATE navigationController].gymLogoImageView setHidden:NO];
    
    [[APP_DELEGATE navigationController] setNavigationBarHidden:NO animated:YES];
    [self.navigationController pushViewController:rVC animated:YES];
}

- (void)loginWithFacebook:(NSString *)fbID email:(NSString *)email{
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:API_URL_BASE]];
    for (NSHTTPCookie *cookie in cookies)
    {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Login Successful"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Ok", nil];
    
    User *user = [User new];
    user.isRemeberOn = rememberMeCheckButton.selected;
    
    UserDataController *uDC = [UserDataController new];
    uDC.user = user;
    
    [uDC fbLoginWithID:fbID email:email success:^(User *user) {
        
        [APP_DELEGATE setLoggedInUser:user];
        
        [uDC profileDetails:user.ID withSuccess:^(Friend *aFriend) {
            
            User *tempUser = (User *)aFriend;
            tempUser.username = [APP_DELEGATE loggedInUser].username;
            //                tempUser.password = [APP_DELEGATE loggedInUser].password;
            
            [APP_DELEGATE setLoggedInUser:tempUser];
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            if (rememberMeCheckButton.selected) {
                [uDC rememberUser:user];
            }
            else
            {
                [uDC forgetUser];
            }
            
            [TopNavigationController addTabBarController];
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSLog(@"%@",error.localizedDescription);
            [alertView setMessage:@"Please try later!"];
            [alertView setTitle:@""];
            [alertView show];
            
        }];
    }
    failure:^(NSError *error) {
        // if account is not linked with GYMatch web site
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Thank you"
                                                            message:@"Please Edit/Complete profile"
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        alertView.tag = 100;
        [alertView show];
    }];
}

- (BOOL)validateInputInView:(UIView*)view
{
    for(UIView *subView in view.subviews){
        if ([subView isKindOfClass:[UIScrollView class]])
            return [self validateInputInView:subView];
        
        if ([subView isKindOfClass:[MHTextField class]]){
            if (![(MHTextField*)subView validate]){
                return NO;
            }
        }
    }
    
    return YES;
}

- (IBAction)loginWithFBPressed:(UIButton *)sender {
    [FBSession.activeSession closeAndClearTokenInformation];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        [FBSession.activeSession closeAndClearTokenInformation];
        [self makeGraphAPICall];
        
        // If the session state is not any of the two "open" states when the button is clicked
    } else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for basic_info permissions when opening a session
        [self requestPermission];
    }
    
}

#pragma mark - FB Graph API Call & Error handling.

- (void)makeGraphAPICall {
    // We will use retryCount as part of the error handling logic for errors that need retries
    retryCount = 0;
    // FBRequestConnection example API call to me

    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // Success! Include your code to handle the results here
            NSLog(@"user info: %@", result);
            FBresultData = result;

            [self loginWithFacebook:[result valueForKey:@"id"] email:[result valueForKey:@"email"]];

        } else {
            // An error occurred, we need to handle the error
            // See: https://developers.facebook.com/docs/ios/errors

            [self handleAPICallError:error];

            dispatch_async(dispatch_get_main_queue(), ^{

                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            });
        }
    }];

}

- (void)requestPermission{

    // FBRequestConnection example API call to me
    [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email", @"user_friends"]
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {

         NSLog(@"Session Details: %@", session);

         // Retrieve the app delegate
         
         // Call the app delegate's sessionStateChanged:state:error method to handle session state changes


         [APP_DELEGATE sessionStateChanged:session state:state error:error];
         if (!error && state == FBSessionStateOpen) {
             [self makeGraphAPICall];
         }
         else {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         }
     }];
}

- (void)handleAPICallError:(NSError *)error
{

    NSLog(@"%@",error.localizedDescription);


    // If the user has removed a permission that was previously granted
    if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryPermissions) {
        NSLog(@"Re-requesting permissions");
        // Ask for required permissions.
        [self requestPermission];
        return;
    }
    
    // Some Graph API errors need retries, we will have a simple retry policy of one additional attempt
    // We also retry on a throttling error message, a more sophisticated app should consider a back-off period
    retryCount++;
    if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryRetry ||
        [FBErrorUtility errorCategoryForError:error] == FBErrorCategoryThrottling) {
        if (retryCount < 2) {
            NSLog(@"Retrying open graph post");
            // Recovery tactic: Call API again.
            [self makeGraphAPICall];
            return;
        } else {
            NSLog(@"Retry count exceeded.");
            return;
        }
    }
    
    // For all other errors...
    NSString *alertText;
    NSString *alertTitle;
    
    // If the user should be notified, we show them the corresponding message
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Something Went Wrong";
        alertText = [FBErrorUtility userMessageForError:error];
        
    } else {
        // show a generic error message
        NSLog(@"Unexpected error posting to open graph: %@", error);
        alertTitle = @"Something went wrong";
        alertText = @"Please try again later.";
    }
    [self showMessage:alertText withTitle:alertTitle];
}

- (void)showMessage:(NSString *)text withTitle:(NSString *)title
{
    [[[UIAlertView alloc] initWithTitle:title
                                message:text
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 100) {
        RegisterViewController *rVC = [[RegisterViewController alloc] init];
        EditProfileViewController *editProfile = [[EditProfileViewController alloc]init];
        

        //Setup Data
        rVC.lVCont = self;
        editProfile.isFromFacebook = true;
        if (![Utility isNull:[FBresultData objectForKey:@"email"]]) {
            editProfile.strfb_Email = [FBresultData objectForKey:@"email"];
        }

        if (![Utility isNull:[FBresultData objectForKey:@"gender"]]) {
            editProfile.strfb_Gender = [FBresultData objectForKey:@"gender"];
        }

        if (![Utility isNull:[FBresultData objectForKey:@"name"]]) {
            editProfile.strfb_UserName = [FBresultData objectForKey:@"name"];
        }

        if (![Utility isNull:[FBresultData objectForKey:@"id"]]) {
            editProfile.strfb_Id = [FBresultData objectForKey:@"id"];
        }

        [[APP_DELEGATE navigationController] setNavigationBarHidden:NO animated:YES];
     //  [self.navigationController pushViewController:rVC animated:YES];
        [self.navigationController pushViewController:editProfile animated:YES];

    }
}

#pragma mark - UIKeyboard notifications

- (void)registerKBN{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeKBN{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) keyboardWillShow:(NSNotification *) notification{
    
    NSDictionary *userInfo = [notification userInfo];
    CGRect kbRect = [[userInfo valueForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    [UIView animateWithDuration:0.3f animations:^{
        
        [scrollView setContentInset:UIEdgeInsetsMake(0, 0, kbRect.size.height, 0)];
        
    }];
    
}

- (void) keyboardWillHide:(NSNotification *) notification{
    
    [UIView animateWithDuration:0.3f animations:^{
        
        [scrollView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }];
}

#pragma mark - UIText field

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == usernameTextField) {
        [passwordTextField becomeFirstResponder];
    }
    else {
        [passwordTextField resignFirstResponder];
        [self loginButtonPressed:loginButton];
    }
    
    return YES;
}

@end
