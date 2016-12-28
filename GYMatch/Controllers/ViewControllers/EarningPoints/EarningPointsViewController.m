//
//  EarningPointsViewController.m
//  GYMatch
//
//  Created by Netdroid-Apple on 12/9/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "EarningPointsViewController.h"

@interface EarningPointsViewController ()

@end

@implementation EarningPointsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Earning Points";
    
    //[self.navigationController setNavigationBarHidden:YES];
    
    Checkin_Lbl.layer.cornerRadius=10.0f;
    ConnectInterect_Lbl.layer.cornerRadius=10.0f;
    Invitefriends_Lbl.layer.cornerRadius=10.0f;
    Referatrainer_Lbl.layer.cornerRadius=10.0f;
    ReferagymStudio_Lbl.layer.cornerRadius=10.0f;
    Referabusiness_Lbl.layer.cornerRadius=10.0f;
    UpgradetoSpotlight_Lbl.layer.cornerRadius=10.0f;
    Createaprofile_Lbl.layer.cornerRadius=10.0f;
    
    //Here masksToBounds and clipsToBounds work same...!!!
    //Checkin_Lbl.clipsToBounds = YES;

    Checkin_Lbl.layer.masksToBounds = YES;
    ConnectInterect_Lbl.layer.masksToBounds = YES;
    Invitefriends_Lbl.layer.masksToBounds = YES;
    Referatrainer_Lbl.layer.masksToBounds = YES;
    ReferagymStudio_Lbl.layer.masksToBounds = YES;
    Referabusiness_Lbl.layer.masksToBounds = YES;
    UpgradetoSpotlight_Lbl.layer.masksToBounds = YES;
    Createaprofile_Lbl.layer.masksToBounds = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//- (IBAction)backButtonPressed:(id)sender {
//    [self.navigationController setNavigationBarHidden:NO];
//    [self.navigationController popViewControllerAnimated:YES];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
