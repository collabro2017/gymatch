//
//  SpotlightDetailsViewController.m
//  GYMatch
//
//  Created by Ram on 24/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "SpotlightDetailsViewController.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "SpotlightDataController.h"
#import "Utility.h"
#import "DayCell.h"
#import "SessionCell.h"
#import "PersonalTraining.h"
#import "Spotlight.h"
#import "TeamViewController.h"
#import "RateView.h"
#import "Utility.h"
#import "UIImage+Overlay.h"

@interface SpotlightDetailsViewController (){
    NSArray *weekDays;
    
    NSInteger numOfSections[4];
    NSInteger numOfRows[4][6];
    NSInteger defaultNumOfRows[4][6];
    NSArray *cellViews;
    NSInteger spotlightType;
    NSArray *sectionHeaders;
    NSArray *bioTitle;
    NSArray *locationTitle;
    NSArray *bgImages;
    
    NSString *dayCellNibName;
    NSString *sessionCellNibName;
    
    NSMutableDictionary *expandButtons;
    UIImageView *discountsImage;
    bool checkAddress ;
}

@end

@implementation SpotlightDetailsViewController

- (id)initWithSpotlight:(Spotlight *)spotlight{
    
    NSString *nibName = @"SpotlightDetailsViewController";
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        nibName = @"SpotlightDetailsViewController_iPad";
    }
    
    self = [super initWithNibName:nibName bundle:nil];
    
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
    personalHourExpandButton.selected = [Utility isButtonCollapsed:spotlightType andSection:2];
    personalHalfHourExpandButton.selected = [Utility isButtonCollapsed:spotlightType andSection:3];
    
}




- (void)viewDidLoad
{
    checkAddress = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self.navigationItem setTitle:@"Individual"];

   // [self.navigationBar setTintColor:[UIColor whiteColor]];
  //  [self.navigationBar setBarTintColor:DEFAULT_NAV_COLOR];
    [self setNeedsStatusBarAppearanceUpdate];

  /*  UITableView *tableView = (UITableView *)self.view;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
  //  headerView.backgroundColor = [UIColor colorWithRed:64.0/255.0 green:64.0/255.0 blue:64.0/255.0 alpha:1.0];
    headerView.backgroundColor = [UIColor clearColor];
    tableView.tableHeaderView = headerView; */


    weekDays = @[@"Sunday",
                 @"Monday",
                 @"Tuesday",
                 @"Wednesday",
                 @"Thursday",
                 @"Friday",
                 @"Saturday"];
    
    sectionHeaders = @[@[@"", @"", @"", @""],
                       @[@"", @"Training Schedule", @"Personal Training - Hour Sessions", @"Personal Training - Half Sessions"],
                       @[@"", @"Club Hours", @"Memberships and Discounts", @"Memberships and Discounts"],
                       @[@"", @"Operational Hours", @"Special Offers and Discounts", @""]
                       ];
    
    bioTitle = @[@"Bio", @"Bio", @"Gym Bio", @"Business Bio"];
    
    locationTitle = @[@"", @"", @"Club Locations", @"Locations"];
    
    spotlightType = 0;
    
    [self decorate];
    
    [self loadData];
    
//    [self initCellViews];
    
    [(UITableView *)self.view setContentInset:UIEdgeInsetsMake(-20, 0, -50, 0)];
    [(UITableView *)self.view setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, -50, 0)];
    
    dayCellNibName = kDayCell;
    sessionCellNibName = kSessionCell;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        dayCellNibName = kDayCell_iPad;
        sessionCellNibName = kSessionCelliPad;
    }
    
    UINib *nib = [UINib nibWithNibName:dayCellNibName bundle:nil];
    [(UITableView *)self.view registerNib:nib forCellReuseIdentifier:dayCellNibName];
    
    nib = [UINib nibWithNibName:sessionCellNibName bundle:nil];
    [(UITableView *)self.view registerNib:nib forCellReuseIdentifier:sessionCellNibName];
    
    bgImages = @[@"bg_individual",
                          @"bg_trainer",
                          @"bg_gym",
                          @"bg_business"];
    
    
    [self fillDetailsWithSpotlight:self.aSpotlight];
    
    
//    __weak TopNavigationController *weakSelf = self.navigationController;
//    
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
//    {
//        self.navigationController.interactivePopGestureRecognizer.delegate = self;
//    }
    
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClicked:)];
    [profileImageView addGestureRecognizer:gesture];
}

