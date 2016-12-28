//
//  CheckinViewController.m
//  GYMatch
//
//  Created by Ram on 06/05/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "CheckinViewController.h"
#import "MBProgressHUD.h"
#include "UserDataController.h"

@interface CheckinViewController (){
    
    // Location
    CLLocationManager *locationManger;
    CLLocationCoordinate2D coordinate;
    CLGeocoder *geoCoder;
    CLPlacemark *placemark;
    
}

@end

@implementation CheckinViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationItem setTitle:@"Check In"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    UIBarButtonItem *barBI = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    
    [self.navigationItem setRightBarButtonItem:barBI];
    doneButton.hidden = YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self startLocationUpdate];
}

- (void)startLocationUpdate{
    
    locationManger = [[CLLocationManager alloc]init];
    
    geoCoder = [[CLGeocoder alloc] init];
    
    locationManger.delegate = self;
    locationManger.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManger startUpdatingLocation];
    
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    if (error.code == kCLErrorDenied) {
        [errorAlert setTitle:nil];
        [errorAlert setMessage:@"Enable Location Service from Settings -> Privacy -> Location -> GYMatch."];
    }
    
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        coordinate = currentLocation.coordinate;
        
        
        mapView.region = MKCoordinateRegionMakeWithDistance(coordinate, 10000, 10000);
    
        // Reverse Geocoding
        NSLog(@"Resolving the Address");
        
        [APP_DELEGATE loggedInUser].coordinate = coordinate;
        
        [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
            if (error == nil && [placemarks count] > 0) {
                placemark = [placemarks lastObject];
                addressLabel.titleLabel.text = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                                     placemark.subThoroughfare, placemark.thoroughfare,
                                     placemark.postalCode, placemark.locality,
                                     placemark.administrativeArea,
                                     placemark.country];
                
                [APP_DELEGATE loggedInUser].city = (placemark.locality == nil) ? placemark.thoroughfare : placemark.locality;
                
                [APP_DELEGATE loggedInUser].state = placemark.administrativeArea;
                
                [APP_DELEGATE loggedInUser].country = placemark.country;
                
                
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
                doneButton.hidden = NO;
                
            } else {
                NSLog(@"%@", error.debugDescription);
                
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }
        }];
        [locationManger stopUpdatingLocation];
        
    }
}

#pragma mark - IBActions

- (IBAction)doneButtonPressed:(id)sender{
    
    doneButton.enabled = NO;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *requestDictionary = [NSMutableDictionary dictionary];
    
    [requestDictionary setObject:[NSNumber numberWithDouble:[APP_DELEGATE loggedInUser].coordinate.latitude] forKey:@"latitude"];
    [requestDictionary setObject:[NSNumber numberWithDouble:[APP_DELEGATE loggedInUser].coordinate.longitude] forKey:@"longitude"];
    [requestDictionary setObject:[APP_DELEGATE loggedInUser].state forKey:@"state"];
    [requestDictionary setObject:[APP_DELEGATE loggedInUser].city forKey:@"city"];
    [requestDictionary setObject:[APP_DELEGATE loggedInUser].country forKey:@"country"];
    
    UserDataController *uDC = [UserDataController new];
    
    [uDC checkinWithDictionary:requestDictionary withSuccess:^{
        
        //        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        
        
        //        [uDC profileDetails:[APP_DELEGATE loggedInUser].ID withSuccess:^(Friend *aFriend) {
        //            [APP_DELEGATE setLoggedInUser:(User *)aFriend];
        //            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Check In successful" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
        //        } failure:^(NSError *error) {
        //            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //            [alertView show];
        //        }];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        doneButton.enabled = YES;
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
        doneButton.enabled = YES;
        alertView = nil;
    }];
    
    
}

@end
