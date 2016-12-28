//
//  UserDataController.m
//  GYMatch
//
//  Created by Ram on 16/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "UserDataController.h"
#import "WebServiceController.h"
#import "Friend.h"
#import "Gym.h"
#import "Utility.h"
#import "Country.h"

@implementation UserDataController

#pragma mark - Web Service Calls

- (void)loginWithSuccess:(void (^)(User *))success
                 failure:(void (^)(NSError *))failure{
    
    NSMutableDictionary *requestDictionary = [NSMutableDictionary dictionaryWithDictionary:[self.user dictionaryForLogin]];
    
    [WebServiceController callURLString:API_URL_LOGIN
                            withRequest:requestDictionary
                              andMethod:@"POST"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                self.user.password = nil;
                                
                                if ([[responseDictionary valueForKeyPath:@"response.status"] isEqualToString:@"Success"]) {
                                    self.user.ID = [[responseDictionary valueForKeyPath:@"response.userid"] integerValue];
                                    success (self.user);
                                } else {
                                    NSString *message = [responseDictionary valueForKeyPath:@"response.message"];
                                    
                                    NSError *error = [NSError errorWithDomain:@"UserError" code:0 userInfo:@{NSLocalizedDescriptionKey: message}];
                                    
                                    failure(error);
                                }
                                
                            } failure:failure];

}

- (void)fbLoginWithID:(NSString *)fbID email:(NSString *)email success:(void (^)(User *))success failure:(void (^)(NSError *))failure{
    
    NSMutableDictionary *requestDictionary = [NSMutableDictionary dictionaryWithDictionary:@{@"fbid": fbID,
                                                                                             @"email": email,
                                                                                             @"device_token": [APP_DELEGATE deviceToken],
                                                                                             @"device_os": @"iOS"}];
    
    [WebServiceController callURLString:API_URL_FB_LOGIN_CHECKIN
                            withRequest:requestDictionary
                              andMethod:@"POST"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                
                                self.user.password = nil;
                                
                                if ([[responseDictionary valueForKeyPath:@"response.status"] isEqualToString:@"Success"])
                                {
                                    self.user.ID = [[responseDictionary valueForKeyPath:@"response.userid"] integerValue];
                                    success (self.user);          
                                }
                                else
                                {
                                    NSString *message = [[responseDictionary valueForKeyPath:@"response.message"] stringValue];
                                    NSError *error = [NSError errorWithDomain:@"UserError" code:0 userInfo:@{NSLocalizedDescriptionKey:message}];
                                    failure(error);
                                }
                                
                            } failure:failure];
}

- (void)changeAvailable:(NSString *)available_status withSuccess:(void (^)(void))success  failure:(void (^)(NSError *))failure{
    
    NSMutableDictionary *requestDictionary = [NSMutableDictionary dictionaryWithDictionary:@{@"status": available_status}];
    
    [WebServiceController callURLString:API_URL_AVAILABLE
                            withRequest:requestDictionary
                              andMethod:@"POST"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                if ([[responseDictionary valueForKeyPath:@"response.status"] isEqualToString:@"Success"]) {
                                    
                                } else {
                                    NSString *message = [responseDictionary valueForKeyPath:@"response.message"];
                                    
                                    NSError *error = [NSError errorWithDomain:@"UserError" code:0 userInfo:@{NSLocalizedDescriptionKey: message}];
                                    
                                    failure(error);
                                }
                                
                            } failure:failure];
    
}


