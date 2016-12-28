//
//  SearchViewController.m
//  GYMatch
//
//  Created by Ram on 02/04/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "SearchViewController.h"
#import "InnerCircleCell.h"
#import "FriendDetailsViewController.h"
#import "MBProgressHUD.h"
#import "UserDataController.h"
#import "FriendCell.h"
#import "Utility.h"

@interface SearchViewController (){
    NSArray *friendsArray;
    NSInteger miles;
    NSString *gender;
    NSString *local;
    
    FiltersViewController *fVC;
    
    NSString *friendCellNibName;
}

@end

@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

     [[self navigationItem] setTitle:@"Search"];
  //  CGRect tableFrame = frinedTableView.frame;
  ///  CGRect viewFrame = self.view.frame;
   /// CGRect viewFrame = [[UIScreen mainScreen] bounds];
   // frinedTableView.frame = CGRectMake(0, tableFrame.origin.y, tableFrame.size.width, tableFrame.size.height+49);  //yt
  //  self.view.frame = CGRectMake(0, 64, viewFrame.size.width, viewFrame.size.height-44);  //yt

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    gender = @"Both";
    miles = 20;
    local = @"All";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
   // if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
  //      self.edgesForExtendedLayout = UIRectEdgeNone;

//    UINib *nib = [UINib nibWithNibName:kInnerCircleCell bundle:nil];
//    [friendsCollectionView registerNib:nib forCellWithReuseIdentifier:kInnerCircleCell];
    
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        friendCellNibName = kFriendCelliPad;
        [frinedTableView setSeparatorInset:UIEdgeInsetsMake(0, 135, 0, 0)];
        
    }else{
        friendCellNibName = kFriendCell;
    }

