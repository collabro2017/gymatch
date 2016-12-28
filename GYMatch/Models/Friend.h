//
//  Friend.h
//  GYMatch
//
//  Created by Ram on 17/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Gym.h"
#import "Message.h"
#import <CoreLocation/CoreLocation.h>

@interface Friend : NSObject

#pragma mark - Basic Details

@property (nonatomic, assign) NSInteger              member_id;
@property (nonatomic, assign) NSInteger              ID;
@property (nonatomic, retain) NSString               *firstName;
@property (nonatomic, retain) NSString               *lastName;
@property (nonatomic, retain) NSString               *name;
@property (nonatomic, retain) NSString               *username;
@property (nonatomic, retain) NSString               *email;
@property (nonatomic, retain) NSString               *gender;
@property (nonatomic, assign) NSInteger              age;
@property (nonatomic, retain) NSString               *image;
@property (nonatomic, retain) NSString               *bgImage;
@property (nonatomic, assign) NSInteger              isOnline;
@property (nonatomic, assign) BOOL                   isFromUS;
@property (nonatomic, retain) NSString               *address;
@property (nonatomic, retain) NSString               *fullAddress;
@property (nonatomic, retain) NSString               *location;
@property (nonatomic, retain) NSString               *city;
@property (nonatomic, retain) NSString               *state;
@property (nonatomic, retain) NSString               *country;
@property (nonatomic, assign) BOOL                   isFriend;
@property (nonatomic, assign) BOOL                   isBlocked;
@property (nonatomic, assign) BOOL                   didYouBlock;
@property (nonatomic, assign) NSInteger              isDeleted;
@property (nonatomic, assign) BOOL                   enabledPushNotification;
@property (nonatomic, retain) NSString               *userType;

// Trainging Preferences

@property (nonatomic, assign) BOOL                   aerobics;
@property (nonatomic, assign) BOOL                   camping;
@property (nonatomic, assign) BOOL                   cardio;
@property (nonatomic, assign) BOOL                   conditioning;
@property (nonatomic, assign) BOOL                   crossTraining;
@property (nonatomic, assign) BOOL                   cycling;
@property (nonatomic, assign) BOOL                   jogging;
@property (nonatomic, assign) BOOL                   martialArts;
@property (nonatomic, assign) BOOL                   pilates;
@property (nonatomic, assign) BOOL                   swimming;
@property (nonatomic, assign) BOOL                   weightTraining;
@property (nonatomic, assign) BOOL                   yoga;
@property (nonatomic, assign) BOOL                   dancing;
@property (nonatomic, assign) BOOL                   beachActivities;
@property (nonatomic, assign) BOOL                   mmaFitness;
@property (nonatomic, assign) BOOL                   gymnastics;

// Details
@property (nonatomic, retain) NSString               *status;
@property (nonatomic, retain) NSString               *gymType;
@property (nonatomic, retain) NSString               *statusDetail;
@property (nonatomic, retain) NSString               *aboutMe;
@property (nonatomic, assign) NSInteger              points;
@property (nonatomic, assign) NSInteger              oReferralPoints;
@property (nonatomic, assign) NSInteger              friendCount;
@property (nonatomic, assign) NSInteger              pictureCount;
@property (nonatomic, assign) NSInteger              unreadSentMessageCount;
@property (nonatomic, assign) NSInteger              unreadReceivedMessageCount;
@property (nonatomic, retain) Gym                    *gym;
@property (nonatomic, retain) Message                *lastMessage;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)stringForTrainingPreferences;
- (NSArray *)arrayForTrainingPrefs;

@end
