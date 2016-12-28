//
//  RecommendViewController.m
//  GYMatch
//
//  Created by Ram Gautam on 11/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "RecommendViewController.h"
#import "AddGymViewController.h"

@interface RecommendViewController ()

@end

@implementation RecommendViewController

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
    
    [self.navigationItem setTitle:@"Recommend"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)recommendButtonPressed:(id)sender {

}

- (IBAction)addGymButtonPressed:(id)sender {
    AddGymViewController *aGVC = [[AddGymViewController alloc]init];
    [self.navigationController pushViewController:aGVC animated:YES];
}
@end
