//
//  TrainingSeesionTimeViewController.m
//  GYMatch
//
//  Created by Ram Gautam on 10/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "TrainingSeesionTimeViewController.h"
#import "calenderVC.h"

@interface TrainingSeesionTimeViewController () {
    int timeType;
    
    __weak IBOutlet UILabel *lblTime;
    __weak IBOutlet UIButton *btnDone;
    
    __weak IBOutlet UIPickerView *pickerView;
}

@end

@implementation TrainingSeesionTimeViewController

- (id)init{
    
    NSString *nibName = @"TrainingSeesionTimeViewController";
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        nibName = @"TrainingSeesionTimeViewController_iPad";
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
    
    
    pickerView.delegate = self;
    pickerView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:[NSDate date]];
    int hour = (int)[components hour];
    int mins = (int)[components minute];
    int index = hour * 2 + (mins / 30) % 2 + 1;
    if (index > [APP_DELEGATE getTimeArray].count)
        index -= [APP_DELEGATE getTimeArray].count;
    [pickerView selectRow:index inComponent:0 animated:NO];
    
    if (timeType == Training_Seesion_Begin_Time || timeType == Multiple_Training_Seesion_Begin_Time) {
        [lblTime setText:@"Start Time"];
    } else if (timeType == Training_Seesion_End_Time || timeType == Multiple_Training_Seesion_End_Time) {
        [lblTime setText:@"End Time"];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 5;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 1)
        return 12;
    else if (component == 2)
        return 2;
    else if (component == 3)
        return 2;
    else
        return 0;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [APP_DELEGATE getValue:component :row];
}

- (IBAction)actionDone:(id)sender {
    NSUInteger row1 = [pickerView selectedRowInComponent:1];
    NSUInteger row2 = [pickerView selectedRowInComponent:2];
    NSUInteger row3 = [pickerView selectedRowInComponent:3];
    [self.delegate setSessionTime:timeType :[NSString stringWithFormat:@"%@:%@ %@", [APP_DELEGATE getValue:1 :row1], [APP_DELEGATE getValue:2 :row2], [APP_DELEGATE getValue:3 :row3]]];
    [self dismissViewControllerAnimated:NO completion:^{
        if (timeType == Multiple_Training_Seesion_Begin_Time) {
            [self.delegate showMultipleSessionEndTime];
        } else if (timeType == Multiple_Training_Seesion_End_Time) {
            [self.delegate updateMultipleSessionDate];
        }
    }];
}

- (void)setType:(int)type {
    timeType = type;
}

@end
