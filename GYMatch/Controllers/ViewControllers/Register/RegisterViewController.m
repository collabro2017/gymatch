//
//  RegisterViewController.m
//  GYMatch
//
//  Created by Ram on 12/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "RegisterViewController.h"
#import "UserDataController.h"
#import "MBProgressHUD.h"
#import "TermsViewController.h"
#import "UIImagePickerHelper.h"
#import "CheckButton.h"
#import "GymDataController.h"
#import "Country.h"
#import "Utility.h" 
#import "UIImage+Overlay.h"
#import "WebServiceController.h"



@interface RegisterViewController ()<UICollectionViewDelegate> {
    
    NSArray *statusArray;
    NSInteger selectedView;
    UIImagePickerHelper *iPH;

    CGPoint oldPoint;
    
    NSArray *prefs;
    BOOL prefsStatus[16];
    NSArray *gymCategory;
    NSArray *genderArray;
    NSArray *countryArray;
    NSArray *stateArray;   

    NSInteger selectedDropDown;
    ActiveDropDownViewController *addVC;
    BOOL isPresentingDropDown;
    NSArray *dropDownMenu;
    Gym *selecedCity;
    Friend *selectedFriend;
    
    Country *selectedCountry;
    
    BOOL isProfilePicAdded; // Gourav june 24
    
    BOOL isResendLink;
    
}

@end

@implementation RegisterViewController
@synthesize strfb_UserName, strfb_Id, strfb_imageURL, strfb_Email, strfb_Gender,reSendUrl;

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
    
    isProfilePicAdded = NO; // Gourav june 24

 //   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardIsHidding:) name:UIKeyboardDidHideNotification object:nil];

  //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];

    [self.navigationItem setTitle:@"Registration"];
    
    statusArray=[[NSArray alloc] initWithObjects:
                 @"Available",
                 @"Spoken For",
                 @"Engaged",
                 @"Happily Single : )",
                 @"Don’t Ask!",
                 @"Open Minded",
                 @"Looking for friends!",
                 @"I need a partner!",
                 @"I am a trainer!", nil];
    
    gymCategory=[[NSArray alloc] initWithObjects:
                 @"",
                 @"Gym",
                 @"Studio",
                 @"Club",
                 @"Spin",
                 @"Camp", nil];
    
    genderArray=[[NSArray alloc] initWithObjects:
                 @"",
                 @"Male",
                 @"Female",
                 nil];
    
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
             @"Gymnastics",nil];

    stateArray = [[NSArray alloc] initWithObjects:nil];
 

    [gender setInputView:genderPickerView];
    [gymCategoryField setInputView:statusPickerView];
    [country setInputView:countryPickerView];
    
    [state setInputView:statePickerView];

    selectedView = 1;
    
    country.enabled = prefsExpandButton.selected;
    
    [self decorate]; 

     //yt8July
    [prefsExpandButton setImage:[[prefsExpandButton imageForState:UIControlStateNormal] imageWithColor:[Utility colorForBgTitle:@"plus.png"]] forState:UIControlStateNormal];

    [prefsExpandButton setImage:[[prefsExpandButton imageForState:UIControlStateNormal] imageWithColor:[Utility colorForBgTitle:@"plus.png"]] forState:UIControlStateDisabled];
     //yt8July// 

    [self loadData];

    if (self.isFromFacebook) {
        
        NSError *err;
        
        username.text = strfb_UserName;
        
        email.text = strfb_Email;
        
        gender.text = [strfb_Gender capitalizedString];
        
        isProfilePicAdded = YES;
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Please fill remaning fields to complete sign up" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alertView show];
    
    }
    
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:NO];
    }];
    return [super canPerformAction:action withSender:sender];
}

- (void)loadData{
    
    UserDataController *uDC = [UserDataController new];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [uDC countries:^(NSArray *countries) {
        countryArray = countries;
        [countryPickerView reloadAllComponents];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];

    if (states == nil) {

        [uDC states:^(NSArray *someStates) {

            stateArray = nil;
            stateArray = someStates;
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
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search"]];
    imageView.frame = CGRectMake(0, 0, 40.0f, 40.0f);
    imageView.contentMode = UIViewContentModeCenter;
    [gymNameTextField setRightView:imageView];
    
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search"]];
    imageView.frame = CGRectMake(0, 0, 40.0f, 40.0f);
    imageView.contentMode = UIViewContentModeCenter;
    [refer1TextField setRightView:imageView];
    
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"category_dd"]];
    imageView.frame = CGRectMake(0, 0, 40.0f, 40.0f);
    imageView.contentMode = UIViewContentModeCenter;
    [gymCategoryField setRightView:imageView];

    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"category_dd"]];
    imageView.frame = CGRectMake(0, 0, 40.0f, 40.0f);
    imageView.contentMode = UIViewContentModeCenter;
    [gender setRightView:imageView];

    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"category_dd"]];
    imageView.frame = CGRectMake(0, 0, 40.0f, 40.0f);
    imageView.contentMode = UIViewContentModeCenter;
    [country setRightView:imageView];
    
    imageView = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationItem setTitle:@"Registration"];
    prefsExpandButton.selected = [Utility isTrainingPrefsCollapsed];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [gender setTintColor:[UIColor clearColor]];
    [country setTintColor:[UIColor clearColor]];
    [gymCategoryField setTintColor:[UIColor clearColor]];
}

