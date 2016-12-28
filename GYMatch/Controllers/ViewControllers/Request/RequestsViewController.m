//
//  RequestsViewController.m
//  GYMatch
//
//  Created by Ram Gautam on 10/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "RequestsViewController.h"
#import "MBProgressHUD.h"
#import "UserDataController.h"
#import "RequestCell.h"
#import "FriendDetailsViewController.h"
#import "Utility.h"

#import "SpotlightsFilterViewController.h"
#import "GymFiltersViewController.h" // Gourav june 26
#import "SpotlightDataController.h"
#import "BookingRequestDetailViewController.h"
#import "PaypalViewController.h"

@interface RequestsViewController () <SpotLightFilterDelegate,GymFilterDelegate>{
    
    NSString *type;
    NSString *nibName;
    
    //SpotlightsFilterViewController *fVC;
    
    GymFiltersViewController *fVC; // Gourav june 26
    NSMutableDictionary *dicSearchKey;

    __weak RequestsViewController * weakSelf;
    __weak NSTimer *timer;
    
    NSMutableArray *friendsArray;
    int loadedCount;
}

@end

@implementation RequestsViewController

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
    searchBar.delegate = self ;
    type = @"Pending";
    
    friendsArray = [[NSMutableArray alloc] init];
    
    nibName = kRequestCell;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        nibName = kRequestCell_iPad;
        
        [friendsTableView setSeparatorInset:UIEdgeInsetsMake(0, 135, 0, 0)];
    }
    
    UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
    [friendsTableView registerNib:nib forCellReuseIdentifier:nibName];
    
    UIImage *titleLogo = [UIImage imageNamed:@"logo_titlebg"];
    UIImageView *titleView = [[UIImageView alloc]initWithImage:titleLogo];
    
    [[(TopNavigationController *)[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:1] navigationItem] setTitleView:titleView];
    
    friendsTableView.tableFooterView = [[UIView alloc] init];
    
    self.btnFilter.layer.cornerRadius = 5;
    dicSearchKey = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Select your name", @"name", @"Select your name", @"country", @"Select your name", @"state", @"Select your name", @"city", @"", @"gender", nil];
    [dicSearchKey setObject:type forKey:@"type"];
    
    
   // [self loadData];
    
    
//// Gourav june 11 start
//    
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureCalled:)];
//    [tapGesture setNumberOfTapsRequired:1];
//    
//    [self.view addGestureRecognizer:tapGesture];

     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(invalidateRequestLoading) name:@"LOGOUTCALLREQUEST" object:nil];

    weakSelf = self;
    timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:weakSelf selector:@selector(loadDataForPeningRequests) userInfo:nil repeats:YES];

}

-(void)viewWillAppear:(BOOL)animated
{
    
    [(TopNavigationController *)[[APP_DELEGATE tabBarController] selectedViewController] showProfileMenuOnlyCalendar];
    
    [self loadData];
}
-(void)invalidateRequestLoading
{

    if (timer) {
        [timer invalidate];
        timer = nil;
        weakSelf = nil;
    }
}

-(void)tapGestureCalled:(UITapGestureRecognizer *)gestureRecognizer
{
   // [searchBar resignFirstResponder];
}

// gourav june 11 end


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    
    [self.navigationItem setTitle:@"Requests"];
    
    [[[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:1] friendNavigationBar] setHidden:NO];
    
    [[[APP_DELEGATE tabBarController] tabBar] setHidden:NO];
    
//    [self loadData];
    
}

//- (void)viewWillDisappear:(BOOL)animated{
//    
//    [super viewWillDisappear:animated];
//    
//    [[[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:1] friendNavigationBar] setHidden:YES];
//    
//    [[[APP_DELEGATE tabBarController] tabBar] setHidden:YES];
//}

- (IBAction)onFilter:(id)sender {
//    if (fVC == nil) {
//        fVC = [[SpotlightsFilterViewController alloc] init];
//        fVC.delegate = self;
//    }
    
    // Gourav june 26 start
    if (fVC == nil) {
        fVC = [[GymFiltersViewController alloc] init];
        fVC.delegate = self;
    }

    // Gourav june 26 end
    
    
    [[[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:3] friendNavigationBar] setHidden:YES];
    
    [self.navigationController pushViewController:fVC animated:YES];
}

-(void)doneWithDictionary:(NSMutableDictionary *)dictionary {
    
    NSString *name = [dictionary objectForKey:@"name"];
    NSString *city = [dictionary objectForKey:@"city"];
    NSString *state = [dictionary objectForKey:@"state"];
    NSString *country = [dictionary objectForKey:@"country"];
    NSString *gender = [dictionary objectForKey:@"gender"];
    
    dicSearchKey = [[NSMutableDictionary alloc] initWithObjectsAndKeys:name, @"name", country, @"country", state, @"state", city, @"city", gender, @"gender", nil];
    [dicSearchKey setObject:type forKey:@"type"];
    [self loadData];
}

