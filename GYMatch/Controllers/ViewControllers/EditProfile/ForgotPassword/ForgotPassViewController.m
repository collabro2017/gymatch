//
//  ForgotPassViewController.m
//  gymatch
//
//  Created by Ram on 20/05/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "ForgotPassViewController.h"
#import "MBProgressHUD.h"
#import "UserDataController.h"

@interface ForgotPassViewController ()

@end

@implementation ForgotPassViewController

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
    
    [self.navigationItem setTitle:@"Forgot Password"];
    instructionLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:15.0f];
    [emailTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)forgotPassword:(UIButton *)sender {
    
    [emailTextField resignFirstResponder];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    UserDataController *uDC = [UserDataController new];
    
    
    [uDC forgotPass:emailTextField.text withSuccess:^{
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"A reset password link has been sent to your email. Please check your email." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alertView show];
       
        [emailTextField becomeFirstResponder];
    }];
}

@end