-(void)imageClicked : (UITapGestureRecognizer *)gesture {
    
    UIImageView *view = (UIImageView *)gesture.view;
    
    _pictureView = [[AvatorViewController alloc] initWithNibName:@"AvatorViewController" bundle:nil];
    _pictureView.image = view.image;
    //[self.navigationController pushViewController:_pictureView animated:NO];
    [self.view addSubview:_pictureView.view];
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromRight;
    [_pictureView.view.window.layer addAnimation:transition forKey:kCATransition];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)cellWithTitle:(NSString *)title andDetail:(NSString *)description{

    if(![description isKindOfClass:[NSString class]])
        description = @"";

    NSString *identifier = [title stringByAppendingString:@"Cell"];
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    cell.textLabel.text = title;
    
    CGFloat labelHeight = 40.0f;
  //  CGFloat width = 320.0f;

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        if([title  isEqual: @"Gym Bio"] || [title  isEqual: @"Business Bio"])
            labelHeight = 120.0f;
        else
            labelHeight = 60.0f;
             // width =
    }
    

    [cell.detailTextLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [cell.detailTextLabel setNumberOfLines:0];
    CGRect frame = cell.frame;
    NSInteger count = [Utility getNumberOfNewLineCharacters:description];
    frame = CGRectMake(frame.origin.x, frame.origin.x, [[UIScreen mainScreen]bounds].size.width, frame.size.height);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 10.0f)];
    label.font = cell.detailTextLabel.font;
    label.text = description;
    frame.size.height = [Utility heightForLabel:label] + labelHeight + (count * 8);
    cell.frame = frame;
    cell.detailTextLabel.text = description;
    
    return cell;
}



