//
//  TrainingSeesionPeriodViewController.m
//  GYMatch
//
//  Created by Ram Gautam on 10/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "TrainingSeesionPeriodViewController.h"

#import "calenderVC.h"

@interface TrainingSeesionPeriodViewController () {
    __weak IBOutlet UIScrollView *scrollView;
//    int selectedIndex;
}

@end

@implementation TrainingSeesionPeriodViewController

- (id)init{
    
    NSString *nibName = @"TrainingSeesionPeriodViewController";
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        nibName = @"TrainingSeesionPeriodViewController_iPad";
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)actionDone:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}
- (IBAction)actionSelectPeriod:(id)sender {
    
    for (int i = 11; i <= 16; i++) {
        UIView *subView = (UIView*)[scrollView viewWithTag:i];
        UIImageView* imgView = (UIImageView*)[subView viewWithTag:2];
        [imgView setImage:[UIImage imageNamed:@"ic_uncheck_round.png"]];
    }
    
    UIButton *button = (UIButton*)sender;
    UIView *subView = (UIView*)button.superview;
    int selectedIndex = (int)subView.tag;
    UIImageView* imgView = (UIImageView*)[subView viewWithTag:2];
    [imgView setImage:[UIImage imageNamed:@"ic_check_round.png"]];
    
//    [self.delegate setSessionTime:Training_Session_Period :selectedIndex - 11];
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}


@end
