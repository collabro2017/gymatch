//
//  SpotlightDataController.m
//  GYMatch
//
//  Created by Ram on 23/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "SpotlightDataController.h"
#import "WebServiceController.h"

@implementation SpotlightDataController

#pragma mark - Spotlights

- (void)spotlightsWithType:(NSString *)type andKeyword:(NSString *)keyword success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure{
    
    NSString *URLString = [NSString stringWithFormat:@"%@type:%@/keyword:%@", API_URL_SPOTLIGHT, type, keyword];
  //  NSString *URLString = [NSString stringWithFormat:@"http://gymatch.com/rest/spotlights/index/type:Individual/keyword:"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjects:@[@"", @"", @"", @""] forKeys:@[@"country", @"state", @"city", @"gender"]];
    [WebServiceController callURLString:URLString
                            withRequest:dict
                              andMethod:@"POST"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                
                                success (
                                         [self spotlightsFromResponseDictionary:responseDictionary]
                                         );
                            } failure:failure];
    
}

- (void)spotlightsWithFilterDict:(NSMutableDictionary *)dict success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure{ //yt

    NSString *URLString = API_URL_SPOTLIGHT_FILTER;

    [WebServiceController callURLString:URLString
                            withRequest:[NSMutableDictionary dictionaryWithDictionary:dict]
                              andMethod:@"POST"
                            withSuccess:^(NSDictionary *responseDictionary) {

                                success (
                                         [self spotlightsFromResponseDictionary:responseDictionary]
                                         );
                            } failure:failure];

}

- (void)spotlightsWithTypeDic:(NSString *)type andKeyword:(NSDictionary *)keyword success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure{
    
    NSString *URLString = [NSString stringWithFormat:@"%@type:%@/keyword:%@", API_URL_SPOTLIGHT, type, keyword];
    
    [WebServiceController callURLString:URLString
                            withRequest:keyword
                              andMethod:@"POST"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                
                                success (
                                         [self spotlightsFromResponseDictionary:responseDictionary]
                                         );
                            } failure:failure];
    
}

- (void)spotlightDetails:(NSInteger)spotlightID
             withSuccess:(void (^)(Spotlight *))success
                 failure:(void (^)(NSError *))failure{
    
    NSString *URLString = [NSString stringWithFormat:@"%@%ld", API_URL_SPOTLIGHT_DETAIL, (long)spotlightID];
    
    [WebServiceController callURLString:URLString
                            withRequest:nil
                              andMethod:@"GET"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                
                                success (
                                         [self spotlightFromResponseDictionary:responseDictionary]
                                         );
                            } failure:failure];
}

- (void)likeSpotlight:(NSInteger)spotlightID
             withLike:(BOOL)likeStatus
          withSuccess:(void (^)(void))success
              failure:(void (^)(NSError *))failure{
    
    NSDictionary *requestDictionary = @{@"spotlight_id": [NSNumber numberWithInt:spotlightID],
                                        @"like": [NSNumber numberWithInt:likeStatus]};
    
    [WebServiceController callURLString:API_URL_SPOTLIGHT_LIKE
                            withRequest:[NSMutableDictionary dictionaryWithDictionary:requestDictionary]
                              andMethod:@"POST"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                if ([[[responseDictionary objectForKey:@"response"] objectForKey:@"status"] isEqualToString:@"Success"]) {
                                    success();
                                } else {
                                    NSString *values = [[responseDictionary objectForKey:@"response"] objectForKey:@"message"];
                                    
                                    NSError *error = [NSError errorWithDomain:@"SpotlightErrror" code:0 userInfo:@{NSLocalizedDescriptionKey: values}];
                                    
                                    failure(error);
                                }
                            } failure:failure];
}


