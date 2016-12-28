//
//  MyPointsViewController.m
//  GYMatch
//
//  Created by Netdroid-Apple on 12/10/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "MyPointsViewController.h"

@interface MyPointsViewController ()

@end

@implementation MyPointsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"Points";
    
    [total_Lbl setText:[NSString stringWithFormat:@"$%@",self.points]];
    [creditLeft_Lbl setText:[NSString stringWithFormat:@"$%@",self.points]];
    [oReferralsPoints setText:[NSString stringWithFormat:@"$%@",self.oRefferalPointsStr]];

    if (!self.isSelfUser) {
        redeemButton.hidden = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    if (!self.isSelfUser) {
//        NSString *message = @"Please access your profile from Desktop to redeem points...";
//
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alertView show];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)redeemBtnClicked:(id)sender
{
    
    //after existing defects----
    
    NSString *message = @"Please access your profile from Desktop to redeem points...";
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    

//    if (self.isSelfUser) {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://gymatch.com/redeem"]];
//    }
//    else
//    {
//        //@"Please access your profile to redeem points for exciting prizes and spotlight time!"
//        NSString *message = @"Please access your profile from Desktop to redeem points...";
//
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alertView show];
//    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
