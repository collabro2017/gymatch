//
//  AddPictureViewController.m
//  GYMatch
//
//  Created by Ram on 31/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "AddPictureViewController.h"
#import "AlbumDataController.h"
#import "MBProgressHUD.h"
#import "MessageDataController.h"
#import "WebServiceController.h"

@interface AddPictureViewController (){
    BOOL isInstagramQueue;
}

@end

@implementation AddPictureViewController

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
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
    
    [self.navigationItem setTitle:@"Upload Picture"];
    [imageView setImage:self.image];

    CGFloat fontSize = 14.0f;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        fontSize = 16.0f;
    }
    captionTextField.font = [UIFont systemFontOfSize:fontSize];

    visibilityLabel.font = [UIFont fontWithName:@"ProximaNova-Light" size:16.0f];
    [visibilitySegmentedConrol setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"ProximaNova-Semibold" size:14.0f]} forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getRecentMedia) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    
    isInstagramQueue = NO;
    
    if (self.isFromGymChat) {
        visibilityLabel.hidden = YES;
        visibilitySegmentedConrol.hidden = YES;
    }else{
        visibilityLabel.hidden = NO;
        visibilitySegmentedConrol.hidden = NO;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBactions

- (IBAction)uploadGymatchButtonPressed:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (self.isFromGymChat) {
        [self addPictureGymChat];
    }
    else if (self.isFromGymChatComment) {
        [self addPictureGymChatInComment];
    }
    else {
        [self addPictureAlbum];
    }
    
}

- (void)addPictureAlbum{
    
    AlbumDataController *aDC = [AlbumDataController new];
    
    NSString *visibility = (visibilitySegmentedConrol.selectedSegmentIndex) ? @"0" : @"1";
    
    NSDictionary *requestDictionary = @{@"title": captionTextField.text,
                                        @"visibility": visibility};
    
    [aDC addWithDictionary:requestDictionary andImage:self.image withSuccess:^{
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Image uploaded successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
        alertView = nil;
    }];

}

- (void)addPictureGymChat{
    
    MessageDataController *mDC = [MessageDataController new];
    NSDictionary *requestDictionary = @{@"message": captionTextField.text};
    [mDC sendGymChatWithDictionary:requestDictionary andImage:self.image withSuccess:^(User *user) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
    }];
    
}


- (void)addPictureGymChatInComment {
    
    MessageDataController *mDC = [MessageDataController new];
    NSDictionary *requestDictionary = @{@"message": captionTextField.text};
    [mDC sendGymChatWithDictionary:requestDictionary andImage:self.image withSuccess:^(User *user) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
    }];
    
}

- (IBAction)uploadInstagramButtonPressed:(id)sender {
    
    if ([[APP_DELEGATE instagram] isSessionValid]) {
        [self shareInInstagram];
    }
    else{
        [APP_DELEGATE setInstagram:[[Instagram alloc] initWithClientId:@"a55bfb45bce54a358c3b005cc36e3716" delegate:self]];
        [[APP_DELEGATE instagram] authorize:[NSArray arrayWithObjects:@"basic", nil]];
    }
    
    
}

#pragma mark - Instagram -

- (void)igDidLogin{
    
    [[NSUserDefaults standardUserDefaults] setValue:@"Yes" forKey:@"isFromInstagram"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [[NSUserDefaults standardUserDefaults] setObject:appDelegate.instagram.accessToken forKey:@"accessToken"];
	[[NSUserDefaults standardUserDefaults] synchronize];
    
    [self shareInInstagram];
    
}

- (void)igDidLogout{
    
}

- (void)igDidNotLogin:(BOOL)cancelled{
    
}

-(void)shareInInstagram
{
    UIImage *imge = self.image;
    
    NSData *imageData = UIImagePNGRepresentation(imge); //convert image into .png format.
    
    NSFileManager *fileManager = [NSFileManager defaultManager];//create instance of NSFileManager
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //create an array and store result of our search for the documents directory in it
    
    NSString *documentsDirectory = [paths objectAtIndex:0]; //create NSString object, that holds our exact path to the documents directory
    
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"insta.igo"]]; //add our image to the path
    
    [fileManager createFileAtPath:fullPath contents:imageData attributes:nil]; //finally save the path (image)
    
    NSLog(@"image saved");
    
    CGRect rect = CGRectMake(0 ,0 , 0, 0);
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIGraphicsEndImageContext();
    NSString *fileNameToSave = [NSString stringWithFormat:@"Documents/insta.igo"];
    NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:fileNameToSave];
    NSLog(@"jpg path %@",jpgPath);
    NSString *newJpgPath = [NSString stringWithFormat:@"file://%@",jpgPath]; //[[NSString alloc] initWithFormat:@"file://%@", jpgPath] ];
    NSLog(@"with File path %@",newJpgPath);
    NSURL *igImageHookFile = [[NSURL alloc] initFileURLWithPath:newJpgPath];
    NSLog(@"url Path %@",igImageHookFile);
    
    self.dic = [self setupControllerWithURL:igImageHookFile usingDelegate:self];
    
    self.dic.UTI = @"com.instagram.exclusivegram";
    if (![captionTextField.text isEqualToString:@""] && captionTextField.text != nil) {
    
        self.dic.annotation = [NSDictionary dictionaryWithObject:captionTextField.text forKey:@"InstagramCaption"];
        
    }
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"instagram://"]]) {
        
        [self.dic presentOpenInMenuFromRect: rect    inView: self.view animated: YES ];
        
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Instagram App is not installed" message:@"You need to install Instagram App to share." delegate:self cancelButtonTitle:@"Later" otherButtonTitles:@"Install", nil];
        [alertView show];
    }
    
}



