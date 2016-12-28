//
//  LocatorViewController.m
//  GYMatch
//
//  Created by Ram on 02/04/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "LocatorViewController.h"
#import "GymDataController.h"
#import "MBProgressHUD.h"
#import "Gym.h"
#import "MapPin.h"
#import "Utility.h"
//#import "MKMapView+ZoomLevel.h"

@interface LocatorViewController (){
    
    NSArray *gymArray;
    MKAnnotationView *selectedAnno;
    BOOL isMapLoadedFirst;
    
    GymFiltersViewController *fVC;
    BOOL isSearching;
    BOOL isCenterAtCurrentLocation;
    
}

@end

@implementation LocatorViewController

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
    isMapLoadedFirst = true;
    self.automaticallyAdjustsScrollViewInsets = NO;
    mapView.delegate = self;
    [self loadData];

    isCenterAtCurrentLocation = YES;
}



- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if(self.isMovingToParentViewController)
    {
        mapView.showsUserLocation = NO;
        mapView.delegate = nil;
        [mapView removeFromSuperview];
        mapView = nil;
        fVC = nil;
    }
}


-(void)viewWillAppear:(BOOL)animated
{


    [super viewWillAppear:animated];
    [[self navigationItem] setTitle:@"Gym Locator"];

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        distanceHeight.constant = 40;
    }
}

- (void)loadData {

    if ([Utility checkInvalidChars:searchBar.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter valid text" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }


    CLLocationCoordinate2D coordinates = mapView.userLocation.coordinate;

    if (isMapLoadedFirst && coordinates.latitude && coordinates.longitude) {
        //AppDelegate *appdel = (AppDelegate*)[[UIApplication sharedApplication] delegate];

        //coordinates.latitude = appdel.locationManager.location.coordinate.latitude;
        //coordinates.longitude = appdel.locationManager.location.coordinate.longitude;

       MKCoordinateRegion mapRegion;
        mapRegion.center = coordinates;
        mapRegion.span.latitudeDelta = 0.01;
        mapRegion.span.longitudeDelta = 0.01;
        [mapView setRegion:mapRegion animated: YES];

        //[mapView setCenterCoordinate:coordinates animated:YES]; //pankaj


        isMapLoadedFirst = false;
    }


    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    GymDataController *gDC = [GymDataController new];
    [gDC gymsWithCoordinate:coordinates distance:0 success:^(NSArray *friends) {
        
        gymArray = friends;
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            [self addPins];
            [distanceLabel setHidden:YES];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            if ([gymArray count] == 0) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"No Gym Around." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
            }
        });
        
    } failure:^(NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    }];
    
}

- (void)searchGyms {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    GymDataController *gDC = [GymDataController new];
    
    [gDC locateGymWithKeyword:searchBar.text success:^(NSArray *friends) {
        gymArray = friends;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self addPins];
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            if ([gymArray count] == 0) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"No Gyms match your criteria." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
            }
        });
        
    } failure:^(NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    }];
}


#pragma mark - IBActions

- (IBAction)filterButtonPressed:(UIButton *)sender {
    mapView.showsUserLocation = NO;
    isCenterAtCurrentLocation = NO;
    if (fVC == nil) {
        fVC = [[GymFiltersViewController alloc] init];
        fVC.delegate = self;
    }
    [self.navigationController pushViewController:fVC animated:YES];
}


#pragma mark - MapView