- (void)loadDataForPeningRequests {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSMutableDictionary *tempDicSearchKey = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Select your name", @"name", @"Select your name", @"country", @"Select your name", @"state", @"Select your name", @"city", @"", @"gender", nil];
    [tempDicSearchKey setObject:@"Pending" forKey:@"type"];

    UserDataController *uDC = [UserDataController new];
    [uDC requestsWithTypeDic:@"Pending" keyword:tempDicSearchKey Success:^(NSArray *friends) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        UITabBarItem *tbItem = [[[APP_DELEGATE tabBarController] viewControllers][1] tabBarItem];
            if([friends count] == 0)
                [tbItem setBadgeValue:nil];
            else
                [tbItem setBadgeValue:[NSString stringWithFormat:@"%lu",(unsigned long)[friends count]]];
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

- (void)loadData{
//    dicSearchKey = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Select your name", @"name", @"Select your name", @"country", @"Select your name", @"state", @"Select your name", @"city", @"", @"gender", nil];
    
    if ([Utility checkInvalidChars:searchBar.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter valid text" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if(![searchBar.text  isEqual: @""])
        [dicSearchKey setValue:searchBar.text forKey:@"name"];

    [friendsArray removeAllObjects];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    UserDataController *uDC = [UserDataController new];
    //[uDC requestsWithType:type keyword:searchBar.text Success:^(NSArray *friends) {
    
    loadedCount = 2;
    NSLog(@"type=> %@ dic search %@",type,dicSearchKey);
    [uDC requestsWithTypeDic:type keyword:dicSearchKey Success:^(NSArray *friends) {
        if (friends.count == 0) {
            loadedCount--;
            if (loadedCount == 0)
                [self reloadTableView];
        } else {
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                for (int i = 0; i < friends.count; i++) {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    dic[@"request_type"] = @"new_friend";
                    dic[@"user_info"] = [friends objectAtIndex:i];
                    [friendsArray addObject:dic];
                    
                    if (i == friends.count - 1) {
                        loadedCount--;
                        if (loadedCount == 0)
                            [self reloadTableView];
                    }
                }
            });
        }
    } failure:^(NSError *error) {
        loadedCount--;
        if (loadedCount == 0)
            [self reloadTableView];
    }];
    
    if ([((AppDelegate*)APP_DELEGATE).strUserType isEqualToString:@"Trainer"]) {
        [self loadBookingRequest];
    } else if ([((AppDelegate*)APP_DELEGATE).strUserType isEqualToString:@"free"]) {
        [self loadManagedRequest];
    } else {
        [self reloadTableView];
    }
}
- (void)loadBookingRequest {
    // Dragon
    NSDictionary *requestDictionary = @{@"trainer_id": [NSString stringWithFormat:@"%d", (int)[APP_DELEGATE loggedInUser].ID]}; //Dragon2
    SpotlightDataController *sDC = [SpotlightDataController new];
    [sDC getBookingRequest:requestDictionary withSuccess:^(NSDictionary *spotlight) {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([spotlight[@"status"] isEqualToString:@"Success"]) {
                NSArray *array = spotlight[@"response"];
                for (int i = 0; i < array.count; i++) {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[array objectAtIndex:i]][@"Booking"];
                    dic[@"request_type"] = @"booking_request";
                    
                    UserDataController *uDC = [UserDataController new];

                    [uDC profileDetails:[NSString stringWithFormat:@"%@", dic[@"appuser_id"]].integerValue withSuccess:^(Friend *aFriend) {
                        Friend *frnd = aFriend;
                        dic[@"user_info"] = frnd;
                        [friendsArray addObject:dic];
                        
                        if (i == array.count - 1) {
                            loadedCount--;
                            if (loadedCount == 0)
                                [self reloadTableView];
                        }
                    } failure:^(NSError *error) {
                        if (i == array.count - 1) {
                            loadedCount--;
                            if (loadedCount == 0)
                                [self reloadTableView];
                        }
                    }];
                }
            } else {
                loadedCount--;
                if (loadedCount == 0)
                    [self reloadTableView];
            }
        });
    } failure:^(NSError *error) {
        loadedCount--;
        if (loadedCount == 0)
            [self reloadTableView];
    }];
}
- (void)loadManagedRequest {
    // Dragon
    NSDictionary *requestDictionary = @{@"user_id": [NSString stringWithFormat:@"%d", (int)[APP_DELEGATE loggedInUser].ID]};
    SpotlightDataController *sDC = [SpotlightDataController new];
    [sDC getManagedBookingRequest:requestDictionary withSuccess:^(NSDictionary *spotlight) {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([spotlight[@"status"] isEqualToString:@"Success"]) {
                NSArray *array = spotlight[@"response"];        // Dragon3
                for (int i = 0; i < array.count; i++) {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[array objectAtIndex:i]][@"Booking"];
                    dic[@"request_type"] = @"managed_request";
                    
                    UserDataController *uDC = [UserDataController new];
                    [uDC profileDetails:[NSString stringWithFormat:@"%@", dic[@"appuser_id"]].integerValue withSuccess:^(Friend *aFriend) {
                        Friend *frnd = aFriend;
                        dic[@"user_info"] = frnd;
                        [friendsArray addObject:dic];
                        
                        if (i == array.count - 1) {
                            loadedCount--;
                            if (loadedCount == 0)
                                [self reloadTableView];
                        }
                    } failure:^(NSError *error) {
                        if (i == array.count - 1) {
                            loadedCount--;
                            if (loadedCount == 0)
                                [self reloadTableView];
                        }
                    }];
                }
            } else {
                loadedCount--;
                if (loadedCount == 0)
                    [self reloadTableView];
            }
        });
    } failure:^(NSError *error) {
        loadedCount--;
        if (loadedCount == 0)
            [self reloadTableView];
    }];
}
- (void) reloadTableView {
    [friendsTableView reloadData];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if ([friendsArray count] == 0) {
        noUserLabel.hidden = NO;
    } else {
        noUserLabel.hidden = YES;
    }
}
#pragma mark - IBActions

