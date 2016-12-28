//
//  GymDetailsViewController.h
//  GYMatch
//
//  Created by Ram on 25/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Spotlight.h"

#import <MessageUI/MFMailComposeViewController.h>

@interface GymDetailsViewController : UIViewController
<UICollectionViewDataSource, UICollectionViewDelegate, MFMailComposeViewControllerDelegate>
{
    __weak IBOutlet UILabel *gymNameLabel;
    __weak IBOutlet UILabel *gymLocationLabel;
    __weak IBOutlet UIImageView *gymImageView;
    __weak IBOutlet UIImageView *barCodeImageView;
    __weak IBOutlet UIImageView *rateImageView;
    
    __weak IBOutlet UILabel *bioLabel;
    __weak IBOutlet UIImageView *complementaryImaegView;
    
    IBOutletCollection(UILabel) NSArray *dayTimeLabels;
    __weak IBOutlet UILabel *locationsLabel;
    __weak IBOutlet UILabel *featuresLabel;
    __weak IBOutlet UICollectionView *trainersCollectionView;
    __weak IBOutlet UIImageView *membershipImageView;
    
    // Auto Layout Constraints
    
    __weak IBOutlet NSLayoutConstraint *bioHeight;
    __weak IBOutlet NSLayoutConstraint *clubLocationHeight;
    __weak IBOutlet NSLayoutConstraint *clubFeatureHeight;
}

@property(nonatomic, retain)Spotlight *aSpotlight;

- (id)initWithSpotlight:(Spotlight *)spotlight;

@end