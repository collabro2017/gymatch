//
//  Message.m
//  GYMatch
//
//  Created by Ram on 27/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "Message.h"
#import "Utility.h"

/*
 {
 "Message" : {
 "id" : "3",
 "image" : "",
 "text" : "Hello punter",
 "receiver_id" : "583",
 "sender_id" : "585"
 }
 }
 */

@implementation Message

- (id)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        NSDictionary *messageDict = [dictionary objectForKey:@"Chat"];
        
        self.ID = [[messageDict objectForKey:@"id"] integerValue];
        self.content = [messageDict objectForKey:@"text"];
        
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        [df setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

        NSString *createdDate = [messageDict objectForKey:@"created"];
        [Utility removeNSNULL:createdDate];
        
        if (createdDate != nil) {
            
            self.date = [df dateFromString:createdDate];
            
        }
        
        self.type = MessageTypeText;
        if ([self.content isEqualToString:@""]) {
            self.content = [messageDict objectForKey:@"image"];
            [Utility removeNSNULL:self.content];
            self.type = MessageTypeImage;
        }
        
        [Utility removeNSNULL:self.content];
        self.userID = [[messageDict objectForKey:@"receiverid"] integerValue]==0?[[messageDict objectForKey:@"appuser_id"] integerValue]:[[messageDict objectForKey:@"receiverid"] integerValue];
        self.userImage = [dictionary valueForKeyPath:@"Receiver.image"];
        self.isSender = YES;
        
        if (self.userID == [[APP_DELEGATE loggedInUser] ID]) {
            self.userID = [[messageDict objectForKey:@"appuser_id"] integerValue];
            self.userImage = [dictionary valueForKeyPath:@"Sender.image"];
            self.isSender = NO;
        }
        
        if (self.userImage == nil) {
            self.userImage = nil;
        }
        
        self.userName = [NSString stringWithFormat:@"%@ %@", [dictionary valueForKeyPath:@"Sender.firstname"], [dictionary valueForKeyPath:@"Sender.lastname"]];
        self.userOnline = [[dictionary valueForKeyPath:@"Sender.loginStatus"] integerValue];
    }
    return self;
}

@end
