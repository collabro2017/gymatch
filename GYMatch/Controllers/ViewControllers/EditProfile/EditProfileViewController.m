//
//  RegisterViewController.m
//  GYMatch
//
//  Created by Ram on 12/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "EditProfileViewController.h"
#import "UserDataController.h"
#import "MBProgressHUD.h"
#import "TermsViewController.h"
#import "UIImagePickerHelper.h"
#import "CheckButton.h"
#import "UIImageView+WebCache.h"
#import "Friend.h"
#import "ActiveDropDownViewController.h"
#import "GymDataController.h"
#import "PasswordViewController.h"
#import "Utility.h"
#import "Country.h"
#import <MessageUI/MessageUI.h>
#import "UIImage+Overlay.h"
#import "WebServiceController.h"
#import "SpotlightDataController.h"


#define MAX_LENGTH          20
#define MAX_LENGTH_TAGLINE  30
#define LEAGELNUM           @"0123456789"

#define GENDER_PICKER       100
#define GYMTYPE_PICKER      200
#define COUNTRY_PICKER      300
#define STATE_PICKER        500
#define ABOUTME_MAX_LENGTH  500

@interface EditProfileViewController ()
{
    
    NSArray *statusArray;
    NSInteger selectedView;
    UIImagePickerHelper *iPH;
    
    NSArray *dropDownMenu;
    ActiveDropDownViewController *addVC;
    
    NSInteger selectedDropDown;
    Gym *selecedCity;
    Country *selectedCountry;
    
    BOOL isPresentingDropDown;
    
    BOOL isPicChanged;
    
    NSArray *gymCategory;
    NSArray *genderArray;
    NSArray *countryArray;
    NSArray *stateArray; // Gourav june 12
    
    
    NSArray *prefs;
    BOOL prefsStatus[16];
    
    NSArray *bgImages;
    NSInteger selectedBgImage;
    NSInteger userLogId;
    BOOL isPicFromFB;
    
    int Text_Field_Length;
}

@end