/*- (void)viewWillDisappear:(BOOL)animated{
    [self.view endEditing:YES];
//    [[[APP_DELEGATE navigationController] navigationBar] setHidden:YES];
//    [registerLogoImageView setHidden:YES];
//    [[APP_DELEGATE navigationController].gymLogoImageView setHidden:NO];
} */

#pragma mark - AddGymDelegate

- (void)didAddGym:(Gym *)gym{
    
    selecedCity = gym;
    gymNameTextField.text = gym.bizName;
    gymCityTextField.text = gym.city;
    gymStateTextField.text = gym.state;
}

#pragma mark -IBActions

- (IBAction)isFromUSButtonPressed:(UIButton *)sender{
    [country setHidden:sender.selected];

    state.text = @"";

    if (country.hidden) {
        lblAsterickForCountry.hidden = YES;
        [state setInputView:statePickerView];
    }else{
        lblAsterickForCountry.hidden = NO;
        [state setInputView:nil];
    }
}

- (IBAction)prefsExpandButtonPressed:(UIButton *)sender
{
    sender.selected = !sender.selected;
    [Utility trainingPrefsCollapsed:sender.selected];
    [mainTableView reloadData];
}

- (IBAction)addNewGymButtonPressed:(UIButton *)sender {
    
    AddGymViewController *aGVC = [[AddGymViewController alloc]init];
    aGVC.delegate = self;
    [self.navigationController pushViewController:aGVC animated:YES];
}

