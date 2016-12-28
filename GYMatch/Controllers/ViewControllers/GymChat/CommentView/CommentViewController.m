//
//  CommentViewController.m
//  GYMatch
//
//  Created by Ram on 09/05/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "CommentViewController.h"
#import "Utility.h"
#import "Comment.h"
#import "MBProgressHUD.h"
#import "MessageDataController.h"
#import "UIImageView+WebCache.h"
#import "CommentCell.h"
#import "Constants.h"

@interface CommentViewController () {
    NSArray *comments;
}

@end

@implementation CommentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    timer = nil;
    weakSelf = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UINib *nib = [UINib nibWithNibName:kCommentCell bundle:nil];
    [messageTableView registerNib:nib forCellReuseIdentifier:kCommentCell];


//    [messageTableView setTableHeaderView:self.gymChatCell];
    
    [self.navigationItem setTitle:@"Comments"];
    
    messageTextField.frame = CGRectMake(messageTextField.frame.origin.x,
                                        messageTextField.frame.origin.y,
                                        [[UIScreen mainScreen] bounds].size.width - 90,
                                        messageTextField.frame.size.height);

    CGFloat fontSize = 12.0f;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        fontSize = 20.0f;
    }

    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    weakSelf = self;
    timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:weakSelf selector:@selector(loadData) userInfo:nil repeats:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [timer invalidate];
    timer = nil;
    weakSelf = nil;
}

- (void)loadData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    MessageDataController *uDC = [MessageDataController new];
    [uDC gymChatCommentsFor:self.gymChat.ID withSuccess:^(NSArray *aComments) {
        comments = aComments;
        //        dispatch_async(dispatch_get_main_queue(), ^{
        [messageTableView reloadData];
        //            [self loadBubbleData];
        //        });
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } failure:^(NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

#pragma mark - UItable View data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [comments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:kMessageCell];
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommentCell];
    [cell fillWithComment:comments[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:kMessageCell];
    
    CGFloat height;
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 294.0f, 10.0f)];
    label.text = [(Comment *)comments[indexPath.row] content];
    label.font = [UIFont systemFontOfSize:15.0f];
    height = [Utility heightForLabel:label];
    
    
    return 50.0f + height;
}

#pragma mark - IBActions

- (IBAction)sendButtonPressed:(UIButton *)sender {
    [self sendTextMessage];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
   //  [self sendTextMessage];
     [textField resignFirstResponder];
    return YES;
}

- (void)sendTextMessage{
    
    messageTextField.text = [messageTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    [messageTextField resignFirstResponder];

    if ([messageTextField.text isEqualToString:@""]) {
        return;
    }
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    MessageDataController *mDC = [MessageDataController new];
    
    [mDC commentGymChat:self.gymChat.ID comment:messageTextField.text withSuccess:^{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        //        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Message sent." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //        [alertView show];
        
        [self loadData];
        [messageTextField setText:@""];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Keyboard Notifications
- (void)keyboardWillShow:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        if (IS_IPAD) {
            [self.view setFrame:CGRectMake(0, -260, self.view.frame.size.width, self.view.frame.size.height)];
        }
        else {
            [self.view setFrame:CGRectMake(0, -185, self.view.frame.size.width, self.view.frame.size.height)];
        }
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        [self.view setFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
    }];
}

@end
