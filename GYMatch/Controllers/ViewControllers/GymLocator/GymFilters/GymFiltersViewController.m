//
//  GymFiltersViewController.m
//  GYMatch
//
//  Created by Ram on 01/05/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "GymFiltersViewController.h"
#import "CheckButton.h"
#import "RoundButton.h"
#import "Utility.h"
#import "UserDataController.h"
#import "MBProgressHUD.h"

#import "FriendTableViewController.h" // Gourav june 26
#import "RequestsViewController.h" // Gourav june 26
#import "SpotlightsViewController.h" // Gourav june 30

#define FRIENDS_FILTER [self.delegate isKindOfClass:[FriendTableViewController class]] // Gourav june 26
#define REQUEST_FILTER [self.delegate isKindOfClass:[RequestsViewController class]] // Gourav june 26
#define SPOTLIGHT_FILTER [self.delegate isKindOfClass:[SpotlightsViewController class]] // Gourav june 30

@interface GymFiltersViewController (){
    
    NSArray *prefs;
    BOOL prefsStatus[12];
    
    NSArray *countries;
    NSArray *states;
    NSArray *genderArray; // Gourav june 30
    
    Country *selectedCountry;
    Country *selectedState;
    NSInteger selectedDistance;
    
}

@end

@implementation GymFiltersViewController

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
    
    genderArray = [NSMutableArray arrayWithObjects:@"Male", @"Female", @"Both", nil]; // Gourav june 30
    
    [self loadData];
    [self decorate];
    
  //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willHideKB:) name:UIKeyboardWillHideNotification object:nil];

}


-(void)viewWillAppear:(BOOL)animated
{
     [(UITableView *)self.view reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [resetButton setBackgroundColor:DEFAULT_BG_COLOR];
    [countryTextField setInputView:countryPickerView];
    [stateTextField setInputView:statePickerView];

    [spotlightGenderTextField setInputView:genderPickerView];
    [spotlightGenderTextField setTintColor:[UIColor clearColor]];
    [countryTextField  setTintColor:[UIColor clearColor]];


    if (countryTextField.hidden) {
        [stateTextField setInputView:statePickerView];
        //[stateTextField  setTintColor:[UIColor clearColor]];
    }
    else {
        [stateTextField setInputView:nil];
        //[stateTextField  setTintColor:[UIColor blackColor]];
    }
    [stateTextField  setTintColor:[UIColor blackColor]];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:NO];
    }];
    return [super canPerformAction:action withSender:sender];
}


