//
//  SearchViewController.h
//  GYMatch
//
//  Created by Ram on 02/04/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckButton.h"
#import "FiltersViewController.h"

@interface SearchViewController : UIViewController
<UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate,
FilterDelegate>
{
    __weak IBOutlet UILabel *noResultLabel; 
    __weak IBOutlet UICollectionView *friendsCollectionView;
    __weak IBOutlet UITableView *frinedTableView;
    
    __weak IBOutlet UISearchBar *searchBar;
    __weak IBOutlet UISwitch *gymatchSearchSwitch;
    
    /*
     * Gender Check Buttons
     */
    __weak IBOutlet CheckButton *maleCheckButton;
    __weak IBOutlet CheckButton *femaleCheckButton;
    __weak IBOutlet CheckButton *bothCheckButton;
    IBOutletCollection(CheckButton) NSArray *genderButtons;
    
    /*
     * Local Check Butttons
     */
    __weak IBOutlet CheckButton *myGymCheckButton;
    __weak IBOutlet CheckButton *allGymCheckButton;
    IBOutletCollection(CheckButton) NSArray *gymButtons;
    
    
    /* 
     * Location Check Buttons
     */
    __weak IBOutlet CheckButton *fiveMilesCheckButton;
    __weak IBOutlet CheckButton *tenMilesCheckButton;
    __weak IBOutlet CheckButton *twentyMilesCheckButton;
    IBOutletCollection(CheckButton) NSArray *mileButtons;
    
    /*
     * Training Preferences
     */
    __weak IBOutlet CheckButton *weightTrainingCheckButton;
    __weak IBOutlet CheckButton *pilatesCheckButton;
    __weak IBOutlet CheckButton *cardioCheckButton;
    __weak IBOutlet CheckButton *aerobicCheckButton;
    __weak IBOutlet CheckButton *joggingCheckButton;
    __weak IBOutlet CheckButton *martialCheckButton;
    __weak IBOutlet CheckButton *conditioningCheckButton;
    __weak IBOutlet CheckButton *yogaCheckButton;
    __weak IBOutlet CheckButton *cyclingCheckButton;
    __weak IBOutlet CheckButton *swimmingCheckButton;
    __weak IBOutlet CheckButton *crossTrainingCheckButton;
    __weak IBOutlet CheckButton *bootCampCheckButton;
    
    __weak IBOutlet CheckButton *dancingButton;
    __weak IBOutlet CheckButton *beachButton;
    __weak IBOutlet CheckButton *mmaButton;
    __weak IBOutlet CheckButton *gymnasticsButton;

}
@end
