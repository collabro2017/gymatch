//
//  AlbumDataController.m
//  GYMatch
//
//  Created by Ram on 18/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "SessionDataController.h"
#import "WebServiceController.h"
#import "Photo.h"
#import "Session.h"
#import "SpotlightDataController.h"

@implementation SessionDataController

- (void)addWithDictionary:(NSDictionary *)requestDictionary andImage:(UIImage *)image withSuccess:(void (^)(void))success failure:(void (^)(NSError *))failure{
    
    [WebServiceController callURLString:API_URL_ALBUM
                            withRequest:[NSMutableDictionary dictionaryWithDictionary:requestDictionary]
                              withImage:image
                              andMethod:@"POST"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                
                                if ([[[responseDictionary objectForKey:@"response"] objectForKey:@"status"] isEqualToString:@"Success"]) {
                                    success();
                                } else {
                                    NSArray *values = [[[responseDictionary objectForKey:@"response"] objectForKey:@"message"] allValues];
                                    
                                    NSError *error = [NSError errorWithDomain:@"Error" code:0 userInfo:@{NSLocalizedDescriptionKey: [values componentsJoinedByString:@".\n"]}];
                                    
                                    failure(error);
                                }
                                
                            } failure:failure];

}

- (void)albumFor:(NSInteger)userID withSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure{
    NSString *stringURL = [NSString stringWithFormat:@"%@%ld", API_URL_ALBUM_VIEW, (long)userID];
    
    [WebServiceController callURLString:stringURL
                            withRequest:nil
                              andMethod:@"GET"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                NSArray *photos = [self photosFromResponseDictionary:responseDictionary];
                                success(photos);
                            } failure:failure];

}

- (void)sessionFor:(NSInteger)userID withDate:(NSDate*)date withSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //NSLog(@"%@", [dateFormatter stringFromDate:userSelectedDate]);
    
    NSString *stringURL = [NSString stringWithFormat:@"http://jebcoolkids.com/gymatch_app/booking.php?user=%ld&date=%@", (long)userID, [dateFormatter stringFromDate:date]];
    
    //stringURL = @"http://jebcoolkids.com/gymatch_app/booking.php?user=1594&date=2016-06-29";
    
    NSLog(@"%@", stringURL);
    
    [WebServiceController callURLString4Session:stringURL
                            withRequest:nil
                              andMethod:@"GET"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                NSArray *sessions = [self sessionsFromResponseDictionary:responseDictionary];
                                success(sessions);
                            } failure:failure];
    
//    
//      NSDictionary *requestDictionary = @{@"user_id": userID,
//                                          @"booking_date": [dateFormatter stringFromDate:date]
//                                        };
//    
//    SpotlightDataController *sDC = [SpotlightDataController new];
//    
//    [sDC bookingTrainer:requestDictionary withSuccess:^(NSDictionary *spotlight) {
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            [[[UIAlertView alloc] initWithTitle:@"GYMatch" message:[spotlight objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//            
//            
//        });
//        
//        
//    } failure:^(NSError *error) {
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            [[[UIAlertView alloc] initWithTitle:@"GYMatch" message:[NSString stringWithFormat:@"%@", error.localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//            
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        });
//        
//    }];
    
}

#pragma mark - Parsing Response

- (NSArray *)photosFromResponseDictionary:(NSDictionary *)responseDictionary{
    NSMutableArray *photos = [NSMutableArray new];
    
    NSString *baseURL = [[responseDictionary objectForKey:@"response"] objectForKey:@"baseurl"];
    
    NSArray *friendsDict = [[responseDictionary objectForKey:@"response"] objectForKey:@"album"];
    
    for (NSDictionary *userDict in friendsDict) {
        
        NSDictionary *userInfoDict = [userDict objectForKey:@"Album"];
        
        Photo *photo = [[Photo alloc]initWithDictionary:userInfoDict];
        
        // Make Full profile URL
        [photo fullURLWithBaseURL:baseURL];
        
        [photos addObject:photo];
    }
    
    return photos;
}

- (NSArray *)sessionsFromResponseDictionary:(NSDictionary *)responseDictionary{
    NSMutableArray *sessions = [NSMutableArray new];
    if([responseDictionary count] > 0){
        //[sessions addObject:responseDictionary];
        for (NSDictionary *userDict in responseDictionary) {
            
            Session *session = [[Session alloc]initWithDictionary:userDict];
            
            [sessions addObject:session];
        }
    }
    
    return sessions;
}


- (void)deletePhoto:(NSInteger)photoID withSuccess:(void (^)(void))success failure:(void (^)(NSError *))failure{

    NSString *urlString = [NSString stringWithFormat:@"%@%ld", API_URL_ALBUM_VIEW, (long)photoID];
    [WebServiceController callURLString:urlString
                            withRequest:nil
                              andMethod:@"DELETE"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                
                                if ([[[responseDictionary objectForKey:@"response"] objectForKey:@"status"] isEqualToString:@"Success"]) {
                                    success();
                                } else {
                                    NSString *message = [[responseDictionary objectForKey:@"response"] objectForKey:@"message"];
                                    
                                    
                                    NSError *error = [NSError errorWithDomain:@"UserError" code:0 userInfo:@{NSLocalizedDescriptionKey:message}];
                                    
                                    failure(error);
                                }
                                
                            } failure:failure];
}//*/

@end