//    UINib *nib = [UINib nibWithNibName:friendCellNibName bundle:nil];
//    [frinedTableView registerNib:nib forCellReuseIdentifier:friendCellNibName];
 //   frinedTableView.tableFooterView = [[UIView alloc] init];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:UIKeyboardWillHideNotification object:nil];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loadData
{
    if ([Utility checkInvalidChars:searchBar.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter valid text" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *requestDictionary = [NSMutableDictionary new];
    
    NSString *circle = (gymatchSearchSwitch.selected) ? @"Yes" : @"No";
    
    [requestDictionary setObject:circle forKey:@"GYMatchCircle"];
    [requestDictionary setObject:[NSNumber numberWithInteger:miles] forKey:@"Location"];
    [requestDictionary setObject:searchBar.text forKey:@"keyword"];
    [requestDictionary setObject:gender forKey:@"Gender"];
    [requestDictionary setObject:local forKey:@"Local"];
    
    [requestDictionary setObject:[NSNumber numberWithBool:weightTrainingCheckButton.selected] forKey:@"weight_training"];
    [requestDictionary setObject:[NSNumber numberWithBool:pilatesCheckButton.selected] forKey:@"pilates"];
    [requestDictionary setObject:[NSNumber numberWithBool:cardioCheckButton.selected] forKey:@"cardio"];
    [requestDictionary setObject:[NSNumber numberWithBool:aerobicCheckButton.selected] forKey:@"aerobics"];
    [requestDictionary setObject:[NSNumber numberWithBool:joggingCheckButton.selected] forKey:@"jogging"];
    [requestDictionary setObject:[NSNumber numberWithBool:martialCheckButton.selected] forKey:@"martial_arts"];
    [requestDictionary setObject:[NSNumber numberWithBool:conditioningCheckButton.selected] forKey:@"conditioning"];
    [requestDictionary setObject:[NSNumber numberWithBool:yogaCheckButton.selected] forKey:@"yoga"];
    [requestDictionary setObject:[NSNumber numberWithBool:cyclingCheckButton.selected] forKey:@"cycling"];
    [requestDictionary setObject:[NSNumber numberWithBool:bootCampCheckButton.selected] forKey:@"camping"];
    [requestDictionary setObject:[NSNumber numberWithBool:swimmingCheckButton.selected] forKey:@"swimming"];
    [requestDictionary setObject:[NSNumber numberWithBool:crossTrainingCheckButton.selected] forKey:@"cross_training"];
    [requestDictionary setObject:[NSNumber numberWithBool:dancingButton.selected] forKey:@"dancing"];
    [requestDictionary setObject:[NSNumber numberWithBool:beachButton.selected] forKey:@"beach_activities"];
    [requestDictionary setObject:[NSNumber numberWithBool:mmaButton.selected] forKey:@"mma_fitness"];
    [requestDictionary setObject:[NSNumber numberWithBool:gymnasticsButton.selected] forKey:@"gymnastics"];
    
    UserDataController *uDC = [UserDataController new];
    
    [uDC searchWith:requestDictionary
            Success:^(NSArray *friends){
                friendsArray = friends;
                
                [frinedTableView reloadData];
                
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
                if ([friendsArray count] == 0) {
                    //            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"You have no friends. Do you want to see GYMatch recommendatations?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
                    //            [alertView show];
                }
                
            } failure:^(NSError *error) {
                
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
                
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }];
}

#pragma mark - IBActions

- (IBAction)filterButtonPressed:(UIButton *)sender {
    if (fVC == nil) {
        fVC = [[FiltersViewController alloc] init];
        fVC.delegate = self;
    }
    [self.navigationController pushViewController:fVC animated:YES];
}

- (IBAction)trainingChanged:(UIButton *)sender {
    [self loadData];
}

- (IBAction)circleChanged:(id)sender {
    [self loadData];
}

- (IBAction)genderTypeButtonPressed:(CheckButton *)sender {
    for (UIButton *button in genderButtons) {
        if (button.tag == sender.tag) {
            //            button.selected = YES;
        } else {
            button.selected = NO;
        }
    }
    gender = sender.titleLabel.text;
    [self loadData];
}

- (IBAction)localTypeButtonPressed:(CheckButton *)sender {
    
    for (UIButton *button in gymButtons) {
        if (button.tag == sender.tag) {
            //            button.selected = YES;
        } else {
            button.selected = NO;
        }
    }
    
    if (sender.tag == 311) {
        local = @"MyGym";
    }else if (sender.tag == 312){
        local = @"All";
    }
    [self loadData];
}

- (IBAction)locationTypeButtonPressed:(CheckButton *)sender {
    for (UIButton *button in mileButtons) {
        if (button.tag == sender.tag) {
            //            button.selected = YES;
        } else {
            button.selected = NO;
        }
    }
    miles = [sender.titleLabel.text integerValue];
    [self loadData];
}



#pragma mark - UICollectionView Data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [friendsArray count];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    InnerCircleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kInnerCircleCell forIndexPath:indexPath];
    
    [cell fillWithPhoto:[friendsArray objectAtIndex:indexPath.row]];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FriendDetailsViewController *fdvc = [[FriendDetailsViewController alloc]init];
    [fdvc setAFriend:[friendsArray objectAtIndex:indexPath.row]];
    [[[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:0] friendNavigationBar] setHidden:YES];
    
    [self.navigationController pushViewController:fdvc animated:YES];
    
}

#pragma mark - UISearchBar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)aSearchBar{
    
    [self loadData];
    [aSearchBar resignFirstResponder];
    
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


- (void)searchBarCancelButtonClicked:(UISearchBar *)aSearchBar{
    
   // [searchBar resignFirstResponder];
    if (![searchBar.text isEqualToString:@""]) {
        
        searchBar.text = @"";
        [self loadData];
    }
    
}

#pragma mark - UItable View data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    NSInteger rowCount = [friendsArray count];
    if (rowCount == 0)
        [noResultLabel setHidden:NO];
    else
        [noResultLabel setHidden:YES];
    return rowCount;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return 100.0f;
    }
    return 70.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:friendCellNibName];

    cell = nil;

    if (cell == nil) {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:friendCellNibName owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }



    Friend *friend = [friendsArray objectAtIndex:indexPath.row];
    
    [cell fillWithFriend:friend];
    
    //    [cell.buttonView setHidden:YES];
    return cell;
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FriendDetailsViewController *fdvc = [[FriendDetailsViewController alloc]init];
    [fdvc setAFriend:[friendsArray objectAtIndex:indexPath.row]];
    //    [[[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:0] friendNavigationBar] setHidden:YES];
    
    [self.navigationController pushViewController:fdvc animated:YES];
    
    [[[APP_DELEGATE tabBarController] tabBar] setHidden:YES];
}

#pragma mark - Filters Delegate

- (void)doneWithDictionary:(NSMutableDictionary *)dictionary{
    
    if ([Utility checkInvalidChars:searchBar.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter valid text" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [dictionary setObject:searchBar.text forKey:@"keyword"];
    
    UserDataController *uDC = [UserDataController new];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [uDC searchWith:dictionary
            Success:^(NSArray *friends){
                friendsArray = friends;
                
                [frinedTableView reloadData];
                
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
               // if ([friendsArray count] == 0)  { }

            } failure:^(NSError *error) {
                
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
                
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }];
}

@end