@implementation EditProfileViewController
@synthesize strfb_UserName, strfb_Id, strfb_imageURL, strfb_Email, strfb_Gender,isFromFacebook;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
    }
    
    return self;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    Text_Field_Length = 1;
    
    isPicFromFB = NO;
    
    isPicChanged = NO;
    
    
    genderArray = [[NSArray alloc] initWithObjects:
                 @"",
                 @"Male",
                 @"Female",
                 nil];
    
    statusArray = [[NSArray alloc] initWithObjects:
                 @"Available",
                 @"Spoken For",
                 @"Engaged",
                 @"Happily Single : )",
                 @"Don’t Ask!",
                 @"Open Minded",
                 @"Looking for friends!",
                 @"I need a partner!",
                 @"I am a trainer!", nil];
    
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
    
    gymCategory = [[NSArray alloc] initWithObjects:
                 @"Gym",
                 @"Studio",
                 @"Club",
                 @"Spin",
                 @"Camp", nil];
    
    // gourav june 12 start

    stateArray = [[NSArray alloc] initWithObjects:nil];


     if([[NSUserDefaults standardUserDefaults] objectForKey:PASSWORD])
        [passwordBtn setEnabled:YES];
     else{
        [passwordBtn setEnabled:NO];
         [passwordStar setHidden:YES];
         [password setEnabled:NO];
         
     }
    
    [gender setInputView:genderPickerView];
    [gymTypeTextField setInputView:statusPickerView];
    [country setInputView:countryPickerView];
    

    [state setInputView:statePickerView]; // Gourav june 12
    
    
    
    bgImages = [Utility imagesForBg];
    
    prefsExpandButton.selected = [Utility isTrainingPrefsCollapsed];

    //yt8July
    [prefsExpandButton setImage:[[prefsExpandButton imageForState:UIControlStateNormal] imageWithColor:[Utility colorForBgTitle:@"plus.png"]] forState:UIControlStateNormal];

    [prefsExpandButton setImage:[[prefsExpandButton imageForState:UIControlStateNormal] imageWithColor:[Utility colorForBgTitle:@"plus.png"]] forState:UIControlStateDisabled];

    [addNewGymButton  setImage:[[addNewGymButton imageForState:UIControlStateNormal] imageWithColor:[Utility colorForBgTitle:@"plus.png"]] forState:UIControlStateNormal];

    [addNewGymButton  setImage:[[addNewGymButton imageForState:UIControlStateNormal] imageWithColor:[Utility colorForBgTitle:@"plus.png"]] forState:UIControlStateDisabled];
    //yt8July//


    [self loadData];
    
    city.delegate = self;
    state.delegate = self;

    
    //check data come from fb
   
        if (isFromFacebook) {
            self.navigationItem.hidesBackButton = YES;
            
       }
  
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];


    [self.navigationItem setTitle:@"Edit Profile"];

    if (!isPresentingDropDown && !isPicChanged) {
        
        if (isFromFacebook) {
            [self isDataComeFromFb];
        }else
        {
             [self fillDetails];
        }
       
        [self decorate];
    }
    
    prefsExpandButton.selected = [Utility isTrainingPrefsCollapsed];
    
    [gender setTintColor:[UIColor clearColor]];
    [country setTintColor:[UIColor clearColor]];
    [gymTypeTextField setTintColor:[UIColor clearColor]];
    
    if ([APP_DELEGATE loggedInUser].isDeleted > 0) {
        [deactivateButton setTitle:@"REACTIVATE" forState:UIControlStateNormal];

        UITableView *tbView = (UITableView *)self.view;
      //   UIView *view = (UIView*)[self view];
        [tbView setScrollEnabled:NO];
        reactivateView.frame = CGRectMake(0, 0, tbView.frame.size.width, tbView.frame.size.height);
        [tbView addSubview:reactivateView];
      /*  CGFloat yOffset = 0;
        
        if (tbView.contentSize.height > tbView.bounds.size.height) {
            yOffset = tbView.contentSize.height - tbView.bounds.size.height;
        }
        
        [tbView setContentOffset:CGPointMake(0, yOffset) animated:YES]; */ 
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
     [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}


- (void)loadData{
    
    UserDataController *uDC = [UserDataController new];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [uDC countries:^(NSArray *countries) {
        
        countryArray = countries;
        NSLog(@"Countries are : %@" , countryArray); 
        [countryPickerView reloadAllComponents];
        
        [uDC pushNotificationStatus:^(BOOL status) {
            
            [[APP_DELEGATE loggedInUser] setEnabledPushNotification:status];
            
            [pnSwitch setOn:status];
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
        } failure:^(NSError *error) {
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
        }];
        
    } failure:^(NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    

    // Gourav june 22 start
    
    
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

    // Gourav june 22 end
}

-(void)isDataComeFromFb
{
   // password.placeholder = @"Password";
    
    
    password.hidden = YES;
    
    
    roundbtnPassword.hidden = YES;
    //strfb_UserName, strfb_Id, strfb_imageURL, strfb_Email, strfb_Gender
    username.text = strfb_UserName;
    email.text = strfb_Email;
    
    NSString *firstCapChar = [[strfb_Gender substringToIndex:1] capitalizedString];
    NSString *cappedString = [strfb_Gender stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstCapChar];
    
    gender.text = cappedString;
    [bgImageView setImage:[Utility imageForBgTitle:self.user.bgImage]];
    selectedBgImage = [Utility indexForBgTitle:self.user.bgImage];

    
}

- (void)decorate{
    
    [aboutMeTextView setInputAccessoryView:accessoryKBToolbar];
    aboutMeTextView.layer.cornerRadius = 3.0f;
    
//    aboutMeTextView.font = [UIFont fontWithName:@"ProximaNova-Regular" size:13.0f];
    aboutMeTextView.layer.borderWidth = 0.5f;
    aboutMeTextView.layer.borderColor = [[UIColor colorWithRed:204.0/255.0f green:204.0f/255.0f blue:205.0f/255.0f alpha:1.0f] CGColor];
    
//    notificationLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:16.0f];
    isPresentingDropDown = NO;
    
    
    // Pref Text View
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:prefsTextView.text];
    
    [string addAttribute:UITextAttributeFont
                   value:[UIFont fontWithName:@"ProximaNova-Regular" size:14.0f]
                   range:NSMakeRange(0, [string length])];
    
    [string addAttribute:UITextAttributeTextColor
                   value:[UIColor colorWithRed:(128.0f/255.0f) green:(128.0f/255.0f) blue:(128.0f/255.0f) alpha:1.0f]
                   range:NSMakeRange(0, [string length])];
    
    NSRange range = [prefsTextView.text rangeOfString:@"Choose Training Preferences:"];
    
    [string addAttribute:UITextAttributeFont
                   value:[UIFont fontWithName:@"ProximaNova-Semibold" size:16.0f]
                   range:range];
    
    prefsTextView.attributedText = string;
    
    // bgImageLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:16.0f];
    
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
    [gymTypeTextField setRightView:imageView];
    
    
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gray_list_arrow"]];
    imageView.frame = CGRectMake(0, 0, 40.0f, 40.0f);
    imageView.contentMode = UIViewContentModeCenter;
    
    if (!isFromFacebook) {
        [password setRightView:imageView];
    }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        bgImageHeight.constant = 410;
    }
    
}

#pragma mark - AddGymDelegate

- (void)didAddGym:(Gym *)gym{
    
    self.user.gym = gym;
    selecedCity = gym;
    gymNameTextField.text = gym.bizName;
    gymCityTextField.text = gym.city;
    gymStateTextField.text = gym.state;
    
}

- (void)fillDetails{
 
    Friend *user = self.user;
    
    // [userImageView setImageWithURL:[NSURL URLWithString:user.image] placeholderImage:[UIImage imageNamed:@"myprofile_icon"]];
    [userImageView sd_setImageWithURL:[NSURL URLWithString:user.image] placeholderImage:[UIImage imageNamed:@"user_plus"]];
    
    [bgImageView setImage:[Utility imageForBgTitle:self.user.bgImage]];
    selectedBgImage = [Utility indexForBgTitle:self.user.bgImage];
    
    username.text = user.username;
    firstName.text = user.firstName;
    lastName.text = user.lastName;
    email.text = user.email;
    city.text = user.city;
    state.text = user.state;
    gender.text = user.gender;
    age.text = [NSString stringWithFormat:@"%d", (int)user.age];
    statusDetailTextField.text = user.statusDetail;
    gymNameTextField.text = user.gym.bizName;
    gymCityTextField.text = user.gym.city;
    gymStateTextField.text = user.gym.state;
    gymTypeTextField.text = user.gymType;
    aboutMeTextView.text = user.aboutMe;
    
    if (!user.isFromUS) {
        
        country.hidden = YES;

        isFromUS.selected = NO;
        
    } else {
        
        country.hidden = NO;
        country.text = user.country;
        isFromUS.selected = YES;
        
        {
            //Peter
            for (Country* item in countryArray) {
                if([[item.name uppercaseString] isEqualToString:[country.text uppercaseString]])
                {
                    selectedCountry = item;
                    break;
                }
            }
            
        }
    }
    
    prefsStatus[0] = user.weightTraining;
    prefsStatus[1] = user.pilates;
    prefsStatus[2] = user.cardio;
    prefsStatus[3] = user.aerobics;
    prefsStatus[4] = user.jogging;
    prefsStatus[5] = user.martialArts;
    prefsStatus[6] = user.conditioning;
    prefsStatus[7] = user.yoga;
    prefsStatus[8] = user.cycling;
    prefsStatus[9] = user.swimming;
    prefsStatus[10] = user.crossTraining;
    prefsStatus[11] = user.camping;
    prefsStatus[12] = user.dancing;
    prefsStatus[13] = user.beachActivities;

    prefsStatus[14] = user.mmaFitness;
    prefsStatus[15] = user.gymnastics;


    selecedCity = user.gym;
    
    [(UITableView *)self.view reloadData];
    
}

#pragma mark -IBActions

- (IBAction)pnStateChanged:(UISwitch *)sender {
   
    UserDataController *udc = [UserDataController new];
    BOOL status = sender.isOn;
    
    [udc setPushNotificationStatus:status success:^{
        [[APP_DELEGATE loggedInUser] setEnabledPushNotification:status];
    } failure:^(NSError *error) {
        
    }];
    
}

- (IBAction)isFromUSButtonPressed:(UIButton *)sender{
    
    [country setHidden:sender.selected];
    
    
    // Gourav june 22 start
    
    state.text = @"";
    
    if (country.hidden) {
        
        [state setInputView:statePickerView];
    
    }else{
        
        [state setInputView:nil];
    }
    // Gourav june 22 end

}


- (IBAction)prefsExpandButtonPressed:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    [Utility trainingPrefsCollapsed:sender.selected];
    [(UITableView *)self.view reloadData];
    
}