- (IBAction)registerButtonPressed:(id)sender
{
    // Gourav june 24 start
    if (!isProfilePicAdded) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Please add your profile picture." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    // Gourav june 24 end
    
    
    if (isFromUS.selected && selectedCountry == nil) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Please select country" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *requestDictionary = [NSMutableDictionary dictionary];
    
    [requestDictionary setObject:username.text forKey:@"username"];
    [requestDictionary setObject:password.text forKey:@"password"];
    [requestDictionary setObject:email.text forKey:@"email"];
    [requestDictionary setObject:age.text forKey:@"age"];
    [requestDictionary setObject:city.text forKey:@"city"];
    [requestDictionary setObject:state.text forKey:@"state"];

    if (self.isFromFacebook) {
        [requestDictionary setObject:strfb_Id forKey:@"fbid"];
    }
    
  /*  NSInteger countryId = 226;  // bydefault ID for USA  //pre
    if(!isFromUS.selected)
        selectedCountry.ID = selectedCountry.ID;

    [requestDictionary setObject:[NSNumber numberWithInteger:countryId] forKey:@"country_id"];
    [requestDictionary setObject:[NSNumber numberWithBool:isFromUS.selected] forKey:@"is_from_us"];
*/

//pankaj
 

    NSInteger countryId = 226;  // bydefault ID for USA                          //pre
    if(isFromUS.selected) {
        selectedCountry.ID = selectedCountry.ID;
        [requestDictionary setObject:[NSNumber numberWithInteger:selectedCountry.ID] forKey:@"country_id"];
        [requestDictionary setObject:[NSNumber numberWithBool:isFromUS.selected]     forKey:@"is_from_us"];
    }
    else
    {
        [requestDictionary setObject:[NSNumber numberWithInteger:countryId]          forKey:@"country_id"];
        [requestDictionary setObject:[NSNumber numberWithBool:isFromUS.selected]     forKey:@"is_from_us"];
    }

//pankaj end



    [requestDictionary setObject:gender.text forKey:@"gender"];
    
//    [requestDictionary setObject:statusDetailTextField.text forKey:@"userstatusDetail"];
    [requestDictionary setObject:gymNameTextField.text forKey:@"gym_name"];
    [requestDictionary setObject:gymCategoryField.text forKey:@"gym_type"];
    
    NSString *aLocation = [NSString stringWithFormat:@"%@, %@", gymCityTextField.text, gymStateTextField.text];
    [requestDictionary setObject:aLocation forKey:@"gym_loc"];
    [requestDictionary setObject:[NSNumber numberWithInteger:selecedCity.ID] forKey:@"gym_id"];
    
    if (selectedFriend != nil) {
        
        [requestDictionary setObject:selectedFriend.username forKey:@"refname1"];
        [requestDictionary setObject:selectedFriend.email forKey:@"refemail1"];
        [requestDictionary setObject:@"refer_friend" forKey:@"user_category"];
    }else{
        
        [requestDictionary setObject:@"" forKey:@"refname1"];
        [requestDictionary setObject:@"" forKey:@"refemail1"];
        [requestDictionary setObject:@"" forKey:@"user_category"];

    }
//    [requestDictionary setObject:refer2TextField.text forKey:@"refname2"];
//    [requestDictionary setObject:@"" forKey:@"refemail2"];
//    [requestDictionary setObject:refer3TextField.text forKey:@"refname3"];
//    [requestDictionary setObject:@"" forKey:@"refemail3"];
//    [requestDictionary setObject:@"device_token" forKey:[[UIDevice currentDevice]identifierForVendor]];
    
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
    
     
    UserDataController *uDC = [UserDataController new];
    
    [uDC registerWithDictionary:requestDictionary andImage:userImageView.image withSuccess:^(User *user) {

        /*
         User *tempUser = (User *)aFriend;
         tempUser.username = [APP_DELEGATE loggedInUser].username;
         //            tempUser.password = [APP_DELEGATE loggedInUser].password;

         [APP_DELEGATE setLoggedInUser:tempUser];

         [TopNavigationController addTabBarController];
         */
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        // [TopNavigationController addLoginNavigationController];
       // [APP_DELEGATE setAutomaticPushAfterRegister:YES];

        [Utility recommendations:NO];
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"Re-SendUrl"]);
        NSString * regmsgStr = @"Verify email address to complete registration and login";
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:regmsgStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Resend Link", nil];
        alertView.tag = 3427;
        [alertView show];

    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
        alertView = nil;
    }];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 3427)
    {
        if (buttonIndex == 1) {
            
           
            NSURLRequest *requst = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults]objectForKey:@"Re-SendUrl"]]];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [NSURLConnection sendAsynchronousRequest:requst queue:[NSOperationQueue mainQueue ] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                
                NSLog(@"%@",response);
                UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:@"GYMatch" message:@"Link sent Successfully. Please check Your Email" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                alrt.tag = 1234;
                [alrt show];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                isResendLink = YES;
                
            }];
        
            
        }
         if (buttonIndex == 0) {
         
             [self.navigationController popViewControllerAnimated:YES];
             
         }
        
