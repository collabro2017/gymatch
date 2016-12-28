//
//  FriendTableViewController.m
//  GYMatch
//
//  Created by Ram on 28/05/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "FriendTableViewController.h"
#import "FriendCell.h"
#import "FBFriendCell.h"
#import "InviteMoreTableViewCell.h"
#import "FriendDetailsViewController.h"
#import "UserDataController.h"
#import "MBProgressHUD.h"
#import "SVSegmentedControl.h"
#import "Utility.h"

#import "SpotlightsFilterViewController.h"
#import "GymFiltersViewController.h" // Gourav june 26




@interface FriendTableViewController () <SpotLightFilterDelegate,GymFilterDelegate>{

    NSArray *friendsArray;
    NSArray *FBFriendsArray;
    NSArray *tempFBArray;
    NSInteger selectedTab;

    BOOL isSearchingFBFriends;
    BOOL isLoadingFriends;
    BOOL isRecommendShowing;
    
    NSString *friendCellNibName;

    //SpotlightsFilterViewController *fVC;

    GymFiltersViewController *fVC; // Gourav june 26

    NSMutableDictionary *dicSearchKey;
    NSMutableDictionary *dicRecommendedKey;
    UILabel *noResultLabel;
}

@end

@implementation FriendTableViewController

-(void)setLabelOnTableView:(BOOL)set
{
    //UILabel *label =  (UILabel*)[self.navigationController.view viewWithTag:1515];
    if(set)
    {
       [noResultLabel setHidden:set];
    }
    else
        [noResultLabel setHidden:set];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //self.tabBarController.delegate = self; //1sept
    filterInProcess = NO;
    reachability = [Reachability reachabilityForInternetConnection];

   // Add a lable in center of view to show if no data is in table.
    noResultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIApplication sharedApplication].keyWindow.frame.size.width, [UIApplication sharedApplication].keyWindow.frame.size.height)];
    noResultLabel.textColor = [UIColor lightGrayColor];
    [noResultLabel setText:@"No Results"];
    noResultLabel.tag = 1515;
    [noResultLabel setFont:[UIFont systemFontOfSize:15]];
    [noResultLabel setTextAlignment:NSTextAlignmentCenter];
    [friendsTableView addSubview:noResultLabel];
    noResultLabel.hidden = YES;

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(loadData) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        friendCellNibName = kFriendCelliPad;
        [friendsTableView setSeparatorInset:UIEdgeInsetsMake(0, 135, 0, 0)];

    }
    else {
        friendCellNibName = kFriendCell;
    }

    UINib *nib = [UINib nibWithNibName:friendCellNibName bundle:nil];
    [friendsTableView registerNib:nib forCellReuseIdentifier:friendCellNibName];

    nib = [UINib nibWithNibName:kFBFriendCell bundle:nil];
    [friendsTableView registerNib:nib forCellReuseIdentifier:kFBFriendCell];


    friendsTableView.tableFooterView = [[UIView alloc] init];

    selectedTab = 101;
    [self initializeMyDict];

    self.btnFilter.layer.cornerRadius = 5;
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [(TopNavigationController *)[[APP_DELEGATE tabBarController] selectedViewController] showProfileMenuOnlyCalendar];
}

-(void)initializeMyDict
{
    dicSearchKey = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Select your name", @"name", @"Select your name", @"country", @"Select your name", @"state", @"Select your name", @"city", @"", @"gender", nil];
    dicRecommendedKey = [[NSMutableDictionary alloc] init];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];

    [self.navigationItem setTitle:@"Friends"];
    UIImage *titleLogo = [UIImage imageNamed:@"logo_titlebg"];
    UIImageView *titleView = [[UIImageView alloc]initWithImage:titleLogo];

    [[(TopNavigationController *)[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:0] navigationItem] setTitleView:titleView];

    [[[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:0] friendNavigationBar] setHidden:NO];

    [[[APP_DELEGATE tabBarController] tabBar] setHidden:NO];

    searchBar.userInteractionEnabled = YES;

    [self loadData];

}


-(void)getFacebookInvitees
{
    FBSDKAppInviteContent *content =[[FBSDKAppInviteContent alloc] init];
    content.appLinkURL = [NSURL URLWithString:@"https://itunes.apple.com/us/app/gymatch/id727555004?ls=1&mt=8"];
    //optionally set previewImageURL
    //content.appInvitePreviewImageURL = [NSURL URLWithString:@"https://www.mydomain.com/my_invite_image.jpg"];

    // present the dialog. Assumes self implements protocol `FBSDKAppInviteDialogDelegate`
    [FBSDKAppInviteDialog showWithContent:content delegate:self];
}

