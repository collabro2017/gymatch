//
//  RequestCell.m
//  GYMatch
//
//  Created by Ram Gautam on 10/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "RequestCell.h"
#import "Friend.h"
#import "UIImageView+WebCache.h"
#import "UserDataController.h"
#import "Utility.h"
#import "RequestsViewController.h"

@implementation RequestCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithFriend:(Friend *)aFriend{
    
    self = [super init];
    
    if (self) {
        [self fillWithFriend:aFriend];
    }
    
    return self;
}

- (void)awakeFromNib{
    
    CGFloat fontSize = 16.0f;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        fontSize = 20.0f;
    }
    
    self.userNameLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:fontSize];
}

- (void)fillWithFriend:(Friend *)aFriend{
    
    self.tag = aFriend.ID;
    
    self.imageView.layer.cornerRadius = 3.0f;
    
    self.userNameLabel.text = (![aFriend.name isEqualToString:@""]) ? aFriend.name : aFriend.username;
    
  //  genderLabel.text = [NSString stringWithFormat:@"%@, %d",aFriend.gender,aFriend.age];

    if (aFriend.age > 0) {
        genderLabel.text = [NSString stringWithFormat:@"%@, %ld",
                                 aFriend.gender,
                                 (long)aFriend.age];
    }
    else{
        genderLabel.text = aFriend.gender;
    }

    if([aFriend.name isEqualToString:@"GYMatch"]){
        genderLabel.text = @"Fitness";
    }

    self.locationLabel.text = aFriend.fullAddress;

    self.userLocationImageView.image = [self.userLocationImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.userLocationImageView setTintColor:DEFAULT_BG_COLOR];

    NSURL *imageURL = [NSURL URLWithString:[aFriend.image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [self.userImageView setImageWithURL:imageURL placeholderImage:[Utility placeHolderImage] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.declineButton.layer.borderColor = [[UIColor colorWithRed:(187.0f/255.0f) green:(187.0f/255.0f) blue:(187.0f/255.0f) alpha:1.0f] CGColor];
    self.declineButton.layer.borderWidth = 1.0f;
    
}

- (void)fillWithFBFriend:(NSDictionary<FBGraphUser> *)aFriend{
    self.tag = [aFriend.objectID integerValue];
    
    self.imageView.layer.cornerRadius = 3.0f;
    
    self.userNameLabel.text = aFriend.name;
    
//    self.genderLabel.text = aFriend.ge;
    
//    self.titlesLabel.text = [aFriend stringForTrainingPreferences];
    
//    NSString *imageName = aFriend.isOnline ? @"status" : @"status-offline";
//    [self.onlineImageView setImage:[UIImage imageNamed:imageName]];
    NSString *URLstring = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture", aFriend.objectID];
    NSURL *imageURL = [NSURL URLWithString:URLstring];
    [self.userImageView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"myprofile_icon"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}

#pragma mark - IBActions
/*

 

 
 */
- (IBAction)acceptButtonPressed:(UIButton *)sender {
    if ([self.dictionary[@"request_type"] isEqualToString:@"new_friend"]) {
        UserDataController *uDC = [UserDataController new];
        
        [uDC respond:self.tag withResponse:@"accept" withSuccess:^{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Request Accepted" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            
            [self.viewController loadData];
        } failure:^(NSError *error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }];
    } else {
        [self.delegate actionAccept:self.dictionary];
    }
}

- (IBAction)declineButtonPressed:(UIButton *)sender {
    if ([self.dictionary[@"request_type"] isEqualToString:@"new_friend"]) {
        UserDataController *uDC = [UserDataController new];
        NSLog(@"%ld", (long)self.tag);
        
        [uDC respond:self.tag withResponse:@"decline" withSuccess:^{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Request Declined" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            [self.viewController loadData];
            
        } failure:^(NSError *error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }];
    } else {
        [self.delegate actionDecline:self.dictionary];
    }
}

- (IBAction)unblockButtonPressed:(id)sender{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Are you sure, you want to Unblock %@",_userNameLabel.text] delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [alertView show];
}

-(void)unblockUser
{

    UserDataController *uDC = [UserDataController new];
    [uDC respond:self.tag withResponse:@"unblock" withSuccess:^{
        //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Successfully Unblocked" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //        [alertView show];

        [[[APP_DELEGATE tabBarController] viewControllers][0] popToRootViewControllerAnimated:NO];
        [[APP_DELEGATE tabBarController] setSelectedIndex:0];

        //        [self.viewController loadData];
    } failure:^(NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }];


}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (buttonIndex == 1) {

        [self unblockUser];
    }


}
@end
