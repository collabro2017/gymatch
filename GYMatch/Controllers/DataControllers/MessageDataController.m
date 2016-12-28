  //
//  MessageDataController.m
//  GYMatch
//
//  Created by Ram on 27/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "MessageDataController.h"
#import "WebServiceController.h"
#import "UserDataController.h"
#import "Message.h"
#import "GymChat.h"
#import "Comment.h"
#import "Likes.h"

@implementation MessageDataController

- (void)messagesForUser:(NSInteger)userID WithSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%lD", API_URL_MESSAGES, userID];
    [WebServiceController callURLString:urlString
                            withRequest:nil
                              andMethod:@"GET"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                success (
                                         [self messagesFromResponseDictionary:responseDictionary]
                                         );
                            } failure:failure];
}

- (void)messagesForGroup:(NSInteger)groupID WithSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%lD", API_URL_MESSAGE_GROUP, groupID];
    [WebServiceController callURLString:urlString
                            withRequest:nil
                              andMethod:@"GET"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                success (
                                         [self groupMessagesFromResponseDictionary:responseDictionary]
                                         );
                            } failure:failure];
}


- (void)gymChatsWithSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure{
    
    NSString *urlString = [NSString stringWithFormat:@"%@start:%d/end:%d", API_URL_GYMCHAT, 0, 10];
    [WebServiceController callURLString:urlString
                            withRequest:nil
                              andMethod:@"GET"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                success (
                                         [self gymchatsFromResponseDictionary:responseDictionary]
                                         );
                            } failure:failure];
    
}

- (void)gymChatCommentsFor:(NSInteger)gymChatID withSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%lD", API_URL_GYMCHAT_COMMENTS, gymChatID];
    [WebServiceController callURLString:urlString
                            withRequest:nil
                              andMethod:@"GET"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                success (
                                         [self gymchatCommentsFromResponseDictionary:responseDictionary]
                                         );
                            } failure:failure];
}

- (void)deleteGymChat:(NSInteger)gymChatID withSuccess:(void (^)(void))success failure:(void (^)(NSError *))failure{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%d", API_URL_GYMCHAT_SEND, gymChatID];
    [WebServiceController callURLString:urlString
                            withRequest:nil
                              andMethod:@"DELETE"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                success ();
                            } failure:failure];
}

- (void)deleteChat:(NSInteger)chatID withSuccess:(void (^)(void))success failure:(void (^)(NSError *))failure{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%d", API_URL_MESSAGE_SEND, chatID];
    [WebServiceController callURLString:urlString
                            withRequest:nil
                              andMethod:@"DELETE"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                success ();
                            } failure:failure];
}

- (void)deleteMessages:(NSInteger)userID withSuccess:(void (^)(void))success failure:(void (^)(NSError *))failure{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%ld", API_URL_MESSAGE_DELETE, (long)userID];
    [WebServiceController callURLString:urlString
                            withRequest:nil
                              andMethod:@"DELETE"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                success ();
                            } failure:failure];
}

- (void)unreadMessagesWithSuccess:(void (^)(NSInteger))success failure:(void (^)(NSError *))failure{
    
    [WebServiceController callURLString:API_URL_MESSAGE_READ
                            withRequest:nil
                              andMethod:@"GET"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                NSInteger count = [[responseDictionary valueForKeyPath:@"response.count"] integerValue];
                                
                                success (count);
                            } failure:failure];
    
}

- (void)unreadMessagesWithUserID:(NSInteger)userID withSuccess:(void (^)(NSInteger count))success
                         failure:(void (^)(NSError *error))failure {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%ld", API_URL_MESSAGE_UNREAD, userID];
    [WebServiceController callURLString:urlString
                            withRequest:nil
                              andMethod:@"GET"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                NSInteger count = [[responseDictionary valueForKeyPath:@"response.count"] integerValue];
                                
                                success (count);
                            } failure:failure];
    
}

- (void)sendersWithSuccess:(void (^)(NSArray *))success
                   failure:(void (^)(NSError *))failure{
    NSLog(@"sendersWithSuccess---%@",API_URL_MESSAGES);
    
    [WebServiceController callURLString:API_URL_MESSAGES
                            withRequest:nil
                              andMethod:@"GET"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                
                                UserDataController *uDC = [UserDataController new];
                                success ([uDC latestChatsFromResponseDictionary:responseDictionary]);
                                
                            } failure:failure];
    
}

- (void)sendWithDictionary:(NSDictionary *)requestDictionary
                      andImage:(UIImage *)image
                   withSuccess:(void (^)(NSString *response))success
                       failure:(void (^)(NSError *error))failure{
    
    [WebServiceController callURLString:API_URL_MESSAGE_SEND
                            withRequest:[NSMutableDictionary dictionaryWithDictionary:requestDictionary]
                              withImage:image
                              andMethod:@"POST"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                
                                if ([[[responseDictionary objectForKey:@"response"] objectForKey:@"status"] isEqualToString:@"Success"]) {
                                    
                                    success([[responseDictionary objectForKey:@"response"] objectForKey:@"message"]);
                                } else {
                                    NSString *values = [[responseDictionary objectForKey:@"response"] objectForKey:@"message"];
                                    
                                    NSError *error = [NSError errorWithDomain:@"UserError" code:0 userInfo:@{NSLocalizedDescriptionKey: values}];
                                    
                                    failure(error);
                                }
                                
                            } failure:failure];
}