- (void)registerWithDictionary:(NSDictionary *)requestDictionary
                      andImage:(UIImage *)image
                   withSuccess:(void (^)(User *user))success
                       failure:(void (^)(NSError *error))failure{
    
    [WebServiceController callURLString:API_URL_REGISTER
                            withRequest:[NSMutableDictionary dictionaryWithDictionary:requestDictionary]
                              withImage:image
                              andMethod:@"POST"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                
                                if ([[[responseDictionary objectForKey:@"response"] objectForKey:@"status"] isEqualToString:@"Success"]) {
                                    success(nil);
                                } else {
                                    
                                    NSArray *keys = @[@"username",
                                                      @"password",
                                                      @"email",
                                                      @"gender",
                                                      @"age",
                                                      @"city",
                                                      @"state"];
                                    
                                    NSMutableArray *messages = [NSMutableArray new];
                                    
                                    for (NSString *key in keys) {
                                        NSString *path = [@"response.message." stringByAppendingString:key];
                                        NSArray *valueArray = [responseDictionary valueForKeyPath:path];
                                        NSString *value = [valueArray componentsJoinedByString:@"\n"];
                                        if (value) {
                                            [messages addObject:value];
                                        }
                                    }
                                    
                                    NSString *message = [messages componentsJoinedByString:@"\n"];
                                    
                                    NSError *error = [NSError errorWithDomain:@"UserError" code:0 userInfo:@{NSLocalizedDescriptionKey: message}];
                                    
                                    failure(error);
                                }
                                
                            } failure:failure];
}

- (void)updateWithDictionary:(NSDictionary *)requestDictionary
                      andImage:(UIImage *)image
                   withSuccess:(void (^)(User *user))success
                       failure:(void (^)(NSError *error))failure{
    
    NSString *stringURL = [NSString stringWithFormat:@"%@%ld", API_URL_PROFILE_UPDATE, (long)[[APP_DELEGATE loggedInUser] ID]];
    
    [WebServiceController callURLString:stringURL
                            withRequest:[NSMutableDictionary dictionaryWithDictionary:requestDictionary]
                              withImage:image
                              andMethod:@"POST"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                
                                if ([[[responseDictionary objectForKey:@"response"] objectForKey:@"status"] isEqualToString:@"Success"]) {
                                    success(nil);
                                } else {
                                    
                                    NSArray *keys = @[@"username",
                                                      @"firstname",
                                                      @"lastname",
                                                      @"password",
                                                      @"email",
                                                      @"gender",
                                                      @"age",
                                                      @"city",
                                                      @"state",
                                                      @"aboutme"];
                                    
                                    NSMutableArray *messages = [NSMutableArray new];
                                    
                                    for (NSString *key in keys) {
                                        NSString *path = [@"response.message." stringByAppendingString:key];
                                        NSArray *valueArray = [responseDictionary valueForKeyPath:path];
                                        NSString *value = [valueArray componentsJoinedByString:@"\n"];
                                        if (value) {
                                            [messages addObject:value];
                                        }
                                    }
                                    
                                    NSString *message = [messages componentsJoinedByString:@"\n"];
                                    
                                    NSError *error = [NSError errorWithDomain:@"UserError" code:0 userInfo:@{NSLocalizedDescriptionKey: message}];
                                    
                                    failure(error);
                                }
                                
                            } failure:failure];
    
}

- (void)changePasswordWithDictionary:(NSDictionary *)requestDictionary
                  withSuccess:(void (^)(void))success
                      failure:(void (^)(NSError *))failure{
    
    //    NSString *stringURL = [NSString stringWithFormat:@"%@", API_URL_CHECKIN];
    
    [WebServiceController callURLString:API_URL_CHANGE_PASSWORD
                            withRequest:[NSMutableDictionary dictionaryWithDictionary:requestDictionary]
                              andMethod:@"POST"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                
                                if ([[[responseDictionary objectForKey:@"response"] objectForKey:@"status"] isEqualToString:@"Success"]) {
                                    
                                    success();
                                    
                                } else if ([[[responseDictionary objectForKey:@"response"] objectForKey:@"status"] isEqualToString:@"ValidationError"]) {
                                    
                                
                                    
                                    NSArray *values = [[[responseDictionary objectForKey:@"response"] objectForKey:@"message"] allValues];
                                    
                                    NSString *message = [values componentsJoinedByString:@"."];
                                    message = [message stringByReplacingOccurrencesOfString:@"(" withString:@""];
                                    message = [message stringByReplacingOccurrencesOfString:@")" withString:@""];
                                    message = [message stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                                    message = [message stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                                    message = [message stringByReplacingOccurrencesOfString:@"    " withString:@"\n"];
                                    
                                    NSError *error = [NSError errorWithDomain:@"UserError" code:0 userInfo:@{NSLocalizedDescriptionKey: message}];
                                    

                                    failure(error);
                                    
                                }else{
                                    
                                    NSString *values = [responseDictionary valueForKeyPath:@"response.message"];
                                    
                                    NSError *error = [NSError errorWithDomain:@"UserError" code:0 userInfo:@{NSLocalizedDescriptionKey: values}];
                                    failure(error);
                                    
                                }
                                
                            } failure:failure];
    
}

- (void)checkinWithDictionary:(NSDictionary *)requestDictionary
                  withSuccess:(void (^)(void))success
                      failure:(void (^)(NSError *))failure{
    
    //    NSString *stringURL = [NSString stringWithFormat:@"%@", API_URL_CHECKIN];
    
    [WebServiceController callURLString:API_URL_CHECKIN
                            withRequest:[NSMutableDictionary dictionaryWithDictionary:requestDictionary]
                              andMethod:@"POST"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                
                                if ([[[responseDictionary objectForKey:@"response"] objectForKey:@"status"] isEqualToString:@"Success"]) {
                                    
                                    success();
                                    
                                } else {
                                    
                                    NSArray *values = [[responseDictionary valueForKeyPath:@"response.message"] allValues];
                                    
                                    NSError *error = [NSError errorWithDomain:@"UserError" code:0 userInfo:@{NSLocalizedDescriptionKey: [values componentsJoinedByString:@".\n"]}];
                                    
                                    failure(error);
                                    
                                }
                                
                            } failure:failure];
    
}

