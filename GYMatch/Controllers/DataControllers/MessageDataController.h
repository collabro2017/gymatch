//
//  MessageDataController.h
//  GYMatch
//
//  Created by Ram on 27/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageDataController : NSObject


- (void)messagesForUser:(NSInteger)userID WithSuccess:(void (^)(NSArray *messages))success
                   failure:(void (^)(NSError *error))failure;

- (void)messagesForGroup:(NSInteger)groupID WithSuccess:(void (^)(NSArray *))success
                 failure:(void (^)(NSError *))failure;

- (void)gymChatsWithSuccess:(void (^)(NSArray *messages))success
                failure:(void (^)(NSError *error))failure;

- (void)gymChatCommentsFor:(NSInteger)gymChatID withSuccess:(void (^)(NSArray *comments))success
                    failure:(void (^)(NSError *error))failure;

- (void)deleteGymChat:(NSInteger)gymChatID withSuccess:(void (^)(void))success
              failure:(void (^)(NSError *error))failure;

- (void)deleteChat:(NSInteger)chatID withSuccess:(void (^)(void))success
              failure:(void (^)(NSError *error))failure;

- (void)deleteMessages:(NSInteger)userID withSuccess:(void (^)(void))success failure:(void (^)(NSError *))failure;

- (void)unreadMessagesWithSuccess:(void (^)(NSInteger count))success
              failure:(void (^)(NSError *error))failure;

- (void)unreadMessagesWithUserID:(NSInteger)userID withSuccess:(void (^)(NSInteger count))success
                          failure:(void (^)(NSError *error))failure;

- (void)sendersWithSuccess:(void (^)(NSArray *friends))success
                   failure:(void (^)(NSError *error))failure;

- (void)sendWithDictionary:(NSDictionary *)requestDictionary
                      andImage:(UIImage *)image
                   withSuccess:(void (^)(NSString *response))success
                       failure:(void (^)(NSError *error))failure;

- (void)sendGymChatWithDictionary:(NSDictionary *)requestDictionary
                  andImage:(UIImage *)image
               withSuccess:(void (^)(User *user))success
                   failure:(void (^)(NSError *error))failure;

- (void)likeGymChat:(NSInteger)gymChatID
                  like:(BOOL)status
               withSuccess:(void (^)(void))success
                   failure:(void (^)(NSError *error))failure;

- (void)gymChatLikesFor:(NSInteger)gymChatID
            withSuccess:(void (^)(NSArray *aLikes))success
                   failure:(void (^)(NSError *error))failure;

- (void)commentGymChat:(NSInteger)gymChatID
               comment:(NSString *)comment
        withSuccess:(void (^)(void))success
            failure:(void (^)(NSError *error))failure;

+ (NSArray *)dummyMessages;

@end
