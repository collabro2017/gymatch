//
//  RequestsViewController.h
//  GYMatch
//
//  Created by Ram Gautam on 10/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckButton.h"

@interface RequestsViewController : UIViewController
<UISearchBarDelegate>
{
    __weak IBOutlet UITableView *friendsTableView;

    __weak IBOutlet UISearchBar *searchBar;
    
    __weak IBOutlet UILabel *noUserLabel;
    
}
@property (strong, nonatomic) IBOutletCollection (UIButton) NSArray *friendsButtons;

@property (weak, nonatomic) IBOutlet UIButton *btnFilter;
- (IBAction)onFilter:(id)sender;

- (void)loadData;
-(void)invalidateRequestLoading;
-(void)loadDataForPeningRequests;
-(void)setTab;
- (IBAction)friendTypeButtonPressed:(UIButton *)sender;
- (void)loadManagedRequest;
- (void)actionAccept:(NSDictionary*)dictionary;
- (void)actionDecline:(NSDictionary*)dictionary;
- (void)payResult:(BOOL)flag;

@end
