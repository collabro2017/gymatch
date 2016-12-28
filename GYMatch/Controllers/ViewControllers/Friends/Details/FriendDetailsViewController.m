//
//  FriendDetailsViewController.m
//  GYMatch
//
//  Created by Ram Gautam on 11/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "FriendDetailsViewController.h"
#import "AlbumViewController.h"
#import "ChatViewController.h"
#import "InnerCircleViewController.h"
#import "AddGymViewController.h"
#import "ReportViewController.h"
#import "RecommendViewController.h"
#import "Friend.h"
#import "UIImageView+WebCache.h"
#import "UserDataController.h"
#import "MBProgressHUD.h"
#import "User.h"
#import "EditProfileViewController.h"
#import "Utility.h"
#import "CheckinViewController.h"
#import "UIImage+Overlay.h"
#import "GymChatViewController.h"

//#import "SpotlightDetailsViewController.h"
#import "FriendWithSpotlightViewController.h"
#import "EarningPointsViewController.h"
#import "MyPointsViewController.h"

#import "TGRImageViewController.h"
#import "TGRImageZoomAnimationController.h"
#import "Constants.h" // Gourav june 25


@interface FriendDetailsViewController () <UIViewControllerTransitioningDelegate>
{

}



@end

@implementation FriendDetailsViewController

- (id)init{
    
    NSString *nibName = @"FriendDetailsViewController";
    
    self = [self initWithNibName:nibName bundle:[NSBundle mainBundle]];
    
    if (self) {
        
    }
    
    return self;
}

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
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"Spostlight Member ID : %ld",(long)self.aFriend.member_id);

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithInteger:self.aFriend.member_id]  forKey:@"member_id"];
    
    [userDefaults synchronize];

    Spotlight_Detail_Btn.enabled=YES;
    bottomView.hidden=NO;
    
    [fitBoardBottomView setHidden:YES]; // Gourav june 30
    

    
    /*
    if ((int*)self.aFriend.member_id != Nil)
    {
        Spotlight_Detail_Btn.enabled=YES;
        bottomView.hidden=NO;
    }
    else
    {
        //Spotlight_Detail_Btn.backgroundColor=[UIColor lightGrayColor];
        Spotlight_Detail_Btn.enabled=NO;
         //bottomView.hidden=YES;
    }
    */
    
    
     Spotlight_Detail_Btn.enabled=YES;
    
    [self decorate];
    
  //  [self fillDetailsWithFriend:self.aFriend];
    
    [scrollView setContentInset:UIEdgeInsetsMake(0, 0, -50, 0)];
    [scrollView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, -50, 0)];
    
    [[self.view subviews][0] setHidden:YES];
    
    //mac
    //Spotlight_Detail_Btn.layer.cornerRadius=8.0f;
    
    //use 3 or 7 or 12 for symmetric look (current implementation supports max 12 buttons)
    NSArray *arrImageName = [[NSArray alloc] initWithObjects:@"avail-0",
                             @"avail-1",
                             @"avail-2",
                             nil];
    
    _iNumberOfButtons = arrImageName.count > 12 ? 12 : arrImageName.count;//current implementation supports max 12 buttons
    _arrButtonImageName = [[NSArray alloc] initWithArray:arrImageName];
    
    _strCornerButtonImageName = @"";
    _strCornerButtonImageName = @"";
    self.delegateCircularMenu = self;
    
    
    [self setupData];
    [self setTapGesture];
    [self setupButtons];
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    CGRect bottomRect = bottomView.frame;
    CGRect rect = self.btnGym.frame;
    rect.origin.x = (screenRect.size.width - rect.size.width) / 2;
    rect.origin.y = bottomRect.origin.y - 50;
    //self.btnGym.frame = rect;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageEnlarge:)];
    [imageView setUserInteractionEnabled:YES];
    [imageView addGestureRecognizer:gesture];


    editButton.hidden = YES;

    [self loadData];
}



- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];

   // [[[APP_DELEGATE tabBarController] tabBar] setHidden:YES];
    
    viewWidth.constant = self.view.frame.size.width;

    editButton.hidden = YES;

    if(self.aFriend.ID == [APP_DELEGATE loggedInUser].ID)
    {
        [self.navigationItem setTitle:@"My Profile"];
        bottomView.hidden = YES;
        [fitBoardBottomView setHidden:YES]; //yt7Jul
        editButton.hidden = NO;
    }
    else
    {
        NSString *title = @"My GYMatch";
        //NSString *title = [NSString stringWithFormat:@"%@ %@", self.aFriend.firstName, self.aFriend]

        //        NSString *title = (![self.aFriend.name isEqualToString:@""]) ? self.aFriend.name : self.aFriend.username;

        [self.navigationItem setTitle:[title substringToIndex:MIN(25, title.length)]];

        editButton.hidden = YES;

    }

    [self loadData];
}

