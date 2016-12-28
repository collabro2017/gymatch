//
//  GymFiltersViewController.h
//  GYMatch
//
//  Created by Ram on 01/05/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Country.h"

@protocol GymFilterDelegate <NSObject>

- (void)doneWithDictionary:(NSMutableDictionary *)dictionary;
- (void)doneWithDistance:(NSInteger)distance;

@end

@interface GymFiltersViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
    IBOutlet UITableViewCell           *gymatchSearchCell;
    IBOutlet UITableViewCell           *localCell;
    IBOutlet UITableViewCell           *genderCell;
    IBOutlet UITableViewCell           *distanceCell;
    IBOutlet UITableViewCell           *tempCell;

    IBOutlet UITableViewCell           *nameCell;                // Gourav june 26

    IBOutlet UITableViewCell           *spotLightGenderCell;     // Gourav june 30

    IBOutlet UIView                    *resetView;
    IBOutlet UIView                    *prefHeaderView;
    __weak IBOutlet UIButton           *prefsExpandButton;
    __weak IBOutlet UIButton           *resetButton;

    // UILabels
    __weak IBOutlet UILabel            *nameLabel;               // Gourav june 26

    __weak IBOutlet UILabel            *spotLightGenderLbl;      // Gourav june 30
    __weak IBOutlet UILabel            *stateLbl;                // Gourav june 30

    __weak IBOutlet UILabel            *gymatchSearchLabel;
    __weak IBOutlet UILabel            *gymatchSearchDescLabel;
    __weak IBOutlet UILabel            *localLabel;
    __weak IBOutlet UILabel            *genderLabel;
    __weak IBOutlet UILabel            *searchGymLabel;
    __weak IBOutlet UILabel            *milesLabel;
    __weak IBOutlet UILabel            *prefsLabel;
    __weak IBOutlet UISwitch           *gymatchSearchSwitch;

    __weak IBOutlet UISegmentedControl *localSegmentedControl;
    __weak IBOutlet UISegmentedControl *genderSegmentedControl;
    __weak IBOutlet UISlider           *milesSlider;

    IBOutlet UIPickerView              *countryPickerView;
    IBOutlet UIPickerView              *statePickerView;

    IBOutlet UIPickerView              *genderPickerView;        // Gourav june 30

    __weak IBOutlet UITextField        *nameTextField;           // Gourav june 26

    __weak IBOutlet UITextField        *spotlightGenderTextField;// Gourav june 30

    __weak IBOutlet UITextField        *countryTextField;
    __weak IBOutlet UITextField        *stateTextField;
    __weak IBOutlet UITextField        *cityTextField;
    __weak IBOutlet UISegmentedControl *distanceSegmentedControl;

    __weak IBOutlet UIButton           *usaButton;
    IBOutlet UIButton                  *doneButton;
    IBOutlet UIButton                  *doneButtonInView;
}

@property(assign) BOOL notHuman;
@property(nonatomic, weak)id <GymFilterDelegate> delegate;

@end
