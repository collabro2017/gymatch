//
//  AlbumDataController.m
//  GYMatch
//
//  Created by Ram on 18/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "AlbumDataController.h"
#import "WebServiceController.h"
#import "Photo.h"

@implementation AlbumDataController

- (void)addWithDictionary:(NSDictionary *)requestDictionary andImage:(UIImage *)image withSuccess:(void (^)(void))success failure:(void (^)(NSError *))failure{
    
    [WebServiceController callURLString:API_URL_ALBUM
                            withRequest:[NSMutableDictionary dictionaryWithDictionary:requestDictionary]
                              withImage:image
                              andMethod:@"POST"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                
                                if ([[[responseDictionary objectForKey:@"response"] objectForKey:@"status"] isEqualToString:@"Success"]) {
                                    success();
                                } else {
                                    NSArray *values = [[[responseDictionary objectForKey:@"response"] objectForKey:@"message"] allValues];
                                    
                                    NSError *error = [NSError errorWithDomain:@"Error" code:0 userInfo:@{NSLocalizedDescriptionKey: [values componentsJoinedByString:@".\n"]}];
                                    
                                    failure(error);
                                }
                                
                            } failure:failure];

}

- (void)albumFor:(NSInteger)userID withSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure{
    NSString *stringURL = [NSString stringWithFormat:@"%@%ld", API_URL_ALBUM_VIEW, (long)userID];
    
    [WebServiceController callURLString:stringURL
                            withRequest:nil
                              andMethod:@"GET"
                            withSuccess:^(NSDictionary *responseDictionary) {
                                NSArray *photos = [self photosFromResponseDictionary:responseDictionary];
                                success(photos);
                            } failure:failure];

}

#pragma mark - Parsing Response

- (NSArray *)photosFromResponseDictionary:(NSDictionary *)responseDictionary{
    NSMutableArray *photos = [NSMutableArray new];
    
    NSString *baseURL = [[responseDictionary objectForKey:@"response"] objectForKey:@"baseurl"];
    
    NSArray *friendsDict = [[responseDictionary objectForKey:@"response"] objectForKey:@"album"];
    
    for (NSDictionary *userDict in friendsDict) {
        
        NSDictionary *userInfoDict = [userDict objectForKey:@"Album"];
        
        Photo *photo = [[Photo alloc]initWithDictionary:userInfoDict];
        
        // Make Full profile URL
        [photo fullURLWithBaseURL:baseURL];
        
        [photos addObject:photo];
    }
    
    return photos;
}

- (void)deletePhoto:(NSInteger)photoID withSuccess:(void (^)(void))success failure:(void (^)(NSError *))failure{

    NSString *urlString = [NSString stringWithFormat:@"%@%ld", API_URL_ALBUM_VIEW, (long)photoID];
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

@end
