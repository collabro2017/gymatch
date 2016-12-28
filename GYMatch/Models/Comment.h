//
//  Comment.h
//  GYMatch
//
//  Created by Ram on 09/05/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject

/// ID of message.
@property (nonatomic, assign)NSInteger ID;

/// Content of message: text/image.
@property (nonatomic, retain)NSString *content;

/// ID of sender or receiver.
@property (nonatomic, assign)NSInteger userID;

/// Image of sender or receiver.
@property (nonatomic, retain)NSString *userImage;

/// Name of sender or receiver.
@property (nonatomic, retain)NSString *username;

/// Name of sender or receiver.
@property (nonatomic, retain)NSString *name;

@property (nonatomic, retain)NSDate *date;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