- (void)loadData
{
    UserDataController *udc = [UserDataController new];
    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (countries == nil) {
        
        [udc countries:^(NSArray *someCountries) {
            countries = someCountries;
            [countryPickerView reloadComponent:0];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } failure:^(NSError *error) {
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (states == nil) {
        
        [udc states:^(NSArray *someStates) {
            states = someStates;
            [statePickerView reloadComponent:0];
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } failure:^(NSError *error) {
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
    
}

- (void)decorate {
    [self.navigationItem setTitle:@"Filters"];
    
//    RoundButton *button = [[RoundButton alloc] initWithFrame:CGRectMake(0, 0, 50.0f, 28.0f)];
//    [button addTarget:self action:@selector(doneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    //UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    //[self.navigationItem setRightBarButtonItem:barButton];
    
    gymatchSearchLabel.font = [UIFont fontWithName:@"ProximaNova-Light" size:16.0f];
    gymatchSearchDescLabel.font = [UIFont fontWithName:@"ProximaNova-Light" size:13.0f];
    localLabel.font = [UIFont fontWithName:@"ProximaNova-Light" size:16.0f];
    nameLabel.font = [UIFont fontWithName:@"ProximaNova-Light" size:16.0f]; // Gourav june 26
    spotLightGenderLbl.font = [UIFont fontWithName:@"ProximaNova-Light" size:16.0f]; // Gourav june 30
    stateLbl.font = [UIFont fontWithName:@"ProximaNova-Light" size:16.0f]; // Gourav june 30
    genderLabel.font = [UIFont fontWithName:@"ProximaNova-Light" size:16.0f];
    searchGymLabel.font = [UIFont fontWithName:@"ProximaNova-Light" size:16.0f];
    milesLabel.font = [UIFont fontWithName:@"ProximaNova-Light" size:16.0f];
    prefsLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:16.0f];
    
    [localSegmentedControl setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"ProximaNova-Semibold" size:14.0f]} forState:UIControlStateNormal];
    [genderSegmentedControl setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"ProximaNova-Semibold" size:14.0f]} forState:UIControlStateNormal];
}

#pragma mark - UItable View data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (FRIENDS_FILTER||REQUEST_FILTER||SPOTLIGHT_FILTER)
        return 1;
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger number;
    
    if (FRIENDS_FILTER||REQUEST_FILTER||SPOTLIGHT_FILTER) {
        // FRIENDS AND REQUEST FILTER
        switch (section) {
            case 0:
                number = 4;
                break;
        }
    }
    else
    {
        // GYM LOCATOR FILTER
        switch (section) {
                
            case 0:
                number = 3;
                break;
                
            case 1:
                number = 1;
                break;
        }
    }

    
    return number;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height;
    
    if (FRIENDS_FILTER||REQUEST_FILTER||SPOTLIGHT_FILTER) {
        // FRIENDS AND REQUEST FILTER
        switch (indexPath.section) {
                
            case 0:
                switch (indexPath.row) {
                    case 0:
                        if(SPOTLIGHT_FILTER && _notHuman)
                            height = 0;
                        else
                            height = genderCell.frame.size.height;
                        break;

                    case 1:
                        if (countryTextField.hidden) {
                            height = 110;
                        }else{
                            height = 160;
                        }
                        break;
                        
                    default:
                        height = genderCell.frame.size.height;
                        break;
                }
                break;
        }
    }
    else
    {
        // GYM LOCATOR FILTER
        switch (indexPath.section) {
                
            case 0:
                switch (indexPath.row) {
                    case 0:
                        if (countryTextField.hidden) {
                            height = 110;
                        }else{
                            height = 160;
                        }
                        break;
                        
                    default:
                        height = genderCell.frame.size.height;
                        break;
                }
                break;
            case 1:
                height = distanceCell.frame.size.height;
        }
    }

    return height;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString *identifier = [NSString stringWithFormat:@"RegisterCellSection%ld", (long)indexPath.section];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    }
    
    if (FRIENDS_FILTER||REQUEST_FILTER||SPOTLIGHT_FILTER) {
        // FRIENDS AND REQUEST FILTER
        switch (indexPath.section) {
                
            case 0:
                switch (indexPath.row) {
                    case 0:
                        if (SPOTLIGHT_FILTER && _notHuman)
                            cell = tempCell;
                        else
                            cell = spotLightGenderCell;  //yt
                      //  else
                      //      cell = nameCell;
                        break;

                    case 1:
                        cell = gymatchSearchCell;
                        break;
                        
                    case 2:
                        cell = localCell;
                        break;
                        
                    case 3:
                        cell = genderCell;
                        break;
                        
                    default:
                        break;
                }
                break;
                
                default:
                    break;
                
        }
        
    }
    else
    {
        // GYM LOCATOR FILTER
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
                        
                    default:
                        break;
                        
                }
                
                break;
                
            case 1:
                cell =  distanceCell; //distanceCell;
                break;
                
        }
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
    
    
    if (FRIENDS_FILTER||REQUEST_FILTER||SPOTLIGHT_FILTER) {
        switch (section) {
            default:
                height = 0;
                break;
        }

    }
    else
    {
        switch (section) {
            case 0:
                height = 25.0f;
                break;
                
            default:
                height = prefHeaderView.frame.size.height;
                break;
        }
    }

    return height;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    CGFloat height;
    
    if (FRIENDS_FILTER||REQUEST_FILTER||SPOTLIGHT_FILTER) {
        switch (section) {
                case 0:
                height= resetView.frame.size.height;
                break;
            default:
                height = 0;
                break;
        }
    }
    else
    {
        switch (section) {
            case 0:
                height = 0;
                break;
                
            default:
                height = resetView.frame.size.height;
                break;
        }
    }
    
    return height;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view;

    if (section == 1) {
        view = prefHeaderView;
    }else{
        view = nil;
    }
    
     return view;
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view;

    if (FRIENDS_FILTER||REQUEST_FILTER||SPOTLIGHT_FILTER) {
        if (section == 0) {
            view = resetView;
        }else{
            view = nil;
        }
    }

    else
    {
        if (section == 1) {
            view = resetView;
        }else{
            view = nil;
        }
    }
        return view;
}


