//
//  ActiveDropDownViewController.m
//  GYMatch
//
//  Created by Ram on 08/04/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "ActiveDropDownViewController.h"

@interface ActiveDropDownViewController ()

@end

@implementation ActiveDropDownViewController

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
    
    self.isSearching = NO;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [self.searchDisplayController.searchBar becomeFirstResponder];
}

- (void)setIsSearching:(BOOL)isSearching{
    
    if (isSearching) {
        
    }else{
        [self.searchDisplayController.searchResultsTableView reloadData];
    }
    
    _isSearching = isSearching;
    
}

#pragma mark - Search Display Delegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    
    [self.delegate didEnterText:searchString];
    self.isSearching = YES;
    
    return NO;
}

#pragma mark - UItable View data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.resultsArray count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GTVCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GTVCell"];
        
        [cell.imageView setImage:[UIImage imageNamed:@"gtv_icon"]];
    }
    
    NSString *gtv = [self.resultsArray objectAtIndex:indexPath.row];

    cell.textLabel.text = gtv;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.delegate didSelectItemAtIndex:indexPath.row];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
//    GTV *gtv = [gtvArray objectAtIndex:indexPath.row];
//    
//    PlayerViewController *pVC = [PlayerViewController new];
//    pVC.gtv = gtv;
//    
//    [self.navigationController pushViewController:pVC animated:YES];
    
    //    FriendDetailsViewController *fdvc = [[FriendDetailsViewController alloc]init];
    //    [fdvc setAFriend:[friendsArray objectAtIndex:indexPath.row]];
    //    [[[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:0] friendNavigationBar] setHidden:YES];
    //
    //    [self.navigationController pushViewController:fdvc animated:YES];
    //
    //    [[[APP_DELEGATE tabBarController] tabBar] setHidden:YES];
}

#pragma mark - IBActions

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
