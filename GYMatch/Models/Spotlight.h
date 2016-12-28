//
//  Spotlight.h
//  GYMatch
//
//  Created by Ram on 23/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OperatingHour : NSObject

@property(nonatomic, assign)NSInteger opening;
@property(nonatomic, assign)NSInteger closing;

+ (NSArray *)operatingHoursFromDictionary:(NSDictionary *)dictionary;

@end

@interface Spotlight : NSObject

@property(nonatomic, assign)NSInteger ID;
@property(nonatomic, assign)NSInteger user_id;
@property(nonatomic, retain)NSString *name;
@property(nonatomic, retain)NSString *image;
@property(nonatomic, retain)NSString *backgroundImage;
@property(nonatomic, assign)CGFloat rate;
@property(nonatomic, assign)NSInteger likes;
@property(nonatomic, assign)BOOL isLiked;

// Details
@property(nonatomic, assign)NSInteger age;
@property(nonatomic, retain)NSString *gender;
@property(nonatomic, retain)NSString *type;

@property(nonatomic, retain)NSString *email;
@property(nonatomic, retain)NSString *address;
@property(nonatomic, retain)NSString *gym;
@property(nonatomic, retain)NSString *gymLocation;//location_gym_city
@property(nonatomic, retain)NSString *location_gym_city;
@property(nonatomic, retain)NSString *preferences;
@property(nonatomic, retain)NSString *hobbies;
@property(nonatomic, retain)NSString *bio;
@property(nonatomic, retain)NSString *desc;
@property(nonatomic, retain)NSString *education;

@property(nonatomic, retain)NSString *location;
@property(nonatomic, retain)NSString *location_city;
@property(nonatomic, retain)NSString *location_state;
@property(nonatomic, retain)NSString *location_us_state;

@property(nonatomic, retain)NSString *fbLink;
@property(nonatomic, retain)NSString *twitterLink;
@property(nonatomic, retain)NSString *instagramLink;
@property(nonatomic, retain)NSString *siteLink;
@property(nonatomic, retain)NSString *gymatchLink;

@property(nonatomic, retain)NSString *complementaryBenefitsImage;
@property(nonatomic, retain)NSString *QRCodeImage;
@property(nonatomic, retain)NSArray *discountsImage;
@property(nonatomic, retain)NSArray *operatingHours;
@property(nonatomic, retain)NSArray *halfPersonalTrainings;
@property(nonatomic, retain)NSArray *fullPersonalTrainings;
@property(nonatomic, retain)NSArray *team;
@property(nonatomic, retain)NSArray *owners;
@property(nonatomic, retain)NSString *clubLocations;//branches
@property(nonatomic, retain)NSArray *gymFeatures;//gymfeature
@property(nonatomic, retain)NSArray *gymBenefits;//gymfeature
@property(nonatomic, retain)NSString* countmyrate;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (id)initWithDetails:(NSDictionary *)dictionary;

@end
