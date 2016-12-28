//
//  MHTextField.h
//
//

#import <UIKit/UIKit.h>

@interface MHTextField : UITextField

@property (nonatomic) BOOL required;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSString *dateFormat;
@property (nonatomic, setter = setDateField:) BOOL isDateField;
@property (nonatomic, setter = setEmailField:) BOOL isEmailField;

- (BOOL) validate;
- (void) setDateFieldWithFormat:(NSString *)dateFormat;

@end
