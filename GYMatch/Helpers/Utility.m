//
//  Utility.m
//  GYMatch
//
//  Created by Ram Gautam on 11/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "Utility.h"
#import "RoundLabel.h"

@implementation Utility


//static void dumpAllFonts() {
//    for (NSString *familyName in [UIFont familyNames]) {
//        for (NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) {
//            NSLog(@"%@", fontName);
//        }
//    }
//}

+ (UIImage *)placeHolderImage{
    if (emptyImage == nil) {
//        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://goobond.uptostart.com/img/no_image.jpg"]];
//        emptyImage = [UIImage imageWithData:imageData];
        emptyImage = [UIImage imageNamed:@"user_plus"];
    }
    
    return emptyImage;
}

+ (UIColor *)inverseColor:(UIColor *)color{
    const CGFloat *componentColors = CGColorGetComponents(color.CGColor);
    
    UIColor *newColor = [[UIColor alloc] initWithRed:(1.0 - componentColors[0])
                                               green:(1.0 - componentColors[1])
                                                blue:(1.0 - componentColors[2])
                                               alpha:componentColors[3]];

    return newColor;
}

+ (void)saveCookies{
    
    NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: cookiesData forKey: @"sessionCookies"];
    [defaults synchronize];
    
}

+ (void)loadCookies{
    
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey: @"sessionCookies"]];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (NSHTTPCookie *cookie in cookies){
        [cookieStorage setCookie: cookie];
    }
    
}

+ (id)removeNSNULL:(id)object{
    if ([object isMemberOfClass:[NSNull class]]) {
        object = nil;
    }
    if (object == [NSNull null]) {
        object = nil;
    }
    return object;
}

+ (void)openURLString:(NSString *)URLString{
    if (URLString) {
        if(![URLString containsString:@"http://"])
        {
            if(![URLString containsString:@"https://"])
                URLString = [@"https://" stringByAppendingString:URLString];
        }
        NSURL *url = [NSURL URLWithString:URLString];
        [[UIApplication sharedApplication] openURL:url];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert!" message:@"No link on server." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

+(NSInteger)getNumberOfNewLineCharacters:(NSString*)str
{
    NSUInteger count = 0, length = [str length];
    NSRange range = NSMakeRange(0, length);
    if(str)
        while(range.location != NSNotFound)
        {
            range = [str rangeOfString:@"\n" options:0 range:range];
            if(range.location != NSNotFound)
            {
                range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
                count++;
            }
        }
    return count;
}

+ (CGFloat)heightForLabel:(UILabel *)label{
    
    //Calculate the expected size based on the font and linebreak mode of your label
    // FLT_MAX here simply means no constraint in height
    label.numberOfLines = 0;
    
    CGSize maximumLabelSize = CGSizeMake(label.frame.size.width, FLT_MAX);
    
//    CGSize expectedLabelSize = [label.text sizeWithFont:label.font constrainedToSize:maximumLabelSize lineBreakMode:label.lineBreakMode];
    
    
    CGRect expectedLabelSize = [label.text boundingRectWithSize:maximumLabelSize
                                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                     attributes:@{NSFontAttributeName:label.font}
                                                        context:nil];
    
    return expectedLabelSize.size.height;
    
}

+ (CGRect)frameForLabel:(UILabel *)label{
    //Calculate the expected size based on the font and linebreak mode of your label
    // FLT_MAX here simply means no constraint in height
    label.numberOfLines = 0;
    
    CGSize maximumLabelSize = CGSizeMake(label.frame.size.width - 100, FLT_MAX);
    
    CGSize expectedLabelSize = [label.text sizeWithFont:label.font constrainedToSize:maximumLabelSize lineBreakMode:label.lineBreakMode];
    
    return CGRectMake(label.frame.origin.x, label.frame.origin.y, expectedLabelSize.width, expectedLabelSize.height);
    
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 44);
    // Create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);   // Fill it with your color
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (NSString *)friendlyStringFromDate:(NSDate *)date
{
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setTimeZone:[NSTimeZone localTimeZone]];
    
    NSTimeInterval timeSinceDate = [[NSDate date] timeIntervalSinceDate:date];
    NSUInteger minutesSinceDate;
    // print up to 24 hours as a relative offset
    if(timeSinceDate < 24.0 * 60.0 * 60.0)
    {
        NSUInteger hoursSinceDate = (NSUInteger)(timeSinceDate / (60.0 * 60.0));
        
        switch(hoursSinceDate)
        {
                
            default: return [NSString stringWithFormat:@"%lu hours ago", (unsigned long)hoursSinceDate];
                
            case 1: return @"1 hour ago";
                
            case 0:
                
                minutesSinceDate = (NSUInteger)(timeSinceDate / 60.0);
                
                if (minutesSinceDate > 1) {
                    
                    return [NSString stringWithFormat:@"%lu minutes ago", (unsigned long)minutesSinceDate];
                    
                }else if (minutesSinceDate == 1) {
                    
                    return [NSString stringWithFormat:@"%lu minute ago", (unsigned long)minutesSinceDate];
                    
                }else{
                    
                    return @"now";
                    
                }
                
                break;
                
        }
    }
    else
    {
        /* normal NSDateFormatter stuff here */
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"d MMM"];
        
        return [dateFormatter stringFromDate:date];
    }
}