#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - IBActions
- (IBAction)distanceValueChanged:(UISegmentedControl *)sender {
    
    NSInteger distances[] = {1, 5, 10, 20, 50};
    
    [self.delegate doneWithDistance:distances[sender.selectedSegmentIndex]];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)usaButtonPressed:(id)sender {
    [countryTextField setHidden:!countryTextField.hidden];
    
    stateTextField.text = @"";
    countryTextField.text = @"";
    
    if (countryTextField.hidden) {
        [stateTextField setInputView:statePickerView];
    }else{
        
        [stateTextField setInputView:nil];
    }
    
    int row = 0;
    if(!(FRIENDS_FILTER||REQUEST_FILTER||SPOTLIGHT_FILTER))
        row =1; // for Gym Locator 
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];

//    [(UITableView *)self.view beginUpdates];
    [(UITableView *)self.view reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
   // [(UITableView *)self.view reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//    [(UITableView *)self.view endUpdates];

    
   // [self performSelector:@selector(increaseContentSize:) withObject:[NSNumber numberWithFloat:1000.0f] afterDelay:0.1f];
}

- (void)prefsAccessoryPressed:(UIButton *)button{
    
    prefsStatus[button.tag] = !button.selected;
}

- (IBAction)prefExpandButtonPressed:(UIButton *)sender{
    sender.selected = !sender.selected;
    [(UITableView *)self.view reloadData];
}

- (IBAction)mileSliderValueChanged:(UISlider *)sender {
    milesLabel.text = [NSString stringWithFormat:@"%ld miles", (long)sender.value];
}

- (IBAction)doneButtonPressed:(id)sender{
    
//    if ([stateTextField.text isEqualToString:@""]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//        return;
//    }
    
    NSMutableDictionary *requestDictionary = [NSMutableDictionary new];
    
    NSString *country = (usaButton.selected) ? @"USA" : countryTextField.text;
    
    if(!(FRIENDS_FILTER||REQUEST_FILTER||SPOTLIGHT_FILTER))
        if ([country isEqualToString:@""] && [stateTextField.text isEqualToString:@""] && [cityTextField.text isEqualToString:@""]) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    
    [requestDictionary setObject:country forKey:@"country"];
    [requestDictionary setObject:stateTextField.text forKey:@"state"];
    [requestDictionary setObject:cityTextField.text forKey:@"city"];
    
    
    // Gourav june 26 start
    if (FRIENDS_FILTER||REQUEST_FILTER||SPOTLIGHT_FILTER) {
        
      //  NSString *name      = nameTextField.text;
        NSString *name      = @"";
        //NSString *country   = countryTextField.text;
        NSString *state     = stateTextField.text;
        NSString *city      = cityTextField.text;
        NSString *gender    = @"";
        
        if (SPOTLIGHT_FILTER && _notHuman)
            gender = @"Both";
        else
            gender = spotlightGenderTextField.text; // Gourav june 30


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
      //  if ([gender isEqualToString:@""]) {
      //      gender = @"Select your name";
      //  }
        if ([gender isEqualToString:@"Both"]) {
            gender = @"";
        }
        if ([name isEqualToString:@"Select your name"] && [country isEqualToString:@"Select your name"] && [city isEqualToString:@"Select your name"] && [gender isEqualToString:@"Select your name"] && [state isEqualToString:@"Select your name"]) {
            name    = @"";
            country = @"";
            city    = @"";
            state   = @"";
            gender  = @"";
        }
        
        NSDictionary *dic = [NSDictionary dictionary];

        if(SPOTLIGHT_FILTER)
            dic =  [NSDictionary dictionaryWithObjectsAndKeys:country, @"country", state, @"state", city, @"city", gender, @"gender", nil];
        else
            dic =  [NSDictionary dictionaryWithObjectsAndKeys:name, @"name", country, @"country", state, @"state", city, @"city", gender, @"gender", nil];


        if (requestDictionary) {
            requestDictionary = nil;
            requestDictionary = [NSMutableDictionary dictionaryWithDictionary:dic];
        }
        
        if (FRIENDS_FILTER) {
            
        }
        
    }

    [self.delegate doneWithDictionary:requestDictionary];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)resetButtonPressed:(id)sender{
    
    countryTextField.text = @"";
    countryTextField.hidden =  YES;
    
    nameTextField.text = @""; // Gourav june 26
    spotlightGenderTextField.text = @""; // Gourav june 30
    
    stateTextField.text = @"";
    cityTextField.text  = @"";
    
    [usaButton setSelected:YES];
    
    [stateTextField setInputView:statePickerView];
    
    
    if (FRIENDS_FILTER||REQUEST_FILTER||SPOTLIGHT_FILTER)
    {
        
         [usaButton setSelected:NO];
         [self usaButtonPressed:nil];
         countryTextField.text = @"";
         countryTextField.hidden =  NO;


        //12 Aug
        NSDictionary *dic = [NSDictionary dictionary];

        if(SPOTLIGHT_FILTER)
            dic =  [NSDictionary dictionaryWithObjectsAndKeys:@"", @"country", @"", @"state", @"", @"city", @"", @"gender", nil];
        else
            dic =  [NSDictionary dictionaryWithObjectsAndKeys:@"", @"name", @"", @"country", @"", @"state", @"", @"city", @"", @"gender", nil];


        NSMutableDictionary *requestDictionary = [NSMutableDictionary dictionaryWithDictionary:dic];
        if(SPOTLIGHT_FILTER)
        {
            SpotlightsViewController *sVCont = (SpotlightsViewController*)[self delegate];
            [sVCont loadData];
        }
        else
            [self.delegate doneWithDictionary:requestDictionary];
      //  [self.navigationController popViewControllerAnimated:YES]; 
    }
    else
    {
       // [self.navigationController popViewControllerAnimated:YES];
        [self.delegate performSelector:@selector(loadData) withObject:nil];
    }
}