- (void)initCellViews{
    
    UITableViewCell *bioCell;
    
    if (spotlightType == 0 || spotlightType == 1) {
        bioCell = [self cellWithTitle:bioTitle[spotlightType] andDetail:self.aSpotlight.bio];
    }else{
        bioCell = [self cellWithTitle:bioTitle[spotlightType] andDetail:self.aSpotlight.desc];
    }
    
    UITableViewCell *educationCell = [self cellWithTitle:@"Education" andDetail:self.aSpotlight.education];
    UITableViewCell *hobbyCell = [self cellWithTitle:@"Hobbies & Interests" andDetail:self.aSpotlight.hobbies];
    UITableViewCell *gymCell = [self cellWithTitle:@"My Gym" andDetail:self.aSpotlight.gym];
    
    NSString *benefits = [self.aSpotlight.gymBenefits componentsJoinedByString:@"\n"];
    
    UITableViewCell *benefitsCell = [self cellWithTitle:@"Gym Benefits" andDetail:benefits];
    
    NSString *clubLocations = [self.aSpotlight.clubLocations stringByReplacingOccurrencesOfString:@"," withString:@"\n"];
    
    UITableViewCell *locationCell = [self cellWithTitle:locationTitle[spotlightType] andDetail:clubLocations];
    
    CGRect frame;
    
    UITableViewCell *ownerCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"OwnerCell"];
    ownerCell.textLabel.text = @"Meet the Owners";
    UIButton *ownerButton = [[UIButton alloc] init];
    UIButton *ownerWrapperButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ownerCell.frame.size.width, ownerCell.frame.size.height)];
    [ownerWrapperButton addTarget:self action:@selector(showOwner:) forControlEvents:UIControlEventTouchUpInside];
    [ownerButton addTarget:self action:@selector(showOwner:) forControlEvents:UIControlEventTouchUpInside];
    [ownerButton setImage:[UIImage imageNamed:@"gray_list_arrow"] forState:UIControlStateNormal];
    [ownerButton setFrame:CGRectMake(0, 0, 44.0f, 44.0f)];
    ownerCell.accessoryView = ownerButton;
    [ownerCell addSubview:ownerWrapperButton];
    frame = ownerCell.frame;
    frame.size.height = 60;
    ownerCell.frame = frame;
    
    UITableViewCell *teamCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"TeamCell"];
    teamCell.textLabel.text = @"Meet the Team";
    UIButton *teamButton = [[UIButton alloc] init];
    UIButton *teamWrapperButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, teamCell.frame.size.width, teamCell.frame.size.height)];
    [teamWrapperButton addTarget:self action:@selector(showTeam:) forControlEvents:UIControlEventTouchUpInside];
    [teamButton addTarget:self action:@selector(showTeam:) forControlEvents:UIControlEventTouchUpInside];
    [teamButton setImage:[UIImage imageNamed:@"gray_list_arrow"] forState:UIControlStateNormal];
    [teamButton setFrame:CGRectMake(0, 0, 44.0f, 44.0f)];
    teamCell.accessoryView = teamButton;
    [teamCell addSubview:teamWrapperButton];
    frame = teamCell.frame;
    frame.size.height = 60;
    teamCell.frame = frame;
    
    numOfSections[0] = 1;
    numOfSections[1] = 4;
    numOfSections[2] = 3;
    numOfSections[3] = 3;
    
    // First Section CellViews
    NSArray *viewsForType1 = @[headerCell, prefsCell,bioCell, educationCell, linksCell];
    NSArray *viewsForType2 = @[headerCell, gymCell, bioCell, educationCell, hobbyCell, linksCell];
    NSArray *viewsForType3 = @[headerCell, bioCell, prefsCell, benefitsCell, locationCell, linksCell, teamCell];
    NSArray *viewsForType4 = @[headerCell, bioCell, locationCell, linksCell, ownerCell, teamCell];
    cellViews = @[viewsForType1, viewsForType2, viewsForType3, viewsForType4];
    
    // First Section Rows
    numOfRows[0][0] = 5;
    numOfRows[1][0] = 6;
    numOfRows[2][0] = 7;
    numOfRows[3][0] = 6;
    
    // Second Section Rows
    numOfRows[0][1] = 0;
    numOfRows[1][1] = 7;
    numOfRows[2][1] = 7;
    numOfRows[3][1] = 7;
    
    // Third Section Rows
    numOfRows[0][2] = 0;
    numOfRows[1][2] = [self.aSpotlight.fullPersonalTrainings count];
    numOfRows[2][2] = 1;
    numOfRows[3][2] = 1;
    
    // Fourth Section Rows
    numOfRows[0][3] = 0;
    numOfRows[1][3] = [self.aSpotlight.halfPersonalTrainings count];
    numOfRows[2][3] = 0;
    numOfRows[3][3] = 0;
    
    for (int index1 = 0; index1 < 4; index1 ++) {
        for (int index2 = 0; index2 < 6; index2 ++) {
            defaultNumOfRows[index1][index2] = numOfRows[index1][index2];
        }
    }
    
    // Trainer
    numOfRows[1][1] *= [Utility isButtonCollapsed:spotlightType andSection:1];
    numOfRows[1][2] *= [Utility isButtonCollapsed:spotlightType andSection:2];
    numOfRows[1][3] *= [Utility isButtonCollapsed:spotlightType andSection:3];
    
    // Gym
    numOfRows[2][1] *= [Utility isButtonCollapsed:spotlightType andSection:1];
    numOfRows[2][2] *= [Utility isButtonCollapsed:spotlightType andSection:2];
    numOfRows[2][3] *= [Utility isButtonCollapsed:spotlightType andSection:3];
    
    // Business
    numOfRows[3][1] *= [Utility isButtonCollapsed:spotlightType andSection:1];
    numOfRows[3][2] *= [Utility isButtonCollapsed:spotlightType andSection:2];
    
}

- (void)decorate{
    
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
//        
//        bgImageHeight.constant = 290;
//        
//        headerCell.frame = CGRectMake(headerCell.frame.origin.x,
//                                      headerCell.frame.origin.y,
//                                      headerCell.frame.size.width,
//                                      headerCell.frame.size.height + 120);
//        
//        profielImageHeight.constant = 195;
//        
//        profileImageView.layer.cornerRadius = profielImageHeight.constant/2;
//        
//        prefsView.frame = CGRectMake(prefsView.frame.origin.x,
//                                     prefsView.frame.origin.y,
//                                     prefsView.frame.size.width + 448,
//                                     prefsView.frame.size.height);
//        
//    }
    
    UITableView *tableView = (UITableView *)self.view;
    tableView.tableFooterView = [[UIView alloc] init];
    
}