- (void)rateSpotlight:(NSInteger)spotlightID withStar:(BOOL)totalStars withSuccess:(void (^)(NSString *rateV))success failure:(void (^)(NSError *))failure{
    
    NSDictionary *requestDictionary = @{@"spotlight_id": [NSNumber numberWithInt:spotlightID],
                                        @"rate": [NSNumber numberWithInt:totalStars]};
    
    [WebServiceController callURLString:API_URL_SPOTLIGHT_RATE
                            withRequest:[NSMutableDictionary dictionaryWithDictionary:requestDictionary]
                              andMethod:@"POST"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                if (responseDictionary == nil)
                                    return;
                                NSDictionary *resp = [responseDictionary objectForKey:@"response"];
                                if ([[resp objectForKey:@"status"] isEqualToString:@"Success"]) {
                                    NSArray *avgr = [resp objectForKey:@"avgrate"] == [NSNull null] ? nil :  [resp objectForKey:@"avgrate"];
                                    if ( (avgr == nil) || avgr.count == 0 )
                                        success(@"0");
                                    
                                    NSString *rateValue = [[[avgr objectAtIndex:0] objectForKey:@"Spotlight"] objectForKey:@"avgrate"];
                                    success(rateValue);
                                } else {
                                    if(responseDictionary){
                                        NSString *values = [[responseDictionary objectForKey:@"response"] objectForKey:@"message"];

                                        NSError *error = [NSError errorWithDomain:@"SpotlightErrror" code:0 userInfo:@{NSLocalizedDescriptionKey: values}];

                                        failure(error);

                                    }

                                }
                            } failure:failure];
}

- (void)bookingTrainer:(NSDictionary *)requestDictionary withSuccess:(void (^)(NSDictionary *spotlight))success failure:(void (^)(NSError *error))failure{
    
    [WebServiceController callURLString:API_URL_SPOTLIGHT_BOOKTRAINER withRequest:[NSMutableDictionary dictionaryWithDictionary:requestDictionary] andMethod:@"POST" withSuccess:^(NSDictionary *responseDictionary) {
        
        if (responseDictionary == nil) {
                    return;
                    
                }else {
                
                    NSDictionary *resp = [responseDictionary objectForKey:@"response"];
                    
                    if ([[NSString stringWithFormat:@"%@", [resp objectForKey:@"Responsecode"]] isEqualToString:@"1"]) {
                        
                        success(resp);
                        
                    } else {
                        
                        if(responseDictionary){
                            
                            NSString *values = [[responseDictionary objectForKey:@"response"] objectForKey:@"Message"];
                            
                            NSError *error = [NSError errorWithDomain:@"SpotlightErrror" code:0 userInfo:@{NSLocalizedDescriptionKey: values}];
                            
                            failure(error);
                            
                        }
                        
                    }
                    
                }

        } failure:failure];
}

