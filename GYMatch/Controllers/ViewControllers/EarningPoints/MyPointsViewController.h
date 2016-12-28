//
//  MyPointsViewController.h
//  GYMatch
//
//  Created by Netdroid-Apple on 12/10/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPointsViewController : UIViewController
{
    IBOutlet UILabel *total_Lbl;
    IBOutlet UILabel *creditLeft_Lbl;
    IBOutlet UIButton *redeemButton;
    IBOutlet UILabel *oReferralsPoints;
}

@property(retain,nonatomic)NSString *points;
@property(retain,nonatomic)NSString *oRefferalPointsStr;
@property(assign,nonatomic)BOOL isSelfUser;

-(IBAction)redeemBtnClicked:(id)sender;

@end
