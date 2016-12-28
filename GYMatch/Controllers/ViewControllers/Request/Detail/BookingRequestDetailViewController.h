//
//  BookingRequestDetailViewController.h
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

@interface BookingRequestDetailViewController : UIViewController
<UIActionSheetDelegate, UIAlertViewDelegate, ADCircularMenuDelegate, UIGestureRecognizerDelegate>
{
    __weak IBOutlet UIImageView *bgImageView;
    __weak IBOutlet UIImageView *locationImageView;
    __weak IBOutlet UIImageView *imageView;
    __weak IBOutlet UILabel *nameLabel;
    __weak IBOutlet UILabel *genderLabel;
    __weak IBOutlet UILabel *cityLabel;
    __weak IBOutlet UIButton *locationButton;

    __weak IBOutlet UILabel *lblWorkoutTypeTitle;
    IBOutlet UIButton *avatorButton;
    

    __weak IBOutlet UIScrollView *scrollView;

    UIImage *profileImage; 

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


@property (strong, nonatomic) IBOutlet UIButton *indicatorBtn;
@property (strong, nonatomic) AvatorViewController *pictureView;
@property(nonatomic) id <ADCircularMenuDelegate> delegateCircularMenu;

@property(nonatomic, retain) NSDictionary *dictionary;
@property(nonatomic, retain) Friend *aFriend;

- (void)loadData; 

@end
