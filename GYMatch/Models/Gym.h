//
//  Gym.h
//  GYMatch
//
//  Created by Ram on 17/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Gym : NSObject

@property(nonatomic, assign)NSInteger ID;
@property(nonatomic, retain)NSString *bizName;
@property(nonatomic, retain)NSString *city;
@property(nonatomic, retain)NSString *state;
@property(nonatomic, retain)NSString *address;
@property(nonatomic, assign)CLLocationCoordinate2D coordinate;

- (id)initWithName:(NSString *)name;

- (NSString *)description;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
