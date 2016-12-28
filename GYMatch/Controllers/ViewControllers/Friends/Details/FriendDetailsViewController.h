//
//  FriendDetailsViewController.h
//  GYMatch
//
//  Created by Ram Gautam on 11/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoundButton.h"
#import "RoundLabel.h"
#import "AvatorViewController.h"

@class Friend;

@protocol ADCircularMenuDelegate<NSObject>

@optional

//callback provides button index
- (void)circularMenuClickedButtonAtIndex:(int) buttonIndex;

@end

@interface FriendDetailsViewController : UIViewController
<UIActionSheetDelegate, UIAlertViewDelegate, ADCircularMenuDelegate, UIGestureRecognizerDelegate>
{
    __weak IBOutlet UIView *innerView; 
    
    __weak IBOutlet UIImageView *imageView;
    __weak IBOutlet UILabel *nameLabel;
    __weak IBOutlet UIImageView *onlineImageView;
    __weak IBOutlet UIImageView *locationImageView;
    __weak IBOutlet UIImageView *bgImageView;
    __weak IBOutlet UILabel *genderLabel;
    __weak IBOutlet UILabel *statusLabel;
    __weak IBOutlet UILabel *cityLabel;
    __weak IBOutlet UILabel *descriptionLabel;
    __weak IBOutlet UILabel *aboutMeLabel;
    __weak IBOutlet UILabel *aboutLabel;
    __weak IBOutlet UILabel *prefsLabel;
    __weak IBOutlet UILabel *myGymLabel;
    
    __weak IBOutlet RoundButton *addButton;
    __weak IBOutlet RoundButton *editButton;
    __weak IBOutlet RoundButton *menuButton;
    __weak IBOutlet UIButton *pointsButton;
    __weak IBOutlet UIButton *friendsButton;
    __weak IBOutlet UIButton *picturesButton;
    __weak IBOutlet UIView *prefsView;
    
    __weak IBOutlet NSLayoutConstraint *aboutHeight;
    __weak IBOutlet NSLayoutConstraint *prefsHeight;
    __weak IBOutlet NSLayoutConstraint *checkInHeight;
    __weak IBOutlet NSLayoutConstraint *gymHeight;
    __weak IBOutlet NSLayoutConstraint *bgImageHeight;
    __weak IBOutlet NSLayoutConstraint *profileImageHeight;
    __weak IBOutlet NSLayoutConstraint *profileImageTop;
    __weak IBOutlet NSLayoutConstraint *nameTop;
    __weak IBOutlet NSLayoutConstraint *statusHeight;
    __weak IBOutlet NSLayoutConstraint *statusTop;
    __weak IBOutlet NSLayoutConstraint *statusBottom;
    
    __weak IBOutlet NSLayoutConstraint *genderTop;
    __weak IBOutlet NSLayoutConstraint *aboutTop;
    __weak IBOutlet NSLayoutConstraint *trainPrefsTop;
    __weak IBOutlet NSLayoutConstraint *myGymTop;
    __weak IBOutlet NSLayoutConstraint *checkInTop;
    
    __weak IBOutlet NSLayoutConstraint *viewWidth;
    __weak IBOutlet NSLayoutConstraint *viewHeight;//Lekha
    __weak IBOutlet UIScrollView *scrollView;
    
    __weak IBOutlet UIButton *locationButton;
    
    __weak IBOutlet UIButton *Spotlight_Detail_Btn;
    __weak IBOutlet UIButton *chatBtn;
    
    IBOutlet UIButton *avatorButton;
    IBOutlet UIView *bottomView;

    UIImage *profileImage; 
    
    // Gourav june 30 start
    IBOutlet UIView *fitBoardBottomView;
    
    IBOutlet UIButton *fitBoardBtn;
    IBOutlet UIButton *gNotesBtn;
    
    // Gourac june 30 end
    
    float _fButtonSize;
    float _fInnerRadius;
    BOOL flag;
    int  clicked;
    
    NSUInteger _iNumberOfButtons;
    NSMutableArray *_arrButtons;
    NSArray *_arrButtonImageName;
    UIButton *_buttonCorner;
    NSString *_strCornerButtonImageName;
    
    UIGestureRecognizer *_gestureRecognizerTap;
}

- (IBAction)OnlineIndicatorClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *indicatorBtn;



@property (weak, nonatomic) IBOutlet RoundButton *btnGym;
@property (strong, nonatomic) AvatorViewController *pictureView;
@property(nonatomic) id <ADCircularMenuDelegate> delegateCircularMenu;

@property(nonatomic, retain)Friend *aFriend;
- (IBAction)Spotlight_Tapped:(id)sender;
- (IBAction)avatar_Tapped:(id)sender;
-(void)show;


- (void)loadData; 
// Gourav june 30 start

- (IBAction)gNotesBtnClicked:(id)sender;
- (IBAction)fitBoardBtnClicked:(id)sender;


// Gourac june 30 end


//Private Methods
-(void)setupData;
-(void)setupUI;
-(void)setTapGesture;
-(void)setupButtons;

-(void)showButtons;
-(void)setButtonFrames;

- (void)removeViewWithAnimation;
//IBActions
- (IBAction)hideMenu:(id)sender;

- (IBAction)imageClicked:(id)sender;


@end
