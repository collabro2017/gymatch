//
//  RegisterViewController.h
//  GYMatch
//
//  Created by Ram on 12/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHTextField.h"
#import "CheckButton.h"
#import <CoreLocation/CoreLocation.h>
#import "ActiveDropDownViewController.h"
#import "AddGymViewController.h"  
#import "LoginViewController.h"

@interface RegisterViewController : UIViewController
<UIPickerViewDataSource, UIPickerViewDelegate,
UITableViewDataSource, UITableViewDelegate, DropDownDelegate, UITextFieldDelegate,
AddGymDelegate, UIAlertViewDelegate>
{

    // Table Cells
    
    IBOutlet UITableViewCell *personalView;
    IBOutlet UITableViewCell *addressView;
    IBOutlet UITableViewCell *referView;
    IBOutlet UITableViewCell *bottomView;
    IBOutlet UITableViewCell *topView;
    
    __weak IBOutlet UIImageView *userImageView;
    // Text Fields
    
    __weak IBOutlet MHTextField *username;
    __weak IBOutlet MHTextField *password;
    __weak IBOutlet MHTextField *email;
    __weak IBOutlet MHTextField *age;
    __weak IBOutlet MHTextField *location;
    __weak IBOutlet MHTextField *city;
    __weak IBOutlet MHTextField *country;
    __weak IBOutlet MHTextField *state;
    __weak IBOutlet MHTextField *gender;
    __weak IBOutlet MHTextField *gymNameTextField;
    __weak IBOutlet MHTextField *gymCategoryField;
    __weak IBOutlet MHTextField *gymCityTextField;
    __weak IBOutlet MHTextField *gymStateTextField;
    __weak IBOutlet MHTextField *refer1TextField;
    
    // Radio Buttons
    
    __weak IBOutlet UIButton *isFromUS;
    
    // Training Preferences
    __weak IBOutlet CheckButton *prefsExpandButton;
    // Status PickerView
    
    IBOutlet UIPickerView *statusPickerView;
    IBOutlet UIPickerView *genderPickerView;
    IBOutlet UIPickerView *countryPickerView;

    IBOutlet UIPickerView *statePickerView; 

    __weak IBOutlet UITextView *privacyTextView;
    __weak IBOutlet UIButton *registerButton;
    __weak IBOutlet UITextView *prefsTextView;
    __weak IBOutlet UILabel *notUSLabel;
    __weak IBOutlet UILabel *lblAsterickForCountry;
    __weak IBOutlet UITableView *mainTableView;
    
}

@property(nonatomic,weak) LoginViewController *lVCont;

@property (assign, nonatomic) BOOL isFromFacebook;
@property (strong, nonatomic) NSString *strfb_UserName;
@property (strong, nonatomic) NSString *strfb_Email;
@property (strong, nonatomic) NSString *strfb_Id;
@property (strong, nonatomic) NSString *strfb_imageURL;
@property (strong, nonatomic) NSString *strfb_Gender;
@property (strong, nonatomic) NSString *reSendUrl;



@end
