//
//  SpotlightsViewController.m
//  GYMatch
//
//  Created by Ram Gautam on 10/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "SpotlightsViewController.h"
#import "SpotCell.h"
#import "MBProgressHUD.h"
#import "SpotlightDataController.h"
#import "SpotlightDetailsViewController.h"
#import "Utility.h"
#import "FiltersViewController.h"
#import "GymFiltersViewController.h" // Gourav june 30

@interface SpotlightsViewController ()<GymFilterDelegate>{
    
    NSMutableDictionary *spotlights;
    NSString *selectedType;
    NSString *spotCellNibName;
    
   // SpotlightsFilterViewController *fVC;
    //FiltersViewController *fVC;
    
    GymFiltersViewController *fVC; // Gourav june 26
    
    
    NSMutableDictionary *dicSearchKey;
    
}

@end
BOOL showBook;


@implementation SpotlightsViewController
@synthesize singleTapBool, label_showSingleText, singleString;

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

    self.edgesForExtendedLayout = UIRectEdgeNone;

    spotlights = [NSMutableDictionary new];
    selectedType = SPOTLIGHT_TYPE_INDIVIDUAL;
    
    spotCellNibName = kSpotCell;
    if ([[UIDevice currentDevice] userInterfaceIdiom]) {
        spotCellNibName = kSpotCell_iPad;
        
        [tableView setSeparatorInset:UIEdgeInsetsMake(0, 135, 0, 0)];
    }
    
    UINib *nib = [UINib nibWithNibName:spotCellNibName bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:spotCellNibName];
    

    tableView.tableFooterView = [[UIView alloc] init];
    self.btnFilter.layer.cornerRadius = 5;
   
    dicSearchKey = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"", @"name", @"", @"country", @"", @"state", @"", @"city", @"", @"gender", nil];
    [dicSearchKey setObject:selectedType forKey:@"type"];
    
    showBook = YES;
    
    //yt7July opened
}



- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    [self.navigationItem setTitle:@"Spotlight"];
    [[(TopNavigationController *)[[APP_DELEGATE tabBarController] selectedViewController] friendNavigationBar] setHidden:YES];
    
    [[[APP_DELEGATE tabBarController] tabBar] setHidden:NO];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [(TopNavigationController *)[[APP_DELEGATE tabBarController] selectedViewController] showProfileMenuOnlyCalendar];
    if (singleTapBool == YES) {
        
        if ([singleString isEqualToString:@"Trainer"]) {
            
            label_showSingleText.text  = singleString;
            label_showSingleText.hidden = NO;
            // button_Trainer.selected = NO;
            [self spotTypeButtonPressed:button_Trainer];
            
        } else {
            
            label_showSingleText.text  = singleString;
            label_showSingleText.hidden = NO;
            [self spotTypeButtonPressed:gymStudio];
        }
    
    } else {
        [self loadData];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"---SpotlightsViewController---: didReceiveMemoryWarning");
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
    
    SpotlightDataController *sDC = [SpotlightDataController new];
    [sDC spotlightsWithType:selectedType andKeyword:searchBar.text success:^(NSArray *spotligtsArray) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [spotlights setObject:spotligtsArray forKey:selectedType];
            [tableView reloadData];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
        });
        
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"The request timed out." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            [tableView reloadData];
        });
    }];
    
}

#pragma mark - IBActions

- (IBAction)spotTypeButtonPressed:(UIButton *)sender {
    
    for (UIButton *button in tabButtons) {
        if (button.tag == sender.tag) {
            button.selected = YES;
        } else {
            button.selected = NO;
        }
    }
    
    switch (sender.tag) {
        case 101:
            selectedType = SPOTLIGHT_TYPE_INDIVIDUAL;
            showBook = YES;
            break;
        case 102:
            selectedType = SPOTLIGHT_TYPE_TRAINER;
            showBook = NO;
            break;
        case 103:
            selectedType = SPOTLIGHT_TYPE_GYMSTAR;
            showBook = NO;
            break;
        case 104:
            selectedType = SPOTLIGHT_TYPE_MOGUL;
            showBook = YES;
            break;
    }
    
    [self loadData];
}


#pragma mark - UItable View

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return 100.0f;
    }
    
    return 68.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    NSInteger countVal = [[spotlights objectForKey:selectedType] count];
    if(countVal>0)
       [noFriendLabel setHidden:YES];

    return countVal;
}

- (UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SpotCell *cell = [atableView dequeueReusableCellWithIdentifier:spotCellNibName];

    //cell = nil;

    if (cell == nil) {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:spotCellNibName owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }

    Spotlight *spotLight = [[spotlights objectForKey:selectedType] objectAtIndex:indexPath.row];
    [cell fillWithSpotlight:spotLight];
    
    return cell;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    Spotlight *spotLight = [[spotlights objectForKey:selectedType] objectAtIndex:indexPath.row];
    
    SpotlightDetailsViewController *viewController = [[SpotlightDetailsViewController alloc] initWithSpotlight:spotLight];
    viewController.showBookButton = showBook;
    viewController.selectedType = selectedType;
    
/*
    if ([selectedType isEqualToString:SPOTLIGHT_TYPE_INDIVIDUAL]) {
        
        viewController = [[SpotlightDetailsViewController alloc]initWithSpotlight:spotLight];
        
    }if ([selectedType isEqualToString:SPOTLIGHT_TYPE_TRAINER]) {
        
        viewController = [[TrainerDetailsViewController alloc]initWithSpotlight:spotLight];
        
    }else if([selectedType isEqualToString:SPOTLIGHT_TYPE_GYMSTAR]){
        
        viewController = [[GymDetailsViewController alloc]initWithSpotlight:spotLight];
        
    }else if([selectedType isEqualToString:SPOTLIGHT_TYPE_MOGUL]){
        
        viewController = [[MogulDetailsViewController alloc]initWithSpotlight:spotLight];
        
    }
 */
    
    
    [self.navigationController pushViewController:viewController animated:YES];
    
    [[[APP_DELEGATE tabBarController] tabBar] setHidden:YES];
}