-(void)imageEnlarge : (UITapGestureRecognizer *)gesture {
    
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    if ([presented isKindOfClass:TGRImageViewController.class]) {
        return [[TGRImageZoomAnimationController alloc] initWithReferenceImageView:imageView.image];
    }
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    if ([dismissed isKindOfClass:TGRImageViewController.class]) {
        return [[TGRImageZoomAnimationController alloc] initWithReferenceImageView:imageView.image];
    }
    return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)decorate
{

    CGFloat multiple = 1;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        multiple = 1.5;
    }
    
    aboutLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:13.0f * multiple];
    prefsLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:13.0f * multiple];
    myGymLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:13.0f * multiple];
    aboutMeLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:13.0f * multiple];
    descriptionLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:13.0f * multiple];

    pointsButton.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:13.0f * multiple];
    friendsButton.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:13.0f * multiple];
    picturesButton.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:13.0f * multiple];
    Spotlight_Detail_Btn.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:15.0f * multiple];
     chatBtn.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:15.0f * multiple];

    if (self.aFriend.ID == [APP_DELEGATE loggedInUser].ID) {
        addButton.hidden = YES;
        menuButton.hidden = YES;
    }
    
    // Gourav june 25 start
    if (self.aFriend.ID == GYMATCH_UNIVERSAL_ID)
    {
        addButton.hidden  = YES;
        menuButton.hidden = YES;
    }

    
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        bgImageHeight.constant = 410;
        profileImageHeight.constant = 195;
        profileImageTop.constant = 35;
        imageView.layer.cornerRadius = imageView.frame.size.width / 2;
        
        nameTop.constant = 35;
        genderTop.constant = 10;
        statusHeight.constant = 20;
        
        aboutTop.constant = 20;
        trainPrefsTop.constant = 20;
        myGymTop.constant = 20;
        checkInTop.constant = 30;
        
        [locationButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    }
    

    
}

