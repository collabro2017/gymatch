//
//  CheckButton.m
//  GYMatch
//
//  Created by Ram Gautam on 10/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "CheckButton.h"

@implementation CheckButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"right_sign"] forState:UIControlStateSelected];
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

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [super touchesEnded:touches withEvent:event];
    
    self.selected = !self.selected;
}

@end