-(BOOL)checkInternetConnectionAvailability
{
    if(reachability.currentReachabilityStatus == NotReachable)
        return NO;
    else
        return YES;
}

#pragma mark - load data

- (void)loadFBFriends{

    if ([Utility checkInvalidChars:searchBar.text]) {

        [self showAlertWithMessage:@"Please enter valid text" withErrorCode:0];
        return;
    }


    if ([tempFBArray count] > 0) {

        if (isSearchingFBFriends && ![searchBar.text isEqualToString:@""]) {

            NSMutableArray *tempFriends = [NSMutableArray new];

            for (NSDictionary<FBGraphUser>* friend in tempFBArray) {

                if ([friend.name rangeOfString:searchBar.text].length || [friend.name rangeOfString:[searchBar.text uppercaseString]].length) {
                    [tempFriends addObject:friend];
                }

                //                NSLog(@"I have a friend named %@ with id %@", friend.name, friend.id);

            }

            FBFriendsArray = tempFriends;


        }
        else{
            FBFriendsArray = tempFBArray;
        }

        isSearchingFBFriends = NO;
        [friendsTableView reloadData];

        return;
    }

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    isSearchingFBFriends = NO;
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {

        //        FBRequest* friendsRequest = [FBRequest requestForMyFriends];
        FBRequest* friendsRequest = [FBRequest requestForGraphPath:@"/me/friends?fields=gender,id,name,picture.width(100)"];
        // FBRequest* friendsRequest = [FBRequest requestForGraphPath:@"/me/friends?fields=name,picture.width(100)"];

        /*FBRequest *friendsRequest = [FBRequest requestForGraphPath:@"me/taggable_friends?fields=gender,id,name,picture.width(100)"];*/
        /*[fbRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            NSAssert(!error, error.localizedDescription);
            NSArray *friends = [(NSDictionary *)result objectForKey:@"data"];
            for (NSDictionary<FBGraphUser> *user in friends) {
                if ([user[@"installed"] isEqual:@(NO)])
                    [notYetUsers addObject:user];
            }
        }];*/

        [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                      NSDictionary* result,
                                                      NSError *error) {
            NSLog(@"Result: %@", result);
            NSArray* friends = [result objectForKey:@"data"];

            /*NSString *str = [[result objectForKey:@"paging"] objectForKey:@"next"];
            NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
            NSURLResponse * response = nil;
            NSError * eror = nil;
            NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                                  returningResponse:&response
                                                              error:&eror];
            if (eror == nil)
            {
                NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"Friends %@",obj);
                // Parse data here
            }
 */


            FBFriendsArray = friends;
            tempFBArray = FBFriendsArray;
            NSLog(@"Found: %lu friends", (unsigned long)friends.count);
            //            for (NSDictionary<FBGraphUser>* friend in friends) {
            //                NSLog(@"I have a friend named %@ with id %@", friend.name, friend.id);
            //            }

            dispatch_async(dispatch_get_main_queue(), ^{

                [friendsTableView reloadData];

                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

            });

        }];

        // If the session state is not any of the two "open" states when the button is clicked
    } else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for basic_info permissions when opening a session
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email", @"user_friends"] allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {

             // Retrieve the app delegate

             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
             [APP_DELEGATE sessionStateChanged:session state:state error:error];

             //             FBRequest* friendsRequest = [FBRequest requestForMyFriends];
             FBRequest* friendsRequest = [FBRequest requestForGraphPath:@"/me/friends?fields=gender,id,name,email,picture.width(100)"];

             [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                           NSDictionary* result,
                                                           NSError *error) {

                 if (error == nil) {
                     NSLog(@"Result: %@", result);

                     NSArray* friends = [result objectForKey:@"data"];

                     FBFriendsArray = friends;

                     tempFBArray = FBFriendsArray;

                     NSLog(@"Found: %lu friends", (unsigned long)friends.count);
                     //                 for (NSDictionary<FBGraphUser>* friend in friends) {
                     //                     NSLog(@"I have a friend named %@ with id %@", friend.name, friend.id);
                     //
                     //                 }



                 }else if([FBErrorUtility shouldNotifyUserForError:error]){
                     [self showAlertWithMessage:[FBErrorUtility userMessageForError:error] withErrorCode:0];

                     FBFriendsArray = nil;

                     tempFBArray = FBFriendsArray;

                 }else{

                     NSError *innerError = [error.userInfo valueForKey:@"com.facebook.sdk:ErrorInnerErrorKey"];

                     //Peter
                     if (innerError) {

                         [self showAlertWithMessage:error.localizedDescription withErrorCode:0];
                     }

                     FBFriendsArray = nil;

                     tempFBArray = FBFriendsArray;

                 }

                 dispatch_async(dispatch_get_main_queue(), ^{

                     [friendsTableView reloadData];

                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

                 });

             }];
         }];
    }


}

