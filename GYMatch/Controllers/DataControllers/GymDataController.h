//
//  GymDataController.h
//  GYMatch
//
//  Created by Ram on 02/04/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Gym.h"

@interface GymDataController : NSObject

- (void)gymsWithCoordinate:(CLLocationCoordinate2D )coordinate
                  distance:(NSInteger)dist
                   success:(void (^)(NSArray *friends))success
                   failure:(void (^)(NSError *error))failure;

- (void)addWithDictionary:(NSDictionary *)requestDictionary
              withSuccess:(void (^)(Gym *gym))success
                  failure:(void (^)(NSError *error))failure;

- (void)gymsWithKeyword:(NSString *)keyword
                success:(void (^)(NSArray *friends))success
                failure:(void (^)(NSError *error))failure;

- (void)gymWithKeyword:(NSString *)keyword
                  city:(NSString *)city
                 state:(NSString *)state
               country:(NSString *)country
               success:(void (^)(NSArray *friends))success
               failure:(void (^)(NSError *error))failure;

- (void)locateGymWithKeyword:(NSString *)keyword
                     success:(void (^)(NSArray *friends))success
                     failure:(void (^)(NSError *error))failure;

@end
