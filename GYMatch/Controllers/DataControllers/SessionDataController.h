//
//  AlbumDataController.h
//  GYMatch
//
//  Created by Ram on 18/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SessionDataController : NSObject

- (void)addWithDictionary:(NSDictionary *)requestDictionary andImage:(UIImage *)image 
                   withSuccess:(void (^)(void))success
                       failure:(void (^)(NSError *error))failure;

- (void)albumFor:(NSInteger)userID withSuccess:(void (^)(NSArray *photos))success
               failure:(void (^)(NSError *error))failure;

- (void)deletePhoto:(NSInteger)photoID
        withSuccess:(void (^)(void))success
            failure:(void (^)(NSError *))failure;

// methods for sessions
- (void)sessionFor:(NSInteger)userID withDate:(NSDate*)date
       withSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure;
@end
