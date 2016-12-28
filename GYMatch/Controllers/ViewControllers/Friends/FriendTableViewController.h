//
//  FriendTableViewController.h
//  GYMatch
//
//  Created by Ram on 28/05/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckButton.h"
#import "Reachability.h" 


@interface FriendTableViewController : UITableViewController<UISearchBarDelegate>
{
    __weak IBOutlet UITableView *friendsTableView;
    
    IBOutletCollection(UIButton) NSArray *friendsButtons;
    
    __weak IBOutlet UISearchBar *searchBar;

    Reachability *reachability;
    BOOL filterInProcess;
}

@property (weak, nonatomic) IBOutlet UIButton *btnFilter;
- (IBAction)onFilter:(id)sender;

@end
