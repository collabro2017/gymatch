//
//  Comment.m
//  GYMatch
//
//  Created by Ram on 09/05/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "Comment.h"
#import "Utility.h"

@implementation Comment

- (id)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    
    if (self) {
    
        NSDictionary *messageDict = [dictionary objectForKey:@"Postmcomment"];
        
        self.ID = [[messageDict objectForKey:@"id"] integerValue];
        
        self.content = [[messageDict objectForKey:@"description"] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
        
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        [df setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        
        self.date = [df dateFromString:[messageDict objectForKey:@"created"]];
        
        self.content = [Utility removeNSNULL:self.content];
        
        self.userID = [[dictionary valueForKeyPath:@"sender.id"] integerValue];
        self.userImage = [dictionary valueForKeyPath:@"sender.image"];
        self.userImage = [Utility removeNSNULL:self.userImage];
        
        self.name = [dictionary valueForKeyPath:@"sender.firstname"];
        self.name = [Utility removeNSNULL:self.name];
        self.username = [dictionary valueForKeyPath:@"sender.username"];
        self.username = [Utility removeNSNULL:self.username];
        
    }
    return self;
}

@end
