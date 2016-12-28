//
//  ReportViewController.m
//  GYMatch
//
//  Created by Ram Gautam on 11/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "ReportViewController.h"
#import "UserDataController.h"
#import "MBProgressHUD.h"

@interface ReportViewController (){
    NSArray *objections;
    NSInteger selectedIndex;
}

@end

@implementation ReportViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        objections = @[@"This profile contains objectional content",
                       @"This person uses abusive language",
                       @"I'm being harassed",
                       @"This is a fake profile"];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationItem setTitle:@"Report"];
    [self decorate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)decorate{
    titleLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:16.0f];
}

#pragma mark - IBActions

- (IBAction)reportButtonPressed:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *requestDictionary = [NSMutableDictionary dictionary];
    
    [requestDictionary setObject:[NSNumber numberWithInteger:self.userID] forKey:@"user_id"];
    [requestDictionary setObject:objections[selectedIndex] forKey:@"reason"];
    
    UserDataController *uDC = [UserDataController new];
    
    [uDC reportWithDictionary:requestDictionary withSuccess:^ {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Your report has been submitted." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
        alertView = nil;
    }];
}

#pragma mark - UIPickerView data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [objections count];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel* tView = (UILabel*)view;
    
    if (!tView){
        tView = [[UILabel alloc] init];
        [tView setTextAlignment:NSTextAlignmentCenter];
        // Setup label properties - frame, font, colors etc
        [tView setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:16.0f]];
    }
    // Fill the label text here
    tView.text = [objections objectAtIndex:row];
    
    return tView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    selectedIndex = row;
}



@end