- (void)reportWithDictionary:(NSDictionary *)requestDictionary withSuccess:(void (^)(void))success failure:(void (^)(NSError *))failure{
    
    [WebServiceController callURLString:API_URL_PROFILE_REPORT
                            withRequest:[NSMutableDictionary dictionaryWithDictionary:requestDictionary]
                              andMethod:@"POST"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                
                                if ([[[responseDictionary objectForKey:@"response"] objectForKey:@"status"] isEqualToString:@"Success"]) {
                                    success();
                                } else {
                                    NSArray *values = [[[responseDictionary objectForKey:@"response"] objectForKey:@"message"] allValues];
                                    
                                    NSError *error = [NSError errorWithDomain:@"UserError" code:0 userInfo:@{NSLocalizedDescriptionKey: [values componentsJoinedByString:@".\n"]}];
                                    
                                    failure(error);
                                }
                                
                            } failure:failure];
}

- (void)addFriend:(NSInteger)userID withSuccess:(void (^)(void))success failure:(void (^)(NSError *))failure{
    
    NSDictionary *requestDictionary = @{@"receiverid": [NSNumber numberWithInteger:userID]};
    
    [WebServiceController callURLString:API_URL_ADD_FRIEND
                            withRequest:[NSMutableDictionary dictionaryWithDictionary:requestDictionary]
                              andMethod:@"POST"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                
                                if ([[[responseDictionary objectForKey:@"response"] objectForKey:@"status"] isEqualToString:@"Success"]) {
                                    success();
                                } else {
                                    NSString *message = [[responseDictionary objectForKey:@"response"] objectForKey:@"message"];
                                    
                                    
                                    NSError *error = [NSError errorWithDomain:@"UserError" code:0 userInfo:@{NSLocalizedDescriptionKey:message}];
                                    
                                    failure(error);
                                }
                                
                            } failure:failure];
}


- (void)deleteAccount:(NSInteger)userID withSuccess:(void (^)(void))success failure:(void (^)(NSError *))failure{
    
//    NSDictionary *requestDictionary = @{@"appuser_id": [NSNumber numberWithInteger:userID]};
    
    NSString *urlString = [NSString stringWithFormat:@"%@%ld", API_URL_PROFILE, (long)userID];
    
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
    
}

