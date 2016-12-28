//
//  TeamViewController.h
//  GYMatch
//
//  Created by Ram on 08/05/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "AvatorViewController.h"


@interface TeamViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>

@property(nonatomic, retain)NSArray *members;
@property(nonatomic, retain)NSString *email;

@property (nonatomic, strong) AvatorViewController *pictureView;

@end
