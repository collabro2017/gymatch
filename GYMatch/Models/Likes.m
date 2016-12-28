//
//  Likes.m
//  GYMatch
//
//  Created by Dev on 11/12/15.
//  Copyright © 2015 xtreem. All rights reserved.
//

#import "Likes.h"
#import "Utility.h"

@implementation Likes
- (id)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    
    if (self) {
        //NSDictionary *messageDict = [dictionary objectForKey:@"sender"];
        //self.ID = [[messageDict objectForKey:@"id"] integerValue];
        
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
