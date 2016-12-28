//
//  SpotCell.m
//  GYMatch
//
//  Created by Ram Gautam on 11/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "SpotCell.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "Utility.h"
#import "MBProgressHUD.h"
#import "SpotlightDataController.h"

@implementation SpotCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)awakeFromNib{
    
    CGFloat size = 16.0f;
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        size = 20.0f;
    }
    
    self.nameLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:size];
}

- (void)fillWithSpotlight:(Spotlight *)aSpotlight{
    
    self.nameLabel.text = aSpotlight.name;
    self.genderLabel.text = [NSString stringWithFormat:@"%@, %ld",
                             aSpotlight.gender,
                             (long)aSpotlight.age];
    
    self.locationLabel.text = aSpotlight.address;
    self.onlineImageView.hidden = YES;
    NSString *imgPath = aSpotlight.image;
    imgPath = [imgPath stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    if(![imgPath hasPrefix:@"http:/"])
        imgPath = [@"http://www.gymatch.com/app/webroot/uploads/spotlight/" stringByAppendingString:imgPath];

    NSURL *imageURL = [NSURL URLWithString:[imgPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

    [self.picImageView setImageWithURL:imageURL placeholderImage:[Utility placeHolderImage] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
      for (int i = 0, j = 0; i < 5; i++, j++) {
        if (aSpotlight.rate > i) {
            [starImageViews[j] setHidden:NO];
        }else{
           
            [starImageViews[j] setImage:[UIImage imageNamed:@"gray_rating"]];
            NSLog(@" spotlight rate : %f ,  i : %d , j: %d", aSpotlight.rate , i , j);
        }
    }

    CGFloat plusFactor1 = 0;
    CGFloat plusFactor2 = 0;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        plusFactor1 = 60;
        plusFactor2 = 80;
    }
    
    if ([aSpotlight.type isEqualToString:SPOTLIGHT_TYPE_MOGUL] || [aSpotlight.type isEqualToString:SPOTLIGHT_TYPE_GYMSTAR]) {
        self.genderLabel.hidden = YES;
        CGRect frame = self.locationLabel.frame;
        frame.origin.x = 92.0f + plusFactor1;
        self.locationLabel.frame = frame;
        
        frame = self.locationIconImageView.frame;
        frame.origin.x = 80.0f + plusFactor1;
        self.locationIconImageView.frame = frame;
    }
    else{
        self.genderLabel.hidden = NO;
        CGRect frame = self.locationLabel.frame;
        frame.origin.x = 161.0f + plusFactor2;
        self.locationLabel.frame = frame;
        
        frame = self.locationIconImageView.frame;
        frame.origin.x = 149.0f + plusFactor2;
        self.locationIconImageView.frame = frame;
    }
    
    self.locationIconImageView.image = [self.locationIconImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.locationIconImageView setTintColor:DEFAULT_BG_COLOR];


}

- (IBAction)likeButtonPressed:(UIButton *)sender{
    
    [MBProgressHUD showHUDAddedTo:self.superview.superview animated:YES];
    SpotlightDataController *sDC = [SpotlightDataController new];
    
    [sDC likeSpotlight:sender.tag withLike:!isLiked withSuccess:^{
        
        NSInteger likes = [sender.titleLabel.text integerValue];
        likes = (isLiked) ? --likes : ++likes;
        if (likes < 0) {
            likes = 0;
        }
        [sender setTitle:[NSString stringWithFormat:@"%ld", (long)likes] forState:UIControlStateNormal];
        isLiked = !isLiked;
        
        [MBProgressHUD hideAllHUDsForView:self.superview.superview animated:YES];
        
    } failure:^(NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
        [MBProgressHUD hideAllHUDsForView:self.superview.superview animated:YES];
        
    }];
    
}
@end
