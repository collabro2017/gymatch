//
//  LocatorViewController.h
//  GYMatch
//
//  Created by Ram on 02/04/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "GymFiltersViewController.h"


@interface LocatorViewController : UIViewController
<MKMapViewDelegate, UISearchBarDelegate, GymFilterDelegate>
{
    

    __weak IBOutlet MKMapView *mapView;
    
    __weak IBOutlet UISearchBar *searchBar;
    __weak IBOutlet UILabel *distanceLabel;
    __weak IBOutlet NSLayoutConstraint *distanceHeight;
}

@end
