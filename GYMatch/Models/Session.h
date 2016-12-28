//
//  Photo.h
//  GYMatch
//
//  Created by Ram on 18/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Session : NSObject{
}

@property (nonatomic, strong) NSString *bookingdate;
@property (nonatomic, strong) NSString *starttime;
@property (nonatomic, strong) NSString *endtime;
@property (nonatomic) NSInteger duration;
@property (nonatomic) NSInteger isSkype;
@property (nonatomic, strong) NSString *skypeId;
@property (nonatomic, strong) NSString *rate;
@property (nonatomic, strong) NSString *workoutType;
@property (nonatomic, strong) NSString *bodyParts;
@property (nonatomic, strong) NSString *trainingType;
@property (nonatomic) NSInteger isAccepted;
@property (nonatomic) NSInteger trainer_id;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
