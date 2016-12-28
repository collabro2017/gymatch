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

enum {
    Training_Seesion_Begin_Time,
    Training_Seesion_End_Time,
    Multiple_Training_Seesion_Begin_Time,
    Multiple_Training_Seesion_End_Time,
    Training_Session_Period,
};

@interface calenderVC : UIViewController

@property (weak, nonatomic) IBOutlet FSCalendar *calendar;

// @property (strong, nonatomic) NSString *string

@property (strong, nonatomic) NSMutableArray *array_Timer;

@property (nonatomic, strong) Spotlight *aSpotlight;

@property (nonatomic, strong) NSString *selectedType;

- (void)setSessionTime:(int)type :(NSString*)time;
- (void)setMultipleSessionDate:(NSMutableArray*)array;
- (void)showMultipleSessionStartTime;
- (void)showMultipleSessionEndTime;
- (void)updateMultipleSessionDate;

@end