- (IBAction)doneButtonPressed:(id)sender {
    [aboutMeTextView resignFirstResponder];
}

- (IBAction)addNewGymButtonPressed:(UIButton *)sender {
    
    [[[APP_DELEGATE tabBarController] tabBar] setHidden:YES];
    
    AddGymViewController *aGVC = [[AddGymViewController alloc]init];
    
    aGVC.delegate = self;

    [self.navigationController pushViewController:aGVC animated:YES];

}

-(IBAction)registerButtonPressed:(id)sender
{
    
    NSLog(@"%lu",username.text.length);
    
    if (username.text.length < 1 || gender.text.length < 1 || email.text.length < 1 || state.text.length < 1 || city.text.length < 1 || age.text.length < 1) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Please Enter Mandatory Fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    if (isFromFacebook) {
//        if ( password.text.length < 1 ) {
//            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Please Enter Mandatory Fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alertView show];
//            return;
//
//        }
    }
    
    if (isFromUS.selected && selectedCountry == nil) {
        if (country.text.length) {
            {
                for (Country* item in countryArray) {
                    if([[item.name uppercaseString] isEqualToString:[country.text uppercaseString]])
                    {
                        selectedCountry = item;
                        break;
                    }
                }
            }
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Please select country" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
    }
 
    if (isFromFacebook) {
        
        if (!isPicFromFB) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Please Add Your Profile Pic" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        
        
        if (userLogId == 0) {
            
           
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            NSMutableDictionary *requestDictionary = [NSMutableDictionary dictionary];
            
            [requestDictionary setObject:username.text forKey:@"username"];
            
            
            NSString *trimFb_id = [strfb_Id substringFromIndex: 8];
            
          
            
            [requestDictionary setObject:trimFb_id forKey:@"password"];
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
            //  [requestDictionary setObject:gymCategoryField.text forKey:@"gym_type"];
            
            NSString *aLocation = [NSString stringWithFormat:@"%@, %@", gymCityTextField.text, gymStateTextField.text];
            [requestDictionary setObject:aLocation forKey:@"gym_loc"];
            [requestDictionary setObject:[NSNumber numberWithInteger:selecedCity.ID] forKey:@"gym_id"];
            Friend *selectedFriend;
            if (selectedFriend != nil) {
                
                [requestDictionary setObject:selectedFriend.username forKey:@"refname1"];
                [requestDictionary setObject:selectedFriend.email forKey:@"refemail1"];
            }else{
                
                [requestDictionary setObject:@"" forKey:@"refname1"];
                [requestDictionary setObject:@"" forKey:@"refemail1"];
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
                UIAlertView *alertView = [[UIAlertView alloc]init];
                
                
                
                //login after register-----------------
                
                
                
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                User *userlogin = [User new];
                userlogin.username = username.text;
                userlogin.password = password.text;
                [[NSUserDefaults standardUserDefaults] setObject:password.text forKey:PASSWORD];
                [[NSUserDefaults standardUserDefaults] synchronize];
                //            user.isRemeberOn = rememberMeCheckButton.selected;
                
                UserDataController *uDC = [UserDataController new];
                uDC.user = user;
                
                
                NSString *token;
                
                if ([APP_DELEGATE deviceToken] != nil) {
                    token = [APP_DELEGATE deviceToken];
                }
                else {
                    token = @"NO_TOKEN";
                }
                
                
                if(isFromFacebook)
                {
                     NSString *trimFb_id = [strfb_Id substringFromIndex: 8];
                
                    password.text = trimFb_id;
                }               
                
                NSDictionary *dict = @{
                                       @"username": username.text,
                                       @"password": password.text,
                                       @"device_token": token,
                                       @"device_os": @"iOS",
                                       @"remember_me": [NSNumber numberWithBool:false]
                                       };

                
                NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithDictionary:dict];
                
                
                [WebServiceController callURLString:API_URL_LOGIN withRequest:requestDict andMethod:@"POST" withSuccess:^(NSDictionary *responseDictionary) {
                    
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    
                    NSLog(@"%@",responseDictionary);
                    
                    if ([[responseDictionary valueForKeyPath:@"response.status"] isEqualToString:@"Success"]) {
                        
                        self.user.ID = [[responseDictionary valueForKeyPath:@"response.userid"] integerValue];
                        NSLog(@"%ld",(long)self.user.ID);
                        
                        userLogId = [[responseDictionary valueForKeyPath:@"response.userid"] integerValue];
                        ////user update profile ------------------------------------------------------------
                        [uDC profileDetails:userLogId withSuccess:^(Friend *aFriend) {
                            
                            User *tempUser = (User *)aFriend;
                            tempUser.username = [APP_DELEGATE loggedInUser].username;
                            //    tempUser.password = [APP_DELEGATE loggedInUser].password;
                            
                            [APP_DELEGATE setLoggedInUser:tempUser];
                            
                            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                            
                           
                            
                        } failure:^(NSError *error) {
                            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:PASSWORD];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            [alertView setMessage:@"Please try later!"];
                            [alertView setTitle:nil];
                            [alertView show];
                            
                        }];
                        
                        //-----------------------
                        NSString *aboutMe = aboutMeTextView.text;
                        
                        if (aboutMe.length > 500) {
                            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Please enter about me less then 500 characters" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                            [alertView show];
                            return;
                        }
                        
                        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        
                        NSMutableDictionary *requestDictionary = [NSMutableDictionary dictionary];
                        
                        [requestDictionary setObject:username.text forKey:@"username"];
                        [requestDictionary setObject:firstName.text forKey:@"firstname"];
                        [requestDictionary setObject:lastName.text forKey:@"lastname"];
                        [requestDictionary setObject:password.text forKey:@"password"];
                        [requestDictionary setObject:email.text forKey:@"email"];
                        [requestDictionary setObject:age.text forKey:@"age"];
                        [requestDictionary setObject:city.text forKey:@"city"];
                        [requestDictionary setObject:state.text forKey:@"state"];
                        
                        
                        /* NSInteger countryId = 226;  // bydefault ID for USA
                         if(!isFromUS.selected)
                         selectedCountry.ID = selectedCountry.ID;                        // pankaj commented it.
                         
                         [requestDictionary setObject:[NSNumber numberWithInteger:countryId] forKey:@"country_id"];
                         
                         */
                        // [requestDictionary setObject:[NSNumber numberWithInteger:selectedCountry.ID] forKey:@"country_id"];
                        
                        
                        //pankaj
                        
                        
                        NSInteger countryId = 226;  // bydefault ID for USA  //pre
                        if(isFromUS.selected)
                        {
                            selectedCountry.ID = selectedCountry.ID;
                            
                            [requestDictionary setObject:[NSNumber numberWithInteger:selectedCountry.ID] forKey:@"country_id"];
                            [requestDictionary setObject:[NSNumber numberWithBool:isFromUS.selected] forKey:@"is_from_us"];
                        }
                        else
                        {
                            [requestDictionary setObject:[NSNumber numberWithInteger:countryId] forKey:@"country_id"];
                            [requestDictionary setObject:[NSNumber numberWithBool:isFromUS.selected] forKey:@"is_from_us"];
                        }
                        
                        
                        
                        //pankaj end
                        
                        [requestDictionary setObject:gender.text forKey:@"gender"];
                        
                        [requestDictionary setObject:[NSNumber numberWithFloat:[APP_DELEGATE loggedInUser].coordinate.latitude] forKey:@"latitude"];
                        [requestDictionary setObject:[NSNumber numberWithFloat:[APP_DELEGATE loggedInUser].coordinate.longitude] forKey:@"longitude"];
                        
                        [requestDictionary setObject:aboutMeTextView.text forKey:@"aboutme"];
                        [requestDictionary setObject:gymNameTextField.text forKey:@"gym_name"];
                        [requestDictionary setObject:gymTypeTextField.text forKey:@"gym_type"];
                        
                        [requestDictionary setObject:[NSNumber numberWithBool:isFromUS.selected] forKey:@"is_from_us"];
                        
                        NSString *location = [NSString stringWithFormat:@"%@, %@", gymCityTextField.text, gymStateTextField.text];
                        [requestDictionary setObject:location forKey:@"gym_loc"];
                        [requestDictionary setObject:[NSNumber numberWithInt:selecedCity.ID] forKey:@"gym_id"];
                        [requestDictionary setObject:statusDetailTextField.text forKey:@"userstatusDetail"];
                        [requestDictionary setObject:[Utility titleForBgImageAtIndex:selectedBgImage] forKey:@"bg_image"];
                        //    [requestDictionary setObject:@"" forKey:@"refemail1"];
                        //    [requestDictionary setObject:refer2TextField.text forKey:@"refname2"];
                        //    [requestDictionary setObject:@"" forKey:@"refemail2"];
                        //    [requestDictionary setObject:refer3TextField.text forKey:@"refname3"];
                        //    [requestDictionary setObject:@"" forKey:@"refemail3"];
                        [requestDictionary setObject:[[UIDevice currentDevice]identifierForVendor] forKey:@"device_token"];
                        
                        [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[0]] forKey:@"weight_training"];
                        [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[1]] forKey:@"pilates"];
                        [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[2]] forKey:@"cardio"];
                        [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[3]] forKey:@"aerobics"];
                        [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[4]] forKey:@"jogging"];
                        [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[5]] forKey:@"martial_arts"];
                        [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[6]] forKey:@"conditioning"];
                        [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[7]] forKey:@"yoga"];
                        [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[8]] forKey:@"cycling"];
                        [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[9]] forKey:@"swimming"];
                        [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[10]] forKey:@"cross_training"];
                        [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[11]] forKey:@"camping"];
                        [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[12]] forKey:@"dancing"];
                        [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[13]] forKey:@"beach_activities"];
                        [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[14]] forKey:@"mma_fitness"];
                        [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[15]] forKey:@"gymnastics"];
                        
                        
                        UserDataController *uDC = [UserDataController new];
                        
                        __weak EditProfileViewController *weakSelf = self;
                        
                        UIImage *image;
                        
                        
                        image = userImageView.image;
                        
                        [uDC updateWithDictionary:requestDictionary andImage:image withSuccess:^(User *user) {
                            //        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                            
                            //        [uDC profileDetails:[APP_DELEGATE loggedInUser].ID withSuccess:^(Friend *aFriend) {
                            //            [APP_DELEGATE setLoggedInUser:(User *)aFriend];
                            //            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                            
                            
//                            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Profile updated successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                            [alertView show];
                            
                            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"You have successfully registered." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                            alertView.tag = 342987;
                            [alertView show];

                            
//   ---------------------if success log in ----------------------------------------------
                            //[weakSelf.navigationController popViewControllerAnimated:YES];
                            isFromFacebook = NO;
                            password.enabled = NO;
                            [TopNavigationController addTabBarController];
                            
                            //        } failure:^(NSError *error) {
                            //            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                            //            [alertView show];
                            //        }];
                            
                            
                        } failure:^(NSError *error) {
                            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                            
                            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                            [alertView show];
                            
                            alertView = nil;
                        }];
                        
                        
                    }
                } failure:^(NSError *error) {
                    
                }];
                
                
                
            } failure:^(NSError *error) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
                
                alertView = nil;
            }];
            
        }
        else
        {
            
            //check about me length;
            NSString *aboutMe = aboutMeTextView.text;
            if (aboutMe.length > 500) {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Please enter about me less then 500 characters" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
                return;
            }
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            NSMutableDictionary *requestDictionary = [NSMutableDictionary dictionary];
            
            [requestDictionary setObject:username.text forKey:@"username"];
            [requestDictionary setObject:firstName.text forKey:@"firstname"];
            [requestDictionary setObject:lastName.text forKey:@"lastname"];
            //    [requestDictionary setObject:password.text forKey:@"password"];
            [requestDictionary setObject:email.text forKey:@"email"];
            [requestDictionary setObject:age.text forKey:@"age"];
            [requestDictionary setObject:city.text forKey:@"city"];
            [requestDictionary setObject:state.text forKey:@"state"];
            
            
            /* NSInteger countryId = 226;  // bydefault ID for USA
             if(!isFromUS.selected)
             selectedCountry.ID = selectedCountry.ID;                        // pankaj commented it.
             
             [requestDictionary setObject:[NSNumber numberWithInteger:countryId] forKey:@"country_id"];
             
             */
            // [requestDictionary setObject:[NSNumber numberWithInteger:selectedCountry.ID] forKey:@"country_id"];
            
            
            //pankaj
            
            
            NSInteger countryId = 226;  // bydefault ID for USA  //pre
            if(isFromUS.selected)
            {
                selectedCountry.ID = selectedCountry.ID;
                
                [requestDictionary setObject:[NSNumber numberWithInteger:selectedCountry.ID] forKey:@"country_id"];
                [requestDictionary setObject:[NSNumber numberWithBool:isFromUS.selected] forKey:@"is_from_us"];
            }
            else
            {
                [requestDictionary setObject:[NSNumber numberWithInteger:countryId] forKey:@"country_id"];
                [requestDictionary setObject:[NSNumber numberWithBool:isFromUS.selected] forKey:@"is_from_us"];
            }
            
            
            
            //pankaj end
            
            [requestDictionary setObject:gender.text forKey:@"gender"];
            
            [requestDictionary setObject:[NSNumber numberWithFloat:[APP_DELEGATE loggedInUser].coordinate.latitude] forKey:@"latitude"];
            [requestDictionary setObject:[NSNumber numberWithFloat:[APP_DELEGATE loggedInUser].coordinate.longitude] forKey:@"longitude"];
            
            [requestDictionary setObject:aboutMeTextView.text forKey:@"aboutme"];
            [requestDictionary setObject:gymNameTextField.text forKey:@"gym_name"];
            [requestDictionary setObject:gymTypeTextField.text forKey:@"gym_type"];
            
            [requestDictionary setObject:[NSNumber numberWithBool:isFromUS.selected] forKey:@"is_from_us"];
            
            NSString *location = [NSString stringWithFormat:@"%@, %@", gymCityTextField.text, gymStateTextField.text];
            [requestDictionary setObject:location forKey:@"gym_loc"];
            [requestDictionary setObject:[NSNumber numberWithInt:selecedCity.ID] forKey:@"gym_id"];
            [requestDictionary setObject:statusDetailTextField.text forKey:@"userstatusDetail"];
            [requestDictionary setObject:[Utility titleForBgImageAtIndex:selectedBgImage] forKey:@"bg_image"];
            //    [requestDictionary setObject:@"" forKey:@"refemail1"];
            //    [requestDictionary setObject:refer2TextField.text forKey:@"refname2"];
            //    [requestDictionary setObject:@"" forKey:@"refemail2"];
            //    [requestDictionary setObject:refer3TextField.text forKey:@"refname3"];
            //    [requestDictionary setObject:@"" forKey:@"refemail3"];
            [requestDictionary setObject:[[UIDevice currentDevice]identifierForVendor] forKey:@"device_token"];
            
            [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[0]] forKey:@"weight_training"];
            [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[1]] forKey:@"pilates"];
            [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[2]] forKey:@"cardio"];
            [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[3]] forKey:@"aerobics"];
            [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[4]] forKey:@"jogging"];
            [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[5]] forKey:@"martial_arts"];
            [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[6]] forKey:@"conditioning"];
            [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[7]] forKey:@"yoga"];
            [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[8]] forKey:@"cycling"];
            [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[9]] forKey:@"swimming"];
            [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[10]] forKey:@"cross_training"];
            [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[11]] forKey:@"camping"];
            [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[12]] forKey:@"dancing"];
            [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[13]] forKey:@"beach_activities"];
            [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[14]] forKey:@"mma_fitness"];
            [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[15]] forKey:@"gymnastics"];
            UserDataController *uDC = [UserDataController new];
            
            __weak EditProfileViewController *weakSelf = self;
            
            UIImage *image;
            
            
            image = userImageView.image;
            
            [uDC updateWithDictionary:requestDictionary andImage:image withSuccess:^(User *user) {
                //        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
                //        [uDC profileDetails:[APP_DELEGATE loggedInUser].ID withSuccess:^(Friend *aFriend) {
                //            [APP_DELEGATE setLoggedInUser:(User *)aFriend];
                //            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                
                
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Profile updated successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
               // [weakSelf.navigationController popViewControllerAnimated:YES];
                
                //   ---------------------if success log in ----------------------------------------------
                //[weakSelf.navigationController popViewControllerAnimated:YES];
                [TopNavigationController addTabBarController];
                
                
                //        } failure:^(NSError *error) {
                //            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                //            [alertView show];
                //        }];
                
                
            } failure:^(NSError *error) {
                [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
                
                alertView = nil;
            }];

            
            
            
        }
        
        
    }
    else
    {
        
        //check about me length;
        NSString *aboutMe = aboutMeTextView.text;
        if (aboutMe.length > 500) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Please enter about me less then 500 characters" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSMutableDictionary *requestDictionary = [NSMutableDictionary dictionary];
        
        [requestDictionary setObject:username.text forKey:@"username"];
        [requestDictionary setObject:firstName.text forKey:@"firstname"];
        [requestDictionary setObject:lastName.text forKey:@"lastname"];
        //    [requestDictionary setObject:password.text forKey:@"password"];
        [requestDictionary setObject:email.text forKey:@"email"];
        [requestDictionary setObject:age.text forKey:@"age"];
        [requestDictionary setObject:city.text forKey:@"city"];
        [requestDictionary setObject:state.text forKey:@"state"];
        
        
        /* NSInteger countryId = 226;  // bydefault ID for USA
         if(!isFromUS.selected)
         selectedCountry.ID = selectedCountry.ID;                        // pankaj commented it.
         
         [requestDictionary setObject:[NSNumber numberWithInteger:countryId] forKey:@"country_id"];
         
         */
        // [requestDictionary setObject:[NSNumber numberWithInteger:selectedCountry.ID] forKey:@"country_id"];
        
        
        //pankaj
        
        
        NSInteger countryId = 226;  // bydefault ID for USA  //pre
        if(isFromUS.selected)
        {
            selectedCountry.ID = selectedCountry.ID;
            
            [requestDictionary setObject:[NSNumber numberWithInteger:selectedCountry.ID] forKey:@"country_id"];
            [requestDictionary setObject:[NSNumber numberWithBool:isFromUS.selected] forKey:@"is_from_us"];
        }
        else
        {
            [requestDictionary setObject:[NSNumber numberWithInteger:countryId] forKey:@"country_id"];
            [requestDictionary setObject:[NSNumber numberWithBool:isFromUS.selected] forKey:@"is_from_us"];
        }
        
        
        
        //pankaj end
        
        [requestDictionary setObject:gender.text forKey:@"gender"];
        
        [requestDictionary setObject:[NSNumber numberWithFloat:[APP_DELEGATE loggedInUser].coordinate.latitude] forKey:@"latitude"];
        [requestDictionary setObject:[NSNumber numberWithFloat:[APP_DELEGATE loggedInUser].coordinate.longitude] forKey:@"longitude"];
        
        [requestDictionary setObject:aboutMeTextView.text forKey:@"aboutme"];
        [requestDictionary setObject:gymNameTextField.text forKey:@"gym_name"];
        [requestDictionary setObject:gymTypeTextField.text forKey:@"gym_type"];
        
        [requestDictionary setObject:[NSNumber numberWithBool:isFromUS.selected] forKey:@"is_from_us"];
        
        NSString *location = [NSString stringWithFormat:@"%@, %@", gymCityTextField.text, gymStateTextField.text];
        [requestDictionary setObject:location forKey:@"gym_loc"];
        [requestDictionary setObject:[NSNumber numberWithInt:selecedCity.ID] forKey:@"gym_id"];
        [requestDictionary setObject:statusDetailTextField.text forKey:@"userstatusDetail"];
        [requestDictionary setObject:[Utility titleForBgImageAtIndex:selectedBgImage] forKey:@"bg_image"];
        //    [requestDictionary setObject:@"" forKey:@"refemail1"];
        //    [requestDictionary setObject:refer2TextField.text forKey:@"refname2"];
        //    [requestDictionary setObject:@"" forKey:@"refemail2"];
        //    [requestDictionary setObject:refer3TextField.text forKey:@"refname3"];
        //    [requestDictionary setObject:@"" forKey:@"refemail3"];
        [requestDictionary setObject:[[UIDevice currentDevice]identifierForVendor] forKey:@"device_token"];
        
        [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[0]] forKey:@"weight_training"];
        [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[1]] forKey:@"pilates"];
        [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[2]] forKey:@"cardio"];
        [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[3]] forKey:@"aerobics"];
        [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[4]] forKey:@"jogging"];
        [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[5]] forKey:@"martial_arts"];
        [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[6]] forKey:@"conditioning"];
        [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[7]] forKey:@"yoga"];
        [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[8]] forKey:@"cycling"];
        [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[9]] forKey:@"swimming"];
        [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[10]] forKey:@"cross_training"];
        [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[11]] forKey:@"camping"];
        [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[12]] forKey:@"dancing"];
        [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[13]] forKey:@"beach_activities"];
        [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[14]] forKey:@"mma_fitness"];
        [requestDictionary setObject:[NSNumber numberWithBool:prefsStatus[15]] forKey:@"gymnastics"];
        UserDataController *uDC = [UserDataController new];
        
        __weak EditProfileViewController *weakSelf = self;
        
        UIImage *image;
        
        
        image = userImageView.image;
        
        [uDC updateWithDictionary:requestDictionary andImage:image withSuccess:^(User *user) {
            //        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            //        [uDC profileDetails:[APP_DELEGATE loggedInUser].ID withSuccess:^(Friend *aFriend) {
            //            [APP_DELEGATE setLoggedInUser:(User *)aFriend];
            //            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Profile updated successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
            //        } failure:^(NSError *error) {
            //            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //            [alertView show];
            //        }];
            
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            
            alertView = nil;
        }];

        
    }
    
    
    
    
}

