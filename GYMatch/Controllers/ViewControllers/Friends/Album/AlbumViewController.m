//
//  AlbumViewController.m
//  GYMatch
//
//  Created by Ram Gautam on 11/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "AlbumViewController.h"
#import "AlbumCell.h"
#import "AlbumDataController.h"
#import "MBProgressHUD.h"
#import "UIImagePickerHelper.h"
#import "AddPictureViewController.h"
#import "PictureViewController.h"

@interface AlbumViewController (){
    NSArray *albumsArray;
    UIImagePickerHelper *iPH;
}

@end

@implementation AlbumViewController


- (id)init{
    
    NSString *nibName = @"AlbumViewController";
    
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
    
    UINib *nib = [UINib nibWithNibName:kAlbumCell bundle:nil];
    [albumCollectionView registerNib:nib forCellWithReuseIdentifier:kAlbumCell];
    
    
    if (self.userID == [APP_DELEGATE loggedInUser].ID) {
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(addPicture:)];
        
        self.navigationItem.rightBarButtonItem = editButton;
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    [self.navigationItem setTitle:@"Album"];
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AlbumDataController *uDC = [AlbumDataController new];
    [uDC albumFor:self.userID withSuccess:^(NSArray *photos) {
        
        albumsArray = photos;
        
        [albumCollectionView reloadData];

        if([albumsArray count] == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"No photos found." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } failure:^(NSError *error) {

        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }];
}

#pragma mark - UICollectionView Data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [albumsArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AlbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAlbumCell forIndexPath:indexPath];
    
    Photo *photo = [albumsArray objectAtIndex:indexPath.row];
    [cell fillWithPhoto:photo];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    Photo *photo = [albumsArray objectAtIndex:indexPath.row];
    PictureViewController *picVC = [PictureViewController new];
    picVC.thePhoto = photo;
    
    if (self.userID == [APP_DELEGATE loggedInUser].ID) {
        picVC.hideDeleteBtn = NO;
    }else{
        picVC.hideDeleteBtn = YES;
    }
    
    [[(TopNavigationController *)[[APP_DELEGATE tabBarController] selectedViewController] friendNavigationBar] setHidden:YES];
    
    [self.navigationController pushViewController:picVC animated:YES];
    
    [[[APP_DELEGATE tabBarController] tabBar] setHidden:YES];
    
}

#pragma mark - IBActions

- (IBAction)addPicture:(id)sender{
    iPH = [[UIImagePickerHelper alloc]init];
    
    [iPH imagePickerInView:self.view WithSuccess:^(UIImage *image) {
        
        AddPictureViewController *aPVC = [[AddPictureViewController alloc] init];
        [aPVC setImage:image];
        [self.navigationController pushViewController:aPVC animated:YES];
        
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }];
}



@end
