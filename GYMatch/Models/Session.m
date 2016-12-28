//
//  Photo.m
//  GYMatch
//
//  Created by Ram on 18/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "Session.h"

@implementation Session

- (id)initWithDictionary:(NSDictionary *)dictionary{
    self = [self init];
    
    if (self) {
        _bookingdate = [dictionary objectForKey:@"date"];
        _starttime = [dictionary objectForKey:@"start_time"];
        _endtime = [dictionary objectForKey:@"end_time"];
        _duration = [[dictionary objectForKey:@"duration"] integerValue];
        _isSkype = [[dictionary objectForKey:@"is_skype"] integerValue];
        _skypeId = [dictionary objectForKey:@"skype_id"];
        _rate = [dictionary objectForKey:@"rate"];
        _workoutType = [dictionary objectForKey:@"workout_type"];
        _bodyParts = [dictionary objectForKey:@"body_parts"];
        _isAccepted = [[dictionary objectForKey:@"is_accepted"] integerValue];
        _trainer_id = [[dictionary objectForKey:@"trainer_id"] integerValue];
        _trainingType = [dictionary objectForKey:@"duration_unit"];
        [self avoidNSNULLvalues];
        
        
    }
    
    return self;
}


- (void)avoidNSNULLvalues{
    
    if ([_bookingdate isMemberOfClass:[NSNull class]]) {
        _bookingdate = nil;
    }
    
    if ([_starttime isMemberOfClass:[NSNull class]]) {
        _starttime = nil;
    }
    
    if ([_endtime isMemberOfClass:[NSNull class]]) {
        _endtime = nil;
    }
    
    
}


@end
