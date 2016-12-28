//
//  UIBubbleHeaderTableViewCell.m
//  UIBubbleTableViewExample
//
//  Created by Александр Баринов on 10/7/12.
//  Copyright (c) 2012 Stex Group. All rights reserved.
//

#import "UIBubbleHeaderTableViewCell.h"

@interface UIBubbleHeaderTableViewCell ()

@property (nonatomic, retain) UIView *label;

@end

@implementation UIBubbleHeaderTableViewCell

@synthesize label = _label;
@synthesize date = _date;

+ (CGFloat)height
{
    return 0.0f;
}

- (void)setDate:(NSDate *)value
{
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
//    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
//    NSString *text = [dateFormatter stringFromDate:value];
//    
//#if !__has_feature(objc_arc)
//    [dateFormatter release];
//#endif
//    
//    if (self.label)
//    {
//        self.label.text = text;
//        return;
//    }
    
    CGFloat fontSize = 0.0f;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        fontSize = 15.0f;
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.label = [[UIView alloc] initWithFrame:CGRectMake(62, 0, self.frame.size.width-80, 1)];
    [self.label setBackgroundColor:[UIColor colorWithRed:0.85f green:0.85f blue:0.85f alpha:1.0f]];
    [self addSubview:self.label];
}



@end
