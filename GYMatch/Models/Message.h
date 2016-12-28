//
//  Message.h
//  GYMatch
//
//  Created by Ram on 27/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    MessageTypeText,
    MessageTypeImage
} MessageType;

@interface Message : NSObject

/// ID of message.
@property (nonatomic, assign)NSInteger ID;

/// Content of message: text/image.
@property (nonatomic, retain)NSString *content;

/// Type of message: text/image.
@property (nonatomic, assign)MessageType type;

/// ID of sender or receiver.
@property (nonatomic, assign)NSInteger userID;

/// Image of sender or receiver.
@property (nonatomic, retain)NSString *userImage;

/// User name.
@property (nonatomic, retain)NSString *userName;

/// User online status.
@property (nonatomic, assign)NSInteger userOnline;

/// BOOL value indicates whether the message is sent by user.
@property (nonatomic, assign)BOOL isSender;

@property (nonatomic, retain)NSDate *date;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
