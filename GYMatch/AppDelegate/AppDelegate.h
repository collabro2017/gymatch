//
//  AppDelegate.h
//  GYMatch
//
//  Created by Ram Gautam on 10/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopNavigationController.h"
#import "User.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AGPushNoteView.h"
#import "Instagram.h"
#import <CoreLocation/CoreLocation.h>
#import "UserDataController.h"
#import "MBProgressHUD.h"
#import "ChatViewController.h"
#import "RequestsViewController.h"


//1374768389465961

/*!
 *  Main application delegate.
 */
@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate, UITabBarControllerDelegate>{
    UIAlertView* notiAV;
    
    // dragon
    NSArray *aryWeekday;
    NSArray *aryMonth;
    NSMutableArray *aryTime;
    NSArray *aryPeriod;
    //
}

@property(assign) BOOL automaticPushAfterRegister; 
@property (strong, nonatomic)  NSString *databasePath; /////////

@property (strong, nonatomic) CLLocationManager *locationManager; /////////
@property (strong, nonatomic) NSTimer *chatTimer;

/*!
 *  Instance of main window.
 */
@property (strong, nonatomic) UIWindow *window;

/*!
 *  Navigation controller for login and registration view controllers.
 */
@property (strong, nonatomic) TopNavigationController *navigationController;

/*!
 *  Tab bar controller for 4 view controllers.
 */
@property (strong, nonatomic) UITabBarController *tabBarController;

/*!
 *  Shared instance of logged in user.
 */
@property (strong, nonatomic) User *loggedInUser;

/*!
 *  Location of push notification.
 */
@property (strong, nonatomic) NSString *breadcumb;

/*!
 *  Device token used to send push notifications.
 */
@property (strong, nonatomic) NSString *deviceToken;

/*!
 *  Shared instagram instance to maintain instagram session.
 */
@property (strong, nonatomic) Instagram *instagram;

@property (strong, nonatomic) NSMutableDictionary* senderInfo;
@property (nonatomic, retain) NSString *strUserType;

/*!
 *  This method will handle ALL the session state changes in the app
 *
 *  @param session Facebook session is stored in this variable.
 *  @param state   Session state is maintained in this variable.
 *  @param error   If some error is occurred during facebook sign in.
 */
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error;
- (void)invalidateChatTimer;

- (NSString*)getCurrentDateInfo:(int)addDate;
- (NSArray*)getTimeArray;
- (NSString*)getTimeValue:(int)index;
- (NSArray*)getPeriodArray;
- (NSString*)getPeriodValue:(int)index;
- (NSString*)getDateValue:(int)addDate;
- (NSString*)getCurrentDateInfoFromString:(NSString*)str;
- (NSString*)getValue:(NSUInteger)component :(NSUInteger)row;

@end