- (void)reactiveAccount:(NSInteger)userID withSuccess:(void (^)(void))success failure:(void (^)(NSError *))failure{
    
    //    NSDictionary *requestDictionary = @{@"appuser_id": [NSNumber numberWithInteger:userID]};
    
    NSString *urlString = [NSString stringWithFormat:@"%@%ld", API_URL_REACTIVATE, (long)userID];
    
    [WebServiceController callURLString:urlString
                            withRequest:nil
                              andMethod:@"POST"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                
                                if ([[[responseDictionary objectForKey:@"response"] objectForKey:@"status"] isEqualToString:@"Success"]) {
                                    success();
                                } else {
                                    NSString *message = [[responseDictionary objectForKey:@"response"] objectForKey:@"message"];
                                    
                                    
                                    NSError *error = [NSError errorWithDomain:@"UserError" code:0 userInfo:@{NSLocalizedDescriptionKey:message}];
                                    
                                    failure(error);
                                }
                                
                            } failure:failure];
    
}

- (void)forgotPass:(NSString *)email withSuccess:(void (^)(void))success failure:(void (^)(NSError *))failure{
    
    NSDictionary *requestDictionary = @{@"email": email};
    
    [WebServiceController callURLString:API_URL_FORGOT_PASSWORD
                            withRequest:[NSMutableDictionary dictionaryWithDictionary:requestDictionary]
                              andMethod:@"POST"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                
                                if ([[[responseDictionary objectForKey:@"response"] objectForKey:@"status"] isEqualToString:@"Success"]) {
                                    success();
                                } else {
                                    NSString *message = [[responseDictionary objectForKey:@"response"] objectForKey:@"message"];
                                    
                                    NSError *error = [NSError errorWithDomain:@"UserError" code:0 userInfo:@{NSLocalizedDescriptionKey:message}];
                                    
                                    failure(error);
                                }
                                
                            } failure:failure];
}

- (void)respond:(NSInteger)userID
   withResponse:(NSString *)status
    withSuccess:(void (^)(void))success
        failure:(void (^)(NSError *error))failure{
    
    NSDictionary *requestDictionary = @{@"senderid": [NSNumber numberWithInteger:userID],
                                        @"status": status};
    
    [WebServiceController callURLString:API_URL_FRIEND_RESPOND
                            withRequest:[NSMutableDictionary dictionaryWithDictionary:requestDictionary]
                              andMethod:@"POST"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                
                                if ([[[responseDictionary objectForKey:@"response"] objectForKey:@"status"] isEqualToString:@"Success"]) {
                                    success();
                                } else {
                                    NSString *message = [[responseDictionary objectForKey:@"response"] objectForKey:@"message"];
                                    
                                    
                                    NSError *error = [NSError errorWithDomain:@"UserError" code:0 userInfo:@{NSLocalizedDescriptionKey:message}];
                                    
                                    failure(error);
                                }
                                
                            } failure:failure];
    
}


- (void)friendsOf:(NSInteger)userID withKeyword:(NSString *)keyword withSuccess:(void (^)(NSArray *))success
          failure:(void (^)(NSError *))failure{
    
    NSString *stringURL = [NSString stringWithFormat:@"%@%ld", API_URL_FRIENDS, (long)userID];
    
    //NSMutableDictionary *requestDictionary = [NSMutableDictionary dictionaryWithDictionary:@{@"keyword": keyword}];
    
    
  //  NSMutableDictionary *requestDictionary = [NSMutableDictionary dictionaryWithDictionary:@{@"city":@"", @"country":@"",@"gender":@"",@"name":@"",@"state":@""}];
    

    NSMutableDictionary *requestDictionary = [NSMutableDictionary dictionaryWithDictionary:@{@"city":@"Select your name", @"country":@"Select your name",@"gender":@"",@"name":keyword,@"state":@"Select your name"}];

    
    [WebServiceController callURLString:stringURL
                            withRequest:requestDictionary
                              andMethod:@"POST"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                
                                success (
                                         [self friendsFromResponseDictionary:responseDictionary]
                                         );
                            } failure:failure];
}


//friendsWithDic
- (void)friendsWithDic:(NSInteger)userID withKeyword:(NSMutableDictionary *)keyword withSuccess:(void (^)(NSArray *))success
          failure:(void (^)(NSError *))failure{
      NSLog(@"call3");  
    NSString *stringURL = [NSString stringWithFormat:@"%@%ld", API_URL_FRIENDS, (long)userID];
    NSLog(@"%@", success);
  //  NSMutableDictionary *requestDictionary = [NSMutableDictionary dictionaryWithDictionary:@{@"keyword": @"happy", @"name": @"mike"}];
  //  NSLog(@"%@", [requestDictionary objectForKey:@"keyword"]);
    //[NSMutableDictionary dictionaryWithObjectsAndKeys:<#(id), ...#>, nil]
    [WebServiceController callURLString:stringURL
                            withRequest:keyword
                              andMethod:@"POST"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                
                                success (
                                         [self friendsFromResponseDictionary:responseDictionary]
                                         );
                            } failure:failure];
}

