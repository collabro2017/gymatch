//
//  GymChat.h
//  GYMatch
//
//  Created by Ram on 04/04/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    GymMessageTypeText,
    GymMessageTypeImage
} GymMessageType;

@interface GymChat : NSObject

/// ID of message.
@property (nonatomic, assign)NSInteger ID;

/// Content of message: text.
@property (nonatomic, retain)NSString *text;

/// Content of message: image.
@property (nonatomic, retain)NSString *image;

/// Type of message: text/image.
@property (nonatomic, assign)GymMessageType type;

/// ID of sender or receiver.
@property (nonatomic, assign)NSInteger userID;

/// Image of sender or receiver.
@property (nonatomic, retain)NSString *userImage;

/// Name of sender or receiver.
@property (nonatomic, retain)NSString *username;

/// Name of sender or receiver.
@property (nonatomic, retain)NSString *name;

@property (nonatomic, assign)BOOL isSender;

/// BOOL value indicates whether user liked or not.
@property (nonatomic, assign)BOOL isLike;

@property (nonatomic, assign)BOOL isInstagram;

@property (nonatomic, assign)NSInteger totalLikes;

@property (nonatomic, assign)NSInteger totalComments;

@property (nonatomic, retain)NSDate *date;

- (id)initWithDictionary:(NSDictionary *)dictionary;
@end
