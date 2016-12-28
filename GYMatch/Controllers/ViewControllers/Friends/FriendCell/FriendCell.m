//
//  FriendCell.m
//  GYMatch
//
//  Created by Ram Gautam on 10/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "FriendCell.h"
#import "Friend.h"
#import "UIImageView+WebCache.h"
#import "UserDataController.h"
#import "Utility.h"

@implementation FriendCell

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

- (id)initWithFriend:(Friend *)aFriend {
    
    self = [super init];
    
    if (self) {
        [self fillWithFriend:aFriend];
    }
    
    return self;
}

- (void)awakeFromNib{
    //self.userNameLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:self.userNameLabel.font.pointSize];
    self.userNameLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:16.0f];
    
}

- (void)fillWithFriend:(Friend *)aFriend{


   

    [self.userImageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"user_plus"]];

    self.tag = aFriend.ID;
    
    self.imageView.layer.cornerRadius = 3.0f;
    
    self.userNameLabel.text = (![aFriend.name isEqualToString:@""]) ? aFriend.name : aFriend.username;
    
    if (aFriend.age > 0) {
        self.genderLabel.text = [NSString stringWithFormat:@"%@, %ld",
                                 aFriend.gender,
                                 (long)aFriend.age];
    }else{
        self.genderLabel.text = aFriend.gender;
    }

    if([aFriend.name isEqualToString:@"GYMatch"]){
        self.genderLabel.text = @"Fitness";
    }
//    
//    if ([aFriend.fullAddress isEqualToString:@""] || aFriend.fullAddress == nil) {
//        [self.locationImageView setHidden:YES];
//    } else{
//         [self.locationImageView setHidden:NO];
//        
//    }

    self.locationLabel.text = aFriend.fullAddress;
    self.onlineImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"avail-%lD", (long)aFriend.isOnline]];

    NSURL *imageURL = [NSURL URLWithString:aFriend.image];

    [self.userImageView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"user_plus"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    NSArray *prefs = [aFriend arrayForTrainingPrefs];
    
    if ([prefs count] > 0) {
        self.pref1Label.text = prefs[0];
        [Utility adjustWidth:self.pref1Label];
        [self.pref1Label setHidden:NO];
    }else{
        [self.pref1Label setHidden:YES];
    }

    CGRect rectUserName  = self.userNameLabel.frame;
    rectUserName.size.width = self.pref1Label.frame.origin.x - rectUserName.origin.x - 2;
    self.userNameLabel.frame = rectUserName;


    if ([prefs count] > 1) {
        self.pref2Label.text = prefs[1];
        [Utility adjustWidth:self.pref2Label];
        [self.pref2Label setHidden:NO];
    }else{
        [self.pref2Label setHidden:YES];
    }
    
    if ([prefs count] > 2) {
        self.pref3Label.text = prefs[2];
        [Utility adjustWidth:self.pref3Label];
        [self.pref3Label setHidden:NO];
    }
    else {
        //[self.locationLabel sizeToFit];
        //[Utility adjustWidth:self.locationLabel];
        [self.pref3Label setHidden:YES];
    }
    self.locationImageView.image = [self.locationImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.locationImageView setTintColor:DEFAULT_BG_COLOR];

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
    [self.userImageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"user_plus"]];
}


@end