- (void)refersWithKeyword:(NSString *)keyword success:(void (^)(NSArray *friends))success
                  failure:(void (^)(NSError *error))failure{
    
    NSString *stringURL = [API_URL_FRIENDS_REFERS stringByAppendingString:keyword];
    
    [WebServiceController callURLString:stringURL
                            withRequest:nil
                              andMethod:@"GET"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                
                                
                                success (
                                         [self friendsFromResponseDictionary:responseDictionary]
                                         );
                            } failure:failure];
    
}

- (void)searchWith:(NSDictionary *)requestDictionary
           Success:(void (^)(NSArray *))success
           failure:(void (^)(NSError *))failure{
    
    [WebServiceController callURLString:API_URL_FRIENDS_SEARCH
                            withRequest:[NSMutableDictionary dictionaryWithDictionary:requestDictionary]
                              andMethod:@"POST"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                
                                success (
                                         [self friendsFromResponseDictionary:responseDictionary]
                                         );
                                
                            } failure:failure];
}

-(void)requestsWithTypeDic:(NSString *)type keyword:(NSDictionary *)keyword Success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
    NSString *stringURL = [NSString stringWithFormat:@"%@type:%@", API_URL_FRIEND_REQUESTS, type];

    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:keyword];
    [WebServiceController callURLString:stringURL
                            withRequest:dict
                              andMethod:@"POST"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                
                                success (
                                         [self friendsFromResponseDictionary:responseDictionary]
                                         );
                            } failure:failure];

}
- (void)requestsWithType:(NSString *)type
                 keyword:(NSString *)keyword
                 Success:(void (^)(NSArray *))success
                 failure:(void (^)(NSError *))failure{
    
    NSString *stringURL = [NSString stringWithFormat:@"%@type:%@/keyword:%@", API_URL_FRIEND_REQUESTS, type, keyword];
    
    [WebServiceController callURLString:stringURL
                            withRequest:nil
                              andMethod:@"GET"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                
                                success (
                                         [self friendsFromResponseDictionary:responseDictionary]
                                         );
                            } failure:failure];
}

- (void)logoutSuccess:(void (^)(void))success
                   failure:(void (^)(NSError *))failure{
    
    
    NSMutableDictionary *requestDictionary = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                             @"device_token": [APP_DELEGATE deviceToken],
                                                                                             @"device_os": @"iOS",}];
    
    [WebServiceController callURLString:API_URL_LOGOUT
                            withRequest:requestDictionary
                              andMethod:@"POST"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                success ();
                            } failure:failure];
}

- (void)recommendedWithDictionary:(NSDictionary *)requestDictionary withSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
    NSString *stringURL = [NSString stringWithFormat:@"%@", APT_URL_RECOMMENDED_FILTER];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:requestDictionary];
    NSLog(@"filter dic==>%@",dict);
    [WebServiceController callURLString:stringURL
                            withRequest:dict
                              andMethod:@"POST"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                success (
                                         [self friendsFromResponseDictionary:responseDictionary]
                                         );
                                
                            } failure:failure];
    

}

- (void)recommendedWithKeyword:(NSString *)keyword withSuccess:(void (^)(NSArray *))success
                   failure:(void (^)(NSError *))failure{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", API_URL_FRIENDS_RECOMMEND, keyword];
    
    [WebServiceController callURLString:urlString
                            withRequest:nil
                              andMethod:@"GET"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                success (
                                         [self friendsFromResponseDictionary:responseDictionary]
                                         );
                            } failure:failure];
    
}


