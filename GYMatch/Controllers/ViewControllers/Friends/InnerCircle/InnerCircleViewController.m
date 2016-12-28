//
//  InnerCircleViewController.m
//  GYMatch
//
//  Created by Ram Gautam on 11/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "InnerCircleViewController.h"
#import "InnerCircleCell.h"
#import "MBProgressHUD.h"
#import "UserDataController.h"
#import "FriendDetailsViewController.h"

@interface InnerCircleViewController (){
    NSArray *friendsArray;
}

@end

@implementation InnerCircleViewController


- (id)init{
    
    NSString *nibName = @"InnerCircleViewController";
    
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
    
    UINib *nib = [UINib nibWithNibName:kInnerCircleCell bundle:nil];
    [albumCollectionView registerNib:nib forCellWithReuseIdentifier:kInnerCircleCell];
    
    [self loadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.navigationItem setTitle:@"Friends"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    UserDataController *uDC = [UserDataController new];
    [uDC friendsOf:self.userID withKeyword:searchView.text withSuccess:^(NSArray *friends) {
        friendsArray = friends;
        
        [albumCollectionView reloadData];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } failure:^(NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
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

- (void)searchBarSearchButtonClicked:(UISearchBar *)aSearchBar{
    
    [self loadData];
    [searchView resignFirstResponder];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)aSearchBar{
    
    [searchView resignFirstResponder];
    if (![searchView.text isEqualToString:@""]) {
        
        searchView.text = @"";
        [self loadData];
    }
    
}

@end
