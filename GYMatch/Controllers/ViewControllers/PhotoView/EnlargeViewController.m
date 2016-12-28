//
//  EnlargeViewController.m
//  GYMatch
//
//  Created by iPHTech2 on 09/09/15.
//  Copyright (c) 2015 xtreem. All rights reserved.
//

#import "EnlargeViewController.h"

@interface EnlargeViewController ()

@end

@implementation EnlargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClicked:)];
    [self.view addGestureRecognizer:gesture];
    
    //[self.navigationController.navigationBar setHidden:YES];
    
    [self initposition];
    
    UIPinchGestureRecognizer *handlePinchGesture=[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    handlePinchGesture.delegate = self;
    [self.view addGestureRecognizer:handlePinchGesture];

}

-(void)viewClicked : (UITapGestureRecognizer *)gesture {
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:kCATransition];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"dismissEnlarge"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self dismissViewControllerAnimated:NO completion:nil];
    
}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) initposition {
    
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    screenRect.origin.y = 0;
    screenRect.size.height += 20;
    self.background.frame = screenRect;
    
    CGRect rect = self.avator.frame;
    CGRect win = [[UIScreen mainScreen] applicationFrame];
    win.size.width -= 10;
    win.size.height -= 20;
    
    if (self.image.size.width >= self.image.size.height)
    {
        rect.size.width = win.size.width;
        rect.size.height = (win.size.width/self.image.size.width)*self.image.size.height;
        
    } else {
        
        rect.size.height = win.size.height;
        rect.size.width = (win.size.height/self.image.size.height)*self.image.size.width;
    }
    
    rect.origin.x = (screenRect.size.width - rect.size.width) / 2;
    rect.origin.y = (screenRect.size.height -rect.size.height) / 2; //- 50;
    
    self.avator.frame = rect;
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    self.avator.image = self.image;
}


- (IBAction)handlePinch:(UIGestureRecognizer *)pinchGesture
{
    //NSLog(@"--qqq");
    
    if (UIGestureRecognizerStateBegan == pinchGesture.state ||
        UIGestureRecognizerStateChanged == pinchGesture.state) {
        
        // Use the x or y scale, they should be the same for typical zooming (non-skewing)
        float currentScale = [[self.avator.layer valueForKeyPath:@"transform.scale.x"] floatValue];
        
        // Variables to adjust the max/min values of zoom
        float minScale = 0.3;
        float maxScale = 4.0;
        float zoomSpeed = .8;
        
        float deltaScale = [(UIPinchGestureRecognizer *)pinchGesture scale];//pinchGesture.scale;
        
        // You need to translate the zoom to 0 (origin) so that you
        // can multiply a speed factor and then translate back to "zoomSpace" around 1
        deltaScale = ((deltaScale - 1) * zoomSpeed) + 1;
        
        // Limit to min/max size (i.e maxScale = 2, current scale = 2, 2/2 = 1.0)
        //  A deltaScale is 0.99 for decreasing or 1.01 for increasing
        //  A deltaScale of 1.0 will maintain the zoom size
        deltaScale = MIN(deltaScale, maxScale / currentScale);
        deltaScale = MAX(deltaScale, minScale / currentScale);
        
        CGAffineTransform zoomTransform = CGAffineTransformScale(self.avator.transform, deltaScale, deltaScale);
        self.avator.transform = zoomTransform;
        
        // Reset to 1 for scale delta's
        //  Note: not 0, or we won't see a size: 0 * width = 0
        [(UIPinchGestureRecognizer *)pinchGesture setScale:1];
        //pinchGesture.scale = 1;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer* )otherGestureRecognizer {
    return YES;
}

@end