- (IBAction)termsConditionsButtonPressed:(id)sender {
    TermsViewController *tVC = [[TermsViewController alloc]init];
    
    [self presentViewController:tVC animated:YES completion:^{
        
    }];
}



- (IBAction)profilePicButtonPressed:(UIButton *)sender {
    iPH = nil;    
    iPH = [[UIImagePickerHelper alloc]init];
    iPH.myAppdelegate = self; // Gourav june 24
    [iPH imagePickerInView:sender WithSuccess:^(UIImage *image) {
        [userImageView setImage:image];
        isPicFromFB = YES;
        isPicChanged = YES;
    } failure:^(NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
    }];
}

- (IBAction)referButtonPressed:(UIButton *)sender {
    
    selectedDropDown = sender.tag;
    addVC = [ActiveDropDownViewController new];
    addVC.delegate = self;
    isPresentingDropDown = YES;
    [self presentViewController:addVC animated:YES completion:nil];
    
}

- (IBAction)signOffButtonPressed:(id)sender{

    [TopNavigationController logout];
    

//    [self.navigationController popToRootViewControllerAnimated:YES];
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    
//    UserDataController *uDC = [UserDataController new];
//    
//    [uDC logoutSuccess:^{
//        
//        [TopNavigationController addLoginNavigationController];
//        [APP_DELEGATE setTabBarController:nil];
//        
//        [uDC forgetUser];
//        [FBSession.activeSession closeAndClearTokenInformation];
//        
//    } failure:^(NSError *error) {
//        
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alertView show];
//        
//    }];

}

