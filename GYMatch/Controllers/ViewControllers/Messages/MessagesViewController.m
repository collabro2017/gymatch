//
//  MessagesViewController.m
//  GYMatch
//
//  Created by Ram Gautam on 10/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "MessagesViewController.h"
#import "MBProgressHUD.h"
#import "MessageDataController.h"
#import "SenderCell.h"
#import "ChatViewController.h"
#import "UITableView+NXEmptyView.h"
#import "TeamChatViewController.h"
#import "SingleChatViewController.h"


#import "SpotlightsFilterViewController.h"

@interface MessagesViewController () {
    
    __weak NSTimer *timer;
    __weak MessagesViewController * weakSelf;
    BOOL isSearching;
}

@end

@implementation MessagesViewController

@synthesize friendsTableView;
@synthesize friendsArray;

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
    _currentSelectedFriend = nil;
    self.searchFriendsArray = [[NSMutableArray alloc] init];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(invalidateMessageLoading) name:@"LOGOUTCALL" object:nil];

    UINib *nib = [UINib nibWithNibName:kSenderCell bundle:nil];
    [friendsTableView registerNib:nib forCellReuseIdentifier:kSenderCell];
    
    UIImage *titleLogo = [UIImage imageNamed:@"logo_titlebg"];
    UIImageView *titleView = [[UIImageView alloc]initWithImage:titleLogo];
    
    [[(TopNavigationController *)[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:2] navigationItem] setTitleView:titleView];

    friendsTableView.tableFooterView = [[UIView alloc] init];
    friendsTableView.nxEV_emptyView = noMessagesView;

    weakSelf = self;
    timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:weakSelf selector:@selector(loadData) userInfo:nil repeats:YES];


    isSearching = NO;

}

-(IBAction)backbuttonPressed:(id)sender
{
    [self endSearch];


}

-(void)addBackButton
{

    if (self.navigationItem.leftBarButtonItem == nil) {
        UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"header_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backbuttonPressed:)];
        self.navigationItem.leftBarButtonItem = leftBtn;
    }


}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    CGFloat multiple = 1;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        multiple = 1.5;

  //  chatBtn.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:13.0f * multiple];
  //  teamChatBtn.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:13.0f * multiple];
    
    [self loadData];
    
    [friendsTableView reloadData];
    
    [self.navigationItem setTitle:@"Messages"];
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        [[[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:2] friendNavigationBar] setHidden:NO];
    }

    [[[APP_DELEGATE tabBarController] tabBar] setHidden:NO];


    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){

        if (_currentSelectedFriend && [self.friendsArray containsObject:_currentSelectedFriend]) {

            //[self.delegate didSelectFriend:_currentSelectedFriend];

        }
        else
        {
            //_currentSelectedFriend = nil;
            if ([self.friendsArray count]>0) {
                _currentSelectedFriend = [self.friendsArray objectAtIndex:0];
            }
            else
            {
                _currentSelectedFriend = nil;
            }
        }


    }
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [(TopNavigationController *)[[APP_DELEGATE tabBarController] selectedViewController] showProfileMenuOnlyCalendar];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    _currentSelectedFriend = nil;
}

-(void)invalidateMessageLoading
{

    if (timer) {
        [timer invalidate];
        timer = nil;
        weakSelf = nil;
    }
}

/*
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
  }

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:(BOOL)animated];
    [timer invalidate];
    timer = nil;
    weakSelf = nil;
} */


/*  -(void)checkForNewMessages
{
    MessageDataController *mDC = [MessageDataController new];
    [mDC unreadMessagesWithSuccess:^(NSInteger count) {

        if (count) {

            NSString *countString = [NSString stringWithFormat:@"%ld", (long)count];
            UITabBarItem *tbItem = [[[APP_DELEGATE tabBarController] viewControllers][2] tabBarItem];
            [tbItem setBadgeValue:countString];
        }
    } failure:^(NSError *error) {

        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];

    }];
} */

