//
//  UIImagePickerHelper.m
//  GYMatch
//
//  Created by Ram on 18/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "UIImagePickerHelper.h"
#import "UIImageCropper.h"
#import "EditProfileViewController.h"
#import "RegisterViewController.h"
#import "GymChatViewController.h"

@implementation UIImagePickerHelper{
    UIView *presentingView;
    void (^successBlock)(UIImage *);
    UIImagePickerController *sharePicker;
}
@synthesize myAppdelegate;


- (void)imagePickerInView:(UIView *)view
              WithSuccess:(void (^)(UIImage *image))success
                  failure:(void (^)(NSError *error))failure{
    presentingView = view;
    successBlock   = success;
    [self showActionSheetinView:view];
}

- (void)showActionSheetinView:(UIView *)view{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose a photo from:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Photo Library", nil];
    
    [actionSheet showInView:view];
}

#pragma mark - UIActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UIImagePickerControllerSourceType sourceType;

    switch (buttonIndex) {
        case 0:
            sourceType = UIImagePickerControllerSourceTypeCamera;
            break;

        case 1:

            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;

        default:
          //  if([myAppdelegate isKindOfClass:[GymChatViewController class]])
          //      [(GymChatViewController*)myAppdelegate enableGymChatAgain];
            return;
            break;
    }


    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        return;
    }

    UIImagePickerController *imagePC = [[UIImagePickerController alloc]init];
    [imagePC setSourceType:sourceType];
    [imagePC setDelegate:self];

    // Navigation bar customization
    //    [imagePC.navigationBar setBackgroundImage:[UIImage imageNamed:@"title_iphone"] forBarMetrics:UIBarMetricsDefault];
    [imagePC.navigationBar setTintColor:[UIColor whiteColor]];
    [imagePC.navigationBar setBarTintColor:[UIColor blackColor]];
    [imagePC.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];

    if ([APP_DELEGATE tabBarController]) {
        [[[APP_DELEGATE tabBarController] viewControllers][[APP_DELEGATE tabBarController].selectedIndex] presentViewController:imagePC animated:YES completion:^{

            [imagePC.navigationBar setTintColor:[UIColor whiteColor]];

        }];

    }else if ([APP_DELEGATE navigationController]) {
        [[[APP_DELEGATE navigationController] topViewController] presentViewController:imagePC animated:YES completion:^{
            [imagePC.navigationBar setTintColor:[UIColor whiteColor]];
        }];
    }

}

/*
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    UIImagePickerControllerSourceType sourceType;
    
    switch (buttonIndex) {
        case 0:
            sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
        
        case 1:
            
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
            
        default:
            if([myAppdelegate isKindOfClass:[GymChatViewController class]])
                [(GymChatViewController*)myAppdelegate enableGymChatAgain];
            return;
            break;
    }
    
    
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        return;
    }
    
    UIImagePickerController *imagePC = [[UIImagePickerController alloc]init];
    [imagePC setSourceType:sourceType];
    [imagePC setDelegate:self];
    
    // Navigation bar customization
//    [imagePC.navigationBar setBackgroundImage:[UIImage imageNamed:@"title_iphone"] forBarMetrics:UIBarMetricsDefault];
    [imagePC.navigationBar setTintColor:[UIColor whiteColor]];
    [imagePC.navigationBar setBarTintColor:[UIColor blackColor]];
    [imagePC.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    [self performSelector:@selector(presentPickerView:) withObject:imagePC afterDelay:0.1];
}


-(void)presentPickerView:(UIImagePickerController*)picker
{
    if ([APP_DELEGATE tabBarController]) {
        [[[APP_DELEGATE tabBarController] viewControllers][[APP_DELEGATE tabBarController].selectedIndex] presentViewController:picker animated:YES completion:^{

            [picker.navigationBar setTintColor:[UIColor whiteColor]];

        }];

    }else if ([APP_DELEGATE navigationController]) {
        [[[APP_DELEGATE navigationController] topViewController] presentViewController:picker animated:YES completion:^{
            [picker.navigationBar setTintColor:[UIColor whiteColor]];
        }];
    }
} */

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
  // [self. setTintColor:[UIColor whiteColor]];
    float actualHeight = image.size.height;
    float actualWidth  = image.size.width;
    float imgRatio     = actualWidth/actualHeight;
    float maxRatio     = 500.0/500.0;
    
//    if(imgRatio!=maxRatio)
    {
        if(imgRatio < maxRatio){
            imgRatio = 500.0 / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = 500.0;
        }
        else{
            imgRatio = 500.0 / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = 500.0;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if ([myAppdelegate isKindOfClass:[EditProfileViewController class]]|| [myAppdelegate isKindOfClass:[RegisterViewController class]])
    {
        
         if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
             //picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
             //[picker.navigationBar setFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 44)];
             [picker.navigationBar setHidden:NO];
         }
        
            UIImageCropper *cropView = [[UIImageCropper alloc] init];
            cropView.cropImg = img;
            cropView.pickerCtrl = self;
            [picker pushViewController:cropView animated:YES];
            sharePicker = picker;
    }
    else
    {
            sharePicker = picker;
            [self done:img];
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)done:(UIImage *)image {
    successBlock(image);
   // [sharePicker.navigationBar setTintColor:[UIColor whiteColor]];
   [sharePicker dismissViewControllerAnimated:YES completion:nil];

}

@end