+ (void)adjustWidth:(UILabel *)label{
    CGSize maximumLabelSize = CGSizeMake(9999,label.frame.size.height);
    
//    CGSize expectedLabelSize = [[label text] sizeWithFont:[label font]
//                                        constrainedToSize:maximumLabelSize
//                                            lineBreakMode:[label lineBreakMode]];
    
    CGRect expectedLabelSize = [label.text boundingRectWithSize:maximumLabelSize
                                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                     attributes:@{NSFontAttributeName:label.font}
                                                        context:nil];

    
    CGRect rect = label.frame;
    rect.size.width = expectedLabelSize.size.width + 10.0f;
    
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    
    rect.origin.x = screenWidth - 4.0f - rect.size.width;
    
    [label setFrame:rect];
}

+ (CGFloat)widthForLabel:(UILabel *)label{
    
    CGSize maximumLabelSize = CGSizeMake(9999,label.frame.size.height);
    
    CGSize expectedLabelSize = [[label text] sizeWithFont:[label font]constrainedToSize:maximumLabelSize
                                            lineBreakMode:[label lineBreakMode]];
    
    CGRect rect = label.frame;
    rect.size.width = expectedLabelSize.width + 20.0f;
    return rect.size.width;
    
}

+ (CGFloat)showPrefs:(NSArray *)array inView:(UIView *)view withColor:(UIColor *)color{
    
    for (id element in [view subviews]) {
        [element removeFromSuperview];
    }
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat height = 0;
    CGFloat heightFactor = 0;
    
    for (NSString *string in array) {
        
        if ([string isEqualToString:@""]) {
            continue;
        }
        
        height = y;
        
        CGFloat labelHeight = 15.0f;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            labelHeight = 25.0f;
            heightFactor = 10.0f;
        }
        
        RoundLabel *label = [[RoundLabel alloc] initWithFrame:CGRectMake(x, y, 50.0f, labelHeight) andColor:color];
        label.text = string;
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
        CGRect frame = label.frame;
        frame.size.width = [Utility widthForLabel:label];
        label.frame = frame;
        
        if ((x + frame.size.width + 5.0f) >= view.frame.size.width) {
            y = y + labelHeight + 5.0f;
            x = 0;
            frame.origin = CGPointMake(x, y);
            label.frame = frame;

             x = x + frame.size.width + 5.0f;
            
        }else{
            x = x + frame.size.width + 5.0f;
        }
        height = y + labelHeight + 5.0f;//Lekha
    }
    
    return height + heightFactor;
}

+ (NSString *)titleForBgImageAtIndex:(NSInteger)index{
    
    if (index == -1) {
        index = 0;
    }
    
    NSArray *array = @[@"BGIMG1", @"BGIMG2", @"BGIMG3", @"BGIMG4", @"BGIMG5", @"BGIMG6", @"BGIMG7", @"BGIMG8", @"BGCOLOR1", @"BGCOLOR2", @"BGCOLOR3", @"BGCOLOR4", @"BGCOLOR5", @"BGCOLOR6", @"BGIMG11"];
    
    return array[index];
    
}

+ (NSInteger)indexForBgTitle:(NSString *)title{
    
    NSArray *array = @[@"BGIMG1", @"BGIMG2", @"BGIMG3", @"BGIMG4", @"BGIMG5", @"BGIMG6", @"BGIMG7", @"BGIMG8", @"BGCOLOR1", @"BGCOLOR2", @"BGCOLOR3", @"BGCOLOR4", @"BGCOLOR5", @"BGCOLOR6", @"BGIMG11"];
    
    NSInteger index = 0;
    
    for (NSString *element in array) {
        
        if ([element isEqualToString:title]) {
            return index;
        }
        index ++;
        
    }
    
    return -1;
    
}

+ (UIImage *)imageForBgTitle:(NSString *)title{
    
    NSArray *array = [Utility imagesForBg];
    
    NSInteger index = [Utility indexForBgTitle:title];
    
    if (index == -1) {
        index = 10;
    }
    
    return array[index];
    
}

