//
//  RoundTextField.m
//  GYMatch
//
//  Created by Ram on 25/04/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "RoundTextField.h"

@implementation RoundTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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
    self.layer.cornerRadius = 3.0f;
}

@end