- (void)loadData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    MessageDataController *mDC = [MessageDataController new];
    [mDC sendersWithSuccess:^(NSArray *dataArr) {

        NSMutableArray *friends = [NSMutableArray arrayWithArray:dataArr];
        NSString *unreadCount = @"0";
        if([friends firstObject])
        {
            for(id obj in friends)
            {
                if([obj isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary *dict = (NSDictionary*)obj;
                    unreadCount = [[dict objectForKey:@"UnreadCount"] stringValue];
                    [friends removeObject:dict];
                }
            }
        }
      //  NSString *countString = [NSString stringWithFormat:@"%ld", (long)count];
        if(unreadCount != nil)
        {
            UITabBarItem *tbItem = [[[APP_DELEGATE tabBarController] viewControllers][2] tabBarItem];
            if([unreadCount isEqual:@"0"])
                [tbItem setBadgeValue:nil];
            else
                [tbItem setBadgeValue:unreadCount];
        }

        self.friendsArray = [NSMutableArray new];
        for (Friend *friend in friends) {
            NSString *name = [NSString stringWithFormat:@"%@ %@", friend.firstName, friend.lastName];
            if ([searchBar.text isEqualToString:@""] || [name rangeOfString:searchBar.text].location != NSNotFound) {
                [self.friendsArray addObject:friend];
            }
        }
        
       // sorting array according time
        NSSortDescriptor *aSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastMessage.date" ascending:NO];
        [self.friendsArray sortUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]];

      //  Friend *friend = [self.friendsArray objectAtIndex:indexPath.row];
        [friendsTableView reloadData];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];


        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
            if([self.friendsArray firstObject] && ![friendsTableView indexPathForSelectedRow])
            {
                if(_currentSelectedFriend)
                {
                  //  NSString *str = [NSString stringWithFormat:@"%ld", (long)_currentSelectedFriend.ID];
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.ID == %ld", (long)_currentSelectedFriend.ID];
                    NSArray *results = [self.friendsArray filteredArrayUsingPredicate:predicate];
                  //  NSArray *arr = [self.friendsArray valueForKey:str];
                    Friend *friend = [results firstObject];

                   // if([self.friendsArray containsObject:_currentSelectedFriend])
                    if(friend)
                    {
                        NSInteger index = [self.friendsArray indexOfObject:friend];
                        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
                        [friendsTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:0];
                        [self tableView:friendsTableView didSelectRowAtIndexPath:indexPath];
                    }
                    else
                    {

                        friend = [self.friendsArray objectAtIndex:0];
                        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
                        [friendsTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:0];
                        [self tableView:friendsTableView didSelectRowAtIndexPath:indexPath];

                    }
                }
                else
                {
                    _currentSelectedFriend = [self.friendsArray objectAtIndex:0];
                    NSIndexPath *firstIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
                    [friendsTableView selectRowAtIndexPath:firstIndexPath animated:YES scrollPosition:0];
                    [self tableView:friendsTableView didSelectRowAtIndexPath:firstIndexPath];
                }
            }
            else{

                if ([self.friendsArray count] == 0) {
                    [self.delegate didSelectFriend:nil];
                    [self.delegate hideLoadingBar];
                }
            }
        }
        
    } failure:^(NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}


-(void)callTableSelectionMethod:(NSInteger)indexValue
{

     NSIndexPath *firstIndexPath = [NSIndexPath indexPathForItem:indexValue inSection:0];
    [friendsTableView selectRowAtIndexPath:firstIndexPath animated:YES scrollPosition:0];
    [self tableView:friendsTableView didSelectRowAtIndexPath:firstIndexPath];
}

-(void)setSelectedFriend:(Friend *)user
{
    _currentSelectedFriend = user;
}

