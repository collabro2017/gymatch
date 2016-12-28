//
//  BookingRequestDetailViewController.m
//  GYMatch
//
//  Created by Ram Gautam on 11/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "BookingRequestDetailViewController.h"
#import "AlbumViewController.h"
#import "ChatViewController.h"
#import "InnerCircleViewController.h"
#import "AddGymViewController.h"
#import "ReportViewController.h"
#import "RecommendViewController.h"
#import "Friend.h"
#import "UIImageView+WebCache.h"
#import "UserDataController.h"
#import "MBProgressHUD.h"
#import "User.h"
#import "EditProfileViewController.h"
#import "Utility.h"
#import "CheckinViewController.h"
#import "UIImage+Overlay.h"
#import "GymChatViewController.h"

//#import "SpotlightDetailsViewController.h"
#import "FriendWithSpotlightViewController.h"
#import "EarningPointsViewController.h"
#import "MyPointsViewController.h"

#import "TGRImageViewController.h"
#import "TGRImageZoomAnimationController.h"
#import "Constants.h" // Gourav june 25
#import "SpotlightDataController.h"


@interface BookingRequestDetailViewController () <UIViewControllerTransitioningDelegate>
{
    
    __weak IBOutlet UIView *viewSessions;
    __weak IBOutlet UILabel *lblBodyParts;
    __weak IBOutlet UILabel *lblWorkoutType;
    __weak IBOutlet UILabel *lblSkype;
    __weak IBOutlet UILabel *lblRate;
}



@end

@implementation BookingRequestDetailViewController

- (id)init{
    
    NSString *nibName = @"BookingRequestDetailViewController";
    
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.    
    NSLog(@"Spostlight Member ID : %ld",(long)self.self.aFriend.member_id);
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithInteger:self.self.aFriend.member_id]  forKey:@"member_id"];
    
    [userDefaults synchronize];
    
    //  [self fillDetailsWithFriend:self.self.aFriend];
    
    [scrollView setContentInset:UIEdgeInsetsMake(0, 0, -50, 0)];
    [scrollView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, -50, 0)];
    
    [[self.view subviews][0] setHidden:YES];
    
    //mac
    //Spotlight_Detail_Btn.layer.cornerRadius=8.0f;
    
    //use 3 or 7 or 12 for symmetric look (current implementation supports max 12 buttons)
    NSArray *arrImageName = [[NSArray alloc] initWithObjects:@"avail-0",
                             @"avail-1",
                             @"avail-2",
                             nil];
    
    _iNumberOfButtons = arrImageName.count > 12 ? 12 : arrImageName.count;//current implementation supports max 12 buttons
    _arrButtonImageName = [[NSArray alloc] initWithArray:arrImageName];
    
    _strCornerButtonImageName = @"";
    _strCornerButtonImageName = @"";
    self.delegateCircularMenu = self;
    
    
    _fButtonSize = 40;//circular button width/height
    _fInnerRadius = 45;//1st circle boundary

    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(avatorSingleTapped:)];
    singleTap.numberOfTapsRequired = 1;
    [avatorButton addGestureRecognizer:singleTap];
}



- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    // [[[APP_DELEGATE tabBarController] tabBar] setHidden:YES];
    
    
    if(self.self.aFriend.ID == [APP_DELEGATE loggedInUser].ID) {
        [self.navigationItem setTitle:@"My Profile"];
    } else {
        NSString *title = @"My GYMatch";
        [self.navigationItem setTitle:[title substringToIndex:MIN(25, title.length)]];
    }
    
    [self loadData];
}