- (void)countries:(void (^)(NSArray *))success
          failure:(void (^)(NSError *))failure{
    
    if ([countries count] != 0) {
        success(countries);
        return;
    }
    
    [WebServiceController callURLString:API_URL_COUNTRIES
                            withRequest:nil
                              andMethod:@"GET"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                
                                countries = [self countiresFromResponseDictionary:responseDictionary];
                                
                                success (
                                        countries
                                         );
                                
                            } failure:failure];
    
}

- (void)states:(void (^)(NSArray *))success
          failure:(void (^)(NSError *))failure{
    NSLog(@"%@", API_URL_STATES);
    
    if ([states count] != 0) {
        success(states);
        return;
    }
    
    [WebServiceController callURLString:API_URL_STATES
                            withRequest:nil
                              andMethod:@"GET"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                states = [self statesFromResponseDictionary:responseDictionary];
                                success (
                                         states
                                         );
                                
                            } failure:failure];
    
}

- (void)setPushNotificationStatus:(BOOL)status success:(void (^)(void))success failure:(void (^)(NSError *))failure{
    NSString *urlString = [NSString stringWithFormat:@"%@%d", API_URL_SET_PN_STATUS, status];
    
    [WebServiceController callURLString:urlString
                            withRequest:nil
                              andMethod:@"GET"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                if ([[[responseDictionary objectForKey:@"response"] objectForKey:@"status"] isEqualToString:@"Success"]) {
                                    success();
                                } else {
                                    NSString *message = [[responseDictionary objectForKey:@"response"] objectForKey:@"message"];
                                    
                                    
                                    NSError *error = [NSError errorWithDomain:@"UserError" code:0 userInfo:@{NSLocalizedDescriptionKey:message}];
                                    
                                    failure(error);
                                }
                                
                                
                            } failure:failure];
}

- (void)pushNotificationStatus:(void (^)(BOOL))success failure:(void (^)(NSError *))failure{
    
    [WebServiceController callURLString:API_URL_PN_STATUS
                            withRequest:nil
                              andMethod:@"GET"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                if ([[[responseDictionary objectForKey:@"response"] objectForKey:@"status"] isEqualToString:@"Success"]) {
                                    success([[responseDictionary valueForKeyPath:@"response.push_notification_status"] boolValue]);
                                } else {
                                    NSString *message = [[responseDictionary objectForKey:@"response"] objectForKey:@"message"];
                                    
                                    
                                    NSError *error = [NSError errorWithDomain:@"UserError" code:0 userInfo:@{NSLocalizedDescriptionKey:message}];
                                    
                                    failure(error);
                                }

                                
                            } failure:failure];
    
}

- (void)profileDetails:(NSInteger)userID
           withSuccess:(void (^)(Friend *aFriend))success
               failure:(void (^)(NSError *error))failure{
    
//    NSMutableDictionary *requestDictionary = [NSMutableDictionary dictionary];
    
    NSString *stringURL = [NSString stringWithFormat:@"%@%ld", API_URL_PROFILE, (long)userID];
    
    [WebServiceController callURLString:stringURL
                            withRequest:nil
                              andMethod:@"GET"
                            withSuccess:^(NSDictionary *responseDictionary) {

                                Friend *friend = [self friendFromResponseDictionary:responseDictionary];
                                success(friend);

                            } failure:failure];

    
}

- (void)fbInvite:(NSString *)userFBID withSuccess:(void (^)(void))success failure:(void (^)(NSError *))failure{
    
    //    NSMutableDictionary *requestDictionary = [NSMutableDictionary dictionary];
    
    NSString *stringURL = [NSString stringWithFormat:@"%@%@", API_URL_INVITE_FB, userFBID];
    
    [WebServiceController callURLString:stringURL
                            withRequest:nil
                              andMethod:@"GET"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                if(responseDictionary != nil)
                                {
                                    // [responseDictionary valueForKeyPath:@"response.status"]
                                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:[responseDictionary valueForKeyPath:@"response.message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                    [alertView show];
                                }

                                success();
                            } failure:failure];
    
    
}