- (void)fillDetailsWithFriend:(Friend *)aFriend{
    
    [friendsButton setImage:[[friendsButton imageForState:UIControlStateNormal]
                             imageWithColor:[Utility colorForBgTitle:aFriend.bgImage]]
                   forState:UIControlStateNormal];
    
    [friendsButton setImage:[[friendsButton imageForState:UIControlStateNormal]
                             imageWithColor:[Utility colorForBgTitle:aFriend.bgImage]]
                   forState:UIControlStateDisabled];
        
    [pointsButton setImage:[[pointsButton imageForState:UIControlStateNormal]
                             imageWithColor:[Utility colorForBgTitle:aFriend.bgImage]]
                   forState:UIControlStateNormal];
    
    [picturesButton setImage:[[picturesButton imageForState:UIControlStateNormal]
                             imageWithColor:[Utility colorForBgTitle:aFriend.bgImage]]
                    forState:UIControlStateNormal];
    
    [picturesButton setImage:[[picturesButton imageForState:UIControlStateNormal]
                              imageWithColor:[Utility colorForBgTitle:aFriend.bgImage]]
                    forState:UIControlStateDisabled];
    
    [Spotlight_Detail_Btn setImage:[[Spotlight_Detail_Btn imageForState:UIControlStateNormal]
                              imageWithColor:[Utility colorForBgTitle:aFriend.bgImage]]
                    forState:UIControlStateNormal];
    [Spotlight_Detail_Btn setImage:[[Spotlight_Detail_Btn imageForState:UIControlStateNormal]
                                    imageWithColor:[Utility colorForBgTitle:aFriend.bgImage]]
                          forState:UIControlStateDisabled];

    [chatBtn setImage:[[chatBtn imageForState:UIControlStateNormal]
                                    imageWithColor:[Utility colorForBgTitle:aFriend.bgImage]]
                          forState:UIControlStateNormal];
    [chatBtn setImage:[[chatBtn imageForState:UIControlStateNormal]
                       imageWithColor:[Utility colorForBgTitle:aFriend.bgImage]]
             forState:UIControlStateDisabled];


    //yt
    [gNotesBtn setImage:[[gNotesBtn imageForState:UIControlStateNormal]
                       imageWithColor:[Utility colorForBgTitle:aFriend.bgImage]]
             forState:UIControlStateNormal];
    [gNotesBtn setImage:[[gNotesBtn imageForState:UIControlStateNormal]
                       imageWithColor:[Utility colorForBgTitle:aFriend.bgImage]]
             forState:UIControlStateDisabled];

    [fitBoardBtn setImage:[[fitBoardBtn imageForState:UIControlStateNormal]
                           imageWithColor:[Utility colorForBgTitle:aFriend.bgImage]]
                 forState:UIControlStateNormal];

    [fitBoardBtn setImage:[[fitBoardBtn imageForState:UIControlStateNormal]
                       imageWithColor:[Utility colorForBgTitle:aFriend.bgImage]]
             forState:UIControlStateDisabled];


    //yt



    self.view.backgroundColor = [Utility colorForView:aFriend.bgImage];
    
    if((self.aFriend.ID == [APP_DELEGATE loggedInUser].ID)){
        [self.navigationItem setTitle:@"My Profile"];
    }else{
        NSString *title = @"My GYMatch";
        
//       NSString *title = (![self.aFriend.name isEqualToString:@""]) ? self.aFriend.name : self.aFriend.username;
        
        [self.navigationItem setTitle:[title substringToIndex:MIN(25, title.length)]];
    }
    
    nameLabel.text = (![aFriend.name isEqualToString:@""]) ? aFriend.name : aFriend.username;
    
    if (aFriend.age > 0) {
        genderLabel.text = [NSString stringWithFormat:@"%@, %ld",
                                 aFriend.gender,
                                 (long)aFriend.age];
    } else{
        genderLabel.text = aFriend.gender;
    }

    if([aFriend.name  isEqual:@"GYMatch"]){ //yt28July
        genderLabel.text = @"Fitness";
    }

    NSString *locText = aFriend.fullAddress;
    
    if ([aFriend.fullAddress isEqualToString:@""]) {
//        [locationImageView setHidden:YES];
        [locationButton setHidden:YES];
    
    }
    else{
//        [locationImageView setHidden:NO];
        [locationButton setHidden:NO];
        
    }
    
    cityLabel.text = locText;
    [locationButton setTitle:locText forState:UIControlStateNormal];
    
    statusLabel.text =
    ([aFriend.statusDetail isEqualToString:@"Public"]) ? aFriend.status : aFriend.statusDetail;
    
    NSArray *array = [aFriend arrayForTrainingPrefs];
    
    CGFloat height = [Utility showPrefs:array inView:prefsView withColor:[Utility colorForBgTitle:aFriend.bgImage]];

    CGRect rect = prefsView.frame;
    rect.size.height = height;
    prefsView.frame = rect;
    
    prefsHeight.constant = height;
    
    aboutMeLabel.text = aFriend.aboutMe;
    aboutHeight.constant = [Utility heightForLabel:aboutMeLabel];

    if (aFriend.pictureCount == 0 && aFriend.ID != [[APP_DELEGATE loggedInUser] ID]) {
        
        picturesButton.enabled = NO;
        
        [picturesButton setTitle:@"No Pictures" forState:UIControlStateNormal];
        
    }else{
        
        picturesButton.enabled = YES;
        
        NSString *string;
        
        if (aFriend.pictureCount == 1) {
            string = [NSString stringWithFormat:@"%ld Picture", (long)aFriend.pictureCount];
        }else{
            string = [NSString stringWithFormat:@"%ld Pictures", (long)aFriend.pictureCount];
        }
        
        [picturesButton setTitle:string forState:UIControlStateNormal];
        
    }
    
    if (aFriend.friendCount == 0) {
        
        friendsButton.enabled = NO;
        [friendsButton setTitle:@"No Friends" forState:UIControlStateNormal];
        
    }else{
        
        NSString *string;
        
        if (aFriend.friendCount == 1) {
            string = [NSString stringWithFormat:@"%ld Friend", (long)aFriend.friendCount];
        }else{
            string = [NSString stringWithFormat:@"%ld Friends", (long)aFriend.friendCount];
        }
        
        [friendsButton setTitle:string forState:UIControlStateNormal];
        
        friendsButton.enabled = YES;
        
    }
    
    if (aFriend.points < 300) {
        
//        pointsButton.enabled = NO;
        [pointsButton setTitle:[NSString stringWithFormat:@"%ld", (long)aFriend.points] forState:UIControlStateNormal];
        
    }else{
        
        [pointsButton setTitle:[NSString stringWithFormat:@"%ld", (long)aFriend.points] forState:UIControlStateNormal];
        
//        pointsButton.enabled = YES;
        
    }
    
    if (aFriend.ID != [APP_DELEGATE loggedInUser].ID) {
//        pointsButton.enabled = NO;
        
        checkInHeight.constant = 0;
    }

    checkInHeight.constant = 0;
    
    descriptionLabel.text = aFriend.gym.description;

    if (descriptionLabel.text == nil || descriptionLabel.text == @"") {


        descriptionLabel.text = @"Gym Not Known";

    }
    gymHeight.constant = [Utility heightForLabel:descriptionLabel] + 15.0f;

    NSInteger index = self.aFriend.isOnline;
     NSLog(@"%ld", (long)aFriend.isOnline);
    NSString *str = [NSString stringWithFormat:@"avail-%lD", (long)index];
    NSLog(@"%@",str);
    onlineImageView.image = [UIImage imageNamed:str];



//    onlineImageView.hidden = !aFriend.isOnline;
    
    [bgImageView setImage:[Utility imageForBgTitle:aFriend.bgImage]];
    
    NSURL *imageURL = [NSURL URLWithString:aFriend.image];
  //  if(profileImage == nil || profileImage != imageView.image)
  //  {
    [imageView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"user_plus"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  //  }
    myGymLabel.text = [NSString stringWithFormat:@"My %@", aFriend.gymType];

   /* if (descriptionLabel.text == nil) {

        myGymLabel.hidden = true;

    }
    else
    {

        myGymLabel.hidden = false;

    }*/

    if (aFriend.isFriend)
    {
        addButton.hidden = YES;
        if(self.aFriend.ID != [APP_DELEGATE loggedInUser].ID && self.aFriend.ID != GYMATCH_UNIVERSAL_ID)
        {
            editButton.hidden = YES;
            menuButton.hidden = NO;
        }
    }
    else
    {
        menuButton.hidden = YES;

        if (self.aFriend.ID != [APP_DELEGATE loggedInUser].ID && self.aFriend.ID != GYMATCH_UNIVERSAL_ID) {
            addButton.hidden = NO;
            menuButton.hidden = YES;
        }
    }

    if (aFriend.isBlocked || aFriend.didYouBlock)
    {
        addButton.hidden = YES;
        menuButton.hidden = YES;
    }



     viewHeight.constant = descriptionLabel.frame.origin.y + descriptionLabel.frame.size.height + 15.0f + 46.0f;

    [scrollView layoutIfNeeded];

}



- (void)loadData{

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    UserDataController *userDC = [UserDataController new];
    //Reference point
    [userDC profileDetails:self.aFriend.ID
            withSuccess:^(Friend *aFriend) {
        self.aFriend = aFriend;
        
                
        [self fillDetailsWithFriend:aFriend];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
                [[self.view subviews][0] setHidden:NO];
        
    } failure:^(NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}




#pragma mark - IBActions

- (IBAction)albumButtonPressed:(id)sender {
    
    AlbumViewController *aVC = [[AlbumViewController alloc]init];
    aVC.userID = self.aFriend.ID;
    [self.navigationController pushViewController:aVC animated:YES];
    
}

- (IBAction)innerCircleButtonPressed:(UIButton *)sender {

    InnerCircleViewController *iCVC = [[InnerCircleViewController alloc]init];
    iCVC.userID = self.aFriend.ID;
    [self.navigationController pushViewController:iCVC animated:YES];
}


-(void)showAlertMsgWithStr:(NSString*)str
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:str delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
     [alert show];

}

- (IBAction)messageButtonPressed:(UIButton *)sender
{
    if (self.aFriend.isBlocked && self.aFriend.isFriend)
    {
        if (self.aFriend.didYouBlock)
            [self showAlertMsgWithStr:@"You have blocked the user. To send message unblock from Requests."];
        else
            [self showAlertMsgWithStr:@"You have been blocked by the user."];

        return;
    }
    else if(!self.aFriend.isFriend)
    {
        [self showAlertMsgWithStr:@"Whoops, you are not friends! Please add user to send them a message."];
        return;
    }


    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        ChatViewController *mVC = [[ChatViewController alloc]init];
        mVC.user = self.aFriend;
        [self.navigationController pushViewController:mVC animated:YES];
    }
    else {
        [[[APP_DELEGATE tabBarController] tabBar] setHidden:NO];
        [[APP_DELEGATE tabBarController] setSelectedIndex:2];
        
        UISplitViewController *sVC = [[APP_DELEGATE tabBarController] viewControllers][2];

        TopNavigationController *tVC1 = [sVC viewControllers][0];
        MessagesViewController *mVC1 = (MessagesViewController*)[tVC1 topViewController];
        mVC1.currentSelectedFriend = self.aFriend;


        TopNavigationController *tVC = [sVC viewControllers][1];
        ChatViewController *cVC = (ChatViewController*)[tVC topViewController];
        cVC.user = self.aFriend;

        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.ID == %ld", (long)self.aFriend.ID];

        if (mVC1.friendsArray) {

            NSArray *results = [mVC1.friendsArray filteredArrayUsingPredicate:predicate];
            Friend *friend = [results firstObject];

            if (friend) {
                 mVC1.currentSelectedFriend = friend;
                 cVC.user = friend;

                NSInteger indexVal = [mVC1.friendsArray indexOfObject:friend];
                [mVC1 callTableSelectionMethod:indexVal];
            }


        }
        
    }
}

- (IBAction)reportButtonPressed:(id)sender {
    
    ReportViewController *rVC = [[ReportViewController alloc]init];
    rVC.userID = self.aFriend.ID;
    [self.navigationController pushViewController:rVC animated:YES];
}

- (IBAction)addButtonPressed:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    UserDataController *uDC = [UserDataController new];
    
    [uDC addFriend:self.aFriend.ID withSuccess:^{
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Your request has been sent successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alertView.tag = 50;
        [alertView show];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        [UIView animateWithDuration:0.3f animations:^{
            addButton.alpha = 0;
        }];
        
        
    } failure:^(NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];

    
//    AddGymViewController *aGVC = [[AddGymViewController alloc]init];
//    [self.navigationController pushViewController:aGVC animated:YES];
}

- (IBAction)recommedButtonPressed:(UIButton *)sender {
    
    RecommendViewController *rVC = [[RecommendViewController alloc]init];
    [self.navigationController pushViewController:rVC animated:YES];
    
}

- (IBAction)blockButtonPressed:(id)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Are you sure you want to block %@?", nameLabel.text] delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    alertView.tag = 10;
    [alertView show];
    
}

