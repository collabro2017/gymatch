//
//  GymChatViewController.m
//  GYMatch
//
//  Created by Ram Gautam on 11/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "GymChatViewController.h"
#import "MessageCell.h"
#import "MessageDataController.h"
#import "MBProgressHUD.h"
#import "Utility.h"
#import "UIImagePickerHelper.h"
#import "NSBubbleData.h"
#import "UIImageView+WebCache.h"
#import "AddPictureViewController.h"


@interface GymChatViewController (){
    NSMutableArray *messages;

    CGFloat durationShowKB;
    CGFloat heightKB;
    NSInteger curveKB;
    AppDelegate *appDel;
    UIImagePickerHelper *iPH;

    NSMutableArray *bubbleData;
    NSString *nibName;
    UIColor *grayColor, *greenColor;
}

@end

@implementation GymChatViewController

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
     [self removeKBObserver];
    timer = nil;
    weakSelf = nil;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    nibName = kMessageCell;

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        nibName = kMessageCell_iPad;
    }
    appDel = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    greenColor = [UIColor colorWithRed:26.0/255.0 green:184.0/255.0 blue:38.0/255.0 alpha:1.0];
    grayColor = [UIColor colorWithRed:241.0/255.0 green:240.0/255.0 blue:1.0 alpha:1.0];

    UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
    [messageTableView registerNib:nib forCellReuseIdentifier:nibName];

    messageTextField.frame = CGRectMake(messageTextField.frame.origin.x,
                                        messageTextField.frame.origin.y,
                                        [[UIScreen mainScreen] bounds].size.width - 130,
                                        messageTextField.frame.size.height);

    //    [messageTextField setInputAccessoryView:messageView];
    //messageTextField.inputAccessoryView = messageView;

    //    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"instagramIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(addPicture:)];
    //    editButton.tag = 2;
    //    self.navigationItem.rightBarButtonItem = editButton;
    [messageTableView setBackgroundColor:[UIColor colorWithRed:225/255.0f green:225/255.0f blue:225/255.0f alpha:225/255.0f]];

    [self addKBObserver];
}

// - (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
    //    [self.navigationController.navigationItem.titleView addSubview:instagramButton];
   // [messageTableView reloadData];
  //  [self loadData];
// }


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     //  [self enableGymChatAgain];
    weakSelf = self;
    timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:weakSelf selector:@selector(loadData) userInfo:nil repeats:YES];
    [timer fire];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationItem setTitle:@"Gym Chat"];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [timer invalidate];
    timer = nil;
    weakSelf = nil;
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
}

- (void)removeKBObserver{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)descardNotNeededMessagesForUser:(NSArray*)arr
{
    NSMutableArray *messageArr = [NSMutableArray arrayWithArray:arr];

    NSMutableDictionary *oldValues = [NSMutableDictionary dictionaryWithContentsOfFile:appDel.databasePath];
    NSString *userId = [NSString stringWithFormat:@"User%ld",(long)appDel.loggedInUser.ID];

    if([[oldValues valueForKey:userId] isEqual:[NSNull null]])
        messages = [NSMutableArray arrayWithArray:arr];
    else
    {
        NSArray *chatIdArray = [oldValues valueForKey:userId];
        for (NSNumber *num in chatIdArray)
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.ID == %@", num];
            NSArray *results = [messageArr filteredArrayUsingPredicate:predicate];
            if([results lastObject])
                [messageArr removeObjectIdenticalTo:[results lastObject]];
        }
        messages = [NSMutableArray arrayWithArray:messageArr];
    }
}

- (void)loadData {

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    MessageDataController *uDC = [MessageDataController new];
    [uDC gymChatsWithSuccess:^(NSArray *someMessages) {
        // messages = [NSMutableArray arrayWithArray:someMessages];
        // do everything here  // 12 Aug
        [self descardNotNeededMessagesForUser:someMessages];


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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    cell.viewController = self;
    [cell fillWithMessage:messages[indexPath.row]];
    cell.myIndex = indexPath;
    return cell;
}

-(void)deleteMessageAtIndex:(NSIndexPath*)indexPath
{
    // add message id to plist  file with corresponding user id to prevent to load again for current user
    GymChat *gymChat = [messages objectAtIndex:indexPath.row];
    NSMutableDictionary *oldValues = [NSMutableDictionary dictionaryWithContentsOfFile:appDel.databasePath];
    NSString *userId = [NSString stringWithFormat:@"User%ld",(long)appDel.loggedInUser.ID];
    if([[oldValues valueForKey:userId] isEqual:[NSNull null]])
    {
        NSArray *arr = [NSArray arrayWithObject:[NSNumber numberWithInteger:gymChat.ID]];
        [oldValues setObject:arr forKey:userId];
    }
    else
    {
        NSMutableArray *arr = [NSMutableArray arrayWithArray:[oldValues valueForKey:userId]];
        NSNumber *numb = [NSNumber numberWithInteger:gymChat.ID];
        if(![arr containsObject:numb])
            [arr addObject:numb];
        [oldValues setObject:arr forKey:userId];
    }

    [oldValues writeToFile:appDel.databasePath atomically:YES];


    [messages removeObjectAtIndex:indexPath.row];
    //  NSIndexPath *indexPath = [NSIndexPath indexPathWithIndex:index];

    [messageTableView beginUpdates];
    [messageTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject: indexPath]  withRowAnimation:UITableViewRowAnimationFade];
    [messageTableView endUpdates];

    [messageTableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:kMessageCell];

    CGFloat height = 0;

    CGFloat heightFactor = 200;
    CGFloat padding =200;

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        heightFactor = 400;
        padding = 200;
    }

    CGFloat fontSize = 12.0f;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        fontSize = 20.0f;
    }

    if ([(GymChat *)messages[indexPath.row] type] == GymMessageTypeText)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width-30, 15.0f)];
        label.text = [(GymChat *)messages[indexPath.row] text];

        label.font = [UIFont fontWithName:@"ProximaNova-Regular" size:fontSize];
        height = [Utility heightForLabel:label];
        //  NSLog(@"%f:dsss",height);

    }else{

        if (![[(GymChat *)messages[indexPath.row] text] isEqualToString:@""]) {

            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width-30, 15.0f)];
            label.text = [(GymChat *)messages[indexPath.row] text];
            label.font = [UIFont fontWithName:@"ProximaNova-Regular" size:fontSize];
            height = [Utility heightForLabel:label];
        }
        height = height+ heightFactor;
    }
    return padding + height;
}


