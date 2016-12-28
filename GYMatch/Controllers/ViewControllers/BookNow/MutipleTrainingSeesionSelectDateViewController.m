//
//  MutipleTrainingSeesionSelectDateViewController.m
//  GYMatch
//
//  Created by Ram Gautam on 10/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "MutipleTrainingSeesionSelectDateViewController.h"
#import "Constants.h"
#import "calenderVC.h"

@interface MutipleTrainingSeesionSelectDateViewController () {
    NSMutableArray *arySelectedDate;
    __weak IBOutlet UIScrollView *scrollView;
    NSDate *selectedDate;
}

@end

@implementation MutipleTrainingSeesionSelectDateViewController

- (id)init {
    
    NSString *nibName = @"MutipleTrainingSeesionSelectDateViewController";
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        nibName = @"MutipleTrainingSeesionSelectDateViewController_iPad";
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
- (void)setInitDate:(NSDate*)date
{
    selectedDate = date;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // AiRin

    arySelectedDate = [NSMutableArray arrayWithArray:@[@"0", @"0", @"0", @"0", @"0", @"0", @"0"]];
    
    NSTimeInterval secondsBetween = [selectedDate timeIntervalSinceDate:[NSDate date]];
    
    int numberOfDays = secondsBetween / 86400;
    
    for (int i = 11; i <= 17; i++) {
        UIView *subView = (UIView*)[scrollView viewWithTag:i];
        UIImageView* imgView = (UIImageView*)[subView viewWithTag:2];
        [imgView setImage:[UIImage imageNamed:@"ic_uncheck_round.png"]];
        
        NSString *strDateInfo = [APP_DELEGATE getCurrentDateInfo:i - 11 + numberOfDays + 2];
        
        UILabel *label = (UILabel*)[subView viewWithTag:3];
        [label setText:strDateInfo];
    }
}
- (IBAction)actionDone:(id)sender {
    [self.delegate setMultipleSessionDate:arySelectedDate];
    for (int i = 0; i < arySelectedDate.count; i++) {
        if ([[arySelectedDate objectAtIndex:i] isEqualToString:@"1"]) {
            [self dismissViewControllerAnimated:NO completion:^{
                [self.delegate showMultipleSessionStartTime];
            }];
            return;
        }
    }
    
    [self dismissViewControllerAnimated:NO completion:^{
    }];
}
- (IBAction)actionCheck:(id)sender {
    UIButton *button = (UIButton*)sender;
    UIView *subView = (UIView*)button.superview;
    int selectedIndex = (int)subView.tag;
    UIImageView* imgView = (UIImageView*)[subView viewWithTag:2];
    
    
    int index = selectedIndex - 11;
    if ([[arySelectedDate objectAtIndex:index] isEqualToString:@"0"]) {
        [arySelectedDate replaceObjectAtIndex:index withObject:@"1"];
        [imgView setImage:[UIImage imageNamed:@"ic_check_round.png"]];
    } else {
        [arySelectedDate replaceObjectAtIndex:index withObject:@"0"];
        [imgView setImage:[UIImage imageNamed:@"ic_uncheck_round.png"]];
    }
    
}

@end