- (void)loadData{  
    
    self.view.backgroundColor = [Utility colorForView:self.aFriend.bgImage];
    
    if((self.self.aFriend.ID == [APP_DELEGATE loggedInUser].ID)){
        [self.navigationItem setTitle:@"My Profile"];
    } else {
        NSString *title = @"My GYMatch";
        [self.navigationItem setTitle:[title substringToIndex:MIN(25, title.length)]];
    }
    
    nameLabel.text = (![self.aFriend.name isEqualToString:@""]) ? self.aFriend.name : self.aFriend.username;
    
    if (self.aFriend.age > 0) {
        genderLabel.text = [NSString stringWithFormat:@"%@, %ld",
                            self.aFriend.gender,
                            (long)self.aFriend.age];
    } else{
        genderLabel.text = self.aFriend.gender;
    }
    
    if([self.aFriend.name  isEqual:@"GYMatch"]){ //yt28July
        genderLabel.text = @"Fitness";
    }
    
    NSString *locText = self.aFriend.fullAddress;
    
    if ([self.aFriend.fullAddress isEqualToString:@""]) {
        //        [locationImageView setHidden:YES];
        [locationButton setHidden:YES];
        
    }
    else{
        //        [locationImageView setHidden:NO];
        [locationButton setHidden:NO];
        
    }
    
    cityLabel.text = locText;
    [locationButton setTitle:locText forState:UIControlStateNormal];
    
    if (self.aFriend.pictureCount == 0 && self.aFriend.ID != [[APP_DELEGATE loggedInUser] ID]) {
    }else{
        NSString *string;
        
        if (self.aFriend.pictureCount == 1) {
            string = [NSString stringWithFormat:@"%ld Picture", (long)self.aFriend.pictureCount];
        }else{
            string = [NSString stringWithFormat:@"%ld Pictures", (long)self.aFriend.pictureCount];
        }
    }
    
    if (self.aFriend.friendCount == 0) {
    }else{
        NSString *string;
        if (self.aFriend.friendCount == 1) {
            string = [NSString stringWithFormat:@"%ld Friend", (long)self.aFriend.friendCount];
        }else{
            string = [NSString stringWithFormat:@"%ld Friends", (long)self.aFriend.friendCount];
        }
    }
        
    [bgImageView setImage:[Utility imageForBgTitle:self.aFriend.bgImage]];
    
    
    NSURL *imageURL = [NSURL URLWithString:self.aFriend.image];
    
    [imageView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"user_plus"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [scrollView layoutIfNeeded];
    
    [[self.view subviews][0] setHidden:NO];
    
    
    UILabel *lblSession = [viewSessions viewWithTag:1];
    lblSession.text = [NSString stringWithFormat:@"%@, %@~%@", [APP_DELEGATE getCurrentDateInfoFromString:self.dictionary[@"booking_date"]], self.dictionary[@"start_time"], self.dictionary[@"end_time"]];
    [lblSession setAdjustsFontSizeToFitWidth:YES];
    NSString *strMultipleSession = self.dictionary[@"multiple_session_date"];
    int multipleSessionCount = 0;
    if (strMultipleSession.length > 0) {
        [strMultipleSession stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSArray *aryMultipleSession = [strMultipleSession componentsSeparatedByString:@","];
        multipleSessionCount = (int)aryMultipleSession.count;
        for (int i = 0; i < multipleSessionCount; i++) {
            UILabel *lblSession = [viewSessions viewWithTag:i + 2];
            lblSession.text = [NSString stringWithFormat:@"%@, %@~%@", [APP_DELEGATE getCurrentDateInfoFromString:[aryMultipleSession objectAtIndex:i]], self.dictionary[@"multiple_session_start_time"], self.dictionary[@"multiple_session_end_time"]];
            [lblSession setAdjustsFontSizeToFitWidth:YES];
        }

    }
    for (int i = multipleSessionCount + 1; i <= 8; i++) {
        UILabel *lblSession = [viewSessions viewWithTag:i];
        lblSession.text = @"";
    }
    
    lblBodyParts.text = self.dictionary[@"body_parts"];
    lblWorkoutType.text = self.dictionary[@"workout_type"];
    lblSkype.text = self.dictionary[@"skype_id"];
    int duration = (int)((NSString*)self.dictionary[@"duration"]).integerValue;
    if ([self.dictionary[@"training_hour_type"] isEqualToString:@"hour"]) {
        lblRate.text = [NSString stringWithFormat:@"%d hrs ~ %@", duration / 60, self.dictionary[@"rate"]];
    } else {
        lblRate.text = [NSString stringWithFormat:@"%d mins ~ %@", duration, self.dictionary[@"rate"]];
    }
}

-(void)avatorSingleTapped:(UIGestureRecognizer *)tapGesture{
    NSLog(@"FriendDetailes Gesture is called");
    _pictureView = [[AvatorViewController alloc] initWithNibName:@"AvatorViewController" bundle:nil];
    _pictureView.image = imageView.image;
    //[self.navigationController pushViewController:_pictureView animated:NO];
    [self.view addSubview:_pictureView.view];
    [_pictureView.view setFrame:[[UIScreen mainScreen] bounds]];
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromRight;
    [_pictureView.view.window.layer addAnimation:transition forKey:kCATransition];
}

- (IBAction)actionAccept:(id)sender {
    if ([self.dictionary[@"request_type"] isEqualToString:@"booking_request"]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSDictionary *requestDictionary = @{@"trainer_id": [NSString stringWithFormat:@"%d", (int)[APP_DELEGATE loggedInUser].ID],
                                            @"id" : self.dictionary[@"id"],
                                            @"is_accepted" : @"1"};
        
        SpotlightDataController *sDC = [SpotlightDataController new];
        [sDC manageBookingRequest:requestDictionary withSuccess:^(NSDictionary *spotlight) {
            [[[UIAlertView alloc] initWithTitle:@"GYMatch" message:@"Success Accept Booking Request." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            [self.navigationController popViewControllerAnimated:YES];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        } failure:^(NSError *error) {
            [[[UIAlertView alloc] initWithTitle:@"GYMatch" message:@"Fail Accept Booking Request." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            [self.navigationController popViewControllerAnimated:YES];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    } else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSDictionary *requestDictionary = @{@"user_id": [NSString stringWithFormat:@"%d", (int)[APP_DELEGATE loggedInUser].ID],
                                            @"id" : self.dictionary[@"id"],
                                            @"is_accepted" : @"1"};
        
        SpotlightDataController *sDC = [SpotlightDataController new];
        [sDC manageBookingRequest:requestDictionary withSuccess:^(NSDictionary *spotlight) {
//Dragon3  pay       [[[UIAlertView alloc] initWithTitle:@"GYMatch" message:@"Success Accept Booking Session." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//                [self.navigationController popViewControllerAnimated:YES];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        } failure:^(NSError *error) {
            [[[UIAlertView alloc] initWithTitle:@"GYMatch" message:@"Fail Accept Booking Session." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            [self.navigationController popViewControllerAnimated:YES];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    }
}
- (IBAction)actionDecline:(id)sender {
    if ([self.dictionary[@"request_type"] isEqualToString:@"booking_request"]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSDictionary *requestDictionary = @{@"trainer_id": [NSString stringWithFormat:@"%d", (int)[APP_DELEGATE loggedInUser].ID],
                                    @"id" : self.dictionary[@"id"],
                                    @"is_accepted" : @"0"};

        SpotlightDataController *sDC = [SpotlightDataController new];
        [sDC manageBookingRequest:requestDictionary withSuccess:^(NSDictionary *spotlight) {
            [[[UIAlertView alloc] initWithTitle:@"GYMatch" message:@"Success Decline Booking Request." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            [self.navigationController popViewControllerAnimated:YES];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        } failure:^(NSError *error) {
            [[[UIAlertView alloc] initWithTitle:@"GYMatch" message:@"Fail Decline Booking Request." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            [self.navigationController popViewControllerAnimated:YES];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    } else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSDictionary *requestDictionary = @{@"user_id": [NSString stringWithFormat:@"%d", (int)[APP_DELEGATE loggedInUser].ID],
                                            @"id" : self.dictionary[@"id"],
                                            @"is_accepted" : @"0"};
        
        SpotlightDataController *sDC = [SpotlightDataController new];
        [sDC manageBookingRequest:requestDictionary withSuccess:^(NSDictionary *spotlight) {
            [[[UIAlertView alloc] initWithTitle:@"GYMatch" message:@"Success Decline Booking Session." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            [self.navigationController popViewControllerAnimated:YES];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        } failure:^(NSError *error) {
            [[[UIAlertView alloc] initWithTitle:@"GYMatch" message:@"Fail Decline Booking Session." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            [self.navigationController popViewControllerAnimated:YES];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    }
}


@end