//        [_lVCont loginAfterRegistrationWithUserName:username.text andPassword:password.text];
//        [self.navigationController popViewControllerAnimated:NO];
    }
    
    if (isResendLink) {
         [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (IBAction)referButtonPressed:(UIButton *)sender
{
    selectedDropDown = sender.tag;
    addVC = [ActiveDropDownViewController new];
    addVC.delegate = self;
    isPresentingDropDown = YES;
    [self presentViewController:addVC animated:YES completion:nil];
}

- (IBAction)termsConditionsButtonPressed:(id)sender {
    TermsViewController *tVC = [[TermsViewController alloc]init];
    tVC.view.frame = self.view.frame;
    [self.navigationController addChildViewController:tVC];
    [self.navigationController.view addSubview:tVC.view];
    
//    [self presentViewController:tVC animated:YES completion:^{
//        
//    }];
}

- (IBAction)profilePicButtonPressed:(UIButton *)sender {
    
    iPH = [[UIImagePickerHelper alloc]init];
    iPH.myAppdelegate = self;
    [iPH imagePickerInView:sender WithSuccess:^(UIImage *image) {
        [userImageView setImage:image];
        isProfilePicAdded = YES;
        
    } failure:^(NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
    }];
}

- (void)prefsAccessoryPressed:(UIButton *)button{
    
    prefsStatus[button.tag] = !button.selected;
}

#pragma mark - UIPickerView Delegates

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSInteger count;
    switch (pickerView.tag) {
        case 100:
            count = [genderArray count];
            break;
            
        case 200:
            count = [gymCategory count];
            break;
            
        case 300:
            count = [countryArray count];
            break;

        case 400:
            count = [stateArray count];
            break;

    }
    
    return count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{

    NSString *string;
    
    switch (pickerView.tag) {
        case 100:
            string = [genderArray objectAtIndex:row];
            break;
            
        case 200:
            string = [gymCategory objectAtIndex:row];
            break;
            
        case 300:
            string = [(Country *)[countryArray objectAtIndex:row] name];
            break;

        case 400:
            string   = [[stateArray objectAtIndex:row] name]; // Gourav june 22
            break;
    }

    return string;
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (thePickerView.tag) {
        case 100:
            gender.text = [genderArray objectAtIndex:row];
            break;
            
        case 200:
            gymCategoryField.text = [gymCategory objectAtIndex:row];
            break;
            
        case 300:
            selectedCountry = (Country *)[countryArray objectAtIndex:row];
            country.text = selectedCountry.name;
            break;

        case 400:
            state.text =  [[stateArray objectAtIndex:row] name];
            break;

    }
    
}

#pragma mark - UItable View data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    NSInteger number;
    
    switch (section) {
            
        case 0:
            number = 1;
            break;
            
        case 1:
            number = 1;
            break;
            
        case 2:
            number = 1;
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
            height = personalView.frame.size.height;
            break;
        case 1:
            height = addressView.frame.size.height;
            break;
        case 2:
            height = referView.frame.size.height;
            break;
            
        default:
            height = 44.0f;
            break;
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier;
    
    UITableViewCell *cell;
    
    switch (indexPath.section) {
            case 0:
                cell = personalView;
                break;
            case 1:
                cell = addressView;
                break;
            case 2:
                cell = referView;
                break;
        }
    
    
    if (indexPath.section == 3) {
        
        identifier = [NSString stringWithFormat:@"RegisterCellSection%d", indexPath.section];
        
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            
        }
        
        cell.textLabel.text = prefs[indexPath.row];
//        cell.textLabel.font = [UIFont fontWithName:@"ProximaNova-Light" size:16.0f];
        CheckButton *button = [[CheckButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 40.0f, 40.0f)];
        button.selected = prefsStatus[indexPath.row];
        button.tag = indexPath.row;
        [button addTarget:self action:@selector(prefsAccessoryPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell setAccessoryView:button];
    }
    
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSString *title;
    
    switch (section) {
        case 0:
            title = @"";
            break;
        case 1:
            title = @"Gym Details:";
            break;
        case 2:
            title = @"Referred By:";
            break;
            
        default:
            title = @"";
            break;
    }
    
    return title;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if([view isKindOfClass:[UITableViewHeaderFooterView class]]){
        UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *) view;
        tableViewHeaderFooterView.textLabel.text = [tableViewHeaderFooterView.textLabel.text capitalizedString];
//        tableViewHeaderFooterView.textLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:16.0f];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    CGFloat height;
    
    switch (section) {
        case 0:
            height = 1;
            break;
        case 1:
            height = 50;
            break;
        case 2:
            height = 50;
            break;
            
        default:
            height = topView.frame.size.height;
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
        case 1:
            height = 0;
            break;
        case 2:
            height = 0;
            break;
            
        default:
            height = bottomView.frame.size.height;
            break;
    }
    
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view;
    
    if (section == 3) {
        view = topView;
    }else{
        view = nil;
    }
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view;
    
    if (section == 3) {
        view = bottomView;
    }else{
        view = nil;
    }
    return view;
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

#pragma mark - DropDown delegate

- (void)didSelectItemAtIndex:(NSInteger)index{
    
    addVC = nil;
    
    NSString *name;
    
    id friend = dropDownMenu[index];
    
    switch (selectedDropDown) {
        case 301:
        {
            {
                //Peter
                selectedFriend = (Friend *)friend;
            }
            name = (![selectedFriend.name isEqualToString:@""]) ? selectedFriend.name : selectedFriend.username;
            
            refer1TextField.text = name;
        }
            break;
            
        case 304:
            gymCityTextField.text = [(Gym *)friend city];
            gymStateTextField.text = [(Gym *)friend state];
            gymNameTextField.text = [(Gym *)friend bizName];
            selecedCity = friend;
            break;
            
        case 305:
            gymNameTextField.text = [(Gym *)friend bizName];
            selecedCity = friend;
            break;
            
        default:
            break;
    }
}


- (void)didEnterText:(NSString *)text
{
    switch (selectedDropDown) {
            
        case 301:
        case 302:
        case 303:
            [self loadRefers:text];
            break;
            
        case 304:
            [self loadGymCities:text];
            break;
            
        case 305:
            [self loadGyms:text];
            break;
            
        default:
            break;
    }
}

- (void)loadRefers:(NSString *)text{
    UserDataController *uDC = [UserDataController new];
    
    [uDC refersWithKeyword:text success:^(NSArray *friends)  {
        dropDownMenu = friends;
        NSMutableArray *stringArray = [NSMutableArray new];
        
        for (Friend *aFriend in friends) {
            NSString *name = (![aFriend.name isEqualToString:@""]) ? aFriend.name : aFriend.username;
            
            [stringArray addObject:name];
        }
        
        addVC.resultsArray = stringArray;
        addVC.isSearching = NO;
        
    } failure:^(NSError *error) {
        //        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        addVC.resultsArray = nil;
        addVC.isSearching = NO;
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
    }];
}

- (void)loadGymCities:(NSString *)text{
    GymDataController *uDC = [GymDataController new];
    
    [uDC gymsWithKeyword:text success:^(NSArray *friends)  {
        dropDownMenu = friends;
        NSMutableArray *stringArray = [NSMutableArray new];
        
        for (Gym *aFriend in friends) {
            [stringArray addObject:aFriend.city];
        }
        
        addVC.resultsArray = stringArray;
        addVC.isSearching = NO;
        
    } failure:^(NSError *error) {
        //        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        addVC.resultsArray = nil;
        addVC.isSearching = NO;
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
    }];
}

- (void)loadGyms:(NSString *)text
{
    GymDataController *uDC = [GymDataController new];
    
    [uDC gymWithKeyword:text city:selecedCity.city state:selecedCity.state country:@"" success:^(NSArray *friends)  {
        dropDownMenu = friends;
        NSMutableArray *stringArray = [NSMutableArray new];
        
        for (Gym *aFriend in friends) {
            [stringArray addObject:aFriend.bizName];
        }
        
        addVC.resultsArray = stringArray;
        addVC.isSearching = NO;
        
    } failure:^(NSError *error) {
        //        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        addVC.resultsArray = nil;
        addVC.isSearching = NO;
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
    }];
}

#pragma mark - UITextField
/*
- (void)textFieldDidBeginEditing:(UITextField *)textField{

    [mainTableView setContentOffset:CGPointMake(0,textField.center.y-60) animated:YES];

   // if(textField.center)
   // oldPoint = [self.view center];
  //  [self.view setCenter:CGPointMake(0, 0)];
    

    UIButton *button = [[UIButton alloc] init];

    switch (textField.tag) {
        case 1:
            button.tag = 304;
            [self referButtonPressed:button];
            break;
        
        case 2:
            
            button.tag = 304;
            [self referButtonPressed:button];
            break;
        
        case 3:
            
            button.tag = 305;
            [self referButtonPressed:button];
            break;
    }
} */

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    MHTextField *txtField = (MHTextField*)textField;
    if(txtField == username || txtField == city || txtField == state)
    {
        NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@" abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ"] invertedSet];

        if ([txtField.text rangeOfCharacterFromSet:set].location != NSNotFound) {
            textField.text = @"";
            [self showAlertMessage:@"Please enter valid name"];
        }
    }
    else if(txtField == age)
    {
        NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        int ageValue = [txtField.text intValue];
        if ([txtField.text rangeOfCharacterFromSet:set].location != NSNotFound || ageValue  == 0 || ageValue>150) {
            textField.text = @"";
            [self showAlertMessage:@"Please enter valid Age"];
        }
    }
    else if(txtField == email)
    {
        if (![Utility validateEmailId:txtField.text]) {
            textField.text = @"";
            [self showAlertMessage:@"Please enter valid EmailId"];
        }
    }
}

-(void)showAlertMessage:(NSString*)msgStr
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!" message:msgStr delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    return YES;
}


/*
- (void) keyboardWasShown:(NSNotification *)nsNotification {

//    NSLog(@"%@",NSStringFromCGPoint(textField.center));
//    int  bottomPosition = self.view.frame.size.height - textField.center.y;
//    if(bottomPosition<375)
//    {
//        CGPoint point =  CGPointMake(textField.center.x, textField.center.y-44);
//
//        [self.view setCenter:point];
//    }

    NSDictionary *userInfo = [nsNotification userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    NSLog(@"Height: %f Width: %f", kbSize.height, kbSize.width);
    // Portrait:    Height: 264.000000  Width: 768.000000
    // Landscape:   Height: 352.000000  Width: 1024.000000
}

- (void) keyboardIsHidding:(NSNotification *)nsNotification
{
    CGSize viewSize = self.view.frame.size;
    self.view.center = CGPointMake(viewSize.width/2, (viewSize.height)/2 + 64);
} */


@end
