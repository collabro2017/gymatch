//
//  MapPin.m
//  aniima
//
//  Created by Ram on 11/09/13.
//  Copyright (c) 2013 Xtreem Solution Pvt. Ltd. All rights reserved.
//

#import "MapPin.h"

@implementation MapPin

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;
@synthesize productIndex;

- (id)initWithCoordinates:(CLLocationCoordinate2D)location placeName:placeName description:description {
    if ([self isValidLocation:location]) {
        self = [super init];
        if (self != nil) {
            coordinate = location;
            title = placeName;
            subtitle = description;
            productIndex = -1;
        }
    }
    
    return self;
}

-(BOOL)isValidLocation:(CLLocationCoordinate2D)location{
    return YES;
    BOOL success = NO;
    if ((location.latitude >= -180 && location.latitude <= 180) && (location.longitude >= -90 && location.longitude <= 90)) {
        success = YES;
    }
    return success;
}

@end