#pragma mark - UItable View data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (isSearching) {
        return [self.searchFriendsArray count];
    }
    return [self.friendsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SenderCell *cell = [tableView dequeueReusableCellWithIdentifier:kSenderCell];

  
    Friend *friend;

    if (isSearching) {

        if ([self.searchFriendsArray count]>indexPath.row) {
            friend = [self.searchFriendsArray objectAtIndex:indexPath.row];
        }

    }
    else
    {
        friend = [self.friendsArray objectAtIndex:indexPath.row];

    }
    
    [cell fillWithFriend:friend];
    
    cell.senderIndex = indexPath.row ;

    if (isSearching) {
        if(indexPath.row == [self.searchFriendsArray count]-1)
            cell.senderIndex = -1 ;
    }
    else
    {
    if(indexPath.row == [self.friendsArray count]-1)
        cell.senderIndex = -1 ;
    }

    [cell addLineView];
    
    
    return cell;
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    SenderCell *cell = (SenderCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell resetCountLabel];

    if (isSearching) {

        _currentSelectedFriend = [self.searchFriendsArray objectAtIndex:indexPath.row];
    }
    else{

        _currentSelectedFriend = [self.friendsArray objectAtIndex:indexPath.row];
    }

    
    UITabBarItem *tbItem = [[[APP_DELEGATE tabBarController] viewControllers][2] tabBarItem];
    NSInteger count = [tbItem.badgeValue integerValue] - _currentSelectedFriend.unreadSentMessageCount;
    NSString *badgeValue;
    
    if (count > 0) {
        badgeValue = [NSString stringWithFormat:@"%ld", (long)count];
    }else{
        badgeValue = nil;
    }
    
    [tbItem setBadgeValue:badgeValue];
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        
        ChatViewController *fdvc = [[ChatViewController alloc]init];
        [fdvc setUser:_currentSelectedFriend];
        fdvc.is_single = YES;
        [[[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:2] friendNavigationBar] setHidden:YES];
        [self.navigationController pushViewController:fdvc animated:YES];
        
        [[[APP_DELEGATE tabBarController] tabBar] setHidden:YES];
        fdvc = nil;
        
    }else{
        [self.delegate didSelectFriend:_currentSelectedFriend];
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        
        Friend *friend = [self.friendsArray objectAtIndex:indexPath.row];
        MessageDataController *mDC = [MessageDataController new];
        
        [mDC deleteMessages:friend.ID withSuccess:^{
            [self.delegate didSelectFriend:nil];
            [self loadData];
        } failure:^(NSError *error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            alertView = nil;
        }];
        
    }
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
    [self loadData];

    if ([[search_Bar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {


        [self endSearch];

    }
    else
    {

        NSString *word = [search_Bar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [self startSearch:word];
        
    }


    [search_Bar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)aSearchBar{
    [searchBar endEditing:YES];
    searchBar.text = @"";
    [self endSearch];

}

-(void)searchBarTextDidEndEditing:(UISearchBar *)search_Bar
{

    if ([[search_Bar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {


        [self endSearch];

    }
    else
    {

        NSString *word = [search_Bar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [self startSearch:word];
        
    }


}

-(void)searchBar:(UISearchBar *)search_Bar textDidChange:(NSString *)searchText
{
    /*if ([[searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {


        [self endSearch];

    }
    else
    {

        NSString *word = [search_Bar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [self startSearch:word];
        
    }*/

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

-(void)startSearch:(NSString *)word
{

    [self addBackButton];

    isSearching = YES;
    [self.searchFriendsArray removeAllObjects];


    for (Friend *aFriend in self.friendsArray) {

        NSString *value = (![aFriend.name isEqualToString:@""]) ? aFriend.name : aFriend.username;

        if ([[value lowercaseString] containsString:[word lowercaseString]]) {
            [self.searchFriendsArray addObject:aFriend];
        }
    }

    [friendsTableView reloadData];
}

-(void)endSearch
{
    [self loadData];
    searchBar.text = @"";
    isSearching = NO;
    [self.searchFriendsArray removeAllObjects];
    [friendsTableView reloadData];

    self.navigationItem.leftBarButtonItem = nil;

}

- (IBAction)loadTeamChat:(id)sender {
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        
        TeamChatViewController *fdvc = [[TeamChatViewController alloc]init];
    
        [[[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:2] friendNavigationBar] setHidden:YES];
        [self.navigationController pushViewController:fdvc animated:YES];
        
        [[[APP_DELEGATE tabBarController] tabBar] setHidden:YES];
        fdvc = nil;
    }
}

- (IBAction)loadChat:(id)sender {
    
        SingleChatViewController *fdvc = [[SingleChatViewController alloc]init];
        
        [[[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:2] friendNavigationBar] setHidden:YES];
        [self.navigationController pushViewController:fdvc animated:YES];
        
        [[[APP_DELEGATE tabBarController] tabBar] setHidden:YES];
        fdvc = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
