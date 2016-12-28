//
//  SpotlightsFilterViewController.m
//  GYMatch
//
//  Created by victor on 4/7/15.
//  Copyright (c) 2015 xtreem. All rights reserved.
//

#import "SpotlightsFilterViewController.h"
#import "UserDataController.h"
#import "MBProgressHUD.h"
#import "Country.h"

@interface SpotlightsFilterViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@end

@implementation SpotlightsFilterViewController {
    NSMutableArray *aryGender;
    NSMutableArray *aryCountry;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    aryGender = [NSMutableArray arrayWithObjects:@"Male", @"Female", @"Both", nil];
    
    self.pickerGender.delegate = self;
    self.pickerGender.dataSource = self;
    self.pickerGender.tag = 100;
    
    self.pickerCountry.delegate = self;
    self.pickerCountry.dataSource = self;
    self.pickerCountry.tag = 200;
    
    //    RoundButton *button = [[RoundButton alloc] initWithFrame:CGRectMake(0, 0, 50.0f, 28.0f)];
    //    [button addTarget:self action:@selector(doneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.pickerGender reloadAllComponents];
    [self.txtGender setInputView:self.pickerGender];
    
    UserDataController *uDC = [UserDataController new];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [uDC countries:^(NSArray *countries) {
        aryCountry = [NSMutableArray arrayWithArray:countries];
        
        [self.pickerCountry reloadAllComponents];
        [self.txtCountry setInputView:self.pickerCountry];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[(TopNavigationController *)[[APP_DELEGATE tabBarController] selectedViewController] friendNavigationBar] removeFromSuperview];
    
    [self.navigationItem setTitle:@"Filters"];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:self.buttonDone];
    [barButton setAction:@selector(btnDonePressed:)];
    [barButton setTarget:self];
    [self.navigationItem setRightBarButtonItem:barButton];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [(TopNavigationController *)[[APP_DELEGATE tabBarController] selectedViewController] addFriendNavigationBar];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    int count = 0;
    switch (pickerView.tag) {
        case 100:
            count = (int)aryGender.count;
            break;
        case 200:
            count = (int)aryCountry.count;
            break;
        default:
            break;
    }
    return count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title = @"Hello";
    switch (pickerView.tag) {
        case 100:
            title = [aryGender objectAtIndex:row];
            break;
        case 200:
            //Country cnt = [aryCountry objectAtIndex:row];
            title = ((Country*)[aryCountry objectAtIndex:row]).name;
        default:
            break;
    }
    return title;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (pickerView.tag) {
        case 100:
            self.txtGender.text = [aryGender objectAtIndex:row];
            break;
        case 200:
            self.txtCountry.text = ((Country*)[aryCountry objectAtIndex:row]).name;
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)doneWithDictionary:(NSMutableDictionary *)dictionary
{
 
}

- (IBAction)btnDonePressed:(id)sender {
    
    //NSMutableDictionary *dic = [NSMutableDictionary alloc];
    NSString *name      = self.txtName.text;
    NSString *country   = self.txtCountry.text;
    NSString *state     = self.txtState.text;
    NSString *city      = self.txtCity.text;
    NSString *gender    = self.txtGender.text;
    
    if ([name isEqualToString:@""]) {
        name = @"Select your name";
    }
    if ([country isEqualToString:@""]) {
        country = @"Select your name";
    }
    if ([state isEqualToString:@""]) {
        state = @"Select your name";
    }
    if ([city isEqualToString:@""]) {
        city = @"Select your name";
    }
   // if ([gender isEqualToString:@""]) {
   //     gender = @"Select your name";
   // }
    if ([gender isEqualToString:@"Both"]) {
        gender = @""; 
    }
    if ([name isEqualToString:@"Select your name"] && [country isEqualToString:@"Select your name"] && [city isEqualToString:@"Select your name"] && [gender isEqualToString:@"Select your name"] && [state isEqualToString:@"Select your name"]) {
        name = @"";
        country = @"";
        city = @"";
        state = @"";
        gender = @"";
    }
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:name, @"name", country, @"country", state, @"state", city, @"city", gender, @"gender", nil];
    
    [self.delegate doneWithDictionary:[NSMutableDictionary dictionaryWithDictionary:dic]];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