- (void)fillDetailsWithSpotlight:(Spotlight *)aSpotlight{


    
    
    //yt7July
    for (int i = 0; i < 5; i++) {
        if (aSpotlight.rate > i) {
            [starImageViews[i] setHidden:NO];
        }else{
            [starImageViews[i] setHidden:YES];
        }
        UIImageView *tempImageView = starImageViews[i];
        tempImageView.image = [tempImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [tempImageView setTintColor:DEFAULT_BG_COLOR];
    }
    //yt7July//

    if ([aSpotlight.type isEqualToString:SPOTLIGHT_TYPE_INDIVIDUAL]) {
        spotlightType = 0;
        bgImgeView.image = [UIImage imageNamed:@"bg_individual"];
    }
    else if ([aSpotlight.type isEqualToString:SPOTLIGHT_TYPE_TRAINER]) {
        spotlightType = 1;
        bgImgeView.image = [UIImage imageNamed:@"bg_trainer"];
    }
    else if ([aSpotlight.type isEqualToString:SPOTLIGHT_TYPE_GYMSTAR]) {
        spotlightType = 2;
        bgImgeView.image = [UIImage imageNamed:@"bg_gym"];
    }
    else if ([aSpotlight.type isEqualToString:SPOTLIGHT_TYPE_MOGUL]) {
        spotlightType = 3;
        bgImgeView.image = [UIImage imageNamed:@"bg_individual"];
    }
    
    
    nameLabel.text = aSpotlight.name;
    genderLabel.text = [NSString stringWithFormat:@"%@, %ld",
                        aSpotlight.gender,
                        (long)aSpotlight.age];
    if (checkAddress) {
        locationLabel.text = aSpotlight.address;
        checkAddress = NO;
    }
    
    
    if (spotlightType == 2) {
        preferencesLabel.text = @"Club Features";
    }
    
    if (spotlightType == 2 || spotlightType == 3) {
        dumbleImageView.hidden = YES;
        gymLabel.hidden = YES;
        
//        CGRect frame = locationLabel.frame;
//        frame.origin.y = genderLabel.frame.origin.y;
//        locationLabel.frame = frame;
        
        locatoinTop.constant = 30.0f;
        
//        center = locationImageView.center;
//        center.y = genderLabel.center.y;
//        locationImageView.center = center;
    }
    
    if ([aSpotlight.gymLocation isEqualToString:@""]) {
        gymLabel.text = [NSString stringWithFormat:@"%@, %@", aSpotlight.gym,aSpotlight.location_gym_city];
    }
    else{
        gymLabel.text = [NSString stringWithFormat:@"%@, %@", aSpotlight.gym, aSpotlight.gymLocation];
    }
    
    
    
    NSURL *imageURL = [NSURL URLWithString:[aSpotlight.image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [profileImageView setImageWithURL:imageURL placeholderImage:[Utility placeHolderImage] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    if(aSpotlight.backgroundImage)
    {
        //NSLog(@"Updated");
        NSURL *imageURL = [NSURL URLWithString:[aSpotlight.backgroundImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        //[bgImgeView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]]];

        if ([aSpotlight.type isEqualToString:SPOTLIGHT_TYPE_INDIVIDUAL])
        {
            [bgImgeView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"bg_individual"]];
        }
        else if ([aSpotlight.type isEqualToString:SPOTLIGHT_TYPE_TRAINER]) {
            [bgImgeView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"bg_trainer"]];
        }
        else if ([aSpotlight.type isEqualToString:SPOTLIGHT_TYPE_GYMSTAR]) {
            [bgImgeView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"bg_gym"]];
        }
        else if ([aSpotlight.type isEqualToString:SPOTLIGHT_TYPE_MOGUL]) {
            [bgImgeView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"bg_business"]];
        }

         //[bgImgeView sd_setImageWithURL:imageURL placeholderImage:[Utility placeHolderImage]];
    }
    else{
        //NSLog(@"Default");
       // bgImgeView.image = [UIImage imageNamed:bgImages[spotlightType]];
    }
         // need to be changed
    
  //  NSURL *barImageURL = [NSURL URLWithString:aSpotlight.QRCodeImage];
 //   [barCodeImageView sd_setImageWithURL:barImageURL placeholderImage:nil];
    
    for (int i = 0, j = 4; i < 5; i++, j--) {
        if (aSpotlight.rate > i) {
            [starImageViews[j] setHidden:NO];
        }else{
            [starImageViews[j] setHidden:YES];
            NSLog(@" spotlight rate : %f ,  i : %d , j: %d", aSpotlight.rate , i , j);
        }
    }
    
    if ([aSpotlight.type isEqualToString:SPOTLIGHT_TYPE_MOGUL] || [aSpotlight.type isEqualToString:SPOTLIGHT_TYPE_GYMSTAR]) {
        genderLabel.hidden = YES;
    }else{
        genderLabel.hidden = NO;
    }
    
    NSArray *array = [[aSpotlight preferences] componentsSeparatedByString:@","];
    
    if ([aSpotlight.type isEqualToString:SPOTLIGHT_TYPE_GYMSTAR]) {
        array = aSpotlight.gymFeatures;
    }
    
    CGRect frame = prefsCell.frame;
    if ([array count] > 0) {
        frame.size.height += [Utility showPrefs:array inView:prefsView withColor:DEFAULT_BG_COLOR] + 20;
    }else{
        frame.size.height += 20;
    }
    
    prefsCell.frame = frame;
    [self initCellViews];
    [(UITableView *)self.view reloadData];
    
    personalHourExpandButton.selected = [Utility isButtonCollapsed:spotlightType andSection:2];
    personalHalfHourExpandButton.selected = [Utility isButtonCollapsed:spotlightType andSection:3];
}


- (void)loadData
{

    //yt7July
    locationImageView.image = [locationImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    dumbleImageView.image = [dumbleImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];


    [personalHourExpandButton setImage:[[personalHourExpandButton imageForState:UIControlStateNormal] imageWithColor:[Utility colorForBgTitle:@"plus.png"]] forState:UIControlStateNormal];

    [personalHourExpandButton setImage:[[personalHourExpandButton imageForState:UIControlStateNormal] imageWithColor:[Utility colorForBgTitle:@"minus.png"]] forState:UIControlStateDisabled];


    [personalHalfHourExpandButton setImage:[[personalHalfHourExpandButton imageForState:UIControlStateNormal] imageWithColor:[Utility colorForBgTitle:@"plus.png"]] forState:UIControlStateNormal];

    [personalHalfHourExpandButton setImage:[[personalHalfHourExpandButton imageForState:UIControlStateNormal] imageWithColor:[Utility colorForBgTitle:@"minus.png"]] forState:UIControlStateDisabled];


    [locationImageView setTintColor:DEFAULT_BG_COLOR];
    [dumbleImageView setTintColor:DEFAULT_BG_COLOR];

    //yt7July//

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    SpotlightDataController *sDC = [SpotlightDataController new];
    
    [sDC spotlightDetails:self.aSpotlight.ID withSuccess:^(Spotlight *aSpotlight) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.aSpotlight = aSpotlight;
            [self fillDetailsWithSpotlight:aSpotlight];
          
            [(UITableView *)self.view reloadData];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        });
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alertView show];
        
    }];
    
}

