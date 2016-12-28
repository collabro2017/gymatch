//
//  UserDataController.h
//  GYMatch
//
//  Created by Ram on 16/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

static NSArray *countries;
static NSArray *states;

@class Friend;

@interface UserDataController : NSObject

@property(nonatomic, retain)User *user;

- (void)loginWithSuccess:(void (^)(User *user))success
                 failure:(void (^)(NSError *error))failure;

- (void)fbLoginWithID:(NSString *)fbID
                email:(NSString *)email
              success:(void (^)(User *user))success
                 failure:(void (^)(NSError *error))failure;

- (void)logoutSuccess:(void (^)(void))success
              failure:(void (^)(NSError * error))failure;

- (void)registerWithDictionary:(NSDictionary *)requestDictionary
                      andImage:(UIImage *)image
                   withSuccess:(void (^)(User *user))success
                       failure:(void (^)(NSError *error))failure;

- (void)updateWithDictionary:(NSDictionary *)requestDictionary
                    andImage:(UIImage *)image
                 withSuccess:(void (^)(User *user))success
                     failure:(void (^)(NSError *error))failure;

- (void)changePasswordWithDictionary:(NSDictionary *)requestDictionary
                  withSuccess:(void (^)(void))success
                      failure:(void (^)(NSError *error))failure;

- (void)checkinWithDictionary:(NSDictionary *)requestDictionary
                 withSuccess:(void (^)(void))success
                     failure:(void (^)(NSError *error))failure;

- (void)friendsOf:(NSInteger)userID withKeyword:(NSString *)keyword withSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure;

- (void)friendsWithDic:(NSInteger)userID withKeyword:(NSDictionary *)keyword withSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure;

- (void)changeAvailable:(NSString *)available_status  withSuccess:(void (^)(void))success  failure:(void (^)(NSError *))failure;

- (void)searchWith:(NSDictionary *)requestDictionary
           Success:(void (^)(NSArray *friends))success
           failure:(void (^)(NSError *error))failure;

- (void)recommendedWithDictionary:(NSDictionary *)requestDictionary
                      withSuccess:(void (^)(NSArray *friends))success
                          failure:(void (^)(NSError *error))failure;

- (void)recommendedWithKeyword:(NSString *)keyword withSuccess:(void (^)(NSArray *friends))success
                       failure:(void (^)(NSError *error))failure;

- (void)countries:(void (^)(NSArray *countries))success
                       failure:(void (^)(NSError *error))failure;


- (void)states:(void (^)(NSArray *states))success
          failure:(void (^)(NSError *error))failure;

- (void)pushNotificationStatus:(void (^)(BOOL status))success
       failure:(void (^)(NSError *error))failure;

- (void)setPushNotificationStatus:(BOOL)status success:(void (^)(void))success
                       failure:(void (^)(NSError *error))failure;

- (void)profileDetails:(NSInteger)userID
           withSuccess:(void (^)(Friend *aFriend))success
               failure:(void (^)(NSError *error))failure;

- (void)fbInvite:(NSString *)userFBID
           withSuccess:(void (^)(void))success
               failure:(void (^)(NSError *error))failure;

- (void)addFriend:(NSInteger)userID
      withSuccess:(void (^)(void))success
          failure:(void (^)(NSError *error))failure;

- (void)deleteAccount:(NSInteger)userID
      withSuccess:(void (^)(void))success
              failure:(void (^)(NSError *error))failure;

- (void)reactiveAccount:(NSInteger)userID
          withSuccess:(void (^)(void))success
              failure:(void (^)(NSError *error))failure;

- (void)forgotPass:(NSString *)email
          withSuccess:(void (^)(void))success
              failure:(void (^)(NSError *error))failure;

- (void)respond:(NSInteger)userID
   withResponse:(NSString *)status
    withSuccess:(void (^)(void))success
        failure:(void (^)(NSError *error))failure;

- (void)reportWithDictionary:(NSDictionary *)requestDictionary
                 withSuccess:(void (^)(void))success
                     failure:(void (^)(NSError *error))failure;

- (void)requestsWithType:(NSString *)type
                 keyword:(NSString *)keyword
                 Success:(void (^)(NSArray *friends))success
                 failure:(void (^)(NSError *error))failure;
- (void)requestsWithTypeDic:(NSString *)type
                 keyword:(NSDictionary *)keyword
                 Success:(void (^)(NSArray *friends))success
                 failure:(void (^)(NSError *error))failure;

- (NSArray *)friendsFromResponseDictionary:(NSDictionary *)responseDictionary;
- (NSArray *)latestChatsFromResponseDictionary:(NSDictionary *)responseDictionary; 

- (void)refersWithKeyword:(NSString *)keyword success:(void (^)(NSArray *friends))success
                   failure:(void (^)(NSError *error))failure;

- (void)rememberUser:(User *)user;
- (void)forgetUser;
- (BOOL)isUserLoggedIn;

- (void)loadUserDetails;


@end
