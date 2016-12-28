//
//  PlayerViewController.m
//  GYMatch
//
//  Created by Ram on 08/04/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "PlayerViewController.h"
#import "UIImageView+WebCache.h"

@interface PlayerViewController ()
{
    BOOL postToSocialMedia;
}
@end

@implementation PlayerViewController

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

    postToSocialMedia = NO;

    NSString *title = self.gtv.name;
    [self.navigationItem setTitle:[title substringToIndex:MIN(25, title.length)]];
    

    [self loadData];

    self.webView.delegate = self;
}

-(void)loadData
{
    if (self.gtv.type == GTVTypeTeaser || self.gtv.type == GTVTypeBlockbuster) {

        [self.webView loadHTMLString:[
                                      NSString stringWithFormat:@"<html><head>\
                                      <style type=\"text/css\">\
                                      body {\
                                      background-color: transparent;\
                                      color: white;\
                                      }\
                                      </style>\
                                      </head><body style=\"margin:0\">\
                                      <iframe width=\"%f\" height=\"%f\" src=\"%@\" frameborder=\"0\" allowfullscreen></iframe>\
                                      </body></html>",
                                      [[UIScreen mainScreen] bounds].size.width,
                                      [[UIScreen mainScreen] bounds].size.height,
                                      self.gtv.videoUrl
                                      ]
                             baseURL:nil];

        //  [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://gymatch.com/gnotes"]]];

    }else{

        switch (self.gtv.mediaType) {

            case MediaTypeTypeVideo:

                [self.webView loadHTMLString:[ NSString stringWithFormat:@"<html><head>\
                                              <style type=\"text/css\">\
                                              body {\
                                              background-color: transparent;\
                                              color: white;\
                                              }\
                                              </style>\
                                              </head><body style=\"margin:0\">\
                                              <iframe width=\"%f\" height=\"%f\" src=\"%@\" frameborder=\"0\" allowfullscreen></iframe>\
                                              </body></html>",
                                              [[UIScreen mainScreen] bounds].size.width,
                                              [[UIScreen mainScreen] bounds].size.height,
                                              self.gtv.videoUrl
                                              ]
                                     baseURL:nil];
                break;

            case MediaTypeTypeArticle:

                self.webView.hidden = YES;
                [self.textView setText:self.gtv.description];
                break;

            case MediaTypeTypeImage:

                self.webView.hidden = YES;
                self.textView.hidden = YES;

                NSString *imageURL = [NSString stringWithFormat:@"%@/uploads/photos/%@", SITE_URL, self.gtv.magzineImage];

                [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageURL]];

                break;

        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark-
#pragma mark UIWebViewDelegate Methods-

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{

    NSLog(@"Request:%@ Type**:%d", request, navigationType);

    if (navigationType == UIWebViewNavigationTypeFormSubmitted) {
        //[self loadData];
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{



}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{

    NSLog(@"Finished Loading");

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Faild Loading %@", error);

    if (error &&  error.userInfo) {

        if ([error.userInfo objectForKey:NSErrorFailingURLStringKey]) {
            NSString *val = [error.userInfo objectForKey:NSErrorFailingURLStringKey];
            if ([val hasPrefix:@"https://www.youtube.com"]) {
                [self loadData];
            }
        }
    }

}



@end
