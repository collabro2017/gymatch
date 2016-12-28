//
//  AddPictureViewController.h
//  GYMatch
//
//  Created by Ram on 31/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHTextField.h"
#import "CheckButton.h"

@interface AddPictureViewController : UIViewController
<UIDocumentInteractionControllerDelegate, IGSessionDelegate, UIAlertViewDelegate>
{
    __weak IBOutlet MHTextField *captionTextField;
    __weak IBOutlet UIImageView *imageView;
    
    __weak IBOutlet UISegmentedControl *visibilitySegmentedConrol;
    
    __weak IBOutlet UILabel *visibilityLabel;
    
    
}

@property (nonatomic, retain) UIImage *image;

@property (nonatomic, retain) UIDocumentInteractionController *dic;

@property (nonatomic, assign) BOOL isFromGymChat;
@property (nonatomic, assign) BOOL isForInstagram;
@property (nonatomic, assign) BOOL isFromGymChatComment;
@end