- (void)addPins
{
    [mapView removeAnnotations:mapView.annotations];
    
    if ([gymArray count] == 0) {
        return;
    }
    int i = 0;
    
    for (Gym *gym in gymArray) {
        
        if (gym.coordinate.latitude == 0 || gym.coordinate.longitude == 0) {
            continue;
        }
        @try {
            //NSLog(@"Display Pin");
            NSString *description = [NSString stringWithFormat:@"%@, %@, %@", gym.address, gym.city, gym.state];
            
            MapPin *pin = [[MapPin alloc] initWithCoordinates:gym.coordinate placeName:gym.bizName description:description];
           
            if (pin) {
                 //NSLog(@"Add Pin");
                [mapView addAnnotation:pin];
            }
            
            pin.productIndex = i++;
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }

//    MKMapRect zoomRect = [Utility showAnnotationsInMapView:mapView];
//
//    if (mapView.userLocation.location.coordinate.longitude && mapView.userLocation.location.coordinate.latitude) {
//        MKMapPoint annotationPoint = MKMapPointForCoordinate(mapView.userLocation.location.coordinate);
//        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
//        zoomRect = MKMapRectUnion(zoomRect, pointRect);
//
//    }

    //[mapView setVisibleMapRect:zoomRect animated:YES];
    [self zoomToFitMapAnnotations:mapView];
    isSearching = NO;


   // [self performSelector:@selector(centerMap) withObject:nil afterDelay:0.2];

}

- (void)zoomToFitMapAnnotations:(MKMapView *)myMapView {
    if ([myMapView.annotations count] == 0) return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(id<MKAnnotation> annotation in myMapView.annotations) {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    
    // Add a little extra space on the sides
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1;
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1;
    
    region = [myMapView regionThatFits:region];
    
    [myMapView setRegion:region animated:YES];
}

/*-(void)centerMap
{

    if (isCenterAtCurrentLocation) {

        //[mapView setCenterCoordinate:mapView.userLocation.location.coordinate animated:YES];

        double zoomLevel = [mapView getZoomLevel];

        [mapView setCenterCoordinate:mapView.userLocation.location.coordinate zoomLevel:zoomLevel animated:YES];


    }
}*/

-(void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)userLocation
{

       if (isMapLoadedFirst) {
        
        MKCoordinateRegion mapRegion;
        mapRegion.center = aMapView.userLocation.coordinate;
        mapRegion.span.latitudeDelta = 0.01;
        mapRegion.span.longitudeDelta = 0.01;
        
        [aMapView setRegion:mapRegion animated: YES];

        
        [self loadData];
        
        isMapLoadedFirst = false;
    }


 
 }

#pragma mark - MKMapView Delegate

-(MKAnnotationView *)mapView:(MKMapView *)aMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    //NSLog(@"Show Pin");
    MKPinAnnotationView *pinView = nil;
    if(annotation != mapView.userLocation)
    {
        static NSString *defaultPinID = @"com.gymatch.pin";
        pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil )
            pinView = [[MKPinAnnotationView alloc]
                       initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        
        pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        // Image and two labels
        //        UIView *leftCAV = [[UIView alloc] initWithFrame:CGRectMake(0,0,23,23)];
        //        [leftCAV addSubview : yourImageView];
        //        [leftCAV addSubview : yourFirstLabel];
        //        [leftCAV addSubview : yourSecondLabel];
        //        UIImageView *pinCalloutImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        
        MapPin *pin = annotation;
        //        Product *product = [_productController.products objectAtIndex:pin.productIndex];
        //        [pinCalloutImageView setImageWithURL:[NSURL URLWithString:product.image] placeholder:placeHolderImage completionBlock:^(UIImage *image) {
        //
        //        }];
        
        pinView.pinColor = MKPinAnnotationColorRed;
        
        pinView.tag = pin.productIndex;
        //        pinView.leftCalloutAccessoryView = pinCalloutImageView;
        
        
        //        pinView.animatesDrop = YES;
        //        NSArray *tCampaigns = [[stores objectAtIndex:pin.productIndex] campaigns];
        //
        //        NSInteger campID = [[tCampaigns objectAtIndex:[tCampaigns count] - 1] integerValue];
        //        Campaign *campaign = [Utility campaignWithID:campID in:campaigns];
        //
        //        UIImage *pinImage = [Utility pinForCampaign:campaign];
        //
        //        pinImage = [Utility drawImage:[Utility pinIconForCampaign:campaign] inImage:pinImage atPoint:CGPointMake(13.5f, 14.0f)];
        //
        
        [pinView setCanShowCallout:YES];
//        pinView.centerOffset = CGPointMake(0.0f, -34.0f);
        
//        pinView.image =  [UIImage imageNamed:@"map_pin"];
    }
    else {
        
        [mapView.userLocation setTitle:NSLocalizedString(@"I am here", nil)];


    }
    return pinView;
}

/*
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    selectedAnno = view;
    Gym *gym = [gymArray objectAtIndex:view.tag];
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    
    request.source = [MKMapItem mapItemForCurrentLocation];
    
    request.destination = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:gym.coordinate addressDictionary:nil]];
    request.requestsAlternateRoutes = YES;
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         if (error) {
             // Handle Error
         } else {
             [self showRoute:response];
         }
         
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];
} */

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    selectedAnno = view;
    //Gym *gym = [gymArray objectAtIndex:view.tag];

  MapPin *pin  = (MapPin *)view.annotation;


    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];

   // Gym *gym1 = [gymArray objectAtIndex:2]; //for testing
   //10 request.source = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:gym1.coordinate addressDictionary:nil]];

   request.source = [MKMapItem mapItemForCurrentLocation];
 

