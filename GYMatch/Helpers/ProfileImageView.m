//
//  ProfileImageView.m
//  GYMatch
//
//  Created by Ram on 25/04/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "ProfileImageView.h"
#import "TGRImageViewController.h"
#import "TGRImageZoomAnimationController.h"

@implementation ProfileImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self decorate];
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

-(void)setImage:(UIImage *)image
{
    if (self.image == nil)
    {
        [super setImage:image];
        return;
    }

  //  if(self.tag == 6576)
   // {
        if(![self.image isEqual:image])
        {
            if(![image isEqual:[UIImage imageNamed:@"user_plus"]])
                [super setImage:image];
        }
  //  }
  //  else
   //     [super setImage:image];
}

- (id)initWithImage:(UIImage *)image{
    self = [super initWithImage:image];
    if (self != nil) {
        
        [self decorate];
    }
    return self;
}

- (void)awakeFromNib{
    [self decorate];
}

- (void)decorate{
    
    self.layer.cornerRadius = self.frame.size.width / 2.0f;
//    self.layer.borderWidth = 1.0f;
    //    self.layer.borderColor = [[UIColor colorWithRed:204.0/255.0f green:204.0f/255.0f blue:205.0f/255.0f alpha:1.0f] CGColor];
//    self.layer.borderColor = [[UIColor whiteColor] CGColor];
    //self.userInteractionEnabled = YES;
    //UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClicked:)];
    //[self addGestureRecognizer:gesture];
}


@end