- (IBAction)contactButtonPressed:(id)sender {
    
    if([MFMailComposeViewController canSendMail]) {
    
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;        // Required to invoke mailComposeController when send
        
        [mailCont setSubject:@"Contact"];
        [mailCont setToRecipients:[NSArray arrayWithObject:@"Contact@gymatch.com"]];
        [mailCont setMessageBody:@"" isHTML:NO];
        
        [self.navigationController presentViewController:mailCont animated:YES completion:nil];
    
    }
    
}

- (IBAction)feedbackButtonPressed:(id)sender {
    
    if([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self; // Required to invoke mailComposeController when send
        
        [mailCont setSubject:@"Feedback"];
        [mailCont setToRecipients:[NSArray arrayWithObject:@"Feedback@gymatch.com"]];
        [mailCont setMessageBody:@"" isHTML:NO];
        
        [self.navigationController presentViewController:mailCont animated:YES completion:nil];
    }
}

#pragma mark - Message Delegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)prefsAccessoryPressed:(UIButton *)button{
    
    prefsStatus[button.tag] = !button.selected;
}

- (IBAction)changePassButtonPressed:(id)sender{
    PasswordViewController *pVC = [PasswordViewController new];
    [self.navigationController pushViewController:pVC animated:YES];
}

- (IBAction)nextButtonPressed:(id)sender{
    selectedBgImage ++;
    if (selectedBgImage == [bgImages count]) {
        selectedBgImage = 0;
    }
    [bgImageView setImage:bgImages[selectedBgImage]];
}