- (IBAction)friendTypeButtonPressed:(UIButton *)sender {
    
    for (UIButton *button in _friendsButtons) {
        if (button.tag == sender.tag) {
            button.selected = YES;
        } else {
            button.selected = NO;
        }
    }
    switch (sender.tag) {
        case 101:
            type = @"Pending";
            break;
            
        case 102:
            type = @"Blocked";
            break;
    }
    
    [dicSearchKey setObject:type forKey:@"type"]; // Gourav june 25
    
    [self loadData];
    
}


#pragma mark - UItable View data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return 100.0f;
    }
    return 80.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [friendsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RequestCell *cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    
    NSDictionary *dic = [friendsArray objectAtIndex:indexPath.row];
    
    Friend *friend = dic[@"user_info"];
    
    [cell fillWithFriend:friend];
    [cell setDictionary:dic];
    [cell setDelegate:self];
    
    if([type isEqualToString:@"Blocked"]){
        [cell.acceptButton setHidden:YES];
        [cell.declineButton setHidden:YES];
        [cell.unblockButton setHidden:NO];
        [cell.userLocationImageView setHidden:NO];
        [cell.locationLabel setHidden:NO];
    }else{
        [cell.acceptButton setHidden:NO];
        [cell.declineButton setHidden:NO];
        [cell.unblockButton setHidden:YES];
        [cell.userLocationImageView setHidden:YES];
        [cell.locationLabel setHidden:YES];
    }

    cell.viewController = self;
    
    return cell;
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

   if (friendsArray.count <= indexPath.row)
       return;
    
    NSDictionary *dic = [friendsArray objectAtIndex:indexPath.row];
     NSLog(@"Dragon Dictionary : %@", dic);
    if ([dic[@"request_type"] isEqualToString:@"new_friend"]) {
        FriendDetailsViewController *fdvc = [[FriendDetailsViewController alloc]init];
        Friend *friend = dic[@"user_info"];
        [fdvc setAFriend:friend];
        [[[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:1] friendNavigationBar] setHidden:YES];
        [self.navigationController pushViewController:fdvc animated:YES];
    } else {
        BookingRequestDetailViewController *fdvc = [[BookingRequestDetailViewController alloc]init];
        Friend *friend = dic[@"user_info"];
        NSLog(@"asdasdasd : %@", dic);
        [fdvc setAFriend:friend];
        [fdvc setDictionary:dic];
        [[[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:1] friendNavigationBar] setHidden:YES];
        [self.navigationController pushViewController:fdvc animated:YES];
    }
    
    [[[APP_DELEGATE tabBarController] tabBar] setHidden:YES];
    
}

#pragma mark - UIAlert View Delegte

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 1:
            break;
            
        default:
            break;
    }
}


#pragma mark - UISearchBar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)search_Bar{
    [search_Bar resignFirstResponder]; // Gourav june 11
    [self loadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)aSearchBar{
    [aSearchBar resignFirstResponder];
    [searchBar endEditing:YES];
    searchBar.text = @"";
   // Gourav june 11
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)search_Bar
{
    UITextField *searchBarTextField = nil;
    NSArray *views = ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0f) ? search_Bar.subviews : [[search_Bar.subviews objectAtIndex:0] subviews];
    for (UIView *subview in views)
    {
        if ([subview isKindOfClass:[UITextField class]])
        {
            searchBarTextField = (UITextField *)subview;
            break;
        }
    }
    searchBarTextField.enablesReturnKeyAutomatically = NO;
}


