//
//  LoginViewController.h
//  GYMatch
//
//  Created by Ram Gautam on 10/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHTextField.h"
#import "CheckButton.h"
#import "MessageDataController.h"
#import "MessagesViewController.h"


@interface LoginViewController : UIViewController
<UITextFieldDelegate, UIAlertViewDelegate>
{
    __weak IBOutlet MHTextField *usernameTextField;
    
    __weak IBOutlet MHTextField *passwordTextField;
    
    __weak IBOutlet CheckButton *rememberMeCheckButton;
    
    __weak IBOutlet UIImageView *loginLogoImageView;
    
    __weak IBOutlet UIView *textFieldsView;
    
    __weak IBOutlet UIButton *forgotPasswordButton;
    
    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UIButton *loginButton;
    __weak IBOutlet UIButton *fbLoginButton;
    __weak IBOutlet UIButton *registerButton;
    __weak IBOutlet UILabel *notMemberLabel;
    
    __weak IBOutlet UIImageView *gradientImageView;
}

-(void)loginAfterRegistrationWithUserName:(NSString*)userName andPassword:(NSString*)password;

@end