#pragma mark -UIALertView

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    [self backButtonPressed:nil];
}

#pragma mark - IBActions

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)rateButtonPressed:(id)sender {
    [self setNeedsStatusBarAppearanceUpdate];

    RateView *rateView = [[RateView alloc] initWithFrame:self.view.frame];
    [rateView setSpotlight:self.aSpotlight];
    [rateView setSuccess:^{
        [self fillDetailsWithSpotlight:self.aSpotlight];
    }];
    [self.view addSubview:rateView];
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

- (IBAction)contactMe:(id)sender
{
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setToRecipients:@[self.aSpotlight.email]];
    [controller setSubject:@"Contact us"];
    [controller setMessageBody:@"" isHTML:NO]; //Hello
    if (controller) [self presentViewController:controller animated:YES completion:nil];
}


- (IBAction)showOwner:(id)sender{
    
    TeamViewController *tVC = [TeamViewController new];
    tVC.members = self.aSpotlight.owners;
    tVC.email = self.aSpotlight.email;
    [tVC.navigationItem setTitle:@"Meet the Owners"];
    [self.navigationController pushViewController:tVC animated:YES];
}


- (IBAction)showTeam:(id)sender{
    
    TeamViewController *tVC = [TeamViewController new];
    tVC.members = self.aSpotlight.team;
    tVC.email   = self.aSpotlight.email;
    [tVC.navigationItem setTitle:@"Meet the Team"];
    [self.navigationController pushViewController:tVC animated:YES];
}


- (IBAction)expandPersonalHour:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    [Utility buttonCollapsed:spotlightType andSectoin:2 andStatus:sender.selected];
    numOfRows[spotlightType][2] = (personalHourExpandButton.selected) ? [self.aSpotlight.fullPersonalTrainings count] : 0;
    [(UITableView *)self.view reloadData];
    if (sender.selected) {
        [(UITableView *)self.view scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:numOfRows[spotlightType][2]-1 inSection:2] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}


