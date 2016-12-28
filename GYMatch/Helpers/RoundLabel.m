//
//  RoundLabel.m
//  GYMatch
//
//  Created by Ram on 28/04/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "RoundLabel.h"
#import "Utility.h"

@implementation RoundLabel

- (id)initWithFrame:(CGRect)frame andColor:(UIColor *)color
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self decorate];
        self.backgroundColor = color;
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

- (void)decorate{
    
    self.layer.cornerRadius = self.frame.size.height / 2.0f;
    self.backgroundColor = DEFAULT_BG_COLOR;
    
    CGFloat size;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        size = 16.0f;
    }else{
        size = 11.0f;
    }
    self.font = [UIFont italicSystemFontOfSize:size];
    self.textColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    
}

- (void)awakeFromNib{
    [self decorate];
}

@end
