//
//  MHTextField.m
//
//

#import "MHTextField.h"
#import "Utility.h"

@interface MHTextField()
{
    UITextField *_textField;
    BOOL _disabled;
    BOOL _enabled;
}

@property (nonatomic) BOOL keyboardIsShown;
@property (nonatomic) CGSize keyboardSize;
@property (nonatomic) BOOL hasScrollView;
@property (nonatomic) BOOL invalid;

@property (nonatomic, setter = setToolbarCommand:) BOOL isToolBarCommand;
@property (nonatomic, setter = setDoneCommand:) BOOL isDoneCommand;

@property (nonatomic , strong) UIBarButtonItem *previousBarButton;
@property (nonatomic , strong) UIBarButtonItem *nextBarButton;

@property (nonatomic, strong) NSMutableArray *textFields;

@property (weak) id keyboardDidShowNotificationObserver;
@property (weak) id keyboardWillHideNotificationObserver;

@end

@implementation MHTextField

@synthesize required;
@synthesize scrollView;
@synthesize toolbar;
@synthesize keyboardIsShown;
@synthesize keyboardSize;
@synthesize invalid;

- (void) awakeFromNib{
    [super awakeFromNib];
    
    self.layer.cornerRadius = 3.0f;
    self.layer.borderWidth = 0.5f;
    self.layer.borderColor = [[UIColor colorWithRed:204.0/255.0f green:204.0f/255.0f blue:205.0f/255.0f alpha:1.0f] CGColor];
    
    [self setup];
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self){
        [self setup];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self markTextFieldsWithTagInView:self.superview];
    
    _enabled = YES;

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    return YES;
}

- (void)setup{
    
    self.font = [UIFont fontWithName:@"ProximaNova-Regular" size:13.0f];
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 20.0f)];
    [self setLeftView:leftView];
    self.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 20.0f)];
    [self setRightView:rightView];
    self.rightViewMode = UITextFieldViewModeAlways;
    
    if ([self respondsToSelector:@selector(setTintColor:)])
        [self setTintColor:[UIColor blackColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:self];
   
    
    toolbar = [[UIToolbar alloc] init];
    toolbar.frame = CGRectMake(0, 0, self.window.frame.size.width, 44);
    // set style
    [toolbar setBarStyle:UIBarStyleDefault];
    
    self.previousBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Previous" style:UIBarButtonItemStylePlain target:self action:@selector(previousButtonIsClicked:)];
    self.nextBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(nextButtonIsClicked:)];

    
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonIsClicked:)];
    
    NSArray *barButtonItems = @[self.previousBarButton, self.nextBarButton, flexBarButton, doneBarButton];
    
    toolbar.items = barButtonItems;
    
    if (self.placeholder) {
        
        self.attributedPlaceholder = [[NSAttributedString alloc]initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    }
    
//    [self setTintColor:[UIColor grayColor]];
    
    self.textFields = [[NSMutableArray alloc]init];
    
}

- (void)markTextFieldsWithTagInView:(UIView*)view{
    
    int index = 0;
    if ([self.textFields count] == 0){
        for(UIView *subView in view.subviews){
            if ([subView isKindOfClass:[MHTextField class]]){
                MHTextField *textField = (MHTextField*)subView;
                textField.tag = index;
                [self.textFields addObject:textField];
                index++;
            }
        }
    }
    
}

- (void) doneButtonIsClicked:(id)sender{
    [self setDoneCommand:YES];
    [self resignFirstResponder];
    [self setToolbarCommand:YES];
}

- (void) nextButtonIsClicked:(id)sender{
    NSInteger tagIndex = self.tag;
    MHTextField *textField =  [self.textFields objectAtIndex:++tagIndex];
    
    while (!textField.isEnabled && tagIndex < [self.textFields count])
        textField = [self.textFields objectAtIndex:++tagIndex];

    [self becomeActive:textField];
}

- (void) previousButtonIsClicked:(id)sender{
    NSInteger tagIndex = self.tag;
    
    MHTextField *textField =  [self.textFields objectAtIndex:--tagIndex];
    
    while (!textField.isEnabled && tagIndex < [self.textFields count])
        textField = [self.textFields objectAtIndex:--tagIndex];
    
    [self becomeActive:textField];
}

- (void)becomeActive:(UITextField*)textField{
    [self setToolbarCommand:YES];
    [self resignFirstResponder];
    [textField becomeFirstResponder];
}


- (void)setBarButtonNeedsDisplayAtTag:(NSInteger)tag{
    BOOL previousBarButtonEnabled = NO;
    BOOL nexBarButtonEnabled = NO;


    for (int index = 0; index < [self.textFields count]; index++)
    {

        UITextField *textField = [self.textFields objectAtIndex:index];


       if ((index < tag) && ![textField  isHidden])
         previousBarButtonEnabled |= textField.isEnabled;
        else if (index > tag && ![textField  isHidden])
         nexBarButtonEnabled |= textField.isEnabled;
    }
    
    self.previousBarButton.enabled = previousBarButtonEnabled;
    self.nextBarButton.enabled = nexBarButtonEnabled;
}