- (IBAction)prevButtonPressed:(id)sender{
    selectedBgImage --;
    if (selectedBgImage < 0) {
        selectedBgImage = [bgImages count] - 1;
    }
    [bgImageView setImage:bgImages[selectedBgImage]];
}

- (IBAction)deleteButtonPressed:(id)sender{
    
    if ([APP_DELEGATE loggedInUser].isDeleted > 0) {

        UserDataController *uDC = [UserDataController new];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [uDC reactiveAccount:[APP_DELEGATE loggedInUser].ID withSuccess:^{
            
            User *tmpUser = [APP_DELEGATE loggedInUser];
            tmpUser.isDeleted = 0;
            [APP_DELEGATE setLoggedInUser: tmpUser];



            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Account reactivated successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            alert.tag = 10;
            [alert show];            
            
        } failure:^(NSError *error) {
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            
        }];
    } else {
        UIAlertView *alertView;
        alertView = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:@"Do you want to deactivate this Account?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alertView show];
        alertView = nil;
    }
    
}

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 10) {
        if([[self.view subviews] containsObject:reactivateView])
        {
            [reactivateView removeFromSuperview];
        }
        [TopNavigationController addTabBarController];
        return;
    }
    
    switch (buttonIndex) {
        case 1:
            // delete account.
            [self deleteAccount];
            break;
            
        default:
            break;
    }
    
}