- (IBAction)unmatchButtonPressed:(id)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Are you sure you want to UnMatch %@?", nameLabel.text] delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    alertView.tag = 20;
    [alertView show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (alertView.tag == 50)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }

    switch (buttonIndex) {
        case 1:
            
            if (alertView.tag == 10) { // to BLOCK 
                
                AppDelegate *appdelgate = (AppDelegate*)[[UIApplication sharedApplication]delegate ];
                [MBProgressHUD showHUDAddedTo:appdelgate.window animated:YES];
                UserDataController *uDC = [UserDataController new];
                [uDC respond:self.aFriend.ID withResponse:@"block" withSuccess:^{
                    [MBProgressHUD hideAllHUDsForView:appdelgate.window animated:YES];
                    
                    [[[APP_DELEGATE tabBarController] viewControllers][0] popToRootViewControllerAnimated:NO];
                    [[APP_DELEGATE tabBarController] setSelectedIndex:0];
                    

//                
//                UserDataController *uDC = [UserDataController new];
//                [uDC respond:self.aFriend.ID withResponse:@"block" withSuccess:^{
//                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"User %@ blocked.", nameLabel.text] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                    [alertView show];
                } failure:^(NSError *error) {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alertView show];
                }];
                
            }
            else if (alertView.tag == 20) { // to UNMATCH
                
                AppDelegate *appdelgate = (AppDelegate*)[[UIApplication sharedApplication]delegate ];
                [MBProgressHUD showHUDAddedTo:appdelgate.window animated:YES];
                UserDataController *uDC = [UserDataController new];
                [uDC respond:self.aFriend.ID withResponse:@"unmatch" withSuccess:^{
                    [MBProgressHUD hideAllHUDsForView:appdelgate.window animated:YES];
                    
                    [[[APP_DELEGATE tabBarController] viewControllers][0] popToRootViewControllerAnimated:NO];
                    [[APP_DELEGATE tabBarController] setSelectedIndex:0];

                } failure:^(NSError *error) {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alertView show];
                }];
                
            }
            
            break;
            
        default:
            break;
    }
    
}