- (void)searchBar:(UISearchBar *)aSearchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope{
    switch (selectedScope) {
        case 0:
            type = @"Pending";
            [aSearchBar setScopeBarBackgroundImage:[UIImage imageNamed:@"requestbg1"]];
            break;
        
        case 1:
            type = @"Blocked";
            [aSearchBar setScopeBarBackgroundImage:[UIImage imageNamed:@"requestbg2"]];
            break;
    }
    [self loadData];
}

-(void)setTab{
    type = @"Pending";
}

- (void)actionAccept:(NSDictionary*)dictionary {
    if ([dictionary[@"request_type"] isEqualToString:@"booking_request"]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSDictionary *requestDictionary = @{@"trainer_id": [NSString stringWithFormat:@"%d", (int)[APP_DELEGATE loggedInUser].ID],
                                            @"id" : dictionary[@"id"],
                                            @"is_accepted" : @"1"};
        
        SpotlightDataController *sDC = [SpotlightDataController new];
        [sDC manageBookingRequest:requestDictionary withSuccess:^(NSDictionary *spotlight) {
            if ([spotlight[@"status"] isEqualToString:@"Success"]) {
                [[[UIAlertView alloc] initWithTitle:@"GYMatch" message:@"Success Accept Booking Request." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                [self loadData];
            }
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        } failure:^(NSError *error) {
            [[[UIAlertView alloc] initWithTitle:@"GYMatch" message:@"Fail Accept Booking Request." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    } else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        PaypalViewController *paypal = [[PaypalViewController alloc] init];
        paypal.delegate = self;
        NSString *cost = [[dictionary objectForKey:@"rate"] stringByReplacingOccurrencesOfString:@"$" withString:@""];
        cost = [cost stringByReplacingOccurrencesOfString:@" " withString:@""];

//dragon        [paypal payPaypal:(int)cost.integerValue];
        
        NSDictionary *requestDictionary = @{@"user_id": [NSString stringWithFormat:@"%d", (int)[APP_DELEGATE loggedInUser].ID],
                                            @"id" : dictionary[@"id"],
                                            @"is_paid" : @"1"};
        
        SpotlightDataController *sDC = [SpotlightDataController new];
        [sDC registerBooking:requestDictionary withSuccess:^(NSDictionary *spotlight) {
            if ([spotlight[@"status"] isEqualToString:@"Success"]) {
                [[[UIAlertView alloc] initWithTitle:@"GYMatch" message:@"Success Accept Booking Session." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                [self loadData];
            }
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        } failure:^(NSError *error) {
            [[[UIAlertView alloc] initWithTitle:@"GYMatch" message:@"Fail Accept Booking Session." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    }
}
- (void)actionDecline:(NSDictionary*)dictionary {
    if ([dictionary[@"request_type"] isEqualToString:@"booking_request"]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSDictionary *requestDictionary = @{@"trainer_id": [NSString stringWithFormat:@"%d", (int)[APP_DELEGATE loggedInUser].ID],
                                            @"id" : dictionary[@"id"],
                                            @"is_accepted" : @"2"};
        
        SpotlightDataController *sDC = [SpotlightDataController new];
        [sDC manageBookingRequest:requestDictionary withSuccess:^(NSDictionary *spotlight) {
            if ([spotlight[@"status"] isEqualToString:@"Success"]) {
                [[[UIAlertView alloc] initWithTitle:@"GYMatch" message:@"Success Decline Booking Request." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                [self loadData];
            }
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        } failure:^(NSError *error) {
            [[[UIAlertView alloc] initWithTitle:@"GYMatch" message:@"Fail Decline Booking Request." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    } else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSDictionary *requestDictionary = @{@"user_id": [NSString stringWithFormat:@"%d", (int)[APP_DELEGATE loggedInUser].ID],
                                            @"id" : dictionary[@"id"],
                                            @"is_paid" : @"2"};
        
        SpotlightDataController *sDC = [SpotlightDataController new];
        [sDC registerBooking:requestDictionary withSuccess:^(NSDictionary *spotlight) {
            if ([spotlight[@"status"] isEqualToString:@"Success"]) {
                [[[UIAlertView alloc] initWithTitle:@"GYMatch" message:@"Success Decline Booking Session." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                [self loadData];
            }
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        } failure:^(NSError *error) {
            [[[UIAlertView alloc] initWithTitle:@"GYMatch" message:@"Fail Decline Booking Session." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    }
}
- (void)payResult:(BOOL)flag {
    NSLog(@"Pay Result %d", flag);
}

@end
