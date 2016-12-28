//
//  TeamDetailsViewController.m
//  GYMatch
//
//  Created by Ram on 25/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "TeamDetailsViewController.h"
#import "UIImageView+WebCache.h"
#import "Utility.h"

@interface TeamDetailsViewController ()

@end

@implementation TeamDetailsViewController

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
    
    [self.navigationController setTitle:@"Team"];
    
    [self fillDetails];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fillDetails{
    nameLabel.text = self.aTeam.name;
    designation.text = self.aTeam.designation;
    description.text = self.aTeam.description;
    
    NSURL *imageURL = [NSURL URLWithString:[self.aTeam.image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [imageView  setImageWithURL:imageURL placeholderImage:[Utility placeHolderImage] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}

#pragma mark - IBActions

- (IBAction)doneButtonPressed:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
