//
//  FiltersViewController.h
//  GYMatch
//
//  Created by Ram on 01/05/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FilterDelegate <NSObject>

- (void)doneWithDictionary:(NSMutableDictionary *)dictionary;

@end

@interface FiltersViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableViewCell *gymatchSearchCell;
    IBOutlet UITableViewCell *localCell;
    IBOutlet UITableViewCell *genderCell;
    IBOutlet UITableViewCell *distanceCell;
    IBOutlet UIView *resetView;
    IBOutlet UIView *prefHeaderView;
    
    __weak IBOutlet UIButton *prefsExpandButton;
    __weak IBOutlet UIButton *resetButton;
    
    
    // UILabels
    __weak IBOutlet UILabel *gymatchSearchLabel;
    __weak IBOutlet UILabel *gymatchSearchDescLabel;
    __weak IBOutlet UILabel *localLabel;
    __weak IBOutlet UILabel *genderLabel;
    __weak IBOutlet UILabel *searchGymLabel;
    __weak IBOutlet UILabel *milesLabel;
    __weak IBOutlet UILabel *prefsLabel;
    __weak IBOutlet UISwitch *gymatchSearchSwitch;
    
    __weak IBOutlet UISegmentedControl *localSegmentedControl;
    __weak IBOutlet UISegmentedControl *genderSegmentedControl;
    __weak IBOutlet UISlider *milesSlider;
    
    IBOutlet UIButton *doneButton;
}

@property(nonatomic, weak)id <FilterDelegate> delegate;

@end