- (void)likeGymChat:(NSInteger)gymChatID
               like:(BOOL)status
        withSuccess:(void (^)(void))success
            failure:(void (^)(NSError *error))failure{
    
    NSDictionary *dictionary = @{@"post_id": [NSNumber numberWithInteger:gymChatID],
                                        @"like": [NSNumber numberWithBool:status]};
    
    [WebServiceController callURLString:API_URL_GYMCHAT_LIKE
                            withRequest:[NSMutableDictionary dictionaryWithDictionary:dictionary]
                              andMethod:@"POST"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                
                                if ([[[responseDictionary objectForKey:@"response"] objectForKey:@"status"] isEqualToString:@"Success"]) {
                                    success();
                                } else {
                                    NSString *message = [[responseDictionary objectForKey:@"response"] objectForKey:@"message"];
                                    
                                    NSError *error = [NSError errorWithDomain:@"UserError" code:0 userInfo:@{NSLocalizedDescriptionKey: message}];
                                    
                                    failure(error);
                                }
                                
                            } failure:failure];
    
}

- (void)gymChatLikesFor:(NSInteger)gymChatID
            withSuccess:(void (^)(NSArray *aLikes))success
                failure:(void (^)(NSError *error))failure {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%ld", API_URL_GYMCHAT_USERLIKES, (long)gymChatID];    
    [WebServiceController callURLString:urlString
                            withRequest:nil
                              andMethod:@"GET"
                            withSuccess:^(NSDictionary *responseDictionary) {
                               
                                success (
                                         [self gymChatLikesFromResponseDictionary:responseDictionary]
                                         );
                            } failure:failure];
}

