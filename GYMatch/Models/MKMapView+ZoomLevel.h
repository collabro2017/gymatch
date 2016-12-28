//
//  MKMapView.h
//  GYMatch
//
//  Created by iPHTech2 on 12/10/15.
//  Copyright (c) 2015 xtreem. All rights reserved.
//

// MKMapView+ZoomLevel.h

#import <MapKit/MapKit.h>

@interface MKMapView (ZoomLevel)

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;
- (double)getZoomLevel;

@end