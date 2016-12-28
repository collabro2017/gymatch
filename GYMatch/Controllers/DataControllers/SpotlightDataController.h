//
//  SpotlightDataController.h
//  GYMatch
//
//  Created by Ram on 23/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Spotlight.h"

@interface SpotlightDataController : NSObject


- (void)spotlightsWithType:(NSString *)type
                andKeyword:(NSString *)keyword
                   success:(void (^)(NSArray *friends))success
                   failure:(void (^)(NSError *error))failure;

- (void)spotlightsWithTypeDic:(NSString *)type
                andKeyword:(NSDictionary *)keyword
                   success:(void (^)(NSArray *friends))success
                   failure:(void (^)(NSError *error))failure;

- (void)spotlightDetails:(NSInteger)spotlightID
           withSuccess:(void (^)(Spotlight *aSpotlight))success
               failure:(void (^)(NSError *error))failure;

- (void)likeSpotlight:(NSInteger)spotlightID
             withLike:(BOOL)likeStatus
             withSuccess:(void (^)(void))success
              failure:(void (^)(NSError *error))failure;

- (void)rateSpotlight:(NSInteger)spotlightID
             withStar:(BOOL)totalStars
          withSuccess:(void (^)(NSString *))success
              failure:(void (^)(NSError *error))failure;

- (void)bookingTrainer:(NSDictionary *)requestDictionary withSuccess:(void (^)(NSDictionary *spotlight))success failure:(void (^)(NSError *error))failure;



- (void)spotlightsWithFilterDict:(NSMutableDictionary *)dict success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure;


// Dragon
- (void)getUserType:(NSDictionary *)requestDictionary withSuccess:(void (^)(NSDictionary *spotlight))success failure:(void (^)(NSError *error))failure;
- (void)sendBookingRequest:(NSDictionary *)requestDictionary withSuccess:(void (^)(NSDictionary *spotlight))success failure:(void (^)(NSError *error))failure;
- (void)getBookingRequest:(NSDictionary *)requestDictionary withSuccess:(void (^)(NSDictionary *spotlight))success failure:(void (^)(NSError *error))failure;
- (void)manageBookingRequest:(NSDictionary *)requestDictionary withSuccess:(void (^)(NSDictionary *spotlight))success failure:(void (^)(NSError *error))failure;
- (void)getManagedBookingRequest:(NSDictionary *)requestDictionary withSuccess:(void (^)(NSDictionary *spotlight))success failure:(void (^)(NSError *error))failure;
- (void)registerBooking:(NSDictionary *)requestDictionary withSuccess:(void (^)(NSDictionary *spotlight))success failure:(void (^)(NSError *error))failure;
- (void)getRegisteredBooking:(NSDictionary *)requestDictionary withSuccess:(void (^)(NSDictionary *spotlight))success failure:(void (^)(NSError *error))failure;
- (void)joinGYM:(NSDictionary *)requestDictionary withSuccess:(void (^)(NSDictionary *spotlight))success failure:(void (^)(NSError *error))failure;

@end
