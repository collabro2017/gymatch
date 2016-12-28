//
//  AddGymViewController.m
//  GYMatch
//
//  Created by Ram Gautam on 11/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "AddGymViewController.h"
#import "GymDataController.h"

@interface AddGymViewController ()

@end

@implementation AddGymViewController

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

   // self.view.adjustsc
    UIScrollView *scrlView = (UIScrollView*)self.view;
    scrlView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0.0);
    [self.navigationItem setTitle:@"Add Gym"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)addButtonPressed:(id)sender {
    GymDataController *gDC = [GymDataController new];
    
    NSDictionary *requestDictionary = @{
                                        @"biz_name": nameLabelTextField.text,
                                        @"e_address": addressTextField.text,
                                        @"e_city": cityTextFIeld.text,
                                        @"e_state": stateTextField.text,
                                        @"biz_phone": phoneTextField.text,
                                        @"web_url": URLTextField.text,
                                        @"latitude": latitudeTextField.text,
                                        @"longitude": longitudeTextField.text,
                                        @"loc_LAT_poly": latitudeTextField.text,
                                        @"loc_LONG_poly": longitudeTextField.text
                                        };

    [gDC addWithDictionary:requestDictionary withSuccess:^(Gym *gym) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Gym added successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
        [self.delegate didAddGym:gym];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        // error.localizedDescription
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
    }];
    
}

- (IBAction)getCoordinate:(id)sender{
    //http://itouchmap.com/latlong.html
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itouchmap.com/latlong.html"]];
    
}

@end
