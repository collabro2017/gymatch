//
//  SingleChatViewController.m
//  GYMatch
//
//  Created by User on 12/26/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "SingleChatViewController.h"
#import "ZFTokenField.h"
#import "MBProgressHUD.h"
#import "UserDataController.h"
#import "InnerCircleCell.h"
#import "MessageDataController.h"
#import "UIImagePickerHelper.h"

@interface SingleChatViewController () <ZFTokenFieldDataSource, ZFTokenFieldDelegate> {
    NSArray *friendsArray;
    NSMutableArray *idArray;
    UIImagePickerHelper *iPH;
}
@property (weak, nonatomic) IBOutlet ZFTokenField *tokenField;
@property (nonatomic, strong) NSMutableArray *tokens;

@end

@implementation SingleChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"New Chat";
    self.tokens = [NSMutableArray array];
    
    
    self.tokenField.dataSource = self;
    self.tokenField.delegate = self;
    self.tokenField.textField.placeholder = @" To: ";
    [self.tokenField reloadData];
    
    idArray = [[NSMutableArray alloc] init];
    
    //[self.tokenField.textField becomeFirstResponder];
    
    UINib *nib = [UINib nibWithNibName:kInnerCircleCell bundle:nil];
    [albumCollectionView registerNib:nib forCellWithReuseIdentifier:kInnerCircleCell];
    
    [self loadData];
    
    [self addKBObserver];
    
    //[albumCollectionView setHidden:YES];
    
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    CGRect rect = self.messageView.frame;
    rect.origin.y = screenRect.size.height - rect.size.height - 43;
    //rect.origin.y =50;
    self.messageView.frame = rect;
    
    //self.messageView.layer.borderWidth = 2;
    //self.messageView.layer.borderColor = [UIColor redColor].CGColor;
    //[toolBar setHidden:NO];
    //[self.messageView setHidden:NO];
    [self.messageView setHidden:YES];
    [self.view bringSubviewToFront:self.inputView];
    
}