#pragma mark - Intialize data

- (void)loadData {
    
    if ([Utility checkInvalidChars:searchBar.text]) {
        [self showAlertWithMessage:@"Please enter valid text" withErrorCode:0];
        [self initializeMyDict];
        return;
    }
    
    BOOL isInternetAvailable = [self checkInternetConnectionAvailability];
    
    if (isLoadingFriends) {
        [self initializeMyDict];
        if (!isInternetAvailable) {
            isLoadingFriends = NO;
            [self.refreshControl endRefreshing];
            [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
        }
        return;
    }
    
    
    UserDataController *uDC = [UserDataController new];
    
    if(![searchBar.text  isEqual: @""])
    {
        [dicSearchKey setValue:searchBar.text forKey:@"name"];
    }
    else if (!filterInProcess)
        dicSearchKey = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Select your name", @"name", @"Select your name", @"country", @"Select your name", @"state", @"Select your name", @"city", @"", @"gender", nil];
    
    
    //check internet cunnectivity
    if(!isInternetAvailable)
    {
        [self.refreshControl endRefreshing];
        [self showAlertWithMessage:@"The Internet connection appears to be offline." withErrorCode:0];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    isLoadingFriends = YES;
    
    if ([Utility wantsRecommendations] && filterInProcess && [searchBar.text isEqualToString:@""]) {
        //Make Service call here
        if (dicRecommendedKey != nil) {
            [self filterAndLoadRecommended];
        }
    }
    else {
        filterInProcess = NO;

        [uDC friendsWithDic:[APP_DELEGATE loggedInUser].ID withKeyword:dicSearchKey withSuccess:^(NSArray *friends) {
            friendsArray = friends;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self initializeMyDict];
                [friendsTableView reloadData];
                [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
                isLoadingFriends = NO;
                
                if ([friendsArray count] == 1)
                {
                    Friend *frnd = [friendsArray firstObject];
                    if(frnd.ID != 1)
                        return;
                    
                    if ([Utility wantsRecommendations]) {
                        [self loadRecommented];
                        //noResultLabel.hidden = YES;
                    }
                    else{
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"You have no friends. Do you want to see GYMatch recommendations?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
                        [alertView show];

                        //[self showAlertWithMessage:@"You have no friends. Do you want to see GYMatch recommendations?" withErrorCode:0];
                    }
                }
                else {
                    [Utility recommendations:NO];
                }
                
            });
            
            [self.refreshControl endRefreshing];
            
        } failure:^(NSError *error) {
            isLoadingFriends = NO;
            [self initializeMyDict];
            //  NSLog(@"Error Description - %@", error.localizedRecoverySuggestion);
            [self.refreshControl endRefreshing];
            [self showAlertWithMessage:error.localizedDescription withErrorCode:error.code];

            [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
            
        }];
    }
    
}

- (void)filterAndLoadRecommended {
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    UserDataController *uDC = [UserDataController new];
    NSLog(@"%@", dicRecommendedKey);
    
    if (dicRecommendedKey.count == 0) {
        if(dicSearchKey.count == 0) {
            dicSearchKey = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"", @"name", @"Select your name", @"country", [APP_DELEGATE loggedInUser].state, @"state", @"Select your name", @"city", @"", @"gender", nil];
            dicRecommendedKey = dicSearchKey;
        }
        else {
            dicRecommendedKey = dicSearchKey;
            [self loadData];
            return;
        }
        
    }
    else {
        if (filterInProcess) {
            //[self initializeMyDict]; Check when user taps on Gymatch friends
            dicRecommendedKey = dicSearchKey;
            dicRecommendedKey = [self checkDictionryExists:dicRecommendedKey];
        }
        else {
            dicSearchKey = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"", @"name", @"Select your name", @"country", [APP_DELEGATE loggedInUser].state, @"state", @"Select your name", @"city", @"", @"gender", nil];
            dicRecommendedKey = dicSearchKey;
        }
    }
    
    
    [uDC recommendedWithDictionary:dicRecommendedKey withSuccess:^(NSArray *friends) {
        friendsArray = friends;
        isLoadingFriends = NO;
        [friendsTableView reloadData];
        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
        [self.refreshControl endRefreshing];
    } failure:^(NSError *error) {
        isLoadingFriends = NO;
        [self.refreshControl endRefreshing];
        [self showAlertWithMessage:error.localizedDescription withErrorCode:error.code];
        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
    }];
}

