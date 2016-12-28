//
//  RateView.h
//  gymatch
//
//  Created by Ram on 19/05/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Spotlight.h"

@protocol RateViewDelegate <NSObject>
-(void) successRating:(float)newRateVal;
@end

@interface RateView : UIView{
    __weak IBOutlet UIView *contentView;
    __weak IBOutlet UILabel *titleText;
    
    
    IBOutletCollection(UIButton) NSArray *starButtons;
    
    NSInteger totalStars;
    
}

@property(retain, nonatomic)Spotlight *spotlight;
@property(copy, nonatomic) void (^success)(NSString* newRate);
@property(nonatomic, weak)id <RateViewDelegate> delegate;

@end