- (void)deleteAccount{
    UserDataController *uDC = [UserDataController new];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [uDC deleteAccount:[APP_DELEGATE loggedInUser].ID withSuccess:^{
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Account deactivated successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        [self signOffButtonPressed:nil];
        
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
    }];

}

#pragma mark - UIPickerView Delegates

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSInteger count;
    switch (pickerView.tag) {
        case GENDER_PICKER:
            count = [genderArray count];
            break;
            
        case GYMTYPE_PICKER:
            count = [gymCategory count];
            break;
            
        case COUNTRY_PICKER:
            count = [countryArray count];
            break;

        case STATE_PICKER:
            count = [stateArray count];
            break;
            
        // Gourav june 12 end
            
    }
    
    return count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSString *string;
    
    switch (pickerView.tag) {
        case GENDER_PICKER:
            string = [genderArray objectAtIndex:row];
            break;
            
        case GYMTYPE_PICKER:
            string = [gymCategory objectAtIndex:row];
            break;
            
        case COUNTRY_PICKER:
            string = [(Country *)[countryArray objectAtIndex:row] name];
            break;
            

        case STATE_PICKER:
            string   = [[stateArray objectAtIndex:row] name]; // Gourav june 22

            break;
            
            // Gourav june 12 end
            
    }
    
    return string;
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (thePickerView.tag) {
        case GENDER_PICKER:
            gender.text = [genderArray objectAtIndex:row];
            break;
            
        case GYMTYPE_PICKER:
            gymTypeTextField.text = [gymCategory objectAtIndex:row];
            break;
            
        case COUNTRY_PICKER:
            selectedCountry = (Country *)[countryArray objectAtIndex:row];
            country.text = selectedCountry.name;
            break;
            

        case STATE_PICKER:
            state.text =  [[stateArray objectAtIndex:row] name]; // [stateArray objectAtIndex:row]; // Gourav june 22

            break;
            
            // Gourav june 12 end
            

    }
    
}

#pragma mark - Table view
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 2;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GTVCell"];
//    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GTVCell"];
//        
//        [cell.imageView setImage:[UIImage imageNamed:@"gtv_icon"]];
//    }
//    
////    GTV *gtv = [dropDownMenu objectAtIndex:indexPath.row];
////    
////    cell.textLabel.text = gtv.name;
//    
//    return cell;
//}

#pragma mark - DropDown delegate

- (void)didSelectItemAtIndex:(NSInteger)index{
    
    addVC = nil;
    
    id friend = dropDownMenu[index];
    
    switch (selectedDropDown) {
        case 301:
            refer1TextField.text = [(Friend *)friend username];
            break;
            
            
            
        case 304:
            gymCityTextField.text = [(Gym *)friend city];
            gymStateTextField.text = [(Gym *)friend state];
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

- (void)didEnterText:(NSString *)text{
    
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
            [stringArray addObject:aFriend.username];
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

- (void)loadGyms:(NSString *)text{
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


- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:NO];
    }];
    return [super canPerformAction:action withSender:sender];
}

#pragma mark - UItable View data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number;
    
    switch (section) {
            
        case 0:
        case 1:
        case 2:
        case 3:
            number = 1;
            break;
            
        case 4:
            if (prefsExpandButton.selected)
                number = [prefs count];
            else
                number = 0;

            break;
    }
    
    return number;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height;
    
    switch (indexPath.section) {
        case 0:
            height = personalView.frame.size.height;
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
                height = 1050;
            }
            break;
        case 1:
            height = addressView.frame.size.height;
            break;
        case 2:
            height = referView.frame.size.height;
            break;
            
