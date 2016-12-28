//
//  WebServiceController.h
//  GYMatch
//
//  Created by Ram on 17/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebServiceController : NSObject

+(id)sharedInstance;

+ (void)callURLString:(NSString *)URLString withRequest:(NSMutableDictionary *)requestDictionary andMethod:(NSString *)method withSuccess:(void (^)(NSDictionary *responseDictionary))success
                 failure:(void (^)(NSError *error))failure;

+ (void)callURLString:(NSString *)URLString
          withRequest:(NSMutableDictionary *)requestDictionary
          withImage:(UIImage *)image
            andMethod:(NSString *)method
          withSuccess:(void (^)(NSDictionary *responseDictionary))success
              failure:(void (^)(NSError *error))failure;

// Michael
+ (void)callURLString4Session:(NSString *)URLString
                  withRequest:(NSMutableDictionary *)requestDictionary
                    andMethod:(NSString *)method
                  withSuccess:(void (^)(NSDictionary *))success
                      failure:(void (^)(NSError *))failure;
@end
