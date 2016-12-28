//
//  PictureViewController.m
//  GYMatch
//
//  Created by Ram on 28/07/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "PictureViewController.h"
#import "UIImageView+WebCache.h"
#import "AlbumDataController.h"
#import "MBProgressHUD.h"

@interface PictureViewController ()

@end

@implementation PictureViewController

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
    
    NSURL *imageURL = [NSURL URLWithString:self.thePhoto.image];
    [pictureView setImageWithURL:imageURL placeholderImage:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    if(_hideDeleteBtn)
        return;

    UIBarButtonItem *del_Button = [[UIBarButtonItem alloc] initWithCustomView:deleteButton];
   // [self.navigationItem setRightBarButtonItem:barButton];
    UIBarButtonItem *edit_Button = [[UIBarButtonItem alloc] initWithCustomView:editButton];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:del_Button, edit_Button, nil]];
}


#pragma mark - IBActions

- (IBAction)deleteButtonPressed:(id)sender{
    
    AlbumDataController *aDC = [AlbumDataController new];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [aDC deletePhoto:self.thePhoto.ID withSuccess:^{
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
       // [self.navigationController   performSelectorOnMainThread:@selector(popViewControllerAnimated:) withObject:[NSNumber numberWithBool:YES] waitUntilDone:NO];
         [self.navigationController  popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }];
}

- (IBAction)editButtonPressed:(id)sender{

    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Change Visibility" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Public", @"Private", nil];
      [actionSheet showInView:self.view];
  /*
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [aDC deletePhoto:self.thePhoto.ID withSuccess:^{

        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        // [self.navigationController   performSelectorOnMainThread:@selector(popViewControllerAnimated:) withObject:[NSNumber numberWithBool:YES] waitUntilDone:NO];
        [self.navigationController  popViewControllerAnimated:YES];

    } failure:^(NSError *error) {

        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }]; */
}

#pragma mark - Action Sheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *str = @"0";
    switch (buttonIndex)
    {
        case 0:
            str = @"1";//public
            break;

        case 1:
            str = @"0";//private
            break;

        default:
            return;
            break;
    }
    [self doneWithDictionary:str];
}


-(void)doneWithDictionary:(NSString *)visibilityStr
{
    NSString *idStr = [NSString stringWithFormat:@"%ld", (long)self.thePhoto.ID];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:idStr, @"id", visibilityStr, @"visibility", nil];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:nil];
    NSString *postLength = [NSString stringWithFormat:@"%ld", (unsigned long)[jsonData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    //  NSLog(@"ur %@", [NSString stringWithFormat:@"%@/get_access_logs.php",[Utility serverAddress]]);
    [request setURL:[NSURL URLWithString:@"http://www.jebcoolkids.com/gymatch_app/editphoto.php"]];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];

    [request setHTTPBody:jsonData];
    //print json:
    // NSLog(@"JSON Summary: %@", [[NSString alloc] initWithData:jsonData
    //                                                  encoding:NSUTF8StringEncoding]);
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [connection start];
    //  [self performSelectorOnMainThread:@selector(displayProgressView) withObject:nil waitUntilDone:NO];
}


#pragma mark- NSURLCONNECTION METHODS

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (!webData)
        webData = [[NSMutableData alloc] init];

    [webData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (!webData)
        webData = [[NSMutableData alloc] init];

    [webData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // NSString *urlStr = [[[connection originalRequest] URL] absoluteString];
    //   NSString *str = [[NSString alloc] initWithData:webData encoding:NSASCIIStringEncoding];
    // NSLog(@"str >>>>>>>>>>>>>>>>>>>>>+++++ %@",str);
    NSDictionary *allDatadictionary=[NSJSONSerialization JSONObjectWithData:webData options:0 error:nil];
    // NSLog(@" AllDatadictionary %@ >>>>>>>>>>>>>>>>>>>>>--------",allDatadictionary);
    //  NSLog(@"All data dictionary object for key  %@",  [allDatadictionary objectForKey:@"name"]);
    if (webData)
        webData = nil;

     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    int errorValue = [[allDatadictionary valueForKey:@"error_code"] intValue];
    if(errorValue==200 )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Successfully Updated." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else if (errorValue ==201)
    {
        NSLog(@"Not Updated.");
      //  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
       // [alert show];
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
