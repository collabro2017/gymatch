//
//  CheckinViewController.h
//  GYMatch
//
//  Created by Ram on 06/05/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface CheckinViewController : UIViewController
<CLLocationManagerDelegate>
{
    __weak IBOutlet UIButton *addressLabel;
    __weak IBOutlet MKMapView *mapView;
    __weak IBOutlet UIButton *doneButton;
}
@end