+ (NSArray *)imagesForBg{
    
    NSArray *array = @[
                       [UIImage imageNamed:@"bgimg1"],
                       [UIImage imageNamed:@"bgimg2"],
                       [UIImage imageNamed:@"bgimg5"],
                       [UIImage imageNamed:@"bgimg6"],
                       [UIImage imageNamed:@"bgimg7"],
                       [UIImage imageNamed:@"bgimg8"],
                       [UIImage imageNamed:@"bgimg9"],
                       [UIImage imageNamed:@"bgimg10"],
                       [Utility imageWithColor:[UIColor blackColor]],
//                       [Utility imageWithColor:[UIColor colorWithRed:0 green:(253.0f/255.0f) blue:(25.0f/255.0f) alpha:1.0f]],
                       [Utility imageWithColor:[UIColor colorWithRed:1.0f green:(129.0f/255.0f) blue:0 alpha:1.0f]],
                       [Utility imageWithColor:DEFAULT_BG_COLOR],
                       [Utility imageWithColor:[UIColor colorWithRed:1.0f green:0 blue:0 alpha:1.0f]],
                       [Utility imageWithColor:[UIColor colorWithRed:(35.0f/255.0f) green:0 blue:(41.0f/255.0f) alpha:1.0f]],
                       [Utility imageWithColor:[UIColor colorWithRed:0 green:(109.0f/255.0f) blue:(5.0f/255.0f) alpha:1.0f]],
                       [UIImage imageNamed:@"bgimg11"]
                       ];
    
    return array;
    
}

+ (UIColor *)colorForBgTitle:(NSString *)title{
    
    NSInteger index = [Utility indexForBgTitle:title];
    
    if (index == -1) {
        index = 0;
    }
    
    NSArray *array = @[
                       DEFAULT_BG_COLOR,
                       DEFAULT_BG_COLOR,
                       DEFAULT_BG_COLOR,
                       DEFAULT_BG_COLOR,
                       DEFAULT_BG_COLOR,
                       DEFAULT_BG_COLOR,
                       DEFAULT_BG_COLOR,
                       DEFAULT_BG_COLOR,
                       [UIColor blackColor],
//                       [UIColor colorWithRed:0 green:(253.0f/255.0f) blue:(25.0f/255.0f) alpha:1.0f],
                       [UIColor colorWithRed:1.0f green:(129.0f/255.0f) blue:0 alpha:1.0f], //green
                       DEFAULT_BG_COLOR,
                       [UIColor colorWithRed:1.0f green:0 blue:0 alpha:1.0f],
                       [UIColor colorWithRed:(35.0f/255.0f) green:0 blue:(41.0f/255.0f) alpha:1.0f],
                       [UIColor colorWithRed:0.0 green:(109.0f/255.0f) blue:(5.0f/255.0f) alpha:1.0f],
                       DEFAULT_BG_COLOR
                       ];
    
    return array[index];
    
}

+ (UIColor *)colorForView:(NSString *)title{
    
    NSInteger index = [Utility indexForBgTitle:title];
    
    if (index == -1) {
        index = 0;
    }
    
    NSArray *array = @[
                       [UIColor lightGrayColor],
                       [UIColor lightGrayColor],
                       [UIColor lightGrayColor],
                       [UIColor lightGrayColor],
                       [UIColor lightGrayColor],
                       [UIColor lightGrayColor],
                       [UIColor lightGrayColor],
                       [UIColor lightGrayColor],
                       [UIColor blackColor],
                       //                       [UIColor colorWithRed:0 green:(253.0f/255.0f) blue:(25.0f/255.0f) alpha:1.0f],
                       [UIColor colorWithRed:1.0f green:(129.0f/255.0f) blue:0 alpha:1.0f],
                      // [UIColor colorWithRed:0 green:(196.0f/255.0f) blue:(192.0f/255.0f) alpha:1.0f],
                       DEFAULT_BG_COLOR,
                       [UIColor colorWithRed:1.0f green:0 blue:0 alpha:1.0f],
                       [UIColor colorWithRed:(35.0f/255.0f) green:0 blue:(41.0f/255.0f) alpha:1.0f],
                       [UIColor colorWithRed:0 green:(109.0f/255.0f) blue:(5.0f/255.0f) alpha:1.0f],
                       [UIColor lightGrayColor]
                       ];
    
    return array[index];
    
}

+ (MKMapRect)showAnnotationsInMapView:(MKMapView *)mapView{
    MKMapRect zoomRect = MKMapRectNull;
    for (id <MKAnnotation> annotation in mapView.annotations)
    {
        if ([annotation isMemberOfClass:[MKUserLocation class]]) {
            continue;
        }
        
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
    }

    return zoomRect;
    
}

#pragma mark - Expandable Buttons

+ (void)trainingPrefsCollapsed:(BOOL)status{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:@(status) forKey:@"TrainingPrefsCollapsed"];
    [userDefaults synchronize];
    
}

+ (BOOL)isTrainingPrefsCollapsed{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [[userDefaults valueForKey:@"TrainingPrefsCollapsed"] boolValue];
    
}