- (IBAction)editProfile:(id)sender{
   // [self removeViewWithAnimation];
    EditProfileViewController *ePVC = [[EditProfileViewController alloc] init];
    ePVC.user = self.aFriend;
    profileImage = imageView.image; 
    [self.navigationController pushViewController:ePVC animated:YES];
}

- (IBAction)menuButtonPressed:(UIButton *)sender{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Block",@"UnMatch", @"Report", nil];
    
    [actionSheet showFromRect:sender.frame inView:sender.superview animated:YES];
    
}

- (IBAction)checkinButtonPressed:(id)sender{
    GymChatViewController *cVC = [GymChatViewController new];
    [self.navigationController pushViewController:cVC animated:YES];
}

- (IBAction)pointsButtonPressed:(id)sender
{
//    NSURL *pointsURL = [NSURL URLWithString:SITE_URL_POINTS];
//    [[UIApplication sharedApplication] openURL:pointsURL];
    
//    EarningPointsViewController *earningPointsVC=[EarningPointsViewController new];
//    [self.navigationController pushViewController:earningPointsVC animated:YES];
    
    MyPointsViewController *myPointsVC = [MyPointsViewController new];
    myPointsVC.points = [NSString stringWithFormat:@"%ld",(long)self.aFriend.points];
    myPointsVC.oRefferalPointsStr = [NSString stringWithFormat:@"%ld",(long)self.aFriend.oReferralPoints];
    

    if(self.aFriend.ID == [APP_DELEGATE loggedInUser].ID)
    {

        myPointsVC.isSelfUser = YES;
    }
    else
    {

        myPointsVC.isSelfUser = NO;

    }
    
    [self.navigationController pushViewController:myPointsVC animated:YES];
}

