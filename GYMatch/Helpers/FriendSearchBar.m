//
//  FriendSearchBar.m
//  GYMatch
//
//  Created by Ram on 26/04/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "FriendSearchBar.h"
#import "Utility.h"

@implementation FriendSearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib{
    
//    [self setScopeBarButtonBackgroundImage:[UIImage imageNamed:@"select_arrow"] forState:UIControlStateNormal];
    
    [super awakeFromNib];
    
    if ([[[UIDevice currentDevice] systemVersion]integerValue] >= 7) {
    
        UISegmentedControl *segControl = [[[[[self.subviews objectAtIndex:0] subviews] objectAtIndex:0] subviews] objectAtIndex:1];
        
        [self setScopeBarButtonBackgroundImage:[Utility imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [self setScopeBarButtonBackgroundImage:[Utility imageWithColor:[UIColor clearColor]] forState:UIControlStateHighlighted];
        
        [self setScopeBarButtonBackgroundImage:[[UIImage imageNamed:@"select_arrow2"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch] forState:UIControlStateSelected];
        
        [segControl setFrame:CGRectMake(0, 0, 320.0f, 44.0f)];
        
    }
    
//    [self setScopeBarButtonTitleTextAttributes:@{UITextAttributeFont: [UIFont fontWithName:@"ProximaNova-Semibold" size:16.0f]} forState:UIControlStateNormal];

//    [segControl setBackgroundColor:[UIColor redColor]];
    
}

@end
