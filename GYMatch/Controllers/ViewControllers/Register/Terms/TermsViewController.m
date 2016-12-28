//
//  TermsViewController.m
//  GYMatch
//
//  Created by Ram on 18/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "TermsViewController.h"

@interface TermsViewController ()

@end

@implementation TermsViewController

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
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"GYMatch_Terms_and_Conditions_Agreement_06-24-2013" ofType:@"pdf"];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"terms" ofType:@"html"];
    NSURL *targetURL = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [webView loadRequest:request];
    [termsLabel setFont:[UIFont fontWithName:@"ProximaNova-Semibold" size:13.0f]];
    
    [self attachPopUpAnimation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) attachPopUpAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation
                                      animationWithKeyPath:@"transform"];
    
    CATransform3D scale1 = CATransform3DMakeScale(1.3, 1.3, 1);
    CATransform3D scale2 = CATransform3DMakeScale(1.1, 1.1, 1);
    CATransform3D scale3 = CATransform3DMakeScale(1.0, 1.0, 1);
    CATransform3D scale4 = CATransform3DMakeScale(1.0, 1.0, 1);
    
    NSArray *frameValues = [NSArray arrayWithObjects:
                            [NSValue valueWithCATransform3D:scale1],
                            [NSValue valueWithCATransform3D:scale2],
                            [NSValue valueWithCATransform3D:scale3],
                            [NSValue valueWithCATransform3D:scale4],
                            nil];
    [animation setValues:frameValues];
    
    NSArray *frameTimes = [NSArray arrayWithObjects:
                           [NSNumber numberWithFloat:0.0],
                           [NSNumber numberWithFloat:0.5],
                           [NSNumber numberWithFloat:0.9],
                           [NSNumber numberWithFloat:1.0],
                           nil];
    [animation setKeyTimes:frameTimes];
    
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = .2;
    
    [self.view.layer addAnimation:animation forKey:@"popup"];
    
    self.view.alpha = 0.0f;
    [UIView animateWithDuration:0.2f animations:^{
        self.view.alpha = 1.0f;
    }];
}

#pragma mark - IBActions

- (IBAction)doneButtonPressed:(UIButton *)sender {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
//    [self dismissViewControllerAnimated:YES completion:^{
//        
//    }];
}


@end
