//
//  calenderVC.h
//  GYMatch
//
//  Created by osvinuser on 24/05/16.
//  Copyright © 2016 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSCalendar.h"
#import "Spotlight.h"
#import "Utility.h"

@class TopNavigationController;

@interface MyCalendar : UIViewController

@property (weak, nonatomic) IBOutlet FSCalendar *calendar;
@property (nonatomic, strong) Spotlight *aSpotlight;
@property (nonatomic, retain) TopNavigationController *topNavigationController;

@end
