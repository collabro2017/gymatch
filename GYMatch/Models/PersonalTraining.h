//
//  PersonalTraining.h
//  GYMatch
//
//  Created by Ram on 25/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    PersonalTrainingHourTypeFull,
    PersonalTrainingHourTypeHalf
} PersonalTrainingHourType;

@interface PersonalTraining : NSObject

@property(nonatomic, assign)NSInteger ID;
@property(nonatomic, assign)NSInteger hour;
@property(nonatomic, assign)PersonalTrainingHourType type;
@property(nonatomic, assign)CGFloat rate;

- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (NSArray *)halfTrainingsFromArray:(NSArray *)array;
+ (NSArray *)fullTrainingsFromArray:(NSArray *)array;

@end
