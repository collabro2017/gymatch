//
//  TrainerDetailsViewController.m
//  GYMatch
//
//  Created by Ram on 24/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "TrainerDetailsViewController.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "SpotlightDataController.h"
#import "Utility.h"
#import "PersonalTraining.h"

@interface TrainerDetailsViewController ()

@end

@implementation TrainerDetailsViewController

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
    [self.navigationItem setTitle:@"Trainer"];
    
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
    nameLabel.text = aSpotlight.name;
    genderLabel.text = [NSString stringWithFormat:@"%@, %d",
                        aSpotlight.gender,
                        aSpotlight.age];
    
    locationLabel.text = aSpotlight.address;
    
    preferencesLabel.text = aSpotlight.preferences;
    
    gymLabel.text = [NSString stringWithFormat:@"%@ trains at %@, %@", aSpotlight.name, aSpotlight.gym, aSpotlight.gymLocation];
    
    bioLabel.text = aSpotlight.description;
    
    educationLabel.text = aSpotlight.education;
    
    NSURL *imageURL = [NSURL URLWithString:aSpotlight.image];
    [imageView setImageWithURL:imageURL placeholderImage:[Utility placeHolderImage]];
    
    hobbiesLabel.text = aSpotlight.hobbies;

    [self fillClubHours];
    
    [self adjustAutoLayoutConstraints];
}

- (void)fillClubHours{
    int i = 0;
    for (OperatingHour *hour in self.aSpotlight.operatingHours) {
        UILabel *tempLabel = [dayTimeLabels objectAtIndex:i++];
        tempLabel.text = [NSString stringWithFormat:@"%d:00 AM To %d:00 PM", hour.opening, hour.closing];
    }
}

- (void)adjustAutoLayoutConstraints{
    gymHeight.constant = [Utility heightForLabel:gymLabel];
    preferenceHeight.constant = [Utility heightForLabel:preferencesLabel];
    educationHeight.constant = [Utility heightForLabel:educationLabel];
    hobbiesHeight.constant = [Utility heightForLabel:hobbiesLabel];
    
    personalTrainingHeight.constant = ( [self.aSpotlight.fullPersonalTrainings count] + [self.aSpotlight.halfPersonalTrainings count] + 2 ) * 20;
}

- (void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    SpotlightDataController *sDC = [SpotlightDataController new];
    
    [sDC spotlightDetails:self.aSpotlight.ID withSuccess:^(Spotlight *aSpotlight) {
        self.aSpotlight = aSpotlight;
        [self fillDetailsWithSpotlight:aSpotlight];
        
        [personalTrainingTableView reloadData];
        
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

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    NSString *title;
    switch (section) {
        case PersonalTrainingHourTypeFull:
            title = @"Hour Session";
            break;
            
        case PersonalTrainingHourTypeHalf:
            title = @"Half Hour Session";
            break;
            
        default:
            break;
    }
    return title;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count;
    switch (section) {
        case PersonalTrainingHourTypeFull:
            count = [self.aSpotlight.fullPersonalTrainings count];
            break;
            
        case PersonalTrainingHourTypeHalf:
            count = [self.aSpotlight.halfPersonalTrainings count];
            break;
            
        default:
            count = 0;
            break;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HourCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]init];
    }
    
    PersonalTraining *personalTraining;
    
    switch (indexPath.section) {
        case PersonalTrainingHourTypeFull:
            personalTraining = [self.aSpotlight.fullPersonalTrainings objectAtIndex:indexPath.row];
            break;
            
        case PersonalTrainingHourTypeHalf:
            personalTraining = [self.aSpotlight.fullPersonalTrainings objectAtIndex:indexPath.row];
            break;
            
        default:
            break;
    }
    
    NSString *title = [NSString stringWithFormat:@"$%.0f / %d hour", personalTraining.rate, personalTraining.hour];
    cell.textLabel.text = title;
    
    
    [cell.textLabel setFont:[UIFont systemFontOfSize:13.0f]];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
    
}

@end
