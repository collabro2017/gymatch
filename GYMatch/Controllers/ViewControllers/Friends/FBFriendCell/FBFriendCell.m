//
//  FBFriendCell.m
//  GYMatch
//
//  Created by Ram Gautam on 10/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "FBFriendCell.h"
#import "Friend.h"
#import "UIImageView+WebCache.h"
#import "UserDataController.h"
#import "Utility.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation FBFriendCell

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
    
    self.userNameLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:16.0f];
    
}

- (void)fillWithFBFriend:(NSDictionary<FBGraphUser> *)aFriend{
    self.tag = [aFriend.objectID integerValue];
    fbFriend = aFriend;
    self.imageView.layer.cornerRadius = 3.0f;
    
    self.userNameLabel.text = aFriend.name;
    
    self.genderLabel.text = [[aFriend valueForKey:@"gender"] capitalizedString];
    
//    self.titlesLabel.text = [aFriend stringForTrainingPreferences];
    
//    NSString *imageName = aFriend.isOnline ? @"status" : @"status-offline";
//    [self.onlineImageView setImage:[UIImage imageNamed:imageName]];
    NSString *URLstring = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture", aFriend.objectID];
    NSURL *imageURL = [NSURL URLWithString:URLstring];
    [self.userImageView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"user_plus"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}

#pragma mark - IBActions

- (void)shareLink{
    
    NSURL* url = [NSURL URLWithString:SITE_URL];
    [FBDialogs presentShareDialogWithLink:url
                                  handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                      if(error) {
                                          NSLog(@"Error: %@", error.description);
                                      } else {
                                          NSLog(@"Success!");
                                      }
                                  }];
}

- (IBAction)inviteButtonPressed:(id)sender{
    
//    [self shareLink];
//    
//    return;
    
    NSMutableDictionary* params =   [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     
                                     // Optional parameter for sending request directly to user
                                     // with UID. If not specified, the MFS will be invoked
                                     fbFriend.objectID, @"to",
                                     // Give the structured request information
//                                     @"send", @"action_type",
//                                     @"YOUR_OBJECT_ID", @"object_id",
                                     nil];
    
    [FBWebDialogs presentRequestsDialogModallyWithSession:nil  message:@"A new Mobile App! It's Health & Fitness meets Social Media! Download App today!"
     title:nil  parameters:params   handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
         
         if (error == nil) {
             
             UserDataController *udc = [UserDataController new];
             [udc fbInvite:fbFriend.objectID withSuccess:^{
               /*  UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 [alertView show]; */   

             } failure:^(NSError *error) {
                 
             }];
         }

     }
     ];
    
}

@end
