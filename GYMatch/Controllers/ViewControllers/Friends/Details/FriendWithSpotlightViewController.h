//
//  FriendWithSpotlightViewController.h
//  GYMatch
//
//  Created by Netdroid-Apple on 12/8/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Spotlight.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface FriendWithSpotlightViewController : UIViewController<MFMailComposeViewControllerDelegate, UITableViewDataSource,
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

}

@property(nonatomic, strong)Spotlight *aSpotlight;
@property(assign,nonatomic) NSInteger Member_id;
- (id)initWithSpotlight:(Spotlight *)spotlight;

@end
