//
//  GTVDataController.m
//  GYMatch
//
//  Created by Ram on 08/04/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "GTVDataController.h"
#import "Utility.h"
#import "GTV.h"

@implementation GTVDataController

- (void)gtvWithKeyword:(NSString *)keyword
           withSuccess:(void (^)(NSArray *))success
               failure:(void (^)(NSError *))failure{
    
    NSString *strignURL = [API_URL_GTV stringByAppendingString:keyword];
    
    [WebServiceController callURLString:strignURL
                            withRequest:nil
                              andMethod:@"GET"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                
                                if ([[responseDictionary valueForKeyPath:@"response.status"] isEqualToString:@"Success"]) {
                                    success (
                                             [self gtvsFromResponseDictionary:responseDictionary]
                                             );
                                } else {
                                    NSString *message = [responseDictionary valueForKeyPath:@"response.message"];
                                    
                                    NSError *error = [NSError errorWithDomain:[responseDictionary valueForKeyPath:@"response.status"] code:0 userInfo:@{NSLocalizedDescriptionKey: message}];
                                    
                                    failure(error);
                                }
                                
                            } failure:failure];

}


#pragma mark - Parsing Response

- (NSArray *)gtvsFromResponseDictionary:(NSDictionary *)responseDictionary{
    NSMutableArray *friends = [NSMutableArray new];
    
//    NSString *baseURL = [[responseDictionary objectForKey:@"response"] objectForKey:@"baseurl"];
    
    NSArray *friendsDict = [[responseDictionary objectForKey:@"response"] objectForKey:@"Gtvs"];
    
    for (NSDictionary *userDict in friendsDict) {
        
        NSDictionary *userInfoDict = [userDict objectForKey:@"Gtv"];
        
        NSLog(@"%@", userInfoDict);
        
        GTV *gtv = [[GTV alloc]initWithDictionary:userInfoDict];
        
        NSLog(@"%@", gtv.m_description);
         NSLog(@"%@", gtv.name);
        ;
        
        // Make Full profile URL
//        if (gtv.image) {
//            
//            gtv.image = [baseURL stringByAppendingPathComponent:friend.image];
//            
//        }
        [friends addObject:gtv];
        
    }
    
    return friends;
}


@end