- (void)addKBObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShowKB:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willHideKB:) name:UIKeyboardWillHideNotification object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didShowKB:) name:UIKeyboardDidShowNotification object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didHideKB:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)willShowKB:(NSNotification *)notification{
    
    //    NSDictionary *userInfo = [notification userInfo];
    //
    //    curveKB = [[userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    //    durationShowKB = [[userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    //
    //
    //    heightKB = [[userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    //
    //    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
    //        heightKB -= 56;
    //    }
    //    CGRect frame = self.view.frame;
    //    frame.size.height -= heightKB;
    //
    //
    if (![messageTextField isFirstResponder]) {
        return;
    }
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    float durationShowKB = 0.3;
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardRect = [[userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    int heightKB = [[userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [UIView animateWithDuration:durationShowKB delay:0.0 options:curveKB animations:^{
        _messageView.frame = CGRectMake(0, keyboardRect.origin.y - 105, 320, _messageView.frame.size.height);
    } completion:^(BOOL finished) {
        
        //[messageTableView scrollBubbleViewToBottomAnimated:NO];
    }];
    
}

- (void)willHideKB:(NSNotification *)notification{
    float durationShowKB = 0.3;
    [UIView animateWithDuration:durationShowKB delay:0.0 options:curveKB animations:^{
        _messageView.frame = CGRectMake(0, self.view.frame.size.height-_messageView.frame.size.height, 320, _messageView.frame.size.height);
    } completion:^(BOOL finished) {
        
        //[messageTableView scrollBubbleViewToBottomAnimated:NO];
    }];
    //    CGRect frame = self.view.frame;
    //    frame.size.height += heightKB;
    //
    //    [UIView animateWithDuration:durationShowKB delay:0.0 options:curveKB animations:^{
    //        self.view.frame = frame;
    //    } completion:^(BOOL finished) {
    //        
    //    }];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self.tokenField reloadData];
    //[self.tokenField.textField becomeFirstResponder];
    CGRect rect = self.messageView.frame;
    
}

- (void)tokenDeleteButtonPressed:(UIButton *)tokenButton
{
    NSUInteger index = [self.tokenField indexOfTokenView:tokenButton.superview];
    if (index != NSNotFound) {
        [self.tokens removeObjectAtIndex:index];
        [self.tokenField reloadData];
    }
}

#pragma mark - ZFTokenField DataSource

- (CGFloat)lineHeightForTokenInField:(ZFTokenField *)tokenField
{
    return 30;
}

- (NSUInteger)numberOfTokenInField:(ZFTokenField *)tokenField
{
    return self.tokens.count;
}

- (UIView *)tokenField:(ZFTokenField *)tokenField viewForTokenAtIndex:(NSUInteger)index
{
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"TokenView" owner:nil options:nil];
    UIView *view = nibContents[0];
    UILabel *label = (UILabel *)[view viewWithTag:2];
    UIButton *button = (UIButton *)[view viewWithTag:3];
    
    [button addTarget:self action:@selector(tokenDeleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    label.text = self.tokens[index];
    CGSize size = [label sizeThatFits:CGSizeMake(1000, 30)];
    view.frame = CGRectMake(0, self.view.frame.size.width - size.width+10, size.width + 10, 30);
    return view;
}

#pragma mark - ZFTokenField Delegate

- (CGFloat)tokenMarginInTokenInField:(ZFTokenField *)tokenField
{
    return 5;
}

- (void)tokenField:(ZFTokenField *)tokenField didReturnWithText:(NSString *)text
{
    for (Friend *friend in friendsArray) {
        if ([text isEqualToString:[NSString stringWithFormat:@"%@ %@", friend.firstName, friend.lastName]] || [text isEqualToString:friend.username]) {
            [self.tokens addObject:text];
            [toolBar setHidden:NO];
            [_messageView setHidden:NO];
            [tokenField reloadData];
        }
    }
}

- (void)tokenField:(ZFTokenField *)tokenField didRemoveTokenAtIndex:(NSUInteger)index
{
    if ([self.tokens count] == [idArray count]) {
        [idArray removeObjectAtIndex:index];
    }
    [self.tokens removeObjectAtIndex:index];
    if (self.tokens.count == 0) {
        [_messageView setHidden:YES];
        [toolBar setHidden:YES];
    }
}

- (BOOL)tokenFieldShouldEndEditing:(ZFTokenField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    UserDataController *uDC = [UserDataController new];
    [uDC friendsOf:[APP_DELEGATE loggedInUser].ID withKeyword:@"" withSuccess:^(NSArray *friends) {
        friendsArray = friends;
        
        [albumCollectionView reloadData];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } failure:^(NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}


#pragma mark - UICollectionView Data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    return 0;
    return [friendsArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    InnerCircleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kInnerCircleCell forIndexPath:indexPath];
    
    [cell fillWithPhoto:[friendsArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    Friend *friend = [friendsArray objectAtIndex:indexPath.row];
    for (NSNumber *num in idArray) {
        if (num.integerValue == friend.ID) return;
    }
    [self.tokens addObject:[NSString stringWithFormat:@"%@ %@", friend.firstName, friend.lastName]];
    [idArray addObject:[NSNumber numberWithInt:friend.ID]];
    [toolBar setHidden:NO];
    [_messageView setHidden:NO];
    [self.tokenField reloadData];    
}

- (void)sendTextMessage{
    
    if ([idArray count] == 0) {
        return;
    }
    NSString *message = messageTextField.text;
    messageTextField.text = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([messageTextField.text isEqualToString:@""]) {
        return;
    }
    
    //    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //    [messageTextField resignFirstResponder];
    
    MessageDataController *mDC = [MessageDataController new];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    for (NSNumber *num in idArray) {
        NSDictionary *requestDictionary = @{@"receiverid": [NSNumber numberWithInteger:num.integerValue],
                                            @"text": messageTextField.text};
        
        [mDC sendWithDictionary:requestDictionary andImage:nil withSuccess:^(NSString *response) {
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            
        }];

    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - IBActions

- (IBAction)sendButtonPressed:(UIButton *)sender {
    [self sendTextMessage];
}

- (IBAction)addPicture:(id)sender{
    
    [self.view endEditing:YES];
    iPH = [[UIImagePickerHelper alloc]init];
    
    [iPH imagePickerInView:self.view WithSuccess:^(UIImage *image) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [messageTextField resignFirstResponder];
        
        MessageDataController *mDC = [MessageDataController new];
        
        for (NSNumber *num in idArray) {
        
            NSDictionary *requestDictionary = @{@"receiverid": [NSNumber numberWithInteger:num.integerValue]};
            
            [mDC sendWithDictionary:requestDictionary andImage:image withSuccess:^(NSString *response) {
                
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
            } failure:^(NSError *error) {
                
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
            }];
        
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
    }];
    
}


#pragma mark - UITextField delegate



- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [messageTextField resignFirstResponder];
    [self sendTextMessage];
    return YES;
}


@end