- (IBAction)expandPersonalHalfHour:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    [Utility buttonCollapsed:spotlightType andSectoin:3 andStatus:sender.selected];
    numOfRows[spotlightType][3] = (personalHalfHourExpandButton.selected) ? [self.aSpotlight.halfPersonalTrainings count] : 0;
    [(UITableView *)self.view reloadData];
    if (sender.selected) {
        [(UITableView *)self.view scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:numOfRows[spotlightType][3]-1 inSection:3] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}


- (IBAction)expandButtonPressed:(UIButton *)sender
{
    sender.selected = !sender.selected;
    [Utility buttonCollapsed:spotlightType andSectoin:sender.tag andStatus:sender.selected];
    numOfRows[spotlightType][sender.tag] = (sender.selected) ? defaultNumOfRows[spotlightType][sender.tag] : 0;
    [(UITableView *)self.view reloadData];
    if (sender.selected) {
        [(UITableView *)self.view scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:numOfRows[spotlightType][sender.tag]-1 inSection:sender.tag] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

#pragma mark - Mail Composer delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    [controller dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark - UItable View data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return numOfSections[spotlightType];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return numOfRows[spotlightType][section];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height = 0.0;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 290, 10)];
    label.font = [UIFont systemFontOfSize:12.0f];
    
    CGFloat dayCelHeight = 23.0f;
    CGFloat discountImageHeight = 160.0f;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        dayCelHeight = 45.0f;
        discountImageHeight = 300.0f;
    }
    
    if (indexPath.section == 0) {
        height = [(UITableViewCell *)cellViews[spotlightType][indexPath.row] frame].size.height;
    }else if(indexPath.section == 1){
        height = dayCelHeight;
    }else if(indexPath.section == 2 || indexPath.section == 3){
        if (spotlightType == 1) {
            height = dayCelHeight;
        }else{
            height = discountImageHeight;
        }
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat screenWidth = [[UIScreen mainScreen]bounds].size.width;
    
    NSString *identifier = [NSString stringWithFormat:@"RegisterCellSection%ld", (long)indexPath.section];
    
    UITableViewCell *cell; // = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (indexPath.section == 0) {
    
        cell = cellViews[spotlightType][indexPath.row];
        
        CGFloat titleFontSize = 13.0f;
        CGFloat detailFontSize = 12.0f;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            titleFontSize = 20.0f;
            detailFontSize = 18.0f;
        }
        
        cell.textLabel.font = [UIFont systemFontOfSize:titleFontSize];
        cell.textLabel.textColor = [UIColor colorWithRed:(102.0f/255.0f) green:(102.0f/255.0f) blue:(103.0f/255.0f) alpha:1.0f];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:detailFontSize];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:(177.0f/255.0f) green:(174.0f/255.0f) blue:(182.0f/255.0f) alpha:1.0f];
    
    }
    else if(indexPath.section == 1){
        DayCell *dayCell = [tableView dequeueReusableCellWithIdentifier:dayCellNibName];
        [dayCell.bgView setHidden:(indexPath.row % 2)];
        
        OperatingHour *hour = self.aSpotlight.operatingHours[indexPath.row];
        dayCell.dayLabel.text = weekDays[indexPath.row];
        dayCell.fromTimeLabel.text = [NSString stringWithFormat:@"%ld:00am", (long)hour.opening];
        NSInteger closingHour;
        if (hour.closing > 12) {
            closingHour = hour.closing - 12;
            dayCell.toTimeLabel.text = [NSString stringWithFormat:@"%ld:00pm", (long)closingHour];
            
        }
        else{
            closingHour = hour.closing;
            dayCell.toTimeLabel.text = [NSString stringWithFormat:@"%ld:00am", (long)closingHour];
            
        }
        
//        dayCell.dayLabel = 
//        cell.backgroundColor = [UIColor colorWithRed:(246.0f/255.0f) green:(246.0f/255.0f) blue:(246.0f/255.0f) alpha:1.0f];
        if ([[[UIDevice currentDevice] systemVersion] integerValue] >= 7) {
            dayCell.separatorInset = UIEdgeInsetsMake(0, screenWidth / 2, 0, screenWidth / 2);
        }
        cell = dayCell;
    }
    else if(indexPath.section == 2){
        
        if (spotlightType == 1) {
            
            SessionCell *dayCell = [tableView dequeueReusableCellWithIdentifier:sessionCellNibName];
            [dayCell.bgView setHidden:(indexPath.row % 2)];
            
            PersonalTraining *personalTraining = self.aSpotlight.fullPersonalTrainings[indexPath.row];
            dayCell.dayLabel.text = [NSString stringWithFormat:@"%ld", (long)personalTraining.hour];
            
            dayCell.priceLabel.text = [NSString stringWithFormat:@"$%.0f", personalTraining.rate];
            
            //        dayCell.dayLabel =
            //        cell.backgroundColor = [UIColor colorWithRed:(246.0f/255.0f) green:(246.0f/255.0f) blue:(246.0f/255.0f) alpha:1.0f];
            if ([[[UIDevice currentDevice] systemVersion] integerValue] >= 7) {
                dayCell.separatorInset = UIEdgeInsetsMake(0, screenWidth / 2, 0, screenWidth / 2);
            }
            cell = dayCell;
        }
        else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            
            discountsImage = [[UIImageView alloc] init];
            [discountsImage sd_setImageWithURL:[NSURL URLWithString:self.aSpotlight.discountsImage[0]]];
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 35.0f)];
            [view setBackgroundColor:[UIColor colorWithRed:(246.0f/255.0f) green:(246.0f/255.0f) blue:(246.0f/255.0f) alpha:1.0f]];
            
            discountsImage.frame = CGRectMake(5, 0, screenWidth - 10, [self tableView:tableView heightForRowAtIndexPath:indexPath]);
            [view addSubview:discountsImage];
            cell.backgroundView = view;
        }
        
    }
    else if(indexPath.section == 3) {
        if (spotlightType == 1) {
            
            
            SessionCell *dayCell = [tableView dequeueReusableCellWithIdentifier:sessionCellNibName];
            [dayCell.bgView setHidden:(indexPath.row % 2)];
            
            PersonalTraining *personalTraining = self.aSpotlight.halfPersonalTrainings[indexPath.row];
            dayCell.dayLabel.text = [NSString stringWithFormat:@"%ld", (long)personalTraining.hour];
            
            dayCell.priceLabel.text = [NSString stringWithFormat:@"$%.0f", personalTraining.rate];
            
            //        dayCell.dayLabel =
            //        cell.backgroundColor = [UIColor colorWithRed:(246.0f/255.0f) green:(246.0f/255.0f) blue:(246.0f/255.0f) alpha:1.0f];
            if ([[[UIDevice currentDevice] systemVersion] integerValue] >= 7) {
                dayCell.separatorInset = UIEdgeInsetsMake(0, screenWidth / 2, 0, screenWidth / 2);
            }
            cell = dayCell;
        }
        else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img1"]];
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.aSpotlight.discountsImage[0]]];

            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 35.0f)];
            [view setBackgroundColor:[UIColor colorWithRed:(246.0f/255.0f) green:(246.0f/255.0f) blue:(246.0f/255.0f) alpha:1.0f]];
            
            imageView.frame = CGRectMake(5, 0, screenWidth / 2, imageView.frame.size.height);
            [view addSubview:imageView];
            cell.backgroundView = view;
        }
    }
    
    return cell;
    
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    
//    NSString *title;
//    
//    switch (section) {
//        case 0:
//            title = @"";
//            break;
//        case 1:
//            title = @"Gym Details:";
//            break;
//        case 2:
//            title = @"Referred By:";
//            break;
//            
//        default:
//            title = @"";
//            break;
//    }
//    
//    return title;
//}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if([view isKindOfClass:[UITableViewHeaderFooterView class]]){
        UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *) view;
        tableViewHeaderFooterView.textLabel.text = [tableViewHeaderFooterView.textLabel.text capitalizedString];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    CGFloat height;
    
    CGFloat viewHeight = 36.0f;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        viewHeight = 72.0f;
    }
    
    switch (section) {
        case 0:
            height = 1;
            break;
        case 1:
            height = viewHeight;
            break;
        case 2:
        case 3:
            if (spotlightType == 1) {
                height = sessionHeaderView.frame.size.height;
            } else {
                height = viewHeight;
            }
            break;
    }
    
    return height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    CGFloat height;
    
    
    
    switch (section) {
        case 0:
            height = 0;
            break;
        case 1:
            height = 11;
            break;
        case 2:
        case 3:
            height = 11;
            break;
            
        case 4:
        case 5:
            height = 0;
            break;
    }
    
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view;
    
    if ([sectionHeaders[spotlightType][section] isEqualToString:@""]) {
        return view;
    }
    
    if (spotlightType == 1) {
        if (section == 2) {
            return sessionHeaderView;
        }else if(section == 3){
            return halfSessionHeaderView;
        }
    }

    
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    
    CGFloat headerFontSize = 15.0f;
    CGFloat viewHeight = 35.0f;
    CGFloat scaleFactor = 1.0f;
    CGRect expandFrame = CGRectMake(screenWidth - 54.0f, 0, 44.0f, 30.0f);
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        headerFontSize = 20.0f;
        viewHeight = 70.0f;
        scaleFactor = 2.0f;
        expandFrame = CGRectMake(screenWidth - 80.0f, 0, 60.0f, 60.0f);
        
    }
    
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, viewHeight)];
    [view setBackgroundColor:[UIColor colorWithRed:(246.0f/255.0f) green:(246.0f/255.0f) blue:(246.0f/255.0f) alpha:1.0f]];
    
    UIView *subview = [[UIView alloc] initWithFrame:CGRectMake(5 * scaleFactor, 5 * scaleFactor, screenWidth - 10 * scaleFactor, 31.0f * scaleFactor)];
    [subview setBackgroundColor:[UIColor whiteColor]];
    
    UIView *borderview = [[UIView alloc] initWithFrame:CGRectMake(4 * scaleFactor, 5 * scaleFactor, screenWidth - 8 * scaleFactor, 31.0f * scaleFactor)];
    [borderview setBackgroundColor:[UIColor colorWithRed:238.0f/255.0f green:237.0f/255.0f blue:238.0f/255.0f alpha:1.0f]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5* scaleFactor, screenWidth - 30, 18 * scaleFactor) ];
    label.text = sectionHeaders[spotlightType][section];
    label.font = [UIFont systemFontOfSize:headerFontSize];
   // label.textColor = [UIColor colorWithRed:0 green:(193.0f/255.0f) blue:(173.0f/255.0f) alpha:1.0f];
    label.textColor = DEFAULT_BG_COLOR;   //yt13July


    UIButton *expandButton = [expandButtons objectForKey:@(section)];
    expandButton = [Utility removeNSNULL:expandButton];
    
    if (expandButton == nil)
    {
        if (expandButtons == nil)
            expandButtons = [NSMutableDictionary new];
        
        expandButton = [[UIButton alloc] initWithFrame:expandFrame];

         //yt13July
      //  [expandButton setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
     //   [expandButton setImage:[UIImage imageNamed:@"minus"] forState:UIControlStateSelected]; 

        expandButton.selected = [Utility isButtonCollapsed:spotlightType andSection:section];
        expandButton.tag = section;
        [expandButton addTarget:self action:@selector(expandButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [expandButtons setObject:expandButton forKey:@(section)];
        
    }else{
        expandButton = [expandButtons objectForKey:@(section)];
    }
    
    
    expandButton.selected = [Utility isButtonCollapsed:spotlightType andSection:section];
    
    [subview addSubview:expandButton];

    //yt13July
    [expandButton setImage:[[UIImage imageNamed:@"plus.png"] imageWithColor:[Utility colorForBgTitle:@"plus.png"]] forState:UIControlStateNormal];

    [expandButton setImage:[[UIImage imageNamed:@"minus.png"] imageWithColor:[Utility colorForBgTitle:@"minus.png"]] forState:UIControlStateSelected];
    //yt13July//


    [subview addSubview:label];
    [view addSubview:borderview];
    [view addSubview:subview];
    
    return view;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view;
    
    if (section != 0) {
        
        CGFloat minusFactor = 10.0f;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            minusFactor = 20.0f;
        }
        
        CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
        
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 10.0f)];
        [view setBackgroundColor:[UIColor colorWithRed:(246.0f/255.0f) green:(246.0f/255.0f) blue:(246.0f/255.0f) alpha:1.0f]];
        
        UIView *subview = [[UIView alloc] initWithFrame:CGRectMake(minusFactor / 2, 0, screenWidth - minusFactor, 10.0f)];
        [subview setBackgroundColor:[UIColor whiteColor]];
        
        UIView *borderview = [[UIView alloc] initWithFrame:CGRectMake(minusFactor / 2 - 1, 0, screenWidth - minusFactor - 2, 11.0f)];
        [borderview setBackgroundColor:[UIColor colorWithRed:238.0f/255.0f green:237.0f/255.0f blue:238.0f/255.0f alpha:1.0f]];
        
        [view addSubview:borderview];
        [view addSubview:subview];
    }
    else{
        view = nil;
    }
    return view;
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"IndexPath: %ld", indexPath.row);
}


@end
