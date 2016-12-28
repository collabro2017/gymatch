//
//  PictureViewController.h
//  GYMatch
//
//  Created by Ram on 28/07/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"

@interface PictureViewController : UIViewController<UIActionSheetDelegate>{
    __weak IBOutlet UIImageView *pictureView;
     __weak IBOutlet UISegmentedControl *visibilitySegmentedConrol;
    IBOutlet UIButton *deleteButton, *editButton;
     NSMutableData *webData; 
}

@property(assign) BOOL hideDeleteBtn;
@property(nonatomic, retain)Photo *thePhoto;
//@property(nonatomic, strong)

@end