- (void) selectInputView:(UITextField *)textField{
    if (_isDateField){
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        datePicker.datePickerMode = UIDatePickerModeDate;
        [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        if (![textField.text isEqualToString:@""]){
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            if (self.dateFormat) {
                [dateFormatter setDateFormat:self.dateFormat];
            } else {
                [dateFormatter setDateFormat:@"MM/dd/YY"];
            }
            [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
            [dateFormatter setDateStyle:NSDateFormatterShortStyle];
            [datePicker setDate:[dateFormatter dateFromString:textField.text]];
        }
        [textField setInputView:datePicker];
    }
}

- (void)datePickerValueChanged:(id)sender{
    UIDatePicker *datePicker = (UIDatePicker*)sender;
    
    NSDate *selectedDate = datePicker.date;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [
     dateFormatter setDateFormat:@"MM/dd/YY"];
    
    [_textField setText:[dateFormatter stringFromDate:selectedDate]];
    
    [self validate];
}

- (void)scrollToField {
    CGRect textFieldRect = [[_textField superview] convertRect:_textField.frame toView:self.window];
    CGRect aRect = self.window.bounds;

    aRect.origin.y = -scrollView.contentOffset.y;
    aRect.size.height -= keyboardSize.height + self.toolbar.frame.size.height + 22;

    CGPoint textRectBoundary = CGPointMake(textFieldRect.origin.x, textFieldRect.origin.y + textFieldRect.size.height);

    if (!CGRectContainsPoint(aRect, textRectBoundary) || scrollView.contentOffset.y > 0) {
        CGPoint scrollPoint = CGPointMake(0.0, self.superview.frame.origin.y + _textField.frame.origin.y + _textField.frame.size.height - aRect.size.height);

        if (scrollPoint.y < 0) scrollPoint.y = 0;

        [scrollView setContentOffset:scrollPoint animated:YES];
    }
}

- (BOOL) validate{
//    self.backgroundColor = [UIColor colorWithRed:255 green:0 blue:0 alpha:0.5];
    
    if (self.required && [self.text isEqualToString:@""]){
        return NO;
    }
    else if (self.isEmailField){
        NSString *emailRegEx =
        @"(?:[A-Za-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[A-Za-z0-9!#$%\\&'*+/=?\\^_`{|}"
        @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
        @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[A-Za-z0-9](?:[a-"
        @"z0-9-]*[A-Za-z0-9])?\\.)+[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?|\\[(?:(?:25[0-5"
        @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
        @"9][0-9]?|[A-Za-z0-9-]*[A-Za-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
        @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
        
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
        
        if (![emailTest evaluateWithObject:self.text]){
            return NO;
        }
    } else if(self.text.length > 300) {
        return NO;
    }

//    [self setBackgroundColor:[UIColor whiteColor]];
    
    return YES;
}


- (void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    
    _enabled = enabled;
    
    [self setNeedsBackground];
}

- (void)setNeedsBackground
{
    if (!_enabled)
        [self setBackgroundColor:[UIColor lightGrayColor]];
    else
        [self setBackgroundColor:[UIColor colorWithRed:231.0/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];

}

- (void)setDateFieldWithFormat:(NSString *)dateFormat {
    self.isDateField = YES;
    self.dateFormat = dateFormat;
}

#pragma mark - UIKeyboard notifications

- (void) keyboardDidShow:(NSNotification *) notification{
    if (_textField== nil)
        return;

    if (keyboardIsShown)
        return;

    if (![_textField isKindOfClass:[MHTextField class]])
        return;
    
    NSDictionary* info = [notification userInfo];
    
    NSValue *aValue = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    keyboardSize = [aValue CGRectValue].size;
    if([self.scrollView isKindOfClass:[UIScrollView class]])
        [self scrollToField];
    
    self.keyboardIsShown = YES;
}

- (void) keyboardWillHide:(NSNotification *) notification{
    NSTimeInterval duration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        if (_isDoneCommand && [self.scrollView isKindOfClass:[UIScrollView class]])
            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }];
    
    keyboardIsShown = NO;
    
    [[NSNotificationCenter defaultCenter]removeObserver:self.keyboardDidShowNotificationObserver];
    [[NSNotificationCenter defaultCenter]removeObserver:self.keyboardWillHideNotificationObserver];
}

#pragma mark - UITextField notifications

- (void)textFieldDidBeginEditing:(NSNotification *) notification {
    UITextField *textField = (UITextField*)[notification object];
    
    _textField = textField;
    
    [self setKeyboardDidShowNotificationObserver:[[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardDidShowNotification object:nil queue:nil usingBlock:^(NSNotification *notification){
        [self keyboardDidShow:notification];
    }]];
    [self setKeyboardWillHideNotificationObserver:[[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:nil usingBlock:^(NSNotification *notification){
        [self keyboardWillHide:notification];
    }]];
 
    [self setBarButtonNeedsDisplayAtTag:textField.tag];
    
    while ([self.superview isKindOfClass:[UIScrollView class]] && self.scrollView == nil) {
        
        self.scrollView = (UIScrollView*)self.superview;
        
    }
    // self.scrollView = (UIScrollView*)[[[self.superview superview] superview] superview];
    
    while ([[[[self.superview valueForKey:@"superview"] valueForKey:@"superview"]valueForKey:@"superview"] isKindOfClass:[UIScrollView class]] && self.scrollView == nil) {
        
        UITableView *tableView = [[[self.superview valueForKey:@"superview"] valueForKey:@"superview"] valueForKey:@"superview"];
        
        self.scrollView = (UIScrollView*)tableView;
        
    }
    
    [self selectInputView:textField];
    [self setInputAccessoryView:toolbar];
    [self setToolbarCommand:NO];
}

- (void)textFieldDidEndEditing:(NSNotification *) notification{
    UITextField *textField = (UITextField*)[notification object];
   
    if (_isDateField && [textField.text isEqualToString:@""] && _isDoneCommand){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        if (self.dateFormat) {
            [dateFormatter setDateFormat:self.dateFormat];
        } else {
            [dateFormatter setDateFormat:@"MM/dd/YY"];
        }
        
        [textField setText:[dateFormatter stringFromDate:[NSDate date]]];
    }
    
    [self validate];

    [self setDoneCommand:NO];
    
    _textField = nil;
}


@end