- (void)sendTextMessage {

    messageTextField.text = [messageTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

     [messageTextField resignFirstResponder];
    if ([messageTextField.text isEqualToString:@""]) {
        return;
    }

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    MessageDataController *mDC = [MessageDataController new];

    NSDictionary *requestDictionary = @{@"message": messageTextField.text,
                                        @"isInstagram": @"No"};

    [mDC sendGymChatWithDictionary:requestDictionary andImage:nil withSuccess:^(User *user) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        //        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Message sent." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //        [alertView show];

        [self loadData];
        [messageTextField setText:@""];
        //        [messageTableV scrollBubbleViewToBottomAnimated:NO];
        [messageTableView setContentOffset:CGPointMake(0, 0) animated:YES];

    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];

    }];
}

#pragma mark - IBActions

- (IBAction)sendButtonPressed:(UIButton *)sender {
    [self sendTextMessage];
}



- (IBAction)addPicture:(id)sender{
    [self.view endEditing:YES];

    [gymChatBtn setImage:[UIImage imageNamed:@"gymchat_01.png"] forState:UIControlStateNormal];
    [photoBtn setImage:[UIImage imageNamed:@"gymchat_21.png"] forState:UIControlStateNormal];
    // [photoBtn setBackgroundColor:greenColor];
    // [gymChatBtn setBackgroundColor:grayColor];

    iPH = [[UIImagePickerHelper alloc]init];
    iPH.myAppdelegate = self;
    [iPH imagePickerInView:self.view WithSuccess:^(UIImage *image) {

        AddPictureViewController *aPVC;

        if ([[sender valueForKey:@"tag"] integerValue] == 0) {

            aPVC.isForInstagram = false;
            aPVC = [[AddPictureViewController alloc] initWithNibName:@"AddPictureViewController" bundle:nil];

        }else{

            aPVC.isForInstagram = true;
            aPVC = [[AddPictureViewController alloc] initWithNibName:@"AddGYMChatPictureViewController" bundle:nil];

        }

        [aPVC setImage:image];
        aPVC.isFromGymChat = true;

        [self.navigationController pushViewController:aPVC animated:YES];
        //
        //        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //
        //        [messageTextField resignFirstResponder];
        //
        //        MessageDataController *mDC = [MessageDataController new];
        //
        //        NSDictionary *requestDictionary = @{@"receiverid": [NSNumber numberWithInteger:self.userID]};
        //
        //        [mDC sendGymChatWithDictionary:requestDictionary andImage:image withSuccess:^(User *user) {
        //
        //            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        //
        //
        //
        //        } failure:^(NSError *error) {
        //
        //            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        //
        //            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //            [alertView show];
        //
        //        }];

    } failure:^(NSError *error) {

        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];

    }];
}

/*
-(void)enableGymChatAgain
{
    [gymChatBtn setImage:[UIImage imageNamed:@"gymchat_0.png"] forState:UIControlStateNormal];
    [photoBtn setImage:[UIImage imageNamed:@"gymchat_2.png"] forState:UIControlStateNormal];
    // [photoBtn setBackgroundColor:grayColor];
    // [gymChatBtn setBackgroundColor:greenColor];
} */



#pragma mark - UITextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
   // [self sendTextMessage];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Keyboard notifications

- (void)willShowKB:(NSNotification *)notification{

    //    NSDictionary *userInfo = [notification userInfo];
    //
    //    curveKB = [[userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    //    durationShowKB = [[userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    //    heightKB = [[userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    //
    //    CGRect frame = self.view.frame;
    //    frame.size.height -= heightKB;
    //
    //
    //    [UIView animateWithDuration:durationShowKB delay:0.0 options:curveKB animations:^{
    //        self.view.frame = frame;
    //    } completion:^(BOOL finished) {
    //
    //        [messageTableView scrollBubbleViewToBottomAnimated:NO];
    //    }];
    
}

- (void)willHideKB:(NSNotification *)notification{
    
    //    CGRect frame = self.view.frame;
    //    frame.size.height += heightKB;
    //    
    //    [UIView animateWithDuration:durationShowKB delay:0.0 options:curveKB animations:^{
    //        self.view.frame = frame;
    //    } completion:^(BOOL finished) {
    //        
    //    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
