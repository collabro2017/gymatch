//
//  MapPin.h
//  aniima
//
//  Created by Ram on 11/09/13.
//  Copyright (c) 2013 Xtreem Solution Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapPin : NSObject <MKAnnotation>{
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
    int productIndex;
}
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;
@property (nonatomic, assign) int productIndex;

- (id)initWithCoordinates:(CLLocationCoordinate2D)location placeName:(NSString *)placeName description:(NSString *)description;

@end
