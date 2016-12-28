//
//  SpotlightsViewController.h
//  GYMatch
//
//  Created by Ram Gautam on 10/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckButton.h"
#import "SpotlightsFilterViewController.h"

@interface SpotlightsViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, SpotLightFilterDelegate>
{
    __weak IBOutlet UITableView *tableView;
    
    IBOutletCollection(UIButton) NSArray *tabButtons;
    
    IBOutlet UIButton *button_Trainer;
    IBOutlet UIButton *gymStudio;
    IBOutlet UIButton *button_Individual;
    
    __weak IBOutlet UISearchBar *searchBar;
    __weak IBOutlet UILabel *noFriendLabel;
    NSMutableData *webData; //yt 6July 
}

@property (weak, nonatomic) IBOutlet UIButton *btnFilter;

@property (nonatomic, assign) BOOL singleTapBool;

@property (weak, nonatomic) IBOutlet UILabel *label_showSingleText;

@property (strong, nonatomic) NSString *singleString;


- (IBAction)onFilter:(id)sender;
- (void)loadData; 



@end
