//
//  SplashViewController.m
//  GYMatch
//
//  Created by Ram Gautam on 10/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "SplashViewController.h"
#import "UserDataController.h"
#import "SpotlightDataController.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

- (id)init{
    
    NSString *nibName = @"SplashViewController";
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        nibName = @"SplashViewController_iPad";
    }
    
    self = [self initWithNibName:nibName bundle:[NSBundle mainBundle]];
    
    if (self) {
        
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    
    // Hide splash after some time.
    [self performSelector:@selector(animateSplash) withObject:nil afterDelay:1.0f];
}

#pragma mark - Animation

- (void)dismissSplash:(UIView *)view {
    
    UserDataController *uDC = [UserDataController new];
    
    if ([uDC isUserLoggedIn]) {
        
        [uDC profileDetails:[APP_DELEGATE loggedInUser].ID withSuccess:^(Friend *aFriend) {
            
            NSDictionary *req = @{@"user_id": [NSString stringWithFormat:@"%ld", (long)[APP_DELEGATE loggedInUser].ID]};
            SpotlightDataController *sDC = [SpotlightDataController new];
            [sDC getUserType:req withSuccess:^(NSDictionary *spotlight) {
                ((AppDelegate*)[UIApplication sharedApplication].delegate).strUserType = [NSString stringWithFormat:@"%@", spotlight[@"user_type"]];
            } failure:^(NSError *error) {
                
            }];
            
            User *tempUser = (User *)aFriend;
            tempUser.username = [APP_DELEGATE loggedInUser].username;
//            tempUser.password = [APP_DELEGATE loggedInUser].password;
            
            [APP_DELEGATE setLoggedInUser:tempUser];
            
            [TopNavigationController addTabBarController];
            
//            [[[APP_DELEGATE tabBarController] view]addSubview:view];
            
        } failure:^(NSError *error) {

//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Please try later!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alertView show];
            
            [TopNavigationController addLoginNavigationController];
            
//            [[[APP_DELEGATE navigationController] view]addSubview:view];
            
        }];
        
    }else{
        
        [TopNavigationController addLoginNavigationController];
        
//        [[[APP_DELEGATE navigationController] view]addSubview:view];
    }
    
}

- (void)animateSplash{
    
    UIImage *image = [SplashViewController imageWithView:self.view];
    UIImageView *view = [[UIImageView alloc]initWithImage:image];
    
    [self dismissSplash:(UIView *)view];
    
    return;
    CGRect frame = view.frame;
    frame.origin.x = frame.size.width;
    
    
    
    [UIView animateWithDuration:0.5 animations:^{
//        view.frame = frame;
        [view setAlpha:0.0];
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];

}

+ (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

@end
