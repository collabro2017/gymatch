//
//  EditProfileViewController.h
//  GYMatch
//
//  Created by Ram on 12/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHTextField.h"
#import "CheckButton.h"
#import "ActiveDropDownViewController.h" 
#import "FriendDetailsViewController.h"
#import "AddGymViewController.h"
#import <MessageUI/MessageUI.h>
#import "User.h"

@interface EditProfileViewController : UIViewController
<UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate,
UITableViewDataSource, UITableViewDelegate, DropDownDelegate, UITextFieldDelegate,
UIAlertViewDelegate, AddGymDelegate, MFMailComposeViewControllerDelegate, UITextViewDelegate>
{
    
    __weak IBOutlet UIImageView *userImageView;
    // Text Fields
    
    IBOutlet UITableViewCell *personalView;
    IBOutlet UITableViewCell *addressView;
    IBOutlet UITableViewCell *referView;
    IBOutlet UIView *checkInView;
    IBOutlet UITableViewCell *notificationView;
    IBOutlet UITableViewCell *aboutView;
    IBOutlet UIView *bottomView;
    IBOutlet UIView *topView;

    __weak IBOutlet UIButton *passwordBtn;
    
    __weak IBOutlet UIImageView *bgImageView;
    
    __weak IBOutlet UISwitch *pnSwitch;
    
    __weak IBOutlet MHTextField *username;
    __weak IBOutlet MHTextField *firstName;
    __weak IBOutlet MHTextField *lastName;
    __weak IBOutlet MHTextField *password;
    __weak IBOutlet MHTextField *email;
    __weak IBOutlet MHTextField *age;
    __weak IBOutlet MHTextField *gender;
    __weak IBOutlet MHTextField *city;
    __weak IBOutlet MHTextField *country;
    __weak IBOutlet MHTextField *state;
    __weak IBOutlet MHTextField *gymCityTextField;
    __weak IBOutlet MHTextField *gymStateTextField;
    __weak IBOutlet MHTextField *gymTypeTextField;
    __weak IBOutlet MHTextField *gymNameTextField;
    __weak IBOutlet MHTextField *refer1TextField;
    __weak IBOutlet MHTextField *statusDetailTextField;
    
    __weak IBOutlet UITextView *aboutMeTextView;
//    __weak IBOutlet CheckButton *agreeCheckButton;
    
    __weak IBOutlet RoundButton *roundbtnPassword;
    __weak IBOutlet UIButton *isFromUS;
    
    // Status PickerView
    
    IBOutlet UIPickerView *statusPickerView;
    IBOutlet UIPickerView *genderPickerView;
    IBOutlet UIPickerView *countryPickerView;
    
    
    IBOutlet UIPickerView *statePickerView; // Gourav june 12

    
    __weak IBOutlet RoundButton *passwordStar;
    
    IBOutlet UIToolbar *accessoryKBToolbar;
    
    __weak IBOutlet CheckButton *prefsExpandButton;
    
    __weak IBOutlet UITextView *prefsTextView;
    __weak IBOutlet UILabel *bgImageLabel;
    __weak IBOutlet UILabel *notificationLabel;
    __weak IBOutlet NSLayoutConstraint *bgImageHeight;
    
    __weak IBOutlet UIButton *deactivateButton;
     __weak IBOutlet UIButton *addNewGymButton;

    __weak IBOutlet UIView *reactivateView;
    __weak IBOutlet UILabel *lblAboutMeLimit;
    __weak IBOutlet UILabel *lblTaglineLimit;
}


@property(nonatomic, retain) FriendDetailsViewController *friendDetailCont;
@property(nonatomic, retain) Friend *user;

-(void)addReactivateView;

@property (assign, nonatomic) BOOL isFromFacebook;
@property (strong, nonatomic) NSString *strfb_UserName;
@property (strong, nonatomic) NSString *strfb_Email;
@property (strong, nonatomic) NSString *strfb_Id;
@property (strong, nonatomic) NSString *strfb_imageURL;
@property (strong, nonatomic) NSString *strfb_Gender;


@end