#pragma mark - UIActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            // Block
            [self blockButtonPressed:nil];
            break;
        case 1:
            [self unmatchButtonPressed:nil];
            break;
        case 2:
            // Report
            [self reportButtonPressed:nil];
            break;
            
        case 3:
            // Cancel
            break;
            
        default:
            break;
    }
}


- (IBAction)Spotlight_Tapped:(id)sender
{
    
    NSLog(@"Spostlight Member ID : %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"]);
    
    
    //if ((int*)self.aFriend.member_id != Nil)
    
    if (([[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"]!= Nil) && ([[[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"] integerValue] >0))
        
    {
        FriendWithSpotlightViewController *viewController;
        
        //    Spotlight *spotLight = [[spotlights objectForKey:selectedType] objectAtIndex:indexPath.row];
        //    viewController = [[SpotlightDetailsViewController alloc]initWithSpotlight:spotLight];
        
        
        viewController = [[FriendWithSpotlightViewController alloc]init];
        
        viewController.Member_id=[[[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"] integerValue];
        
        [[[[[APP_DELEGATE tabBarController] viewControllers] objectAtIndex:3] friendNavigationBar] setHidden:YES];
        
        [self.navigationController pushViewController:viewController animated:YES];
        
        [[[APP_DELEGATE tabBarController] tabBar] setHidden:YES];
    }
    
    else
    {
        //         UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"This user has not purchased any spotlight until now." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        
        NSString *alertStr = [NSString stringWithFormat:@"%@ is not a Spotlight Member.",self.aFriend.name];
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:alertStr delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
    }
    
    
}


- (IBAction)avatar_Tapped:(id)sender
{
    
    if((self.aFriend.ID == [APP_DELEGATE loggedInUser].ID)){
//    circularMenuVC.containView = self.view;
        [self show];
    } else {
        _pictureView = [[AvatorViewController alloc] initWithNibName:@"AvatorViewController" bundle:nil];
        _pictureView.image = imageView.image;
        //[self.navigationController pushViewController:_pictureView animated:NO];
        [self.view addSubview:_pictureView.view];
        CATransition* transition = [CATransition animation];
        transition.duration = 0.5f;
        transition.type = kCATransitionFade;
        transition.subtype = kCATransitionFromRight;
        [_pictureView.view.window.layer addAnimation:transition forKey:kCATransition];
    }
}

-(void)setupData
{
    _fButtonSize = 40;//circular button width/height
    _fInnerRadius = 45;//1st circle boundary
}


-(void)setTapGesture
{
    _gestureRecognizerTap = [[UITapGestureRecognizer alloc]
                             initWithTarget:self action:@selector(handleSingleTap:)];
    _gestureRecognizerTap.cancelsTouchesInView = NO;
    _gestureRecognizerTap.delegate = self;
    [self.view addGestureRecognizer:_gestureRecognizerTap];
}


- (void)setupButtons
{
    //Corner button
    _buttonCorner = [UIButton buttonWithType:UIButtonTypeCustom];
    [_buttonCorner setImage:[UIImage imageNamed:_strCornerButtonImageName] forState:UIControlStateNormal];
    [_buttonCorner addTarget:self action:@selector(hideMenu:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonCorner setFrame:onlineImageView.frame];
    
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(avatorSingleTapped:)];
    singleTap.numberOfTapsRequired = 1;
    [avatorButton addGestureRecognizer:singleTap];
    
//    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(avatorDoubleTapped:)];
//    doubleTap.numberOfTapsRequired = 2;
//    [avatorButton addGestureRecognizer:doubleTap];
//    
//    [singleTap requireGestureRecognizerToFail:doubleTap];

    
    
    //setUpgseture on online imageview 10june
//    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onlineImageTapped:)];
//    [onlineImageView setUserInteractionEnabled:YES];
//    [singleTap setNumberOfTapsRequired:1];
//    [onlineImageView addGestureRecognizer:singleTap];
    
    //Circular menu buttons
    _arrButtons = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < _iNumberOfButtons; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTag:i];
        [button addTarget:self action:@selector(hideMenu:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:[_arrButtonImageName objectAtIndex:i]] forState:UIControlStateNormal];
        [button setFrame:onlineImageView.frame];
        button.imageView.contentMode = UIViewContentModeScaleToFill;
//        [button setBackgroundColor:[UIColor redColor]];
        [_arrButtons addObject:button];
    }
}



