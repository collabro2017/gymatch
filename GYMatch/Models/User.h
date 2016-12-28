//
//  User.h
//  GYMatch
//
//  Created by Ram on 16/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Friend.h"

@interface User : Friend

@property(nonatomic, retain)NSString *password;
@property(nonatomic, assign)BOOL isRemeberOn;

- (NSDictionary *)dictionaryForLogin;

@end
