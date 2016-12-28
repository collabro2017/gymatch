//
//  GTVViewController.h
//  GYMatch
//
//  Created by Ram on 08/04/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTVViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    
    __weak IBOutlet UISegmentedControl *typeSegmentedControl;
    __weak IBOutlet UITableView *gtvTableView;
}

- (void)didSelectedWithIndex:(int)index type:(int)type;

@end
