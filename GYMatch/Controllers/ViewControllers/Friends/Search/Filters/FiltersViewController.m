//
//  FiltersViewController.m
//  GYMatch
//
//  Created by Ram on 01/05/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "FiltersViewController.h"
#import "CheckButton.h"
#import "RoundButton.h"
#import "Utility.h" 
#import "UIImage+Overlay.h"



@interface FiltersViewController (){
    
    NSArray *prefs;
    BOOL prefsStatus[16];
}

@end

@implementation FiltersViewController

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
    
    prefs = [[NSArray alloc] initWithObjects:
             @"Free Weight Training",
             @"Pilates",
             @"Cardio",
             @"Aerobics Classes",
             @"Jogging",
             @"Martial Arts",
             @"Conditioning",
             @"Yoga",
             @"Studio Cycling",
             @"Swimming",
             @"Cross Training",
             @"Boot Camp",
             @"Dancing",
             @"Beach Activities",
             @"MMA Fitness",
             @"Gymnastics", nil];
    
    prefsExpandButton.selected = [Utility isTrainingPrefsCollapsed];

    //yt8July
    [resetButton setBackgroundColor:DEFAULT_BG_COLOR];
    [milesLabel setTextColor:DEFAULT_BG_COLOR];

    [prefsExpandButton setImage:[[prefsExpandButton imageForState:UIControlStateNormal] imageWithColor:[Utility colorForBgTitle:@"plus.png"]] forState:UIControlStateNormal];

    [prefsExpandButton setImage:[[prefsExpandButton imageForState:UIControlStateNormal] imageWithColor:[Utility colorForBgTitle:@"plus.png"]] forState:UIControlStateDisabled];
    //yt8July//

    
    [self decorate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)decorate{
    [self.navigationItem setTitle:@"Filters"];
    
//    RoundButton *button = [[RoundButton alloc] initWithFrame:CGRectMake(0, 0, 50.0f, 28.0f)];
//    [button addTarget:self action:@selector(doneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
//    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:doneButton];    
//    [self.navigationItem setRightBarButtonItem:barButton];

    gymatchSearchLabel.font = [UIFont fontWithName:@"ProximaNova-Light" size:16.0f];
    gymatchSearchDescLabel.font = [UIFont fontWithName:@"ProximaNova-Light" size:13.0f];
    localLabel.font = [UIFont fontWithName:@"ProximaNova-Light" size:16.0f];
    genderLabel.font = [UIFont fontWithName:@"ProximaNova-Light" size:16.0f];
    searchGymLabel.font = [UIFont fontWithName:@"ProximaNova-Light" size:16.0f];
    milesLabel.font = [UIFont fontWithName:@"ProximaNova-Light" size:16.0f];
    prefsLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:16.0f];
    
    [localSegmentedControl setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"ProximaNova-Semibold" size:14.0f]} forState:UIControlStateNormal];
    [genderSegmentedControl setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"ProximaNova-Semibold" size:14.0f]} forState:UIControlStateNormal];
}

#pragma mark - UItable View data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger number;
    
    switch (section) {
            
        case 0:
            number = 4;
            break;
            
        default:
            
            if (prefsExpandButton.selected) {
                
                number = [prefs count];
                
            }else{
                
                number = 0;
                
            }
            
            break;
    }
    
    return number;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height;
    
    switch (indexPath.section) {
        
        case 0:
        
            switch (indexPath.row) {
                case 0:
                    height = gymatchSearchCell.frame.size.height;
                    break;
                    
                default:
                    height = genderCell.frame.size.height;
                    break;
            }
            break;
        default:
            height = 44.0f;
            break;
    }
    
    return height;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identifier = [NSString stringWithFormat:@"RegisterCellSection%ld", (long)indexPath.section];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        
    }
    
    switch (indexPath.section) {
            
            case 0:
            
            switch (indexPath.row) {
                    
                case 0:
                    cell = gymatchSearchCell;
                    break;
                    
                case 1:
                    cell = localCell;
                    break;
                    
                case 2:
                    cell = genderCell;
                    break;
                    
                case 3:
                    cell = distanceCell;
                    break;
                    
                default:
                    break;
                    
            }
            
            break;
            
        case 1:
            
            cell.textLabel.text = prefs[indexPath.row];
            cell.textLabel.font = [UIFont fontWithName:@"ProximaNova-Light" size:16.0f];
            CheckButton *button = [[CheckButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 40.0f, 40.0f)];
            button.tag = indexPath.row;
            [button addTarget:self action:@selector(prefsAccessoryPressed:) forControlEvents:UIControlEventTouchUpInside];
            button.selected = prefsStatus[indexPath.row];
            [cell setAccessoryView:button];
            
            break;
            
    }
    
    return cell;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    
//    NSString *title;
//    
//    switch (section) {
//        case 0:
//            title = @"";
//            break;
//        case 1:
//            title = @"Gym Details:";
//            break;
//        case 2:
//            title = @"Referred By:";
//            break;
//            
//        default:
//            title = @"";
//            break;
//    }
//    
//    return title;
//}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if([view isKindOfClass:[UITableViewHeaderFooterView class]]){
        UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *) view;
        tableViewHeaderFooterView.textLabel.text = [tableViewHeaderFooterView.textLabel.text capitalizedString];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    CGFloat height;
    
    switch (section) {
        case 0:
            height = 25.0f;
            break;
            
        default:
            height = prefHeaderView.frame.size.height;
            break;
    }
    
    return height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    CGFloat height;
    
    switch (section) {
        case 0:
            height = 0;
            break;
            
        default:
            height = resetView.frame.size.height;
            break;
    }
    
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view;
    
    if (section == 1) {
        view = prefHeaderView;
    }else{
        view = nil;
    }
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view;
    
    if (section == 1) {
        view = resetView;
    }else{
        view = nil;
    }
    return view;
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

