//
//  Gym.m
//  GYMatch
//
//  Created by Ram on 17/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "Gym.h"
#import "Utility.h"

@implementation Gym

- (id)initWithName:(NSString *)name{
    self = [super init];
    if (self) {
        self.bizName = name;
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dictionary{
    
    self = [super init];
    
    if (self) {
        
        self.ID = [[dictionary objectForKey:@"id"] integerValue];
        
        self.bizName = [dictionary objectForKey:@"biz_name"];
        self.city = [dictionary objectForKey:@"e_city"];
        self.state = [dictionary objectForKey:@"e_state"];
        self.address = [dictionary objectForKey:@"e_address"];
        
        CGFloat latitude = 0.0,
        longitude = 0.0;

        if([dictionary objectForKey:@"loc_LAT_poly"] != [NSNull null])
            latitude = [[dictionary objectForKey:@"loc_LAT_poly"] floatValue];
        if([dictionary objectForKey:@"loc_LONG_poly"] != [NSNull null])
            longitude = [[dictionary objectForKey:@"loc_LONG_poly"] floatValue];

        if (latitude == 0.0 || longitude == 0.0) {

            if([dictionary objectForKey:@"latitude"] != [NSNull null])
                latitude = [[dictionary objectForKey:@"latitude"] floatValue];
            if([dictionary objectForKey:@"longitude"] != [NSNull null])
                longitude = [[dictionary objectForKey:@"longitude"] floatValue];

        }

        self.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        
        [self avoidNSNULLvalues];
        
    }
    
    return self;
    
}

- (NSString *)description{
    if (self.bizName == nil) {
        return nil;
    }
    
    if (self.city == nil && self.state == nil) {
        return self.bizName;
    }
    
    return [NSString stringWithFormat:@"%@, %@, %@", self.bizName, self.city, self.state];
}

- (void)avoidNSNULLvalues{
    
    [Utility removeNSNULL:self.bizName];
    [Utility removeNSNULL:self.city];
    [Utility removeNSNULL:self.state];
    [Utility removeNSNULL:self.address];
    
}
@end