- (void)loadRecommented {
    
    if ([Utility checkInvalidChars:searchBar.text]) {
        [self showAlertWithMessage:@"Please enter valid text"  withErrorCode:0];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    UserDataController *uDC = [UserDataController new];
    
    [uDC recommendedWithKeyword:searchBar.text withSuccess:^(NSArray *friends) {
        friendsArray = friends;
        if ([friendsArray count] == 0)
        {

            Friend *frnd = [friendsArray firstObject];
            if(frnd.ID != 1)
                return;

//            if(frnd.ID != 1) {
//                [self showAlertWithMessage:@"No users are available in your region" withErrorCode:0];
//                [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
//                return;
//            }

            if ([Utility wantsRecommendations]) {
                [self loadRecommented];
                noResultLabel.hidden = YES;
            }
            else {
                noResultLabel.hidden = NO;
                //[self showAlertWithMessage:@"You have no friends. Do you want to see GYMatch recommendations?" withErrorCode:0];
            }
        }
        
        isLoadingFriends = NO;
        [friendsTableView reloadData];
        
        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
        [self.refreshControl endRefreshing];
    } failure:^(NSError *error) {
        //  error.localizedDescription
        isLoadingFriends = NO;
        [self.refreshControl endRefreshing];
        [self showAlertWithMessage:error.localizedDescription withErrorCode:error.code];
        
        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
    }];
}

- (NSMutableDictionary *)resetDictionary:(NSMutableDictionary *)dictionary {
    if ([[dictionary objectForKey:@"city"] isEqualToString:@""]) {
        [dictionary setValue:@"Select your name" forKey:@"city"];
    }
    
    if ([[dictionary objectForKey:@"country"] isEqualToString:@""]) {
        [dictionary setValue:@"Select your name" forKey:@"country"];
    }
    
    if ([[dictionary objectForKey:@"name"] isEqualToString:@""]) {
        [dictionary setValue:@"Select your name" forKey:@"name"];
    }
    
    if ([Utility wantsRecommendations]) {
        if ([[dictionary objectForKey:@"state"] isEqualToString:@""]) {
            [dictionary setValue:[APP_DELEGATE loggedInUser].state forKey:@"state"];
        }
    }
    else {
        if ([[dictionary objectForKey:@"state"] isEqualToString:@""]) {
            [dictionary setValue:@"Select your name" forKey:@"state"];
        }
    }
    
    if ([[dictionary objectForKey:@"gender"] isEqualToString:@""]) {
        [dictionary setValue:@"" forKey:@"gender"];
    }
    
    return dictionary;
}

- (NSMutableDictionary *)checkDictionryExists:(NSMutableDictionary *)dictonry {
    if ([dictonry allKeys].count == 0) {
        dictonry = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Select your name", @"name", @"Select your name", @"country", [APP_DELEGATE loggedInUser].state, @"state", @"Select your name", @"city", @"", @"gender", nil];
    }
    return  dictonry;
}

#pragma mark - IBActions

- (IBAction)friendTypeButtonPressed:(UIButton *)sender {

    dicSearchKey = [NSMutableDictionary dictionary];  //yt10July
    searchBar.text = @"";
    
    selectedTab = sender.tag;
    for (UIButton *button in friendsButtons) {
        if (button.tag == sender.tag) {
            button.selected = YES;
        }
        else {
            button.selected = NO;
        }
    }

    switch (selectedTab) {
        case 101:
            if (isRecommendShowing) {
                [self loadRecommented];
            }
            else {
                [self loadData];
            }

            [searchBar setPlaceholder:@""];
            break;

        case 102:
            [self loadFBFriends];
            [searchBar setPlaceholder:@""];
            break;
    }
}


#pragma mark - UItable View data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return 100.0f;
    }
    return 70.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    NSInteger friendCount = 0;
    if (selectedTab == 101) {
        friendCount = [friendsArray count];
    }else{
        friendCount = [FBFriendsArray count] + 1;
    }

   // BOOL alreadyAdded = [[self.navigationController.view subviews] containsObject:noResultLabel];
    if(friendCount == 0)
    {
        //[self setLabelOnTableView:YES];
        noResultLabel.hidden = NO;
    }
    else
    {
        noResultLabel.hidden = YES;
        //[self setLabelOnTableView:NO];
    }

    return friendCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if (selectedTab == 101) {
        cell = [tableView dequeueReusableCellWithIdentifier:friendCellNibName];
        Friend *friend = [friendsArray objectAtIndex:indexPath.row];
        [(FriendCell *)cell fillWithFriend:friend];

    }
    else
    {
        if (indexPath.row < [FBFriendsArray count]) {
            cell = [tableView dequeueReusableCellWithIdentifier:kFBFriendCell];
            NSDictionary<FBGraphUser> *friend = [FBFriendsArray objectAtIndex:indexPath.row];
            [(FBFriendCell *)cell fillWithFBFriend:friend];
        }
        else
        {
            cell = [tableView dequeueReusableCellWithIdentifier:kInviteMoreFriendCell];
            if (cell == nil) {
                // Load the top-level objects from the custom cell XIB.
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"InviteMoreTableViewCell" owner:self options:nil];
                // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
                cell = [topLevelObjects objectAtIndex:0];
            }
        }
    }
    //    [cell.buttonView setHidden:YES];
    return cell;
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (selectedTab == 102) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];

        return;
    }

    FriendDetailsViewController *fdvc = [[FriendDetailsViewController alloc]init];
    [fdvc setAFriend:[friendsArray objectAtIndex:indexPath.row]];
    //    [[[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:0] friendNavigationBar] setHidden:YES];

    [self.navigationController pushViewController:fdvc animated:YES];

    [[[APP_DELEGATE tabBarController] tabBar] setHidden:YES];
}