- (NSArray *)dummyFriends{
    Friend *friend = [Friend new];
    friend.ID = 20;
    friend.username = @"Ram one";
    friend.image = nil;
    
    Friend *friend2 = [Friend new];
    friend2.ID = 21;
    friend2.username = @"Ram two";
    friend2.image = nil;
    
    Friend *friend3 = [Friend new];
    friend3.ID = 22;
    friend3.username = @"Ram three";
    friend3.image = nil;
    
    Friend *friend4 = [Friend new];
    friend4.ID = 23;
    friend4.username = @"Ram four";
    friend4.image = nil;
    
    return @[friend, friend2, friend3, friend4];
}

#pragma mark - Parsing Response

- (NSArray *)friendsFromResponseDictionary:(NSDictionary *)responseDictionary{
    
    NSMutableArray *friends = [NSMutableArray new];
    
    NSString *baseURL = [[responseDictionary objectForKey:@"response"] objectForKey:@"baseurl"];
    
    NSArray *friendsDict = [[responseDictionary objectForKey:@"response"] objectForKey:@"users"];
    
    
    NSArray *spotIdsArray = [[responseDictionary objectForKey:@"response"] objectForKey:@"spotlightIDs"]; // Gourav june 22
    
    for (NSDictionary *userDict in friendsDict) {
        
        NSDictionary *userInfoDict = [userDict objectForKey:@"Appuser"];
        
        NSString *country = [userDict valueForKeyPath:@"Country.name"];
        [Utility removeNSNULL:country];
        Friend *friend = [[Friend alloc] initWithDictionary:userInfoDict];
        
        // Gourav for storing spotlight member id start june 22
        
        for (int i=0; i<[spotIdsArray count]; i++) {
            
            NSDictionary *spotLightDictionary = [spotIdsArray objectAtIndex:i];
            NSDictionary *spotDictionary      = [spotLightDictionary objectForKey:@"Spotlight"];
            
            int spot_User_Id = [[spotDictionary objectForKey:@"appusers_id"] intValue];
            
            if (spot_User_Id == (int)friend.ID) {
                friend.member_id = [[spotDictionary objectForKey:@"id"] integerValue];//spot_User_Id;
                NSLog(@"Spotlight Match found");
                break;
            }
        }

        [friend setCountry:country];
        
        // Make Full profile URL
        if (friend.image) {
            friend.image = [baseURL stringByAppendingPathComponent:friend.image];
        }
        
        friend.unreadSentMessageCount = [[userDict valueForKeyPath:@"Chat.total_unread"] intValue];
        
        friend.lastMessage = [[Message alloc] initWithDictionary:userDict];
        [friends addObject:friend];
    }
    
    return friends;
}


- (NSArray *)latestChatsFromResponseDictionary:(NSDictionary *)responseDictionary
{
    NSMutableArray *friends = [NSMutableArray new];

    NSDictionary *responseDict = [responseDictionary objectForKey:@"response"];

    NSString *baseURL = [responseDict objectForKey:@"baseurl"];
    NSArray *userDict = [responseDict objectForKey:@"users"]; // friends with chat messages

    NSString *totalUnread = [responseDict objectForKey:@"datatotalunread"];

    NSMutableArray *friendsDict = [NSMutableArray arrayWithArray:[responseDict objectForKey:@"friendsChat"]]; // total friend list

     for(NSDictionary *dict in userDict)
     {
         NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.Appuser.id == %@", [[dict objectForKey:@"Appuser"] objectForKey:@"id"]];
         NSArray *results = [friendsDict filteredArrayUsingPredicate:predicate];
         if([results firstObject])
         {
             NSDictionary *fr = [results firstObject];
             NSInteger index = [friendsDict indexOfObject:fr];
             [friendsDict replaceObjectAtIndex:index withObject:dict];
         }
    }

    for (NSDictionary *userDict in friendsDict)
    {
        NSDictionary *userInfoDict = [userDict objectForKey:@"Appuser"];

        NSString *country = [userDict valueForKeyPath:@"Country.name"];
        [Utility removeNSNULL:country];
        Friend *friend = [[Friend alloc] initWithDictionary:userInfoDict];

        friend.member_id = 0;
        [friend setCountry:country];

        // Make Full profile URL
        if (friend.image) {
            friend.image = [baseURL stringByAppendingPathComponent:friend.image];
        }

        friend.unreadSentMessageCount = [[userDict valueForKeyPath:@"Chat.total_unread"] intValue];

        friend.lastMessage = [[Message alloc] initWithDictionary:userDict];

        if ([userDict valueForKeyPath:@"Chat.text"] != nil) {
            [friends addObject:friend];
        }

    }

    if(totalUnread != nil)
        [friends addObject:[NSDictionary dictionaryWithObject:totalUnread forKey:@"UnreadCount"]];

    return friends;
}



