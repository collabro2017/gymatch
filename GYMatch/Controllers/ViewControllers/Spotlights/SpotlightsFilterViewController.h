//
//  SpotlightsFilterViewController.h
//  GYMatch
//
//  Created by victor on 4/7/15.
//  Copyright (c) 2015 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHTextField.h"
#import "RoundButton.h"

@protocol SpotLightFilterDelegate <NSObject>

- (void)doneWithDictionary:(NSMutableDictionary *)dictionary;

@end


@interface SpotlightsFilterViewController : UIViewController {
    
}

@property(nonatomic, weak)id <SpotLightFilterDelegate> delegate;


@property (weak, nonatomic) IBOutlet MHTextField *txtCountry;
@property (weak, nonatomic) IBOutlet MHTextField *txtGender;
@property (weak, nonatomic) IBOutlet MHTextField *txtState;
@property (weak, nonatomic) IBOutlet MHTextField *txtCity;
@property (weak, nonatomic) IBOutlet MHTextField *txtName;


@property (strong, nonatomic) IBOutlet UIPickerView *pickerGender;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerCountry;

@property (strong, nonatomic) IBOutlet RoundButton *buttonDone;

- (IBAction)btnDonePressed:(id)sender;

@end
