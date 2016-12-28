//
//  GymChat.m
//  GYMatch
//
//  Created by Ram on 04/04/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "GymChat.h"
#import "Utility.h"

@implementation GymChat

- (id)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        NSDictionary *messageDict = [dictionary objectForKey:@"Postmessage"];
        
        @try {
            self.ID = [[messageDict objectForKey:@"id"] integerValue];
            self.totalLikes = [[messageDict objectForKey:@"total_likes"] integerValue];
            self.totalComments = [[messageDict objectForKey:@"total_comments"] integerValue];
            self.isInstagram = [[messageDict objectForKey:@"isInstagram"] boolValue];
            self.isLike = [[messageDict objectForKey:@"is_like"] boolValue];
            
            self.text = [[messageDict objectForKey:@"message"] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
            
            NSDateFormatter *df = [[NSDateFormatter alloc]init];
            [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            [df setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
            
            self.date = [df dateFromString:[messageDict objectForKey:@"created"]];
            
            self.text = [Utility removeNSNULL:self.text];
            self.type = GymMessageTypeText;
            self.image = [messageDict objectForKey:@"image"];
            self.image = [Utility removeNSNULL:self.image];
            if (self.image != nil && ![self.image isEqualToString:@""]) {
                
                self.type = GymMessageTypeImage;
                
            }
            
            
            
            self.userImage = [dictionary valueForKeyPath:@"Sender.image"];
            self.userImage = [Utility removeNSNULL:self.userImage];
            
            //self.userID = [[dictionary valueForKeyPath:@"Sender.id"] integerValue];//Lekha
            
            if ([NSNull null] != [dictionary valueForKeyPath:@"Sender.id"]) {
                self.userID = [[NSString stringWithFormat:@"%@", [dictionary valueForKeyPath:@"Sender.id"]] integerValue];
            }
            
            self.name = [dictionary valueForKeyPath:@"Sender.firstname"];
            self.name = [Utility removeNSNULL:self.name];
            self.username = [dictionary valueForKeyPath:@"Sender.username"];
            self.username = [Utility removeNSNULL:self.username];
            self.isSender = YES;
            
            if (self.userID == [[APP_DELEGATE loggedInUser] ID]) {
                self.isSender = NO;
            }
        }
        @catch (NSException *exception) {
            [Utility showAlertMessage:exception.debugDescription];
        }
    }
    return self;
}

@end