#pragma mark - UIAlert View Delegte

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 1:
            isRecommendShowing = YES;
            [Utility recommendations:YES];
            [self loadRecommented];
            break;

        default:
            break;
    }
}

-(void)showAlertWithMessage:(NSString*)msgStr withErrorCode:(NSInteger)code
{
    //if(code == -1003)
        //msgStr = @"Please check your Internet connection.";

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:msgStr delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark - UISearchbar delegate

-(void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope{

    switch (selectedScope) {
        case 0:
            selectedTab = 101;
            if (isRecommendShowing) {
                [self loadRecommented];
            }
            else {
                [self loadData];
            }
            break;

        case 1:
            selectedTab = 102;
            [self loadFBFriends];
            break;
    }

}


- (void)searchBarSearchButtonClicked:(UISearchBar *)aSearchBar{
    NSString *keyword = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    searchBar.text = keyword;
    
    switch (selectedTab) {
        case 101:
            if (isRecommendShowing) {
                [self loadRecommented];
            }
            else {
                [self loadData];
            }
            break;

        case 102:
            [self loadFBFriends];
            break;
    }

    [searchBar resignFirstResponder];
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


- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    //dicSearchKey = [NSMutableDictionary dictionary];  //yt10July
    switch (selectedTab) {
        case 101:
            
            if (isRecommendShowing) {
                [self loadRecommented];
            }
            else {
                [self loadData];
            }
            break;

        case 102:
            [self loadFBFriends];
            break;
    }
}



- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    switch (selectedTab) {
        case 101:

            break;

        case 102:
            isSearchingFBFriends = YES;
            [self loadFBFriends];
            break;
    }
}


#pragma mark -
#pragma mark - Filter Delegate

- (IBAction)onFilter:(id)sender {
    if (fVC == nil) {
        fVC = [[GymFiltersViewController alloc] init];
        fVC.delegate = self;
    }
    [[[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:3] friendNavigationBar] setHidden:YES];
    [self.navigationController pushViewController:fVC animated:YES];
}

-(void)doneWithDictionary:(NSMutableDictionary *)dictionary {
    //NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.txtName.text, @"name", self.txtCountry.text, @"country", self.txtState.text, @"state", self.txtCity.text, @"city", self.txtGender, @"gender", nil];
    NSLog(@"%@", dictionary);
    filterInProcess  = YES;
    dicSearchKey = dictionary;
    dicRecommendedKey = dictionary;
}

#pragma mark-
#pragma mark FBInviteeDelegate Methods-

- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didCompleteWithResults:(NSDictionary *)results
{
    NSLog(@"FB Success Invite Results: %@", results);
}

- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didFailWithError:(NSError *)error
{
    NSLog(@"FB Fail Invite Results: %@", error.description);
}

@end