// Dragon
- (void)getUserType:(NSDictionary *)requestDictionary withSuccess:(void (^)(NSDictionary *spotlight))success failure:(void (^)(NSError *error))failure {
    [WebServiceController callURLString:API_URL_GET_USER_TYPE withRequest:[NSMutableDictionary dictionaryWithDictionary:requestDictionary] andMethod:@"POST" withSuccess:^(NSDictionary *responseDictionary) {
        if (responseDictionary == nil) {
            return;
        }else {
            NSDictionary *resp = [responseDictionary objectForKey:@"response"];
            if ([resp[@"status"] isEqualToString:@"Success"]) {
                success(resp);
            } else {
                if(responseDictionary){
                    NSString *values = [[responseDictionary objectForKey:@"response"] objectForKey:@"message"];
                    NSError *error = [NSError errorWithDomain:@"SpotlightErrror" code:0 userInfo:@{NSLocalizedDescriptionKey: values}];
                    failure(error);
                }
            }
        }
    } failure:failure];
}
- (void)sendBookingRequest:(NSDictionary *)requestDictionary withSuccess:(void (^)(NSDictionary *spotlight))success failure:(void (^)(NSError *error))failure {
    [WebServiceController callURLString:API_URL_SEND_BOOKING_REQUEST withRequest:[NSMutableDictionary dictionaryWithDictionary:requestDictionary] andMethod:@"POST" withSuccess:^(NSDictionary *responseDictionary) {
        if (responseDictionary == nil) {
            return;
        }else {
            NSDictionary *resp = [responseDictionary objectForKey:@"response"];
            if ([[NSString stringWithFormat:@"%@", [resp objectForKey:@"Responsecode"]] isEqualToString:@"1"]) {
                success(resp);
            } else {
                if(responseDictionary){
                    NSString *values = [[responseDictionary objectForKey:@"response"] objectForKey:@"Message"];
                    NSError *error = [NSError errorWithDomain:@"SpotlightErrror" code:0 userInfo:@{NSLocalizedDescriptionKey: values}];
                    failure(error);
                }
            }
        }
    } failure:failure];
}
- (void)getBookingRequest:(NSDictionary *)requestDictionary withSuccess:(void (^)(NSDictionary *spotlight))success failure:(void (^)(NSError *error))failure {
    [WebServiceController callURLString:API_URL_GET_BOOKING_REQUEST withRequest:[NSMutableDictionary dictionaryWithDictionary:requestDictionary] andMethod:@"POST" withSuccess:^(NSDictionary *responseDictionary) {
        if (responseDictionary == nil) {
            return;
        } else {
            if ([responseDictionary[@"status"] isEqualToString:@"Success"]) {
                NSDictionary *resp = [responseDictionary objectForKey:@"response"];
                success(resp);
            } else {
                success([responseDictionary objectForKey:@"response"]);
            }
        }
    } failure:failure];
}
- (void)manageBookingRequest:(NSDictionary *)requestDictionary withSuccess:(void (^)(NSDictionary *spotlight))success failure:(void (^)(NSError *error))failure {
    [WebServiceController callURLString:API_URL_MANAGE_BOOKING_REQUEST withRequest:[NSMutableDictionary dictionaryWithDictionary:requestDictionary] andMethod:@"POST" withSuccess:^(NSDictionary *responseDictionary) {
        if (responseDictionary == nil) {
            return;
        }else {
            NSDictionary *resp = [responseDictionary objectForKey:@"response"];
            if ([resp[@"status"] isEqualToString:@"Success"]) {
                success(resp);
            } else {
                if(responseDictionary){
//                    NSString *values = [[responseDictionary objectForKey:@"response"] objectForKey:@"Message"];
                    NSError *error = [NSError errorWithDomain:@"SpotlightErrror" code:0 userInfo:@{NSLocalizedDescriptionKey: resp[@"status"]}];
                    failure(error);
                }
            }
        }
    } failure:failure];
}
- (void)getManagedBookingRequest:(NSDictionary *)requestDictionary withSuccess:(void (^)(NSDictionary *spotlight))success failure:(void (^)(NSError *error))failure {
    [WebServiceController callURLString:API_URL_GET_MANAGED_BOOKING_REQUEST withRequest:[NSMutableDictionary dictionaryWithDictionary:requestDictionary] andMethod:@"POST" withSuccess:^(NSDictionary *responseDictionary) {
        if ([responseDictionary[@"status"] isEqualToString:@"Success"]) {
            NSDictionary *resp = [responseDictionary objectForKey:@"response"];
            success(resp);
        } else {
            success(responseDictionary[@"response"]);
        }
    } failure:failure];
}
- (void)registerBooking:(NSDictionary *)requestDictionary withSuccess:(void (^)(NSDictionary *spotlight))success failure:(void (^)(NSError *error))failure {
    [WebServiceController callURLString:API_URL_REGISTER_BOOKING withRequest:[NSMutableDictionary dictionaryWithDictionary:requestDictionary] andMethod:@"POST" withSuccess:^(NSDictionary *responseDictionary) {
        if (responseDictionary == nil) {
            return;
        }else {
            NSDictionary *resp = [responseDictionary objectForKey:@"response"];
            if ([resp[@"status"] isEqualToString:@"Success"]) {
                success(resp);
            } else {
                if(responseDictionary){
                    //                    NSString *values = [[responseDictionary objectForKey:@"response"] objectForKey:@"Message"];
                    NSError *error = [NSError errorWithDomain:@"SpotlightErrror" code:0 userInfo:@{NSLocalizedDescriptionKey: resp[@"status"]}];
                    failure(error);
                }
            }
        }
    } failure:failure];
}
- (void)getRegisteredBooking:(NSDictionary *)requestDictionary withSuccess:(void (^)(NSDictionary *spotlight))success failure:(void (^)(NSError *error))failure {
    [WebServiceController callURLString:API_URL_GET_REGISTERD_BOOKING withRequest:[NSMutableDictionary dictionaryWithDictionary:requestDictionary] andMethod:@"POST" withSuccess:^(NSDictionary *responseDictionary) {
        if (responseDictionary == nil) {
            return;
        }else {
            NSDictionary *resp = [responseDictionary objectForKey:@"response"];
            if ([resp[@"status"] isEqualToString:@"Success"]) {
                success(resp);
            } else {
                if(responseDictionary){
                    NSString *values = [[responseDictionary objectForKey:@"response"] objectForKey:@"message"];
                    NSError *error = [NSError errorWithDomain:@"SpotlightErrror" code:0 userInfo:@{NSLocalizedDescriptionKey: values}];
                    failure(error);
                }
            }
        }
    } failure:failure];
}
- (void)joinGYM:(NSDictionary *)requestDictionary withSuccess:(void (^)(NSDictionary *spotlight))success failure:(void (^)(NSError *error))failure {
    [WebServiceController callURLString:API_URL_JOIN_GYM withRequest:[NSMutableDictionary dictionaryWithDictionary:requestDictionary] andMethod:@"POST" withSuccess:^(NSDictionary *responseDictionary) {
        if (responseDictionary == nil) {
            return;
        }else {
            NSDictionary *resp = [responseDictionary objectForKey:@"response"];
            if ([[NSString stringWithFormat:@"%@", [resp objectForKey:@"Responsecode"]] isEqualToString:@"1"]) {
                success(resp);
            } else {
                if(responseDictionary){
                    NSString *values = [[responseDictionary objectForKey:@"response"] objectForKey:@"Message"];
                    NSError *error = [NSError errorWithDomain:@"SpotlightErrror" code:0 userInfo:@{NSLocalizedDescriptionKey: values}];
                    failure(error);
                }
            }
        }
    } failure:failure];
}
///////////////////////////////////
#pragma mark - Parsing Response

