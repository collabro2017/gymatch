//
//  ReportViewController.h
//  GYMatch
//
//  Created by Ram Gautam on 11/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportViewController : UIViewController
<UIPickerViewDataSource, UIPickerViewDelegate>
{
    
    __weak IBOutlet UIPickerView *pickerView;
    __weak IBOutlet UILabel *titleLabel;
    
}

@property(nonatomic, assign)NSInteger userID;

@end