+ (void)trainingScheduleCollapsed:(BOOL)status{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:@(status) forKey:@"TrainingScheduleCollapsed"];
    [userDefaults synchronize];
    
}

+ (BOOL)isTrainingScheduleCollapsed{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [[userDefaults valueForKey:@"TrainingScheduleCollapsed"] boolValue];
    
}

+ (void)personalHourCollapsed:(BOOL)status{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:@(status) forKey:@"PersonalHourCollapsed"];
    [userDefaults synchronize];
    
}

+ (BOOL)ispersonalHourCollapsed{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [[userDefaults valueForKey:@"PersonalHourCollapsed"] boolValue];
    
}

+ (void)personalHalfHourCollapsed:(BOOL)status{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:@(status) forKey:@"PersonalHalfHourCollapsed"];
    [userDefaults synchronize];
    
}

+ (BOOL)ispersonalHalfHourCollapsed{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [[userDefaults valueForKey:@"PersonalHalfHourCollapsed"] boolValue];
    
}

+ (void)clubHourCollapsed:(BOOL)status{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:@(status) forKey:@"ClubHourCollapsed"];
    [userDefaults synchronize];
    
}

+ (BOOL)isclubHourCollapsed{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [[userDefaults valueForKey:@"ClubHourCollapsed"] boolValue];
    
}

+ (void)complementaryCollapsed:(BOOL)status{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:@(status) forKey:@"ComplementaryCollapsed"];
    [userDefaults synchronize];
    
}

+ (BOOL)iscomplementaryCollapsed{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [[userDefaults valueForKey:@"ComplementaryCollapsed"] boolValue];
    
}

+ (void)membershipCollapsed:(BOOL)status{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:@(status) forKey:@"MembershipCollapsed"];
    [userDefaults synchronize];
    
}

+ (BOOL)ismembershipCollapsed{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [[userDefaults valueForKey:@"MembershipCollapsed"] boolValue];
    
}

+ (void)operationalHourCollapsed:(BOOL)status{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:@(status) forKey:@"OperationHourCollapsed"];
    [userDefaults synchronize];
    
}

+ (BOOL)isoperationalHourCollapsed{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [[userDefaults valueForKey:@"OperationHourCollapsed"] boolValue];
    
}

+ (void)offersCollapsed:(BOOL)status{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:@(status) forKey:@"OffersCollapsed"];
    [userDefaults synchronize];
    
}

+ (BOOL)isoffersCollapsed{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [[userDefaults valueForKey:@"OffersCollapsed"] boolValue];
    
}

+ (void)buttonCollapsed:(NSInteger)type andSectoin:(NSInteger)index andStatus:(BOOL)status{
  
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"Expandable%d%d", type, index];
    [userDefaults setObject:@(status) forKey:key];
    [userDefaults synchronize];

}

+ (BOOL)isButtonCollapsed:(NSInteger)type andSection:(NSInteger)index{
    
    NSString *key = [NSString stringWithFormat:@"Expandable%d%d", type, index];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [[userDefaults valueForKey:key] boolValue];
    
}

+ (BOOL)wantsRecommendations{
   
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    return [[userDef valueForKey:@"WantsRecommendation"] boolValue];
    
}

+ (void)recommendations:(BOOL)status{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setValue:@(status) forKey:@"WantsRecommendation"];
}

+ (BOOL)checkInvalidChars:(NSString *)string{
    NSCharacterSet *s = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_ "];
    s = [s invertedSet];
    NSRange r = [string rangeOfCharacterFromSet:s];
    if (r.location != NSNotFound) {
        NSLog(@"the string contains illegal characters");
        return YES;
    }
    return NO;
}

+(BOOL)validateEmailId:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

+(void)showAlertMessage:(NSString*)msgStr
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!" message:msgStr delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}


+ (BOOL)isNull:(id)var
{
    if ([var isKindOfClass:[NSString class]] == YES) {
        NSCharacterSet* whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString* trimmed = [var stringByTrimmingCharactersInSet:whitespace];
        
        if (trimmed == nil || [trimmed class] == [NSNull class] || [trimmed isEqualToString:@""]) {
            return true;
        }
        return false;
    }
    else if ([var isKindOfClass:[NSArray class]] == YES) {
        if ([var isKindOfClass:[NSNull class]] || var == nil || [var count] == 0) {
            return true;
        }
        else {
            return false;
        }
    }
    else if ([var isKindOfClass:[NSDictionary class]] == YES) {
        if ([var isKindOfClass:[NSNull class]] || var == nil || [var count] == 0) {
            return true;
        }
        else {
            return false;
        }
    }
    else if ([var isKindOfClass:[NSNull class]] == YES) {
        return true;
    }
    return true;
}

@end
