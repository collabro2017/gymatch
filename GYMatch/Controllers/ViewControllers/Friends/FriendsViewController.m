//
//  FriendsViewController.m
//  GYMatch
//
//  Created by Ram Gautam on 10/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "FriendsViewController.h"
#import "FriendCell.h"
#import "FBFriendCell.h"
#import "FriendDetailsViewController.h"
#import "UserDataController.h"
#import "MBProgressHUD.h"


@interface FriendsViewController (){
    NSArray *friendsArray;
    NSArray *FBFriendsArray;
    NSArray *tempFBArray;
    NSInteger selectedTab;
    
    BOOL isSearching;
    
    BOOL isRecommendShowing;
}

@end

@implementation FriendsViewController

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
    
    UINib *nib = [UINib nibWithNibName:kFriendCell bundle:nil];
    [friendsTableView registerNib:nib forCellReuseIdentifier:kFriendCell];
    
    nib = [UINib nibWithNibName:kFBFriendCell bundle:nil];
    [friendsTableView registerNib:nib forCellReuseIdentifier:kFBFriendCell];
    
    
    friendsTableView.tableFooterView = [[UIView alloc] init];
    
    selectedTab = 101;
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    
    [self.navigationItem setTitle:@"Friends"];
    [super viewDidAppear:animated];
    UIImage *titleLogo = [UIImage imageNamed:@"logo_titlebg"];
    UIImageView *titleView = [[UIImageView alloc]initWithImage:titleLogo];
    
    [[(TopNavigationController *)[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:0] navigationItem] setTitleView:titleView];
    
    [[[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:0] friendNavigationBar] setHidden:NO];
    
    [[[APP_DELEGATE tabBarController] tabBar] setHidden:NO];
    
}

- (void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    UserDataController *uDC = [UserDataController new];
    [uDC friendsOf:[APP_DELEGATE loggedInUser].ID withKeyword:searchBar.text withSuccess:^(NSArray *friends) {
        friendsArray = friends;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [friendsTableView reloadData];
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            if ([friendsArray count] == 0) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"You have no friends. Do you want to see GYMatch recommendatations?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
                [alertView show];
            }
        });
        
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

- (void)loadRecommented{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    UserDataController *uDC = [UserDataController new];
    [uDC recommendedWithKeyword:searchBar.text withSuccess:^(NSArray *friends) {
        friendsArray = friends;
        
        [friendsTableView reloadData];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

- (void)loadFBFriends{
    
    if ([tempFBArray count] > 0) {
        
        if (isSearching && ![searchBar.text isEqualToString:@""]) {
            
            NSMutableArray *tempFriends = [NSMutableArray new];
            
            for (NSDictionary<FBGraphUser>* friend in tempFBArray) {
                
                if ([friend.name rangeOfString:searchBar.text].length || [friend.name rangeOfString:[searchBar.text uppercaseString]].length) {
                    [tempFriends addObject:friend];
                }
                
//                NSLog(@"I have a friend named %@ with id %@", friend.name, friend.id);
            
            }
            
            FBFriendsArray = tempFriends;
            
            
        }else{
            FBFriendsArray = tempFBArray;
        }
        
        isSearching = NO;
        [friendsTableView reloadData];
        
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    isSearching = NO;
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
//        FBRequest* friendsRequest = [FBRequest requestForMyFriends];
        FBRequest* friendsRequest = [FBRequest requestForGraphPath:@"/me/friends?fields=gender,id,name,picture.width(100)"];
        
        [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                      NSDictionary* result,
                                                      NSError *error) {
            NSArray* friends = [result objectForKey:@"data"];
            
            FBFriendsArray = friends;
            tempFBArray = FBFriendsArray;
            NSLog(@"Found: %i friends", friends.count);
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
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info", @"user_friends"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             // Retrieve the app delegate
             
             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
             [APP_DELEGATE sessionStateChanged:session state:state error:error];
             
//             FBRequest* friendsRequest = [FBRequest requestForMyFriends];
             FBRequest* friendsRequest = [FBRequest requestForGraphPath:@"/me/friends?fields=gender,id,name,picture.width(100)"];
             
             [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                           NSDictionary* result,
                                                           NSError *error) {
                 NSArray* friends = [result objectForKey:@"data"];
                 
                 FBFriendsArray = friends;
                 
                 tempFBArray = FBFriendsArray;
                 
                 NSLog(@"Found: %i friends", friends.count);
//                 for (NSDictionary<FBGraphUser>* friend in friends) {
//                     NSLog(@"I have a friend named %@ with id %@", friend.name, friend.id);
//                     
//                 }
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     [friendsTableView reloadData];
                     
                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                     
                 });
                 
             }];
         }];
    }
    
    
}

#pragma mark - IBActions

- (IBAction)friendTypeButtonPressed:(CheckButton *)sender {
    selectedTab = sender.tag;
    for (UIButton *button in friendsButtons) {
        if (button.tag == sender.tag) {
//            button.selected = YES;
        } else {
            button.selected = NO;
        }
    }
    
    if (sender.tag == 102) {
        [self loadFBFriends];
    }else{
        [friendsTableView reloadData];
    }
    
}


#pragma mark - UItable View data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (selectedTab == 101) {
        return [friendsArray count];
    }else{
    
        return [FBFriendsArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if (selectedTab == 101) {
        cell = [tableView dequeueReusableCellWithIdentifier:kFriendCell];
        
        Friend *friend = [friendsArray objectAtIndex:indexPath.row];
        
        [(FriendCell *)cell fillWithFriend:friend];
        
        
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:kFBFriendCell];
        
        NSDictionary<FBGraphUser> *friend = [FBFriendsArray objectAtIndex:indexPath.row];
        [(FBFriendCell *)cell fillWithFBFriend:friend];
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
            [self loadRecommented];
            break;
            
        default:
            break;
    }
}

#pragma mark - UISearchbar delegate

-(void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope{
    
    switch (selectedScope) {
        case 0:
            selectedTab = 101;
            if (isRecommendShowing) {
                [self loadRecommented];
            }else{
                [self loadData];
            }
            break;
            
        case 1:
            selectedTab = 102;
            [self loadFBFriends];
            break;
    }
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    switch (selectedTab) {
        case 101:
            if (isRecommendShowing) {
                [self loadRecommented];
            }else{
                [self loadData];
            }
            break;
            
        case 102:
            [self loadFBFriends];
            break;
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    switch (selectedTab) {
        case 101:
            if (isRecommendShowing) {
                [self loadRecommented];
            }else{
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
            isSearching = YES;
            [self loadFBFriends];
            break;
    }
}

@end
