//
//  EnlargeViewController.h
//  GYMatch
//
//  Created by iPHTech2 on 09/09/15.
//  Copyright (c) 2015 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnlargeViewController : UIViewController <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *background;

@property (weak, nonatomic) IBOutlet UIImageView *avator;

@property (strong, nonatomic) UIImage *image;

@end