#pragma mark - IBActions

- (void)prefsAccessoryPressed:(UIButton *)button{
    
    prefsStatus[button.tag] = !button.selected;
}

- (IBAction)prefExpandButtonPressed:(UIButton *)sender{
    sender.selected = !sender.selected;
    [(UITableView *)self.view reloadData];
}

- (IBAction)mileSliderValueChanged:(UISlider *)sender {
    NSInteger value = (NSInteger)sender.value;
    if (value >= 20) {
        milesLabel.text = @"Any Distance";
    }else{
        milesLabel.text = [NSString stringWithFormat:@"%ld miles", (long)value];
    }
}

- (IBAction)doneButtonPressed:(id)sender{
    
    NSMutableDictionary *requestDictionary = [NSMutableDictionary new];
    
    NSString *circle = (gymatchSearchSwitch.on) ? @"Yes" : @"No";
    
    [requestDictionary setObject:circle forKey:@"GYMatchCircle"];
    [requestDictionary setObject:[NSNumber numberWithInteger:milesSlider.value] forKey:@"Location"];
    
    
    NSString *gender;
    
    switch (genderSegmentedControl.selectedSegmentIndex) {
        case 0:
            gender = @"Male";
            break;
        case 1:
            gender = @"Female";
            break;
            
        default:
            gender = @"Both";
            break;
    }
    [requestDictionary setObject:gender forKey:@"Gender"];



    NSString *local;

    switch (localSegmentedControl.selectedSegmentIndex) {
        case 0:
            local = @"MyGym";
            break;
        case 1:
            local = @"All";
            break;

        default:
            local = @"All";
            break;
    }
    [requestDictionary setObject:local forKey:@"Local"]; // yt 29July
    
    [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[0]] forKey:@"weight_training"];
    [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[1]] forKey:@"pilates"];
    [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[2]] forKey:@"cardio"];
    [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[3]] forKey:@"aerobics"];
    [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[4]] forKey:@"jogging"];
    [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[5]] forKey:@"martial_arts"];
    [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[6]] forKey:@"conditioning"];
    [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[7]] forKey:@"yoga"];
    [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[8]] forKey:@"cycling"];
    [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[9]] forKey:@"camping"];
    [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[10]] forKey:@"swimming"];
    [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[11]] forKey:@"cross_training"];
    [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[12]] forKey:@"dancing"];
    [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[13]] forKey:@"beach_activities"];
    [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[14]] forKey:@"mma_fitness"];
    [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[15]] forKey:@"gymnastics"];
    
    [self.delegate doneWithDictionary:requestDictionary];
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)resetButtonPressed:(id)sender{
    
    gymatchSearchSwitch.on = NO;
    localSegmentedControl.selectedSegmentIndex = 1;
    genderSegmentedControl.selectedSegmentIndex = 2;
    milesSlider.value = 10;
    milesLabel.text = [NSString stringWithFormat:@"%ld miles", (long)milesSlider.value];
    
    for (int index = 0; index < 12; index ++) {
        prefsStatus[index] = 0;
    }
    
    prefsExpandButton.selected = NO;
    
    [(UITableView *)self.view reloadData];




    //yt 12Aug
    NSMutableDictionary *requestDictionary = [NSMutableDictionary new];
    [requestDictionary setObject:@"No" forKey:@"GYMatchCircle"];
    [requestDictionary setObject:[NSNumber numberWithInteger:10] forKey:@"Location"];
    [requestDictionary setObject:@"Both" forKey:@"Gender"];
    [requestDictionary setObject:@"All" forKey:@"Local"];

    NSNumber *num = [NSNumber numberWithBool:0];
    [requestDictionary setObject:num forKey:@"weight_training"];
    [requestDictionary setObject:num forKey:@"pilates"];
    [requestDictionary setObject:num forKey:@"cardio"];
    [requestDictionary setObject:num forKey:@"aerobics"];
    [requestDictionary setObject:num forKey:@"jogging"];
    [requestDictionary setObject:num forKey:@"martial_arts"];
    [requestDictionary setObject:num forKey:@"conditioning"];
    [requestDictionary setObject:num forKey:@"yoga"];
    [requestDictionary setObject:num forKey:@"cycling"];
    [requestDictionary setObject:num forKey:@"camping"];
    [requestDictionary setObject:num forKey:@"swimming"];
    [requestDictionary setObject:num forKey:@"cross_training"];
    [requestDictionary setObject:num forKey:@"dancing"];
    [requestDictionary setObject:num forKey:@"beach_activities"];
    [requestDictionary setObject:num forKey:@"mma_fitness"];
    [requestDictionary setObject:num forKey:@"gymnastics"];

    [self.delegate doneWithDictionary:requestDictionary];

    [self.navigationController popViewControllerAnimated:YES];
}



@end
