//
//  ChatViewController.m
//  GYMatch
//
//  Created by Ram Gautam on 11/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "TeamMsgViewController.h"
#import "MessageCell.h"
#import "MessageDataController.h"
#import "MBProgressHUD.h"
#import "Utility.h"
#import "UIImagePickerHelper.h"
#import "NSBubbleData.h"
#import "UIImageView+WebCache.h"
#import "Friend.h"
#import "UserDataController.h"

@interface TeamMsgViewController (){
    
    NSArray *messages;
    NSArray *members;
    
    CGFloat durationShowKB;
    CGFloat heightKB;
    NSInteger curveKB;
    
    UIImagePickerHelper *iPH;
    
    NSMutableArray *bubbleData;
    
    __weak NSTimer *timer;
    __weak TeamMsgViewController * weakSelf;
    
    BOOL isStart;
    
    BOOL isRead;
    
}

@end

@implementation TeamMsgViewController

- (id)initWithGroup:(int)group_id
{
    NSString *nibName = @"TeamMsgViewController";
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
//        nibName = @"SplashViewController_iPad";
    }
    
    self = [self initWithNibName:nibName bundle:[NSBundle mainBundle]];
    
    if (self) {
        groupID = group_id;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    //    UINib *nib = [UINib nibWithNibName:kMessageCell bundle:nil];
    //    [messageTableView registerNib:nib forCellReuseIdentifier:kMessageCell];
    
    //     [messageTextField setInputAccessoryView:messageView];
    
    //    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(addPicture:)];
    //
    //    self.navigationItem.rightBarButtonItem = editButton;
    
    //    __weak ChatViewController *weakSelf = self;
    weakSelf = self;
//    timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:weakSelf selector:@selector(loadData) userInfo:nil repeats:YES];
//    [self loadData];
    isStart = YES;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        textboxBottom.constant = 55;
        messageTextField.frame = CGRectMake(messageTextField.frame.origin.x,
                                            messageTextField.frame.origin.y,
                                            messageTextField.frame.size.width + 120,
                                            messageTextField.frame.size.height);
        
        tableTop.constant = 64;
    }
    
    //messageTextField.inputAccessoryView = messageView;
    
    [self addKBObserver];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadData];
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [self.navigationItem setTitle:@"Chat In Session"];
    
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didShowKB:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didHideKB:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)removeKBObserver{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (void)loadData{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (self.navigationController.topViewController != self) {
        [self removeKBObserver];
        [timer invalidate];
        timer = nil;
        weakSelf = nil;
        return;
    }
    
    MessageDataController *uDC = [MessageDataController new];
    
    [uDC messagesForGroup:groupID WithSuccess:^(NSArray *someMessages) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        messages = [someMessages objectAtIndex:1];
        members = [someMessages objectAtIndex:0];
        [self drawScrollBar];
        
        if ([messages count] == 0) {
            noMessagesLabel.hidden = NO;
            
        }else{
            noMessagesLabel.hidden = YES;
            
        }
        
        //        dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf loadBubbleData];
        
        
    } failure:^(NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
    }];
     /**
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
    
    
    
    //    __weak ChatViewController *weakSelf = self;
    
    [uDC messagesForUser:[[weakSelf user] ID] WithSuccess:^(NSArray *someMessages) {
     
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        messages = someMessages;
        
        if ([messages count] == 0) {
            noMessagesLabel.hidden = NO;
            
        }else{
            noMessagesLabel.hidden = YES;
            
        }
        
        //        dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf loadBubbleData];
        //        [weakSelf performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
        //        });
        
        // Read Messages
        if (!isRead) {
            
            weakSelf.user.unreadSentMessageCount = 0;
            isRead = true;
            
        }
        
    } failure:^(NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
    }];
     */
}

