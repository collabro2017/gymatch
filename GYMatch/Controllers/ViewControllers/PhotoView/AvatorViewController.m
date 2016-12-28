//
//  AvatorViewController.m
//  GYMatch
//
//  Created by victor on 4/14/15.
//  Copyright (c) 2015 xtreem. All rights reserved.
//

#import "AvatorViewController.h"

@interface AvatorViewController ()

@end

@implementation AvatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClicked:)];
    [self.view addGestureRecognizer:gesture];
    
    //[self.navigationController.navigationBar setHidden:YES];
    
    [self initposition];
    
}

-(void)viewClicked : (UITapGestureRecognizer *)gesture {
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:kCATransition];
    [self.view removeFromSuperview];
//    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initposition {
    
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    screenRect.origin.y = 0;
    screenRect.size.height += 20;
    self.background.frame = screenRect;
    
    CGRect rect = self.avator.frame;
    rect.size.width = 250;
    rect.size.height = 250;
    rect.origin.x = (screenRect.size.width - rect.size.width) / 2;
    rect.origin.y = (screenRect.size.height -rect.size.height) / 2 - 50;
    self.avator.frame = rect;
    
    self.avator.layer.cornerRadius = rect.size.width / 2;
    self.avator.layer.masksToBounds = YES;
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.avator.image = self.image;
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