-(void)avatorSingleTapped:(UIGestureRecognizer *)tapGesture{
    NSLog(@"FriendDetailes Gesture is called");
    _pictureView = [[AvatorViewController alloc] initWithNibName:@"AvatorViewController" bundle:nil];
    _pictureView.image = imageView.image;
    //[self.navigationController pushViewController:_pictureView animated:NO];
    [self.view addSubview:_pictureView.view];
     [_pictureView.view setFrame:[[UIScreen mainScreen] bounds]];
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromRight;
    [_pictureView.view.window.layer addAnimation:transition forKey:kCATransition];
}

-(void)avatorDoubleTapped:(UIGestureRecognizer *)tapGesture{
    NSLog(@"Double Gesture is called");
    if((self.aFriend.ID == [APP_DELEGATE loggedInUser].ID)){
        [self show];
    }
}

#pragma mark - Show menu

-(void)show
{
    [self showButtons];
}

- (void)showButtons
{
    if (!flag) {
        [self.view addSubview:_buttonCorner];
        [_buttonCorner setUserInteractionEnabled:NO];  // Gourav july 03
        
        for (int index = 0; index < _iNumberOfButtons; index++)
        {
            UIButton *button = [_arrButtons objectAtIndex:index];
            button.center = CGPointMake(onlineImageView.frame.origin.x+10, onlineImageView.frame.origin.y+10);
            [scrollView addSubview:button];
        }
        
        [scrollView layoutIfNeeded];
        flag = true;
    } else {
        for (int index = 0; index < _iNumberOfButtons; index++)
        {
            UIButton *button = [_arrButtons objectAtIndex:index];
            button.hidden = NO;
        }
    }
            
     // Ensures that all pending layout operations have been completed
    
    [UIView animateWithDuration:0.4 animations:
     ^{
         onlineImageView.hidden = YES;
         [self setButtonFrames];
         [scrollView layoutIfNeeded]; // Forces the layout of the subtree animation block and then captures all of the frame changes
         imageView.layer.borderWidth = 5.0f;
         imageView.layer.borderColor = [[UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:0.6f] CGColor];
     }];
}

