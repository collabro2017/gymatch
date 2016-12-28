//
//  User.m
//  GYMatch
//
//  Created by Ram on 16/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "User.h"

@implementation User

- (NSDictionary *)dictionaryForLogin{
    
    NSString *token;
    
    if ([APP_DELEGATE deviceToken] != nil) {
        token = [APP_DELEGATE deviceToken];
    }
    else {
        token = @"NO_TOKEN";
    }
    
    NSDictionary *dict = @{
                           @"username": self.username,
                           @"password": self.password,
                           @"device_token": token,
                           @"device_os": @"iOS",
                           @"remember_me": [NSNumber numberWithBool:self.isRemeberOn]
                           };
    
    return dict;
}

@end
