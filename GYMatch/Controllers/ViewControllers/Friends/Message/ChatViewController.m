//
//  ChatViewController.m
//  GYMatch
//
//  Created by Ram Gautam on 11/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "ChatViewController.h"
#import "MessageCell.h"
#import "MessageDataController.h"
#import "MBProgressHUD.h"
#import "Utility.h"
#import "UIImagePickerHelper.h"
#import "NSBubbleData.h"
#import "UIImageView+WebCache.h"
#import "Friend.h"
#import "UserDataController.h"

@interface ChatViewController (){
    
    NSArray *messages;
    
    CGFloat durationShowKB;
    CGFloat heightKB;
    NSInteger curveKB;
    
    UIImagePickerHelper *iPH;
    
    NSMutableArray *bubbleData;
    
    __weak NSTimer *timer;
    __weak ChatViewController * weakSelf;
    
    BOOL isStart;
    
    BOOL isRead;
    CGRect rect;
}

@end

@implementation ChatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    isStart = YES;

    rect = messageTextField.frame;

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        textboxBottom.constant = 49;
        rect = CGRectMake(messageTextField.frame.origin.x,
                                 messageTextField.frame.origin.y,
                                 messageTextField.frame.size.width +140,
                                 messageTextField.frame.size.height);
        textBarBtn.customView.frame = rect;



      //  tableTop.constant = 64;
    }

    [self addKBObserver];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"dismissEnlarge"]) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"dismissEnlarge"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return;
    }
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isChatView"];
    [[NSUserDefaults standardUserDefaults] setInteger:self.user.ID forKey:@"currentSelectedFriendID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
     isSendingInProcess = NO;
    messageTFView.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width +5,  rect.size.height);

    weakSelf = self;
    [weakSelf loadData];

//    timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:weakSelf selector:@selector(loadData) userInfo:nil repeats:YES];

//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
//        [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"NewPush" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"ChatDeleted" object:nil];

    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:(BOOL)animated];
    isSendingInProcess = NO;
//    [timer invalidate];
//    timer = nil;
    weakSelf = nil;
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isChatView"];
    [[NSUserDefaults standardUserDefaults] setInteger:(-1) forKey:@"currentSelectedFriendID"];

    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self.navigationItem setTitle:self.user.name];
    messageTextField.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width -5,  rect.size.height);
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)dealloc{
    
    [self removeKBObserver];
    [timer invalidate];
    timer = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//- (void)viewDidAppear:(BOOL)animated{
//    
//    [super viewDidAppear:animated];
//    UIImage *titleLogo = [UIImage imageNamed:@"logo_titlebg"];
//    UIImageView *titleView = [[UIImageView alloc]initWithImage:titleLogo];
//    
//    [[(TopNavigationController *)[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:0] navigationItem] setTitleView:titleView];
//    
//    
//    [[[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:0] friendNavigationBar] setHidden:NO];
//    
//    [[[APP_DELEGATE tabBarController] tabBar] setHidden:NO];
//}

- (void)addKBObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShowKB:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willHideKB:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(test) name:@"ChatDeleted" object:nil];
}

- (void)removeKBObserver{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ChatDeleted" object:nil];

}
-(void)test{
    [messageTableView reloadData];
}
-(void)hideLoadingBar
{

    [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];

}
- (void)loadData
{

    if(self.user == nil)
        return;

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (self.navigationController.topViewController != self) {
        [self removeKBObserver];
        [timer invalidate];
        timer = nil;
        weakSelf = nil;
        return;
    }

    if ([[self valueForKey:@"user"] isMemberOfClass:[NSNull class]] &&
        ![[self valueForKey:@"user"] isMemberOfClass:[Friend class]]) {
        return;
    }
    
    if (self.user == nil) {
        messages = nil;
        [messageView setHidden:YES];
        [self loadBubbleData];
        return;
    }
    
    [messageView setHidden:NO];
    
    MessageDataController *uDC = [MessageDataController new];
    

    [uDC messagesForUser:[[weakSelf user] ID] WithSuccess:^(NSArray *someMessages) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            messages = someMessages;
            
            if ([messages count] == 0) {
                noMessagesLabel.hidden = NO;
                
            }
            else {
                noMessagesLabel.hidden = YES;
            }
            
            [weakSelf loadBubbleData];
            
            //[weakSelf performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
            
            // Read Messages
            if (!isRead) {
                weakSelf.user.unreadSentMessageCount = 0;
                isRead = true;
            }
            
            [messageTableView scrollBubbleViewToBottomAnimated:NO];
            //        if (first) {
            //            int msgCount = messages.count;
            //            NSIndexPath* ip = [NSIndexPath indexPathForRow:1 inSection:0];
            //            [messageTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            //        }
            //        else
            //            first = YES;
        });
        
    } failure:^(NSError *error) {
        
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alertView show];
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
    }];
}

