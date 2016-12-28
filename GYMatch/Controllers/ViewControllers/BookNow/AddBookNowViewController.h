//
//  AddBookNowViewController.h
//  GYMatch
//
//  Created by osvinuser on 5/31/16.
//  Copyright © 2016 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayPalMobile.h"

@interface AddBookNowViewController : UIViewController <PayPalPaymentDelegate, PayPalFuturePaymentDelegate, PayPalProfileSharingDelegate>

@property (strong, nonatomic) NSDictionary *dict_SessionInfo;

@property (nonatomic) bool isSessionView;

@property (nonatomic, strong) NSString *BodyName;
@property (nonatomic, strong) NSString *WorkoutName;
@property (nonatomic, strong) NSString *SkypeName;

@end
