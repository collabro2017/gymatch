//
//  TrainingSeesionTimeViewController.h
//  GYMatch
//
//  Created by Ram Gautam on 10/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>

@class calenderVC;

@interface TrainingSeesionTimeViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, retain) calenderVC *delegate;

- (void)setType:(int)type;

@end