- (void)commentGymChat:(NSInteger)gymChatID comment:(NSString *)comment withSuccess:(void (^)(void))success failure:(void (^)(NSError *))failure{
    
    NSDictionary *dictionary = @{@"post_id": [NSNumber numberWithInteger:gymChatID],
                                 @"description": comment};
    
    [WebServiceController callURLString:API_URL_GYMCHAT_COMMENT
                            withRequest:[NSMutableDictionary dictionaryWithDictionary:dictionary]
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

- (void)sendGymChatWithDictionary:(NSDictionary *)requestDictionary
                  andImage:(UIImage *)image
               withSuccess:(void (^)(User *user))success
                   failure:(void (^)(NSError *error))failure{
    
    [WebServiceController callURLString:API_URL_GYMCHAT_SEND
                            withRequest:[NSMutableDictionary dictionaryWithDictionary:requestDictionary]
                              withImage:image
                              andMethod:@"POST"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                
                                if ([[[responseDictionary objectForKey:@"response"] objectForKey:@"status"] isEqualToString:@"Success"]) {
                                    success(nil);
                                } else {
                                    NSArray *values = [[[responseDictionary objectForKey:@"response"] objectForKey:@"message"] allValues];
                                    
                                    NSError *error = [NSError errorWithDomain:@"UserError" code:0 userInfo:@{NSLocalizedDescriptionKey: [values componentsJoinedByString:@".\n"]}];
                                    
                                    failure(error);
                                }
                                
                            } failure:failure];
}

#pragma mark - Parsing Response

- (NSArray *)messagesFromResponseDictionary:(NSDictionary *)responseDictionary{
    NSMutableArray *messages = [NSMutableArray new];
    
    NSString *baseURLMsg = [[responseDictionary objectForKey:@"response"] objectForKey:@"baseurlMsg"];
    NSString *baseURLUser = [[responseDictionary objectForKey:@"response"] objectForKey:@"baseurlUser"];
    
    NSArray *messagesDict = [[responseDictionary objectForKey:@"response"] objectForKey:@"messages"];
    
    for (NSDictionary *userDict in messagesDict) {
        
//        NSDictionary *userInfoDict = [userDict objectForKey:@"Message"];
        
        Message *messsage = [[Message alloc]initWithDictionary:userDict];
        
        // Make Full profile URL
        if (messsage.type == MessageTypeImage && messsage.content) {
            
            messsage.content = [baseURLMsg stringByAppendingPathComponent:messsage.content];
            
        }
        messsage.userImage = [baseURLUser stringByAppendingPathComponent:messsage.userImage];
        
        [messages addObject:messsage];
    }
    
    return messages;
}

- (NSArray *)groupMessagesFromResponseDictionary:(NSDictionary *)responseDictionary{
    NSMutableArray *messages = [NSMutableArray new];
    NSMutableArray *members  = [NSMutableArray new];
    
    NSString *baseURLMsg = [[responseDictionary objectForKey:@"response"] objectForKey:@"baseurlMsg"];
    NSString *baseURLUser = [[responseDictionary objectForKey:@"response"] objectForKey:@"baseurlUser"];
    NSArray *messagesDict = [[responseDictionary objectForKey:@"response"] objectForKey:@"messages"];
    NSArray *membersDict = [[responseDictionary objectForKey:@"response"] objectForKey:@"members"];
    
    for (NSDictionary *userDict in membersDict) {
        
        NSDictionary *userInfoDict = [userDict objectForKey:@"Appuser"];
        
        Friend *friend = [[Friend alloc]initWithDictionary:userInfoDict];
        // Make Full profile URL
        if (friend.image) {
            friend.image = [baseURLUser stringByAppendingPathComponent:friend.image];
        }

        [members addObject:friend];
    }
    
    for (NSDictionary *userDict in messagesDict) {
        
        //        NSDictionary *userInfoDict = [userDict objectForKey:@"Message"];
        Message *messsage = [[Message alloc]initWithDictionary:userDict];
        
        // Make Full profile URL
        if (messsage.type == MessageTypeImage && messsage.content) {
            
            messsage.content = [baseURLMsg stringByAppendingPathComponent:messsage.content];
            
        }
        messsage.userImage = [baseURLUser stringByAppendingPathComponent:messsage.userImage];
        
        [messages addObject:messsage];
    }
    
    return [[NSArray alloc] initWithObjects:members, messages, nil];
}

- (NSArray *)gymchatsFromResponseDictionary:(NSDictionary *)responseDictionary{
    NSMutableArray *messages = [NSMutableArray new];
    
    NSString *baseURLMsg = [[responseDictionary objectForKey:@"response"] objectForKey:@"baseurlMsg"];
    NSString *baseURLUser = [[responseDictionary objectForKey:@"response"] objectForKey:@"baseurlusr"];
    
    NSArray *messagesDict = [[responseDictionary objectForKey:@"response"] objectForKey:@"messages"];
    
    for (NSDictionary *userDict in messagesDict) {
        
        //        NSDictionary *userInfoDict = [userDict objectForKey:@"Message"];
        
        GymChat *messsage = [[GymChat alloc]initWithDictionary:userDict];
        
        // Make Full profile URL
        if (messsage.type == MessageTypeImage && messsage.image!= nil) {
            
            messsage.image = [baseURLMsg stringByAppendingPathComponent:messsage.image];
            
        }
        
        if (messsage.userImage != nil) {
            
            messsage.userImage = [baseURLUser stringByAppendingPathComponent:messsage.userImage];
            
        }
        [messages addObject:messsage];
    }
    
    return messages;
}

- (NSArray *)gymchatCommentsFromResponseDictionary:(NSDictionary *)responseDictionary{
    NSMutableArray *messages = [NSMutableArray new];
    
    NSString *baseURLUser = [[responseDictionary objectForKey:@"response"] objectForKey:@"baseurl"];
    
    NSArray *messagesDict = [[responseDictionary objectForKey:@"response"] objectForKey:@"messages"];
    
    for (NSDictionary *userDict in messagesDict) {
        
        //        NSDictionary *userInfoDict = [userDict objectForKey:@"Message"];
        
        Comment *messsage = [[Comment alloc]initWithDictionary:userDict];
    
        if (messsage.userImage != nil) {
            
            messsage.userImage = [baseURLUser stringByAppendingPathComponent:messsage.userImage];
            
        }
        [messages addObject:messsage];
    }
    
    return messages;
}

- (NSArray *)gymChatLikesFromResponseDictionary:(NSDictionary *)responseDictionary {
    NSMutableArray *arraylikes = [NSMutableArray new];
    
    NSString *baseURLUser = [[responseDictionary objectForKey:@"response"] objectForKey:@"baseurl"];
    
    NSArray *messagesDict = [[responseDictionary objectForKey:@"response"] objectForKey:@"messages"];
    
    for (NSDictionary *userDict in messagesDict) {
        
        //        NSDictionary *userInfoDict = [userDict objectForKey:@"Message"];
        
        Likes *aLikes = [[Likes alloc] initWithDictionary:userDict];
        
        if (aLikes.userImage != nil) {
            aLikes.userImage = [baseURLUser stringByAppendingPathComponent:aLikes.userImage];
        }
        
        [arraylikes addObject:aLikes];
    }
    
    return arraylikes;
}

+ (NSArray *)dummyMessages{
    Message *one = [Message new];
    one.content = @"One";
    one.userID = 123;
    one.userImage = nil;
    one.isSender = YES;
    one.type = MessageTypeText;
    one.date = [NSDate date];
    
    Message *two = [Message new];
    two.content = @"Two";
    two.userID = 234;
    two.userImage = nil;
    two.isSender = NO;
    two.type = MessageTypeText;
    two.date = [NSDate date];
    
    Message *three = [Message new];
    three.content = @"Two";
    three.userID = 234;
    three.userImage = nil;
    three.isSender = NO;
    three.type = MessageTypeText;
    three.date = [NSDate date];
    
    Message *four = [Message new];
    four.content = @"Two";
    four.userID = 234;
    four.userImage = nil;
    four.isSender = NO;
    four.type = MessageTypeText;
    four.date = [NSDate date];
    
    return @[one, two, three, four];
    
}
@end
