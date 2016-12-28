//
//  PasswordViewController.h
//  GYMatch
//
//  Created by Ram on 06/05/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasswordViewController : UIViewController{
    __weak IBOutlet UITextField *currentPasswordTF;
    __weak IBOutlet UITextField *newPasswordTF;
    __weak IBOutlet UITextField *confirmPasswordTF;
    __weak IBOutlet UIButton *doneButton;
    __weak IBOutlet NSLayoutConstraint *topConstraints;

    NSString *newPasswordStr;
}

@end
