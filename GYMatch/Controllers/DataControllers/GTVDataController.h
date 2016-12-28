//
//  GTVDataController.h
//  GYMatch
//
//  Created by Ram on 08/04/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "WebServiceController.h"

@interface GTVDataController : WebServiceController

- (void)gtvWithKeyword:(NSString *)keyword
           withSuccess:(void (^)(NSArray *friends))success
               failure:(void (^)(NSError *error))failure;

@end