- (UIDocumentInteractionController *) setupControllerWithURL: (NSURL*) fileURL
                                               usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate {
    NSLog(@"file url %@",fileURL);
    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL: fileURL];
    interactionController.delegate = interactionDelegate;
    
    return interactionController;
}

- (void)documentInteractionController:(UIDocumentInteractionController *)controller didEndSendingToApplication:(NSString *)application{
    isInstagramQueue = YES;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)getRecentMedia
{
    if (!isInstagramQueue) {
        return;
    }
    
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.instagram.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    appDelegate.instagram.sessionDelegate = self;
    
    if ([appDelegate.instagram isSessionValid])
    {
        AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        appDelegate.instagram.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
        appDelegate.instagram.sessionDelegate = self;
        
        NSString *urlString = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/media/recent?access_token=%@", [appDelegate.instagram.accessToken stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURL *url = [NSURL URLWithString:urlString];
        
//        NSString *string = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSString *imageURL = [[obj valueForKeyPath:@"data"][0] valueForKeyPath:@"images.standard_resolution.url"];
        
        MessageDataController *mDC = [MessageDataController new];
        NSDictionary *requestDictionary = @{@"message": captionTextField.text,
                                            @"isInstagram": @(YES)};
        
        [mDC sendGymChatWithDictionary:requestDictionary andImage:self.image withSuccess:^(User *user) {
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            
        }];
        
//        
//        [WebServiceController callURLString:urlString withRequest:nil andMethod:@"GET" withSuccess:^(NSDictionary *responseDictionary) {
//            
//        } failure:^(NSError *error) {
//            
//        }];
        
    }
    else
    {
        
        [appDelegate.instagram authorize:[NSArray arrayWithObjects:@"basic", nil]];
        
    }
    
    isInstagramQueue = NO;
}

//- (void)getInstagramIDFinished:(ASIHTTPRequest *)request
//{
//    // Use when fetching text data
//    NSString *responseString = [request responseString];
//    NSMutableDictionary *responseJSON = [responseString JSONValue];
//    NSLog(@"Got Instagram Profile: %@", responseJSON);
//    instagramUserId=[[responseJSON valueForKey:@"data"] valueForKey:@"id"];
//    [[NSUserDefaults standardUserDefaults] setObject:instagramUserId forKey:@"instagramUserId"];
//	[[NSUserDefaults standardUserDefaults] synchronize];
//
//    [self getRecentMedia];
//    AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [app hideProgress];
//}

//- (void)getRecentMediaFinished:(ASIHTTPRequest *)request1
//{
//    // Use when fetching text data
//    NSString *responseString = [request1 responseString];
//    NSMutableDictionary *responseJSON = [responseString JSONValue];
//    //  NSLog(@"Got Instagram Media: %@", responseJSON);
//    self.instaDataArray=[responseJSON valueForKey:@"data"];
//    
//    AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [app showProgress];
//    NSMutableString *jsonTypeStr = [[NSMutableString alloc] init];
//    
//    [jsonTypeStr appendFormat:@"{\"details\":["];
//    NSString *userId= [[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"];
//    
//    for (int o=0; o<[self.instaDataArray count]; o++)//[allObjsWitness count]=2
//    {
//        [jsonTypeStr appendString:@"{"];
//        [jsonTypeStr appendFormat:@"\"appuserid\":\"%@\",",userId];
//        [jsonTypeStr appendFormat:@"\"instagramlink\":\"%@\",",[[[[self.instaDataArray valueForKey:@"images"] valueForKey:@"low_resolution"] valueForKey:@"url"] objectAtIndex:o]];
//        [jsonTypeStr appendFormat:@"\"instagramid\":\"%@\",",[[self.instaDataArray valueForKey:@"id"] objectAtIndex:o]];
//        [jsonTypeStr appendFormat:@"\"instagramtext\":\"\""];
//        [jsonTypeStr appendString:@"},"];
//    }
//    NSString* toTest = [jsonTypeStr substringFromIndex:[jsonTypeStr length]-1];
//    NSMutableString* jsonStr2 = [NSMutableString string];;
//    if ([toTest isEqualToString:@","])
//    {
//        jsonStr2 = [[jsonTypeStr substringToIndex:[jsonTypeStr length] - 1] mutableCopy];
//    }
//    else
//    {
//        //  [jsonStr2 appendString:@"["];
//    }
//    [jsonStr2 appendString:@"]}"];
//    
//    NSString *url = @"http://www.gymatch.com/Services/postinstagram";
//    NSData *postData = [jsonStr2 dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
//    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:300];
//    [request setHTTPMethod:@"POST"];
//    [request setValue:@"json" forHTTPHeaderField:@"Data-Type"];
//    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setHTTPBody:postData];
//    self.responseData = [NSMutableData dataWithContentsOfURL:[NSURL URLWithString:url]];
//    connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
//}

#pragma mark - UIAlertView -

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        
        case 1:
     
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/gb/app/instagram/id389801252?mt=8"]];
            break;
            
        default:
            break;
    }
    
}

@end
