//
//  Likes.h
//  GYMatch
//
//  Created by Dev on 11/12/15.
//  Copyright © 2015 xtreem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Likes : NSObject

/// ID of message.
@property (nonatomic, assign)NSInteger ID;

/// ID of sender or receiver.
@property (nonatomic, assign)NSInteger userID;

/// Image of sender or receiver.
@property (nonatomic, retain)NSString *userImage;

/// Name of sender or receiver.
@property (nonatomic, retain)NSString *username;

/// Name of sender or receiver.
@property (nonatomic, retain)NSString *name;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
