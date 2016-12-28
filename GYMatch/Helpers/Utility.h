//
//  Utility.h
//  GYMatch
//
//  Created by Ram Gautam on 11/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

static UIImage *emptyImage;

@interface Utility : NSObject

//static void dumpAllFonts();

+ (UIColor *)inverseColor:(UIColor *)color;

+ (void)saveCookies;

+ (void)loadCookies;

+ (id)removeNSNULL:(id)object;

+ (void)openURLString:(NSString *)URLString;

+ (UIImage *)placeHolderImage;

+ (CGFloat)heightForLabel:(UILabel *)label;

+ (CGRect)frameForLabel:(UILabel *)label;

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (NSString *)friendlyStringFromDate:(NSDate *)date;

+ (void)adjustWidth:(UILabel *)label;

+ (CGFloat)widthForLabel:(UILabel *)label;

+ (CGFloat)showPrefs:(NSArray *)array inView:(UIView *)view withColor:(UIColor *)color;

+ (NSString *)titleForBgImageAtIndex:(NSInteger)index;

+ (NSInteger)indexForBgTitle:(NSString *)title;

+ (UIImage *)imageForBgTitle:(NSString *)title;

+ (NSArray *)imagesForBg;

+ (UIColor *)colorForBgTitle:(NSString *)title;

+ (UIColor *)colorForView:(NSString *)title;

+ (void)trainingPrefsCollapsed:(BOOL)status;
+ (BOOL)isTrainingPrefsCollapsed;

+ (void)trainingScheduleCollapsed:(BOOL)status;
+ (BOOL)isTrainingScheduleCollapsed;

+ (void)personalHourCollapsed:(BOOL)status;
+ (BOOL)ispersonalHourCollapsed;

+ (void)personalHalfHourCollapsed:(BOOL)status;
+ (BOOL)ispersonalHalfHourCollapsed;

+ (void)clubHourCollapsed:(BOOL)status;
+ (BOOL)isclubHourCollapsed;

+ (void)complementaryCollapsed:(BOOL)status;
+ (BOOL)iscomplementaryCollapsed;

+ (void)membershipCollapsed:(BOOL)status;
+ (BOOL)ismembershipCollapsed;

+ (void)operationalHourCollapsed:(BOOL)status;
+ (BOOL)isoperationalHourCollapsed;

+ (void)offersCollapsed:(BOOL)status;
+ (BOOL)isoffersCollapsed;

+ (void)buttonCollapsed:(NSInteger)type andSectoin:(NSInteger)index andStatus:(BOOL)status;
+ (BOOL)isButtonCollapsed:(NSInteger)type andSection:(NSInteger)index;

+ (BOOL)wantsRecommendations;
+ (void)recommendations:(BOOL)status;

+ (BOOL)checkInvalidChars:(NSString *)string;
+(BOOL)validateEmailId:(NSString *)checkString;

+(void)showAlertMessage:(NSString*)msgStr;
+(NSInteger)getNumberOfNewLineCharacters:(NSString*)str; 

+ (MKMapRect)showAnnotationsInMapView:(MKMapView *)mapView;
+ (BOOL)isNull:(id)var;
@end