- (void)loadBubbleData{
    
    bubbleData = [[NSMutableArray alloc]init];
    messageTableView.bubbleDataSource = self;
    messageTableView.showAvatars = YES;
    messageTableView.is_single = self.is_single;
    
    
    for (Message *message in messages) {
        
        NSBubbleType type = (message.isSender)?BubbleTypeSomeoneElse:BubbleTypeMine;
        NSBubbleData *bubble;
        
        if (message.type == MessageTypeText) {
            
            bubble = [NSBubbleData dataWithText:message.content date:message.date type:type single:self.is_single];
            
        }else{
            
            CGRect imagerect = CGRectMake(0, 0, 200, 200);
            
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
                imagerect = CGRectMake(0, 0, 350, 350);
            }
            
            UIImageView *bImageView = [[UIImageView alloc]initWithFrame:imagerect];
            //            bImageView.layer.cornerRadius = 3.0f;
            bImageView.clipsToBounds = YES;
            [bImageView sd_setImageWithURL:[NSURL URLWithString:message.content] placeholderImage:[Utility placeHolderImage]];
            bImageView.layer.borderWidth = 0.0f;
            UIEdgeInsets edgeInsets;
            if (type == BubbleTypeMine) {
                edgeInsets = UIEdgeInsetsMake(25, 12, 12, 33);
            }else{
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
        bubble.userName = message.userName;
        bubble.userOnline = message.userOnline;
    }
    
    
    //    NSBubbleData *heyBubble = [NSBubbleData dataWithText:@"Hey, halloween is soon" date:[NSDate dateWithTimeIntervalSinceNow:-300] type:BubbleTypeSomeoneElse];
    //    heyBubble.avatar = [UIImage imageNamed:@"avatar1.png"];
    //
    //    NSBubbleData *photoBubble = [NSBubbleData dataWithImage:[UIImage imageNamed:@"halloween.jpg"] date:[NSDate dateWithTimeIntervalSinceNow:-290] type:BubbleTypeSomeoneElse];
    //    photoBubble.avatar = [UIImage imageNamed:@"avatar1.png"];
    //
    //    NSBubbleData *replyBubble = [NSBubbleData dataWithText:@"Wow.. Really cool picture out there. iPhone 5 has really nice camera, yeah?" date:[NSDate dateWithTimeIntervalSinceNow:-5] type:BubbleTypeMine];
    //    replyBubble.avatar = nil;
    
    // The line below sets the snap interval in seconds. This defines how the bubbles will be grouped in time.
    // Interval of 120 means that if the next messages comes in 2 minutes since the last message, it will be added into the same group.
    // Groups are delimited with header which contains date and time for the first message in the group.
    
    messageTableView.snapInterval = 30;
    
    // The line below enables avatar support. Avatar can be specified for each bubble with .avatar property of NSBubbleData.
    // Avatars are enabled for the whole table at once. If particular NSBubbleData misses the avatar, a default placeholder will be set (missingAvatar.png)
    
    messageTableView.showAvatars = YES;
    
    // Uncomment the line below to add "Now typing" bubble
    // Possible values are
    //    - NSBubbleTypingTypeSomebody - shows "now typing" bubble on the left
    //    - NSBubbleTypingTypeMe - shows "now typing" bubble on the right
    //    - NSBubbleTypingTypeNone - no "now typing" bubble
    
    //    messageTableView.typingBubble = NSBubbleTypingTypeSomebody;
    
    [messageTableView reloadData];
    
    if (isStart) {
        
        [messageTableView scrollBubbleViewToBottomAnimated:NO];
        isStart = NO;
    }
    
}

#pragma mark - UIBubbleTableViewDataSource implementation

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    return [bubbleData count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
    return [bubbleData objectAtIndex:row];
}

#pragma mark - UItable View data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
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

- (void)sendTextMessage{
    
    NSString *message = messageTextField.text;
    messageTextField.text = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    if ([messageTextField.text isEqualToString:@""]) {
        return;
    }
    
    //    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //    [messageTextField resignFirstResponder];
    
    MessageDataController *mDC = [MessageDataController new];
    
    /**NSDictionary *requestDictionary = @{@"receiverid": [NSNumber numberWithInteger:self.user.ID],
                                        @"text": messageTextField.text};
    
    [mDC sendWithDictionary:requestDictionary andImage:nil withSuccess:^(NSString *response) {
        //        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        //        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Message sent." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //        [alertView show];
        
        
        NSBubbleData *bubble = [NSBubbleData dataWithText:messageTextField.text date:[NSDate date] type:BubbleTypeMine single:self.is_single];
        [bubbleData addObject:bubble];
        
        [messageTableView reloadData];
        [messageTableView scrollBubbleViewToBottomAnimated:YES];
        
        [messageTextField setText:@""];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
    }];*/
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
 /**
        NSDictionary *requestDictionary = @{@"receiverid": [NSNumber numberWithInteger:self.user.ID]};
        
        [mDC sendWithDictionary:requestDictionary andImage:image withSuccess:^(NSString *response) {
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            //            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Image sent." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //            [alertView show];
            
            NSBubbleData *bubble = [NSBubbleData dataWithImage:image date:[NSDate date] type:BubbleTypeMine];
            [bubbleData addObject:bubble];
            
            [messageTableView reloadData];
            [messageTableView scrollBubbleViewToBottomAnimated:YES];
            
        } failure:^(NSError *error) {
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            
        }];
    */
        
    } failure:^(NSError *error) {
        
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

#pragma mark - Keyboard notifications

- (void)didShowKB:(NSNotification *)notification{
    
}

- (void)didHideKB:(NSNotification *)notification{
    
    
    
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
        messageView.frame = CGRectMake(0, keyboardRect.origin.y - 105, 320, messageView.frame.size.height);
    } completion:^(BOOL finished) {
        
        //[messageTableView scrollBubbleViewToBottomAnimated:NO];
    }];
    
}

- (void)willHideKB:(NSNotification *)notification{
    float durationShowKB = 0.3;
    [UIView animateWithDuration:durationShowKB delay:0.0 options:curveKB animations:^{
        messageView.frame = CGRectMake(0, self.view.frame.size.height-messageView.frame.size.height, 320, messageView.frame.size.height);
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

#pragma mark - MessagesViewControllerDelegate

- (void)didSelectFriend:(Friend *)aFriend{
//    
//    self.user = aFriend;
//    messages = nil;
//    
//    [self loadBubbleData];
//    [self.navigationItem setTitle:(![self.user.name isEqualToString:@""]) ? self.user.name : self.user.username];
//    
//    isStart = YES;
//    [self loadData];
}

#pragma mark - Delete message

- (void)deleteMessageAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (IBAction)arrow_left:(id)sender {
    
}

- (IBAction)arrow_right:(id)sender {
    
}

- (void)drawScrollBar {
    int x = 0;
    for (Friend *friend in members) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20.0f + x * 55.0f, 5.0f, 50.0f, 50.0f)];
        [imgView sd_setImageWithURL:[NSURL URLWithString:friend.image] placeholderImage:[Utility placeHolderImage]];
        [imgView setContentMode:UIViewContentModeScaleAspectFill];
        imgView.layer.cornerRadius = imgView.frame.size.width / 2.0f;
        imgView.layer.masksToBounds = YES;
        x ++;
        [scrollView addSubview:imgView];
    }
}

@end