/*
//pankaj

 MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
 CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(26.0768974, 79.3225047);
 pin.coordinate=coor;
    request.source =[[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:pin.coordinate addressDictionary:nil]];


CLLocationCoordinate2D coorCurrent = CLLocationCoordinate2DMake(26.1393034, 79.3395147);
pin.coordinate=coorCurrent;

request.destination =[[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:pin.coordinate addressDictionary:nil]];

//pankaj end

*/

    request.destination = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:pin.coordinate addressDictionary:nil]];
    //request.source = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coorCurrent addressDictionary:nil]];


    request.requestsAlternateRoutes = YES;
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];

    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         if (error) {
             NSString *title = @"Alert", *failureReason = error.localizedDescription;
             if(error.localizedFailureReason != nil)
             {
                 title = error.localizedDescription;
                 failureReason = error.localizedFailureReason;
             }
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:failureReason delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
             [alert show];
             // Handle Error
         } else {
             [self showRoute:response];
         }

         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];
}


-(void)showRoute:(MKDirectionsResponse *)response
{
    mapView.showsUserLocation = YES;
    [self zoomToFitMapAnnotations:mapView];
//    [mapView removeAnnotations:mapView.annotations];
    [mapView removeOverlays:mapView.overlays];
    
    for (MKRoute *route in response.routes)
    {
        [mapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
        
        distanceLabel.hidden = NO;
        // 1 km = 0.621 miles
        // route.distance is in meters
        distanceLabel.text = [NSString stringWithFormat:@"Distance: %.1f miles", route.distance * 0.000621];
        
        break;
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKPolylineRenderer *renderer =
    [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 5.0;
    return renderer;
}

#pragma mark - UISearchBar

- (void)searchBarSearchButtonClicked:(UISearchBar *)aSearchBar{
    isSearching = YES;
    [self searchGyms];
    
    [aSearchBar endEditing:YES];
}

/*
- (void)searchBar:(UISearchBar *)searchBar1 textDidChange:(NSString *)searchText
{
    if([searchText  isEqual: @""])
    {
        [searchBar1 resignFirstResponder];
        [self loadData];
    }
} */

- (void)searchBarCancelButtonClicked:(UISearchBar *)aSearchBar{
    [mapView removeOverlays:mapView.overlays];
    [aSearchBar endEditing:YES];
}


#pragma mark - Filters Delegate

- (void)doneWithDistance:(NSInteger)distance{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    GymDataController *gDC = [GymDataController new];
    
    [gDC gymsWithCoordinate:mapView.userLocation.coordinate distance:distance success:^(NSArray *friends) {
        
        gymArray = friends;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self addPins];
            [distanceLabel setHidden:YES];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            if ([gymArray count] == 0) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"No Gyms match your criteria." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
            }
        });
        
    } failure:^(NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    }];

}

- (void)doneWithDictionary:(NSMutableDictionary *)dictionary{
    if ([Utility checkInvalidChars:searchBar.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter valid text" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    GymDataController *uDC = [GymDataController new];
    
    [uDC gymWithKeyword:searchBar.text city:[dictionary valueForKey:@"city"] state:[dictionary valueForKey:@"state"] country:[dictionary valueForKey:@"country"] success:^(NSArray *friends)  {
        gymArray = friends;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self addPins];
            [distanceLabel setHidden:YES];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            if ([gymArray count] == 0) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"No Gyms match your criteria." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
            }
            
        });
        
    } failure:^(NSError *error) {
        //        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
    }];
    
}

#pragma mark - Memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if (![self isViewLoaded]) {
        /* release your custom data which will be rebuilt in loadView or viewDidLoad */
        mapView.showsUserLocation = NO;
        mapView.delegate = nil;
        [mapView removeFromSuperview];
        mapView = nil;
        selectedAnno = nil;
        
        searchBar.delegate = nil;
        searchBar = nil;
        fVC.delegate = nil;
        fVC = nil;
        gymArray = nil;
        distanceLabel = nil;
    }
}

@end
