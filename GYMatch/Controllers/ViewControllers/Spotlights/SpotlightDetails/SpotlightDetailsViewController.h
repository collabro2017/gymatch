//
//  SpotlightDetailsViewController.h
//  GYMatch
//
//  Created by Ram on 24/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Spotlight.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "AvatorViewController.h"
#import "RoundButton.h"

@interface SpotlightDetailsViewController : UIViewController
<MFMailComposeViewControllerDelegate, UITableViewDataSource,
UITableViewDelegate, UIGestureRecognizerDelegate,
UIAlertViewDelegate>
{
    
    __weak IBOutlet UIImageView *profileImageView;
    __weak IBOutlet UILabel *nameLabel;
    __weak IBOutlet UILabel *genderLabel;
    __weak IBOutlet UILabel *locationLabel;
    __weak IBOutlet UILabel *gymLabel;
    __weak IBOutlet UILabel *preferencesLabel;
    __weak IBOutlet UIImageView *bgImgeView;
    
    __weak IBOutlet UIImageView *dumbleImageView;
    __weak IBOutlet UIImageView *locationImageView;
    
    IBOutlet UITableViewCell *headerCell;
    IBOutlet UITableViewCell *linksCell;
    IBOutlet UITableViewCell *prefsCell;
    
    __weak IBOutlet UIView *prefsView;
    IBOutlet UIView *sessionHeaderView;
    IBOutlet UIView *halfSessionHeaderView;
    
//    __weak IBOutlet UIImageView *barCodeImageView;
    __weak IBOutlet NSLayoutConstraint *locatoinTop;
    __weak IBOutlet NSLayoutConstraint *bgImageHeight;
    __weak IBOutlet NSLayoutConstraint *profielImageHeight;
    
    IBOutletCollection(UIImageView) NSArray *starImageViews;
    
    IBOutlet UIButton *personalHourExpandButton;
    IBOutlet UIButton *personalHalfHourExpandButton;
    
    IBOutlet RoundButton *rateBtn;
    
   // __weak IBOutlet UI
    
   IBOutlet UITableView *tableView_Main;
   IBOutlet NSLayoutConstraint *tableViewFooterLayoutConstraint;
   IBOutlet UIView *view_BookingButtonView;
   IBOutlet UIButton *button_BookNow;
    
}

@property (nonatomic, strong) AvatorViewController *pictureView;
@property(nonatomic, strong)Spotlight *aSpotlight;


@property (nonatomic, assign) BOOL showBookButton;
@property (nonatomic, strong) NSString *selectedType;

- (id)initWithSpotlight:(Spotlight *)spotlight;

@end
