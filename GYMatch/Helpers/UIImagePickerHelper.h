//
//  UIImagePickerHelper.h
//  GYMatch
//
//  Created by Ram on 18/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImagePickerHelper : NSObject
<UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate>

- (void)imagePickerInView:(UIView *)view
              WithSuccess:(void (^)(UIImage *image))success
                  failure:(void (^)(NSError *error))failure;
- (void)done:(UIImage *)image;
@property (assign) id myAppdelegate;
@end
