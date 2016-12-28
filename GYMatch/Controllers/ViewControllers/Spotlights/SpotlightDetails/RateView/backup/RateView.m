//
//  RateView.m
//  gymatch
//
//  Created by Ram on 19/05/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "RateView.h"
#import "MBProgressHUD.h"
#import "SpotlightDataController.h"

@implementation RateView

- (id)initWithFrame:(CGRect)frame
{
//    self = [super initWithFrame:frame];
    
    RateView *view = [[[NSBundle mainBundle] loadNibNamed:@"RateView" owner:nil options:nil] objectAtIndex:0];
    self = view;
    self.frame = frame;
    if (self) {
        // Initialization code
        
        contentView.layer.cornerRadius = 10.0f;
        
        [self attachPopUpAnimation];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) attachPopUpAnimation
{
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation
                                      animationWithKeyPath:@"transform"];
    
    CATransform3D scale1 = CATransform3DMakeScale(1.3, 1.3, 1);
    CATransform3D scale2 = CATransform3DMakeScale(1.1, 1.1, 1);
    CATransform3D scale3 = CATransform3DMakeScale(1.0, 1.0, 1);
    CATransform3D scale4 = CATransform3DMakeScale(1.0, 1.0, 1);
    
    NSArray *frameValues = [NSArray arrayWithObjects:
                            [NSValue valueWithCATransform3D:scale1],
                            [NSValue valueWithCATransform3D:scale2],
                            [NSValue valueWithCATransform3D:scale3],
                            [NSValue valueWithCATransform3D:scale4],
                            nil];
    [animation setValues:frameValues];
    
    NSArray *frameTimes = [NSArray arrayWithObjects:
                           [NSNumber numberWithFloat:0.0],
                           [NSNumber numberWithFloat:0.5],
                           [NSNumber numberWithFloat:0.9],
                           [NSNumber numberWithFloat:1.0],
                           nil];
    
    [animation setKeyTimes:frameTimes];
    
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = .2;
    
    [self.layer addAnimation:animation forKey:@"popup"];
    
    self.alpha = 0.0f;
    [UIView animateWithDuration:0.2f animations:^{
        self.alpha = 1.0f;
    }];
    
}

- (void)setSpotlight:(Spotlight *)spotlight{
    _spotlight = spotlight;
    titleText.text = [NSString stringWithFormat:@"How many stars for %@", spotlight.name];
    
}

- (void)hide{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
}

#pragma mark - IBActions

- (IBAction)cancelButtonPressed:(id)sender{
    
    [self hide];
    
}

- (IBAction)starButtonPressed:(UIButton *)sender{
    
    totalStars = sender.tag;
    
//    sender.selected = YES;return;
    
    for (int tag = 0; tag < 5; tag++) {
        UIButton *btn = starButtons[tag];
        if (tag < totalStars) {

            [btn setSelected:YES];
            [btn setImage:[UIImage imageNamed:@"rating"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"rating"] forState:UIControlStateSelected];
            [btn setContentMode:UIViewContentModeScaleAspectFit];
            
        }else{
            
            [btn setSelected:NO];
            [btn setImage:[UIImage imageNamed:@"gray_rating"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"gray_rating"] forState:UIControlStateSelected];
            [btn setContentMode:UIViewContentModeScaleAspectFit];
        }
        
    }
    
}

- (IBAction)rateButtonPressed:(id)sender{
    
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    SpotlightDataController *sDC = [[SpotlightDataController alloc] init];
    
    [sDC rateSpotlight:_spotlight.ID withStar:totalStars withSuccess:^(NSString *rateV){
        
        [MBProgressHUD hideAllHUDsForView:self animated:YES];
        
        //self.spotlight.rate = (self.spotlight.rate == 0)? totalStars :(self.spotlight.rate + totalStars)/2.0f;
      //  self.spotlight.rate = totalStars;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Thank You For The Rate!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
        
        self.success(rateV);
        [self hide];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self animated:YES];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
        
        [self hide];
        
    }];
    
}

@end
