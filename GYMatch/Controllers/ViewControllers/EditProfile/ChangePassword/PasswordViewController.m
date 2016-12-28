//
//  PasswordViewController.m
//  GYMatch
//
//  Created by Ram on 06/05/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "PasswordViewController.h"
#import "MBProgressHUD.h"
#import "UserDataController.h"
#import "ForgotPassViewController.h"

@interface PasswordViewController ()

@end

@implementation PasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    newPasswordStr = @"";
    [self.navigationItem setTitle:@"Change Password"];
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        topConstraints.constant = 115;
  /*  UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    [self.navigationItem setRightBarButtonItem:barButton]; */ 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)isValidFields{
    
    BOOL success;
    
    NSString *errorMessage;
    NSLog(@"Password - %@",[[NSUserDefaults standardUserDefaults] objectForKey:PASSWORD]);
    if ([currentPasswordTF.text isEqualToString:@""]) {
        errorMessage = NSLocalizedString(@"Please enter Current Password.", @"");
        success = NO;
    }else if ([newPasswordTF.text isEqualToString:@""]) {
        errorMessage = NSLocalizedString(@"Please enter New Password.", @"");
        success = NO;
    }else if (![currentPasswordTF.text isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:PASSWORD]]){
        errorMessage = NSLocalizedString(@"Wrong current Password.", @"");
        success = NO;
    }else if ([confirmPasswordTF.text isEqualToString:@""]) {
        errorMessage = NSLocalizedString(@"Please enter Confirm Password.", @"");
        success = NO;
    }else if (![newPasswordTF.text isEqualToString:confirmPasswordTF.text]) {
        errorMessage = NSLocalizedString(@"New Password and Confirm Password do not match.", @"");
        success = NO;
    }else{
        success = TRUE;
    }


    if (!success) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Alert!" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        alertView = nil;
    }
    return success;
}


#pragma mark - IBActions

- (IBAction)changePasswordButtonPressed:(id)sender{

    if (![self isValidFields]) {
        return;
    }

    newPasswordStr = newPasswordTF.text;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *requestDictionary = [NSMutableDictionary dictionary];
    
    [requestDictionary setObject:currentPasswordTF.text forKey:@"current_password"];
    [requestDictionary setObject:newPasswordTF.text forKey:@"new_password"];
    
    UserDataController *uDC = [UserDataController new];
    
    [uDC changePasswordWithDictionary:requestDictionary withSuccess:^{

        [[NSUserDefaults standardUserDefaults] setObject:newPasswordStr forKey:PASSWORD];
        [[NSUserDefaults standardUserDefaults] synchronize];

        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Password Updated" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
        alertView = nil;
        
    }];
    
}

- (IBAction)forgotPassButtonPressed:(id)sender{
    ForgotPassViewController *forgotPVC = [ForgotPassViewController new];
    [self.navigationController pushViewController:forgotPVC animated:YES];
}

@end