- (void)loadBubbleData {
    
    bubbleData = [[NSMutableArray alloc]init];
    messageTableView.bubbleDataSource = self;
    messageTableView.showAvatars = YES;
    messageTableView.is_single   = self.is_single;
    
    
    for (Message *message in messages) {
        
        NSBubbleType type = (message.isSender)?BubbleTypeMine:BubbleTypeSomeoneElse;
        NSBubbleData *bubble;
        
        if (message.type == MessageTypeText) {
            
            bubble = [NSBubbleData dataWithText:message.content date:message.date type:type single:self.is_single];
            
        }
        else {
            
            CGRect imagerect = CGRectMake(0, 0, 200, 200);
            //CGRect imagerect = CGRectMake(0, 0, 220, 300);
            
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
                imagerect = CGRectMake(0, 0, 350, 350);
            }

            UIImageView *bImageView = [[UIImageView alloc]initWithFrame:imagerect];
//            bImageView.layer.cornerRadius = 3.0f;
            bImageView.contentMode= UIViewContentModeScaleAspectFit; // Gourav june 19
            
            bImageView.clipsToBounds = YES;
            [bImageView sd_setImageWithURL:[NSURL URLWithString:message.content] placeholderImage:[Utility placeHolderImage]];
            bImageView.layer.borderWidth = 0.0f;
            UIEdgeInsets edgeInsets;
            
            if (type == BubbleTypeMine) {
                edgeInsets = UIEdgeInsetsMake(25, 12, 12, 33);
            }
            else {
                edgeInsets = UIEdgeInsetsMake(25, 34, 12, 12);
            }
            
            bubble = [NSBubbleData dataWithView:bImageView date:message.date type:type insets:edgeInsets];
        }
        
        [bubbleData addObject:bubble];
        if (message.isSender)
            bubble.avatarURL = [[APP_DELEGATE loggedInUser] image];
        else
            bubble.avatarURL = message.userImage;
        
    
        bubble.ID = message.ID;
        bubble.userName = @"";
        bubble.userOnline = message.userOnline;
        
         [self addTouchGestureToBubble:bubble];

    }

    messageTableView.snapInterval = 30;
    
    // The line below enables avatar support. Avatar can be specified for each bubble with .avatar property of NSBubbleData.
    // Avatars are enabled for the whole table at once. If particular NSBubbleData misses the avatar, a default placeholder will be set (missingAvatar.png)
    
    messageTableView.showAvatars = YES;
    
    // Uncomment the line below to add "Now typing" bubble
    // Possible values are
    //    - NSBubbleTypingTypeSomebody - shows "now typing" bubble on the left
    //    - NSBubbleTypingTypeMe - shows "now typing" bubble on the right
    //    - NSBubbleTypingTypeNone - no "now typing" bubble
    
    
    [messageTableView reloadData];

    if (isStart) {
        isStart = NO;
    }
    
   
}


- (void)addTouchGestureToBubble:(NSBubbleData *)oBubbleData
{
    UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchEventOnImage:)];
    [tapRecognizer setNumberOfTouchesRequired:1];
    //Don't forget to set the userInteractionEnabled to YES, by default It's NO.
    oBubbleData.view.userInteractionEnabled = YES;
    [oBubbleData.view addGestureRecognizer:tapRecognizer];
}

- (void)touchEventOnImage:(id)sender
{
    if( [sender isKindOfClass:[UIGestureRecognizer class]] )
    {
        UIGestureRecognizer *recognizer = (UIGestureRecognizer *)sender;
        
        if( [recognizer.view isKindOfClass:[UIImageView class]] )
        {
            NSLog(@"ChatView Gesture is called");
            UIImage *img = ((UIImageView *)recognizer.view).image;
            if (img != nil && !CGSizeEqualToSize(img.size, CGSizeZero)) {
                _vc = [[EnlargeViewController alloc] initWithNibName:@"AvatorViewController" bundle:nil];
                
                _vc.image = ((UIImageView *)recognizer.view).image;
                [_vc.view setFrame:[[UIScreen mainScreen] bounds]];
                CATransition* transition = [CATransition animation];
                transition.duration = 0.5f;
                transition.type = kCATransitionFade;
                transition.subtype = kCATransitionFromRight;
                [_vc.view.window.layer addAnimation:transition forKey:kCATransition];
                
                [self presentViewController:_vc animated:NO completion:nil];
            }
        }
    }
}