- (void)setButtonFrames
{
    CGPoint circleCenter = onlineImageView.frame.origin;
    
    //1st circle initialization
    float incAngle = ( 117/3 )*M_PI/180.0 ;
    float curAngle = 0.19;//more value more to left;
    float circleRadius = _fInnerRadius;
    
    for (int i = 0; i < _iNumberOfButtons; i++)
    {
        if(i == 3)//2nd circle
        {
            curAngle = 0.09;
            incAngle = ( 115/4 )*M_PI/180.0;
            circleRadius = _fInnerRadius +65;
        }
        else if(i == 7)//3rd circle
        {
            curAngle = 0.04;
            incAngle = ( 113/5 )*M_PI/180.0;
            circleRadius = _fInnerRadius +(65*2);
        }
        
        CGPoint buttonCenter;
        buttonCenter.x = circleCenter.x + cos(curAngle)*circleRadius;
        buttonCenter.y = circleCenter.y + sin(curAngle)*circleRadius;
        UIButton *button = [_arrButtons objectAtIndex:i];
        button.center = buttonCenter;
        curAngle += incAngle;
    }
}


#pragma mark - Remove menu

- (IBAction)hideMenu:(id)sender
{
    if (sender &&
        sender != _buttonCorner &&
        _delegateCircularMenu &&
        [_delegateCircularMenu respondsToSelector:@selector(circularMenuClickedButtonAtIndex:)])
    {
        UIButton *button = (UIButton*)sender;
        [_delegateCircularMenu circularMenuClickedButtonAtIndex:(int)button.tag];
    }
    
    [self removeViewWithAnimation];
}

- (IBAction)imageClicked:(id)sender {
    TGRImageViewController *viewController = [[TGRImageViewController alloc] initWithImage:imageView.image];
    viewController.transitioningDelegate = self;
    
    [self presentViewController:viewController animated:YES completion:nil];
}


- (void)removeViewWithAnimation
{
    [self.view layoutIfNeeded];
    
    [UIView animateWithDuration:0.3 animations:
     ^{
         imageView.layer.borderWidth = 3.0f;

         for (int index = 0; index < _iNumberOfButtons; index++)
         {
             UIButton *button = [_arrButtons objectAtIndex:index];
             button.center = CGPointMake(onlineImageView.frame.origin.x+12, onlineImageView.frame.origin.y+12);
         }
     }
      completion:^(BOOL finished)
     {  
         for (int index = 0; index < _iNumberOfButtons; index++)
         {
             UIButton *button = [_arrButtons objectAtIndex:index];
             button.hidden = YES;
         }
         onlineImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"avail-%d", clicked]];
         onlineImageView.hidden = NO;

         [self.indicatorBtn setUserInteractionEnabled:YES]; // Gourav july 03

     }];
}


#pragma mark - Tap gesture handling

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    //ingore touch for button at top left corner, let its touch up inside handler method handle that
    
    if(touch.view==onlineImageView)
        return YES;
    
    if ((touch.view == _buttonCorner))
        return NO;
    
    //ingore touch gesture for all menu button, let their touch up inside handler method handle that
    for (int index = 0; index < _iNumberOfButtons; index++)
    {
        UIButton *button = [_arrButtons objectAtIndex:index];
        
        if ((touch.view == button)) {
            clicked = index;
            if (!clicked)
                index = 3;
            UserDataController *uDC = [UserDataController new];
            
            NSString *arg = [NSString stringWithFormat:@"%d", index];
          //  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [uDC changeAvailable:arg  withSuccess:^{

             /*   [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Availability changed successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show]; */


            } failure:^(NSError *error) {

             /*   [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];  */ 
            }];
            
            return NO;
        }
    }
    
    return YES;
}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    //view was touched at point other than buttons
  //  [self removeViewWithAnimation];
}

// Gourav june 30 start

- (IBAction)gNotesBtnClicked:(id)sender {
    
      NSLog(@"gNotesBtnClicked Bttn Clicked");
}

- (IBAction)fitBoardBtnClicked:(id)sender {
    
    NSLog(@"Fit Board Bttn Clicked");
    
    GymChatViewController *fdvc = [[GymChatViewController alloc]init];
    [self.navigationController pushViewController:fdvc animated:NO];
    
    [[[APP_DELEGATE tabBarController] tabBar] setHidden:YES];
}

// Gourav june 30 end

- (IBAction)OnlineIndicatorClicked:(id)sender {

    NSLog(@"OnlineIndicatorClicked");

    [self.indicatorBtn setUserInteractionEnabled:NO];

    if((self.aFriend.ID == [APP_DELEGATE loggedInUser].ID)){
        //    circularMenuVC.containView = self.view;
        [self show];
    }
    
}

@end
