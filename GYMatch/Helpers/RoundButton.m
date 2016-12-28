//
//  RoundButton.m
//  GYMatch
//
//  Created by Ram on 25/04/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "RoundButton.h"

@implementation RoundButton

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

- (void)awakeFromNib{
    
    [self decorate];
}

- (void)decorate{
    self.layer.cornerRadius = 3.0f;
    
    self.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:self.titleLabel.font.pointSize];
    self.titleEdgeInsets = UIEdgeInsetsMake(3, 0, 0, 0);
}

@end
