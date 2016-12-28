//
//  TrainerDetailsViewController.h
//  GYMatch
//
//  Created by Ram on 24/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Spotlight.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface TrainerDetailsViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>
{
    
    __weak IBOutlet UIImageView *imageView;
    __weak IBOutlet UILabel *nameLabel;
    __weak IBOutlet UILabel *genderLabel;
    __weak IBOutlet UILabel *locationLabel;
    __weak IBOutlet UILabel *gymLabel;
    __weak IBOutlet UIImageView *starImageView;
    __weak IBOutlet UILabel *preferencesLabel;
    __weak IBOutlet UILabel *bioLabel;
    __weak IBOutlet UILabel *educationLabel;
    
    IBOutletCollection(UILabel) NSArray *dayTimeLabels;
    
    __weak IBOutlet UITableView *personalTrainingTableView;
    __weak IBOutlet UILabel *hobbiesLabel;
    
    // Auto Layout Constraints
    
    __weak IBOutlet NSLayoutConstraint *gymHeight;
    __weak IBOutlet NSLayoutConstraint *preferenceHeight;
    __weak IBOutlet NSLayoutConstraint *personalTrainingHeight;
    __weak IBOutlet NSLayoutConstraint *educationHeight;
    __weak IBOutlet NSLayoutConstraint *hobbiesHeight;
}

@property(nonatomic, retain)Spotlight *aSpotlight;

- (id)initWithSpotlight:(Spotlight *)spotlight;

@end
