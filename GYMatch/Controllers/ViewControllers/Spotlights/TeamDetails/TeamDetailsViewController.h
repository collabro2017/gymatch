//
//  TeamDetailsViewController.h
//  GYMatch
//
//  Created by Ram on 25/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Team.h"

@interface TeamDetailsViewController : UIViewController
{
    __weak IBOutlet UILabel *nameLabel;
    __weak IBOutlet UIImageView *imageView;
    __weak IBOutlet UILabel *designation;
    __weak IBOutlet UITextView *description;
    
}

@property(nonatomic, retain)Team *aTeam;

@end
