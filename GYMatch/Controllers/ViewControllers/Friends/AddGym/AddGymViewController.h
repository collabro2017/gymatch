//
//  AddGymViewController.h
//  GYMatch
//
//  Created by Ram Gautam on 11/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHTextField.h"
#import "Gym.h"

@protocol AddGymDelegate <NSObject>

- (void)didAddGym:(Gym *)gym;

@end

@interface AddGymViewController : UIViewController
{
    
    __weak IBOutlet MHTextField *nameLabelTextField;
    __weak IBOutlet MHTextField *addressTextField;
    __weak IBOutlet MHTextField *cityTextFIeld;
    __weak IBOutlet MHTextField *stateTextField;
    __weak IBOutlet MHTextField *phoneTextField;
    __weak IBOutlet MHTextField *URLTextField;
    __weak IBOutlet MHTextField *latitudeTextField;
    __weak IBOutlet MHTextField *longitudeTextField;
    
}

@property(nonatomic, weak)id <AddGymDelegate> delegate;

@end
