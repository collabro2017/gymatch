//
//  CustomTextField.h
//  GYMatch
//
//  Created by iPHTech2 on 20/08/15.
//  Copyright (c) 2015 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTextField : UITextField

@property (nonatomic) BOOL required;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSString *dateFormat;
@property (nonatomic, setter = setDateField:) BOOL isDateField;
@property (nonatomic, setter = setEmailField:) BOOL isEmailField;

- (BOOL) validate;
- (void) setDateFieldWithFormat:(NSString *)dateFormat;

@end


