//
//  FriendsViewController.h
//  GYMatch
//
//  Created by Ram Gautam on 10/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckButton.h"

@interface FriendsViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UISearchBarDelegate>
{
    __weak IBOutlet UITableView *friendsTableView;
    
    IBOutletCollection(CheckButton) NSArray *friendsButtons;
    
    __weak IBOutlet UISearchBar *searchBar;
}
@end