#pragma mark - UIPickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView.tag == 1) {
        return [countries count];
    }else if (pickerView.tag == 2) {
        return [states count];
    }
    else if (pickerView.tag == 3) {
        return [genderArray count];
    }
    else{
        return 0;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *title;
    
    if (pickerView.tag == 1) {
        title = [[countries objectAtIndex:row] name];
    }else if (pickerView.tag == 2) {
        title = [[states objectAtIndex:row] name];
    }else if (pickerView.tag == 3) {
        title = [genderArray objectAtIndex:row];
    }else{
        title = @"";
    }
    
    return title;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (pickerView.tag == 1) {
        selectedCountry = [countries objectAtIndex:row];
        countryTextField.text = [selectedCountry name];
    }else if (pickerView.tag == 2) {
        selectedState = [states objectAtIndex:row];
        NSString *newState  = [selectedState name];
        if(![stateTextField.text isEqualToString:newState])
            cityTextField.text = @"";
        stateTextField.text = newState;
    }
    else if (pickerView.tag == 3) {
        spotlightGenderTextField.text = [genderArray objectAtIndex:row];
    }

    
}

#pragma mark - Custom methods for Autoscrolling

-(void)increaseContentSize:(NSNumber*)increasedValue
{
    UITableView *filterTableView = (UITableView *)self.view;
    
    //    [filterTableView setContentOffset:CGPointMake(0.0, filterTableView.contentSize.height - self.view.bounds.size.height) animated:NO];
    
   // [filterTableView setContentOffset:CGPointMake(0.0, 200) animated:NO];

    
    
    [filterTableView setContentSize:CGSizeMake(filterTableView.frame.size.width, filterTableView.frame.size.height+increasedValue.floatValue)];
    [filterTableView setBackgroundColor:[UIColor redColor]];
    
   // NSLog(@"filterTableView.frame.size.height= %f", filterTableView.frame.size.height);
}


//- (CGSize)preferredContentSize
//{
//    // Force the table view to calculate its height
//    UITableView *filterTableView = (UITableView *)self.view;
//    
//    [filterTableView layoutIfNeeded];
//    
//    return filterTableView.contentSize;
//}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [nameTextField resignFirstResponder];
    [countryTextField resignFirstResponder];
    [stateTextField resignFirstResponder];
    [cityTextField resignFirstResponder];
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    return YES;
}


/*
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
  //  [self setContentOffsetToPoint:CGPointMake(0.0, 300.0)];
    return YES;
    
}


- (void)willHideKB:(NSNotification *)notification{
    
    [self setContentOffsetToPoint:CGPointMake(0.0, 0.0)];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self setContentOffsetToPoint:CGPointMake(0.0, 0.0)];
    
    return YES;
}

-(void)setContentOffsetToPoint:(CGPoint)point
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.50];
    
    UITableView *filterTableView = (UITableView *)self.view;
    
    [filterTableView setContentOffset:point animated:NO];
    
    //[filterTableView setContentOffset:CGPointMake(0.0, 0.0) animated:NO];
    
  //  NSLog(@"filterTableView.frame.size.height= %f", filterTableView.frame.size.height);
    
    [UIView commitAnimations];
    
} */


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

    if (![self isViewLoaded]) {
        
    }
}
@end
