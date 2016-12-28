//
//  GymDataController.m
//  GYMatch
//
//  Created by Ram on 02/04/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "GymDataController.h"
#import "WebServiceController.h"
#import "Utility.h"
#import "NSString+HTML.h"

@implementation GymDataController

- (void)addWithDictionary:(NSDictionary *)requestDictionary
              withSuccess:(void (^)(Gym *gym))success
                  failure:(void (^)(NSError *))failure{
    
    
    [WebServiceController callURLString:API_URL_GYM_ADD
                            withRequest:[NSMutableDictionary dictionaryWithDictionary:requestDictionary]
                              andMethod:@"POST"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                
                                if ([[[responseDictionary objectForKey:@"response"] objectForKey:@"status"] isEqualToString:@"Success"]) {
                                    
                                    Gym *gym = [[Gym alloc] initWithDictionary:[responseDictionary valueForKeyPath:@"response.gym"]];
                                    
                                    success(gym);
                                    
                                } else {
                                    
                                    NSArray *values = [[[responseDictionary objectForKey:@"response"] objectForKey:@"message"] allValues];
                                    
                                    NSString *message = [values componentsJoinedByString:@"."];
                                    message = [message stringByReplacingOccurrencesOfString:@"(" withString:@""];
                                    message = [message stringByReplacingOccurrencesOfString:@")" withString:@""];
                                    message = [message stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                                    message = [message stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                                    message = [message stringByReplacingOccurrencesOfString:@"    " withString:@"\n"];
                                    
                                    NSError *error = [NSError errorWithDomain:@"UserError" code:0 userInfo:@{NSLocalizedDescriptionKey: message}];
//
//                                    
//                                    NSString *message = [[responseDictionary objectForKey:@"response"] objectForKey:@"message"];
//                                    
//                                    
//                                    NSError *error = [NSError errorWithDomain:@"UserError" code:0 userInfo:@{NSLocalizedDescriptionKey:message}];
                                    
                                    failure(error);
                                }
                                
                            } failure:failure];
}

- (void)gymsWithKeyword:(NSString *)keyword success:(void (^)(NSArray *friends))success  failure:(void (^)(NSError *error))failure{
    
    NSString *stringURL = [API_URL_GYM_CITY_SEARCH stringByAppendingString:keyword];
    
    [WebServiceController callURLString:stringURL
                            withRequest:nil
                              andMethod:@"GET"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                
                                success (
                                         [self gymsFromResponseDictionary:responseDictionary]
                                         );
                            } failure:failure];
    
}

- (void)locateGymWithKeyword:(NSString *)keyword success:(void (^)(NSArray *friends))success
                failure:(void (^)(NSError *error))failure{
    
    NSString *stringURL = [API_URL_GYM_LOCATOR_SEARCH stringByAppendingString:keyword];
    
    [WebServiceController callURLString:stringURL
                            withRequest:nil
                              andMethod:@"GET"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                
                                success (
                                         [self gymsFromResponseDictionary:responseDictionary]
                                         );
                            }
                                failure:failure];
    
}

- (void)gymsWithCoordinate:(CLLocationCoordinate2D )coordinate distance:(NSInteger)dist success:(void (^)(NSArray *friends))success
                failure:(void (^)(NSError *error))failure{
    
    NSString *stringURL = [NSString stringWithFormat:@"%@lat:%f/long:%f/distance:%ld", API_URL_GYM_LOCATOR, coordinate.latitude, coordinate.longitude, (long)dist];
    
    [WebServiceController callURLString:stringURL
                            withRequest:nil
                              andMethod:@"GET"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                
                                success (
                                         [self gymsFromResponseDictionary:responseDictionary]
                                         );
                                
                            } failure:failure];
    
}


- (void)gymsWithCity:(CLLocationCoordinate2D )coordinate success:(void (^)(NSArray *friends))success
                   failure:(void (^)(NSError *error))failure{
    
    NSString *stringURL = [NSString stringWithFormat:@"%@lat:%f/long:%f", API_URL_GYM_LOCATOR, coordinate.latitude, coordinate.longitude];
    
    [WebServiceController callURLString:stringURL
                            withRequest:nil
                              andMethod:@"GET"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                
                                success (
                                         [self gymsFromResponseDictionary:responseDictionary]
                                         );
                                
                            } failure:failure];
    
    
}

- (void)gymWithKeyword:(NSString *)keyword
                  city:(NSString *)city
                 state:(NSString *)state
                 country:(NSString *)country
               success:(void (^)(NSArray *friends))success
               failure:(void (^)(NSError *error))failure{
    
    NSString *stringURL = [NSString stringWithFormat:@"%@city:%@/state:%@/keyword:%@/country:%@",  API_URL_GYM_SEARCH, [city stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [state stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], keyword, [country stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [WebServiceController callURLString:stringURL
                            withRequest:nil
                              andMethod:@"GET"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                
                                success (
                                         [self gymsFromResponseDictionary:responseDictionary]
                                         );
                                
                            } failure:failure];

}

#pragma mark - Parsing Response

- (NSArray *)gymsFromResponseDictionary:(NSDictionary *)responseDictionary{
    NSMutableArray *gyms = [NSMutableArray new];
    
    NSArray *gymsDict = [[responseDictionary objectForKey:@"response"] objectForKey:@"Gyms"];
    
    for (NSDictionary *userDict in gymsDict) {
        
        NSDictionary *userInfoDict = [userDict objectForKey:@"Gym"];
        
        Gym *gym = [[Gym alloc]initWithDictionary:userInfoDict];
        
        [gyms addObject:gym];
    }
    
    return gyms;
    
}

@end