#pragma mark - UIBubbleTableViewDataSource implementation

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    NSLog(@"bubble called");
    return [bubbleData count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
    return [bubbleData objectAtIndex:row];
}


#pragma mark - UItable View data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"Table called");
    return [messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:kMessageCell];
    
    [cell fillWithMessage:messages[indexPath.row]];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:kMessageCell];
    [cell fillWithMessage:messages[indexPath.row]];
    
    return cell.frame.size.height;
}

- (void)sendTextMessage
{

    NSString *message = messageTextField.text;
    message = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    isSendingInProcess = YES;
    if ([message isEqualToString:@""]) {
        isSendingInProcess = NO;
        return;
    }
    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [messageTextField resignFirstResponder];
    
    MessageDataController *mDC = [MessageDataController new];
    NSDictionary *requestDictionary = @{@"receiverid": [NSNumber numberWithInteger:self.user.ID],
                                        @"text": message};
    
    [mDC sendWithDictionary:requestDictionary andImage:nil withSuccess:^(NSString *response) {
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        

        /*  NSBubbleData *bubble = [NSBubbleData dataWithText:message date:[NSDate date] type:BubbleTypeMine single:self.is_single];
        [bubbleData addObject:bubble];
        
        [messageTableView reloadData];
        [messageTableView scrollBubbleViewToBottomAnimated:YES]; */

        [self loadData];
        [messageTextField setText:@""];
        isSendingInProcess = NO;        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateTabBarBadge" object:nil];
    } failure:^(NSError *error) {
        isSendingInProcess = NO;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

#pragma mark - IBActions

- (IBAction)sendButtonPressed:(UIButton *)sender {
    if (!isSendingInProcess) {
        [self sendTextMessage];
    }
    
}

- (IBAction)addPicture:(id)sender{
    
    [self.view endEditing:YES];
    iPH = [[UIImagePickerHelper alloc]init];
    
    [iPH imagePickerInView:self.view WithSuccess:^(UIImage *image) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [messageTextField resignFirstResponder];
        
        MessageDataController *mDC = [MessageDataController new];
        
        NSDictionary *requestDictionary = @{@"receiverid": [NSNumber numberWithInteger:self.user.ID]};
        
        [mDC sendWithDictionary:requestDictionary andImage:image withSuccess:^(NSString *response) {
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
//            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Image sent." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alertView show];

            NSBubbleData *bubble = [NSBubbleData dataWithImage:image date:[NSDate date] type:BubbleTypeMine];
            [bubbleData addObject:bubble];
            
            [messageTableView reloadData];
            [messageTableView scrollBubbleViewToBottomAnimated:NO];
            
        } failure:^(NSError *error) {
//            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//
//            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alertView show];
            
        }];
        
        
    } failure:^(NSError *error) {
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alertView show];
        
    }];
    
}



#pragma mark - UITextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [messageTextField resignFirstResponder];
    return YES;
}


#pragma mark - Keyboard notifications

- (void)willShowKB:(NSNotification *)notification
{
    durationShowKB = 0.3;
    NSDictionary *userInfo = [notification userInfo];
   // CGRect keyboardRect = [[userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    heightKB = [[userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [UIView animateWithDuration:durationShowKB delay:0.0 options:curveKB animations:^{

        textboxBottom.constant = heightKB;
        
    } completion:^(BOOL finished) {
        [messageTableView scrollBubbleViewToBottomAnimated:YES];
        }];
}


- (void)willHideKB:(NSNotification *)notification
{
    [UIView animateWithDuration:durationShowKB delay:0.0 options:curveKB animations:^{
         if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad )
             textboxBottom.constant = 49;
         else
            textboxBottom.constant = 0;

    } completion:^(BOOL finished) {
          }];
}


#pragma mark - MessagesViewControllerDelegate

- (void)didSelectFriend:(Friend *)aFriend{

    if (aFriend == nil) {
        [self view];

        self.user = nil;
        messages = nil;
    }
    else
    {

        self.user = aFriend;

    }


    [self loadBubbleData];
    [self.navigationItem setTitle:(![self.user.name isEqualToString:@""]) ? self.user.name : self.user.username];
    
    isStart = YES;
    [self loadData];
}

#pragma mark - Delete message

- (void)deleteMessageAtIndexPath:(NSIndexPath *)indexPath
{
    return;
}

@end