- (NSArray *)countiresFromResponseDictionary:(NSDictionary *)responseDictionary{
    
    NSMutableArray *friends = [NSMutableArray new];
    
    NSArray *friendsDict = [[responseDictionary objectForKey:@"response"] objectForKey:@"countries"];
    
    for (NSDictionary *userDict in friendsDict) {
        
        NSDictionary *userInfoDict = [userDict objectForKey:@"Country"];
        
        Country *friend = [[Country alloc]initWithDictionary:userInfoDict];
        
        [friends addObject:friend];
    }
    
    return friends;
}

- (NSArray *)statesFromResponseDictionary:(NSDictionary *)responseDictionary{
    
    NSMutableArray *friends = [NSMutableArray new];
    
    NSArray *friendsDict = [[responseDictionary objectForKey:@"response"] objectForKey:@"states"];
    
    for (NSDictionary *userDict in friendsDict) {
        
        NSDictionary *userInfoDict = [userDict objectForKey:@"State"];
        
        Country *friend = [[Country alloc]initWithDictionary:userInfoDict];
        
        [friends addObject:friend];
    }
    
    return friends;
}

- (Friend *)friendFromResponseDictionary:(NSDictionary *)responseDictionary{
   
    NSString *baseURL = [[responseDictionary objectForKey:@"response"] objectForKey:@"baseurl"];
    
    NSDictionary *userInfoDict = [[[responseDictionary objectForKey:@"response"] objectForKey:@"user"] objectForKey:@"Appuser"];
    
    NSString *country = [[[[responseDictionary objectForKey:@"response"] objectForKey:@"user"]  objectForKey:@"Country"] objectForKey:@"name"];
    NSString *gym = [[[[responseDictionary objectForKey:@"response"] objectForKey:@"user"]  objectForKey:@"Gym"] objectForKey:@"biz_name"];
    
    Friend *friend = [[Friend alloc]initWithDictionary:userInfoDict];
    
    if (![country isMemberOfClass:[NSNull class]] && country != nil) {
        
        [friend setCountry:country];
    }
    
    if (![gym isMemberOfClass:[NSNull class]] && gym != nil) {
        
        Gym *aGym = [[Gym alloc]initWithDictionary:[[[responseDictionary objectForKey:@"response"] objectForKey:@"user"]  objectForKey:@"Gym"]];
        [friend setGym:aGym];
        
    }
    
    // Make Full profile URL
    if (friend.image) {
        
        friend.image = [baseURL stringByAppendingPathComponent:friend.image];
        
    }
    
    return friend;
}

#pragma mark - NSUserDefaults

- (void)rememberUser:(User *)user{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:[NSNumber numberWithInteger:user.ID] forKey:USER_ID_KEY];
    [userDefaults setObject:user.username forKey:USER_NAME_KEY];
    [userDefaults setObject:user.password forKey:USER_PASS_KEY];
    
    [userDefaults synchronize];
}

- (void)forgetUser{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:nil forKey:USER_ID_KEY];
    [userDefaults setObject:nil forKey:USER_NAME_KEY];
    [userDefaults setObject:nil forKey:USER_PASS_KEY];

    [userDefaults synchronize];
}

- (BOOL)isUserLoggedIn{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [userDefaults objectForKey:USER_NAME_KEY];
    
    User *user = [User new];
    user.ID = [userDefaults integerForKey:USER_ID_KEY];
    user.username = [userDefaults objectForKey:USER_NAME_KEY];
    user.password = [userDefaults objectForKey:USER_PASS_KEY];
    
    [APP_DELEGATE setLoggedInUser:user];
    
    if (username != nil) {
        return YES;
    }else{
        return NO;
    }
    
}

- (void)loadUserDetails{
    
    
    
}

- (void)loginWithUserDefaults{
    
}

@end