//        case 2:
//            height = checkInView.frame.size.height;
//            break;
            
        case 3:
            height = aboutView.frame.size.height;
            break;
        case 4:
            height = 44.0f;
            break;
    }
    
    return height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier;
    
    UITableViewCell *cell;
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
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
            case 3:
                cell = aboutView;
                break;

        }
    }
    
    if (indexPath.section == 4) {
        
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
            title = @"Tagline:";
            break;
//        case 2:
//            title = @"Check In:";
//            break;
        case 3:
            title = @"About Me:";
            break;

        case 4:
            title = @"";
            break;
    }
    
    return title;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor blueColor];
    
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
        case 2:
        case 3:
            height = 50;
            break;
            
        case 4:
            height = topView.frame.size.height;
            break;
    }
    
    return height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    CGFloat height;
    
    switch (section) {
        case 0:
        case 1:
        case 2:
        case 3:
            height = 0;
            break;
            
        case 4:
            height = bottomView.frame.size.height;
            break;
    }
    
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel *view;
    UIView *superview;
    NSString *title;
    
    switch (section) {
        case 0:
            title = @"";
            break;
        case 1:
            title = @"Gym Details:";
            break;
        case 2:
            title = @"Tagline:";
            break;
            //        case 2:
            //            title = @"Check In:";
            //            break;
        case 3:
            title = @"About Me:";
            break;
        case 4:
            title = @"";
            break;
    }
    
    
    if (section == 4) {
        return topView;
    }else{
        //view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
        view = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, tableView.bounds.size.width, 30)];
        superview =[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    }
    // view = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
  //  [view setTextColor:[UIColor colorWithRed:90/255.0f green:105/255.0f blue:226/255.0f alpha:1.0]];
    [view setTextColor:DEFAULT_BG_COLOR]; //yt8July

   // [view setTextAlignment:NSTextAlignmentJustified];
    [superview addSubview:view];
    [view setText:title];
    return superview;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view;
    
    if (section == 4) {
        view = bottomView;
    }else{
        view = nil;
    }
    return view;
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

#pragma mark - UItextFieldDelegate

//Peter
//City and state text field max length validation logic

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(textField == age) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:LEAGELNUM] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]     componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        return basicTest;
    }

    if (textField == statusDetailTextField) {
        NSString *stringtxt = textField.text;
        NSLog(@"%@",stringtxt);
        
//        if ((MAX_LENGTH_TAGLINE - statusDetailTextField.text.length) == 3) {
//            //lblTaglineLimit.textColor = [UIColor redColor];
//            Text_Field_Length = 1;
//            
//        }
//        else {
//            lblTaglineLimit.textColor = [UIColor blackColor];
//            
//        }
        
       
        if (statusDetailTextField.text.length + string.length - range.length >= 30) {
            lblTaglineLimit.text = [NSString stringWithFormat:@"You have %ld characters remaining",0];
            lblTaglineLimit.textColor = [UIColor redColor];
            Text_Field_Length = -1;
        }
        else
        {
             lblTaglineLimit.textColor = [UIColor blackColor];
            lblTaglineLimit.text = [NSString stringWithFormat:@"You have %ld characters remaining", MAX_LENGTH_TAGLINE - statusDetailTextField.text.length - Text_Field_Length];
           
        }
        
        
        
        
        NSRange textFieldRange = NSMakeRange(0, [textField.text length]);
        if (NSEqualRanges(range, textFieldRange) && [string length] == 0) {
            // Game on: when you return YES from this, your field will be empty
            lblTaglineLimit.text = [NSString stringWithFormat:@"You have %ld characters remaining", MAX_LENGTH_TAGLINE];
            Text_Field_Length = 1;
        }
      
        
        return [self isAcceptableTextLength:statusDetailTextField.text.length + string.length - range.length MaxLength:MAX_LENGTH_TAGLINE];
    }

    if (textField == city || textField == state) {
        if (textField.text.length >= MAX_LENGTH && range.length == 0)
        {
            return NO; // return NO to not change text
        }
        else
        {
            return YES;
        }
    }

    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    MHTextField *txtField = (MHTextField*)textField;
    if(txtField == firstName || textField == lastName || txtField == city || txtField == state)
    {
        NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@" abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ"] invertedSet];

        if ([txtField.text rangeOfCharacterFromSet:set].location != NSNotFound) {
            textField.text = @"";
            [Utility showAlertMessage:@"Please enter valid name"];
        }
    }
    else if(txtField == age)
    {
        NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        int ageValue = [txtField.text intValue];
        if ([txtField.text rangeOfCharacterFromSet:set].location != NSNotFound || ageValue  == 0 || ageValue>150) {
            textField.text = @"";
            [Utility showAlertMessage:@"Please enter valid Age"];
        }
    }
    else if(txtField == email)
    {
        if (![Utility validateEmailId:txtField.text]) {
            textField.text = @"";
            [Utility showAlertMessage:@"Please enter valid EmailId"];
        }
    }

    if (textField == statusDetailTextField) {
        lblTaglineLimit.text = @"";
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == statusDetailTextField) {
        lblTaglineLimit.text = @"";
    }
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITextView Delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ((ABOUTME_MAX_LENGTH - textView.text.length) == 0) {
        lblAboutMeLimit.textColor = [UIColor redColor];
    }
    else {
        lblAboutMeLimit.textColor = [UIColor blackColor];
    }
    lblAboutMeLimit.text = [NSString stringWithFormat:@"You have %ld characters remaining", ABOUTME_MAX_LENGTH - textView.text.length];
    
    NSRange textFieldRange = NSMakeRange(0, [textView.text length]);
    if (NSEqualRanges(range, textFieldRange) && [text length] == 0) {
        // Game on: when you return YES from this, your field will be empty
        lblAboutMeLimit.text = [NSString stringWithFormat:@"You have %ld characters remaining", ABOUTME_MAX_LENGTH];
       
    }
    
    return [self isAcceptableTextLength:textView.text.length + text.length - range.length MaxLength:ABOUTME_MAX_LENGTH];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView == aboutMeTextView) {
        lblAboutMeLimit.text = @"";
    }
}

- (BOOL)isAcceptableTextLength:(NSUInteger)length MaxLength:(NSUInteger)maxLength {
    return length <= maxLength;
}

@end
