//
//  MogulDetailsViewController.m
//  GYMatch
//
//  Created by Ram on 25/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "MogulDetailsViewController.h"
#import "Utility.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "SpotlightDataController.h"
#import "InnerCircleCell.h"
#import "Team.h"
#import "TeamDetailsViewController.h"

@interface MogulDetailsViewController ()

@end

@implementation MogulDetailsViewController

- (id)initWithSpotlight:(Spotlight *)spotlight{
    self = [super init];
    if (self) {
        self.aSpotlight = spotlight;
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
    [self.navigationItem setTitle:@"Business"];
    
    UINib *nib = [UINib nibWithNibName:kInnerCircleCell bundle:nil];
    [trainersCollectionView registerNib:nib forCellWithReuseIdentifier:kInnerCircleCell];
    [self loadData];
    
    [self fillDetailsWithSpotlight:self.aSpotlight];
    [self decorate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)decorate{
}

- (void)fillDetailsWithSpotlight:(Spotlight *)aSpotlight{
    gymNameLabel.text = aSpotlight.name;
    
    gymLocationLabel.text = aSpotlight.address;
    
    bioLabel.text = aSpotlight.description;
    
    NSURL *imageURL = [NSURL URLWithString:aSpotlight.image];
    [gymImageView setImageWithURL:imageURL placeholderImage:[Utility placeHolderImage]];
    
    imageURL = [NSURL URLWithString:aSpotlight.QRCodeImage];
    [barCodeImageView setImageWithURL:imageURL placeholderImage:nil];
    
    imageURL = [NSURL URLWithString:aSpotlight.discountsImage];
    [membershipImageView setImageWithURL:imageURL placeholderImage:nil];
    
    imageURL = [NSURL URLWithString:aSpotlight.complementaryBenefitsImage];
    [complementaryImaegView setImageWithURL:imageURL placeholderImage:nil];
    
    [self fillClubHours];
    
    locationsLabel.text = aSpotlight.clubLocations;
    
    [trainersCollectionView reloadData];
}

- (void)fillClubHours{
    int i = 0;
    for (OperatingHour *hour in self.aSpotlight.operatingHours) {
        UILabel *tempLabel = [dayTimeLabels objectAtIndex:i++];
        tempLabel.text = [NSString stringWithFormat:@"%d:00 AM To %d:00 PM", hour.opening, hour.closing];
    }
}


- (void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    SpotlightDataController *sDC = [SpotlightDataController new];
    
    [sDC spotlightDetails:self.aSpotlight.ID withSuccess:^(Spotlight *aSpotlight) {
        self.aSpotlight = aSpotlight;
        [self fillDetailsWithSpotlight:aSpotlight];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    }];
}

#pragma mark - IBActions


- (IBAction)rateButtonPressed:(id)sender {
}

- (IBAction)fbButtonPressed:(id)sender {
    [Utility openURLString:self.aSpotlight.fbLink];
}

- (IBAction)twitterButtonPressed:(id)sender {
    
    [Utility openURLString:self.aSpotlight.twitterLink];
}

- (IBAction)instagramButtonPressed:(id)sender {
    [Utility openURLString:self.aSpotlight.instagramLink];
}

- (IBAction)mailButtonPressed:(id)sender {
    
    [Utility openURLString:self.aSpotlight.siteLink];
}

- (IBAction)gymatchButtonPressed:(id)sender {
    [Utility openURLString:self.aSpotlight.gymatchLink];
}
- (IBAction)contactMe:(id)sender{
    
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setToRecipients:@[self.aSpotlight.email]];
    [controller setSubject:@"Contact us"];
    [controller setMessageBody:@"Hello " isHTML:NO];
    if (controller) [self presentViewController:controller animated:YES completion:nil];
    
}

#pragma mark - Mail Composer delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    [controller dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark - UICollectionView Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return (collectionView.tag == 201)
    ? [self.aSpotlight.owners count]
    : [self.aSpotlight.team count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    InnerCircleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kInnerCircleCell forIndexPath:indexPath];
    
    Team *team = (collectionView.tag == 201)
    ? [self.aSpotlight.owners objectAtIndex:indexPath.row]
    : [self.aSpotlight.team objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = team.name;
    NSURL *imageURL = [NSURL URLWithString:team.image];
    [cell.imageView setImageWithURL:imageURL placeholderImage:[Utility placeHolderImage]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TeamDetailsViewController *tDVC = [TeamDetailsViewController new];
    
    tDVC.aTeam = (collectionView.tag == 201)
    ? [self.aSpotlight.team objectAtIndex:indexPath.row]
    : [self.aSpotlight.team objectAtIndex:indexPath.row];
    
    //    [self.navigationController pushViewController:tDVC animated:YES];
    [self presentViewController:tDVC animated:YES completion:nil];
}
@end