#pragma mark - UISearchBar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)aSearchBar{
    
    NSString *keyword = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    searchBar.text = keyword;

    [searchBar resignFirstResponder];
    [self loadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)aSearchBar{
    [searchBar resignFirstResponder];
    searchBar.text = @"";
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)aSearchBar{
    
    NSString *keyword = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    searchBar.text = keyword;
    
    if ([keyword isEqualToString:@""]) {
        [searchBar resignFirstResponder];
        
    }
    [self loadData];
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

-(void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope{
    switch (selectedScope) {
        case 0:
            selectedType = SPOTLIGHT_TYPE_INDIVIDUAL;
            break;
        case 1:
            selectedType = SPOTLIGHT_TYPE_TRAINER;
            break;
        case 2:
            selectedType = SPOTLIGHT_TYPE_GYMSTAR;
            break;
        case 3:
            selectedType = SPOTLIGHT_TYPE_MOGUL;
            break;
            
        default:
            break;
    }
    
    [self loadData];
}


- (IBAction)onFilter:(id)sender {
//    if (fVC == nil) {
//        //fVC = [[SpotlightsFilterViewController alloc] init];
//        fVC = [[FiltersViewController alloc] init]; // Gourav june 11
//        fVC.delegate = self;
//    }
    

    if (fVC == nil) {
        fVC = [[GymFiltersViewController alloc] init];
        fVC.delegate = self;
    }
    if([selectedType  isEqual: SPOTLIGHT_TYPE_GYMSTAR] || [selectedType  isEqual: SPOTLIGHT_TYPE_MOGUL])
        fVC.notHuman = YES;
    else
        fVC.notHuman = NO;

    [[[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:3] friendNavigationBar] setHidden:YES];
    
    [self.navigationController pushViewController:fVC animated:YES];
}

-(void)doneWithDictionary:(NSMutableDictionary *)dictionary {

    NSString *gender      = [dictionary objectForKey:@"gender"];
    NSString *city      = [dictionary objectForKey:@"city"];
    NSString *state     = [dictionary objectForKey:@"state"];
    NSString *country   = [dictionary objectForKey:@"country"];
    if(!gender && !city && !state && !country)
        return;

  //  selectedType = SPOTLIGHT_TEMP_FILTER;
    dicSearchKey = [[NSMutableDictionary alloc] initWithObjectsAndKeys:gender, @"gender", country, @"country", state, @"state", city, @"city", selectedType, @"category",  nil];
  //  [dicSearchKey setObject:selectedType forKey:@"type"];
  //  [self loadData];




    //yt 6July

        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dicSearchKey options:kNilOptions error:nil];
        NSString *postLength = [NSString stringWithFormat:@"%ld", (unsigned long)[jsonData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setHTTPMethod:@"POST"];
        //  NSLog(@"ur %@", [NSString stringWithFormat:@"%@/get_access_logs.php",[Utility serverAddress]]);
        [request setURL:[NSURL URLWithString:@"http://www.jebcoolkids.com/gymatch_app/spotlight_search.php"]];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];

        [request setHTTPBody:jsonData];
        //print json:
        NSLog(@"JSON Summary: %@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    
        NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        [connection start];
      //  [self performSelectorOnMainThread:@selector(displayProgressView) withObject:nil waitUntilDone:NO];

    //yt 6July
}



#pragma mark-
#pragma mark- NSURLCONNECTION METHODS

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (!webData)
        webData = [[NSMutableData alloc] init];

    [webData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (!webData)
        webData = [[NSMutableData alloc] init];

    [webData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
   // ds
   // NSString *urlStr = [[[connection originalRequest] URL] absoluteString];
    NSLog(@"URL: %@", [[[connection originalRequest] URL] absoluteString]);
    NSString *str = [[NSString alloc] initWithData:webData encoding:NSASCIIStringEncoding];
    NSLog(@"str >>>>>>>>>>>>>>>>>>>>>+++++ %@",str);
    NSDictionary *allDatadictionary=[NSJSONSerialization JSONObjectWithData:webData options:0 error:nil];
    
    NSLog(@" AllDatadictionary %@ >>>>>>>>>>>>>>>>>>>>>--------",allDatadictionary);
    NSLog(@"All data dictionary object for key  %@",  [allDatadictionary objectForKey:@"name"]);
    NSLog(@"\n\n\nAll data dictionary: %@\n\n\n\n\n", allDatadictionary);
    
    if (webData)
        webData = nil;

    int errorValue = [[allDatadictionary valueForKey:@"error_code"] intValue];
    if(errorValue == 200 )
    {
        noFriendLabel.hidden = YES;
        NSArray *arr = [allDatadictionary valueForKey:@"friends"];
        NSMutableArray *resultArr = [NSMutableArray array];
        for(NSDictionary *dict in arr)
        {
            Spotlight *spotLight = [[Spotlight alloc] initWithDictionary:dict];
            [resultArr addObject:spotLight];

        }
        [spotlights setObject:resultArr forKey:selectedType];
        [tableView reloadData];
        // [self loadData];
    }
    else if (errorValue ==201)
    {
        noFriendLabel.hidden = NO;
        spotlights = [NSMutableDictionary dictionary];
        [tableView reloadData];
    }
   // [self performSelectorOnMainThread:@selector(hideProgressView) withObject:nil waitUntilDone:NO];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{}


@end
