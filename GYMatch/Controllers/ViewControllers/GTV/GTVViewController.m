//
//  GTVViewController.m
//  GYMatch
//
//  Created by Ram on 08/04/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "GTVViewController.h"
#import "GTV.h"
#import "MBProgressHUD.h"
#import "GTVDataController.h"
#import "PlayerViewController.h"
#import "RoundButton.h"
#import "GTVCell.h"
#import "Utility.h"

@interface GTVViewController (){
    NSArray *gtvArray;
    NSString *type;
    NSString *nibName;
}

@end

@implementation GTVViewController

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
    
    type = @"Teaser";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    nibName = kGTVCell;

    float segmentTextFontSize = 12.0;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        nibName = kGTVCell_iPad;
        segmentTextFontSize = 15.0;
        [gtvTableView setSeparatorInset:UIEdgeInsetsMake(0, 100, 0, 0)];
        
    }
    
    UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
    [gtvTableView registerNib:nib forCellReuseIdentifier:nibName];
    
    [typeSegmentedControl setBackgroundColor:[UIColor colorWithRed:0 green:(191.0f/255.0f) blue:(77.0f/255.0f) alpha:1.0f]];
    
    [typeSegmentedControl setBackgroundImage:[Utility imageWithColor:[UIColor colorWithRed:0 green:(191.0f/255.0f) blue:(77.0f/255.0f) alpha:1.0f]] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    [typeSegmentedControl setBackgroundImage:[Utility imageWithColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f]] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    NSDictionary *txtAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:segmentTextFontSize], NSForegroundColorAttributeName:[UIColor whiteColor]};
    [typeSegmentedControl setTitleTextAttributes:txtAttributes forState:UIControlStateSelected];
    
    txtAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:segmentTextFontSize], NSForegroundColorAttributeName:[UIColor darkGrayColor]};
    [typeSegmentedControl setTitleTextAttributes:txtAttributes forState:UIControlStateNormal];
//    [typeSegmentedControl setBackgroundImage:[[UIImage imageNamed:@"select_arrow2"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
//    
//    [typeSegmentedControl setFrame:CGRectMake(0, 44.0f, 320.0f, 88.0f)];
    
//    [typeSegmentedControl setDividerImage:[UIImage imageNamed:@"nav_sep"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    [typeSegmentedControl setDividerImage:[UIImage imageNamed:@"nav_sep"] forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    [typeSegmentedControl setDividerImage:[UIImage imageNamed:@"nav_sep"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];

    
    [self loadData];
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationItem setTitle:@"G-TV"];
     self.view.frame = CGRectMake(0, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height+49);  //yt 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    GTVDataController *uDC = [GTVDataController new];
    [uDC gtvWithKeyword:type withSuccess:^(NSArray *friends){
        gtvArray = friends;
        
        [gtvTableView reloadData];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
//        if ([friendsArray count] == 0) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"You have no friends. Do you want to see GYMatch recommendatations?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
//            [alertView show];
//        }
        
    } failure:^(NSError *error) {
        
        if ([error.domain isEqualToString:@"NoAccess"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Get Spotlight" message:error.localizedDescription delegate:self cancelButtonTitle:@"Not Now" otherButtonTitles:@"Sign Me Up!", nil];
            [alertView show];
        }
        else {
          //  NSLog(@"Error- code = %ld description = %@", (long)error.code, error.localizedDescription);
            NSString *msg = error.localizedDescription;
            if(error.code == -1003)
                msg = @"The Internet connection appears to be offline.";
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            
        }
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        gtvArray = nil;
        
        [gtvTableView reloadData];
    }];
}


#pragma mark - UItable View data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [gtvArray count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
//        return 100.0f;
//    }
//    return 122.0f;
    
    CGFloat height = 0;
    
  //  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
  //      return 100.0f;
  //  }
    CGFloat padding = 255;
    
    
    CGFloat fontSize = 13.0f;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        fontSize = 17.0f;
    }
    
      GTV *gtv = [gtvArray objectAtIndex:indexPath.row];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 294.0f, 25.0f)];
    
    label.text = gtv.m_description;
    label.font = [UIFont fontWithName:@"ProximaNova-Regular" size:fontSize];
    height = [Utility heightForLabel:label];
    
    return height+padding-66;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    GTVCell *cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GTVCell"];
//        
//        [cell.imageView setImage:[UIImage imageNamed:@"play"]];
//        RoundButton *button = [RoundButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake(0, 0, 57.0f, 29.0f);
//        button.titleLabel.text = @"Watch";
//        
//        [cell setAccessoryView:button];
//        [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
//    }
    
    
    GTV *gtv = [gtvArray objectAtIndex:indexPath.row];
    
    NSLog(@"%@",gtv.m_description);
    
    [cell fillWithGTV:gtv parent:self index:(int)indexPath.row];
    
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    GTV *gtv = [gtvArray objectAtIndex:indexPath.row];
    
    PlayerViewController *pVC = [PlayerViewController new];
    pVC.gtv = gtv;
    
    [self.navigationController pushViewController:pVC animated:YES];
    
//    FriendDetailsViewController *fdvc = [[FriendDetailsViewController alloc]init];
//    [fdvc setAFriend:[friendsArray objectAtIndex:indexPath.row]];
//    [[[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:0] friendNavigationBar] setHidden:YES];
//    
//    [self.navigationController pushViewController:fdvc animated:YES];
//    
//    [[[APP_DELEGATE tabBarController] tabBar] setHidden:YES];
}

#pragma mark - IBActions

- (IBAction)gtvTypeChanged:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
            
        case 0:
            type = @"Teaser";
            break;
            
        case 1:
            type = @"Blockbuster";
            break;
            
        case 2:
            type = @"Buzz";
            break;
            
        default:
            break;
            
    }
    
    [self loadData];
    
}

#pragma mark - UIAlertView -

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 1:
            [self openSpotlight];
            break;
            
        default:
            break;
    }
}

- (void)openSpotlight{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:SITE_URL_SPOTLIGHT]];
    
}

- (void)didSelectedWithIndex:(int)index type:(int)type_val {
    
    if (type_val == 0) {
        GTV *gtv = [gtvArray objectAtIndex:index];
        
        PlayerViewController *pVC = [PlayerViewController new];
        pVC.gtv = gtv;
        
        [self.navigationController pushViewController:pVC animated:YES];
    }
}

@end
