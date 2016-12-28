//
//  UIImageCropper.m
//  GYMatch
//
//  Created by User on 12/8/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "UIImageCropper.h"

@interface UIImageCropper ()

@end

@implementation UIImageCropper

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
    // Do any additional setup after loading the view.
    
    _cropImageView = [[KICropImageView alloc] initWithFrame:self.view.bounds];
    [_cropImageView setCropSize:CGSizeMake(200, 200)];
    [_cropImageView setImage:self.cropImg];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:_cropImageView];
    
    self.navigationItem.title = @"Scale & Crop";
    
    UIBarButtonItem *btnSave = [[UIBarButtonItem alloc]
                                initWithTitle:@"Crop & Save"
                                style:UIBarButtonItemStyleDone
                                target:self
                                action:@selector(aa)];

    self.navigationItem.rightBarButtonItem = btnSave;
    
    
    
    [self.navigationController.navigationBar setBackgroundColor:[UIColor redColor]];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat width = screenSize.width;
    CGFloat height = screenSize.height;
    UIButton* btnSave1 = [[UIButton alloc] initWithFrame:CGRectMake(width * 0.6, height * 0.9, width * 0.3, height * 0.08)];
    [btnSave1 setBackgroundColor:[UIColor clearColor]];
    [btnSave1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btnSave1 setTitle:@"Save" forState:UIControlStateNormal];
    [btnSave1 addTarget:self action:@selector(aa) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSave1];
    
    UIButton* btnCanel = [[UIButton alloc] initWithFrame:CGRectMake(width * 0.1, height * 0.9, width * 0.3, height * 0.08)];
    [btnCanel setBackgroundColor:[UIColor clearColor]];
    [btnCanel setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [btnCanel setTitle:@"Cancel" forState:UIControlStateNormal];
    [btnCanel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnCanel];

    

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UIImageView *imTouchView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"touch1"]];
    imTouchView.frame = CGRectMake(self.view.frame.size.width-110.0f, self.view.frame.size.height-125.0f, 120.0f, 135.0f);
    [self.view addSubview:imTouchView];
    imTouchView.alpha = 0.0f;
    
    [UIView animateWithDuration:1.0
        delay:0.8
        options:UIViewAnimationCurveEaseIn
        animations:^{
            imTouchView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:3.0
            delay:3
            options:UIViewAnimationCurveEaseOut
            animations:^{
            imTouchView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (void)aa {
    
    UIImage *img = [_cropImageView cropImage];

    [self.pickerCtrl done:img];

//    NSData *data = UIImagePNGRepresentation([_cropImageView cropImage]);
//    [data writeToFile:[NSString stringWithFormat:@"%@/Documents/test.png", NSHomeDirectory()] atomically:YES];

}

-(void) cancel{
    [self.pickerCtrl done:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
