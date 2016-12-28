//
//  GTVCell.h
//  GYMatch
//
//  Created by Ram on 28/04/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTV.h"
#import "GTVViewController.h"

#define kGTVCell @"GTVCell"
#define kGTVCell_iPad @"GTVCell_iPad"

@interface GTVCell : UITableViewCell
{
   // GTV *myGtv;
    __weak IBOutlet UILabel *GTVTitleLabel;
    __weak IBOutlet UIImageView *iconImageView;
    __weak IBOutlet UIButton *button;
    __weak IBOutlet UIView *containView;
    __weak IBOutlet UIImageView *borderView;
    __weak IBOutlet UILabel *likeLabel;
    __weak IBOutlet UILabel *gshareLabel;
    __weak IBOutlet UILabel *descriptionLbl;
    GTVViewController *parentView;
    int index;
    
}

- (void)fillWithGTV:(GTV *)gtv parent:(GTVViewController *)parent index:(int)index_num;

@end