- (NSArray *)spotlightsFromResponseDictionary:(NSDictionary *)responseDictionary{

    NSMutableArray *spotlights = [NSMutableArray new];
    
    NSString *baseURL = [[responseDictionary objectForKey:@"response"] objectForKey:@"baseurl"];
    
    NSArray *spotlightsDict = [[responseDictionary objectForKey:@"response"] objectForKey:@"spotlights"];
    
    for (NSDictionary *userDict in spotlightsDict) {
        
        NSDictionary *userInfoDict = [userDict objectForKey:@"Spotlight"];
        
        Spotlight *spotlight = [[Spotlight alloc]initWithDictionary:userInfoDict];
        
        // Make Full profile URL
        if (spotlight.image) {
            
            spotlight.image = [baseURL stringByAppendingPathComponent:spotlight.image];
            
        }
        [spotlights addObject:spotlight];
    }
    
    return spotlights;
    
}


- (Spotlight *)spotlightFromResponseDictionary:(NSDictionary *)responseDictionary{
    
//    NSMutableArray *spotlights = [NSMutableArray new];
    
    NSString *baseURL = [[responseDictionary objectForKey:@"response"] objectForKey:@"baseurl"];
    
//    NSArray *spotlightsDict = [[responseDictionary objectForKey:@"response"] objectForKey:@"spotlights"];
    
//    for (NSDictionary *userDict in spotlightsDict) {
    
        NSDictionary *userInfoDict = [responseDictionary valueForKeyPath:@"response.message"];
        
        Spotlight *spotlight = [[Spotlight alloc]initWithDetails:userInfoDict];
        
        // Make Full profile URL
        if (spotlight.image) {
            
            spotlight.image = [baseURL stringByAppendingPathComponent:spotlight.image];
            
        }
    if (spotlight.backgroundImage) {

        spotlight.backgroundImage = [baseURL stringByAppendingPathComponent:spotlight.backgroundImage];

    }
//        [spotlights addObject:spotlight];
//    }
    
    return spotlight;
    
}

@end
