 //
//  WebServiceController.m
//  GYMatch
//
//  Created by Ram on 17/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "WebServiceController.h"
#import "AFNetworking.h"


@implementation WebServiceController

/*
 {
 "response" : {
 "status" : "Warning",
 "message" : "You are not logged in."
 }
 }
 */


+ (void)callURLString:(NSString *)URLString
          withRequest:(NSMutableDictionary *)requestDictionary
            andMethod:(NSString *)method
          withSuccess:(void (^)(NSDictionary *))success
              failure:(void (^)(NSError *))failure{
    
    NSURL *baseURL = [NSURL URLWithString:API_URL_BASE];
    
    //build normal NSMutableURLRequest objects
    //make sure to setHTTPMethod to "POST".
    //from https://github.com/AFNetworking/AFNetworking
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    [httpClient defaultValueForHeader:@"Accept"];
    
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    
    NSMutableURLRequest *request;
    
    URLString = [URLString stringByAppendingString:@".json"];
    URLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"\n\nURL: %@\n\n", URLString);
    NSLog(@"\n\nMethod: %@\n\n", method);
    NSLog(@"\n\nParameter: %@\n\n\n", requestDictionary);
    
    if ([method isEqualToString:@"POST"]) {
        request = [httpClient multipartFormRequestWithMethod:method path:URLString parameters:requestDictionary constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
            // Aditoinal form data params.
        }];

    }
    else{
        request = [httpClient requestWithMethod:method path:URLString parameters:requestDictionary];
    }
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
   
    
    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject) {
         
         NSString *response = [operation responseString];
          NSLog(@"response: %@",response);

         NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
         
         
         if ([[obj valueForKeyPath:@"response.status"] isEqualToString:@"Warning"]  &&  [[obj valueForKeyPath:@"response.message"] isEqualToString:@"You are not logged in."]) {

             UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Session time out!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             alertView = nil;
             
             NSError *error = [NSError errorWithDomain:@"SessionTimeOut" code:103 userInfo:@{@"LocalizedDescription": @"Session time out."}];
         }
         else {
                 success (obj);
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
         alertView = nil;
         
         failure (error);
     }];
    
    // DISABLE CACHE //
    [operation setCacheResponseBlock:
     ^NSCachedURLResponse *(NSURLConnection *connection, NSCachedURLResponse *cachedResponse) {
         return nil;
     }];
    
    //call start on your request operation
    [operation start];
}


+ (void)callURLString:(NSString *)URLString withRequest:(NSMutableDictionary *)requestDictionary withImage:(UIImage *)image andMethod:(NSString *)method withSuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure{
    
    NSURL *baseURL = [NSURL URLWithString:API_URL_BASE];
    
    //build normal NSMutableURLRequest objects
    //make sure to setHTTPMethod to "POST".
    //from https://github.com/AFNetworking/AFNetworking
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    [httpClient defaultValueForHeader:@"Accept"];
    
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    
    
    NSMutableURLRequest *request;
    
    URLString = [URLString stringByAppendingString:@".json"];
    
    URLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if ([method isEqualToString:@"POST"]) {
        
        request = [httpClient multipartFormRequestWithMethod:method
                                                        path:URLString
                                                  parameters:requestDictionary
                                   constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
            // Aditoinal form data params.
                                       if (image != nil) {
                                           [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 90)
                                                                       name:@"image"
                                                                   fileName:@"userimage.jpg"
                                                                   mimeType:@"image/jpeg"];
                                       }
        }];
        
    }
    else{
     
        request = [httpClient requestWithMethod:method path:URLString parameters:requestDictionary];
        
    }
    
    NSLog(@"URL: %@", URLString);
    NSLog(@"Method: %@", method);
    NSLog(@"Parameter: %@\n\n\n", requestDictionary);
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];

    
    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject) {
         NSString *response = [operation responseString];
         NSLog(@"response: %@",response);
         
         NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
         if ([[obj valueForKeyPath:@"response.status"] isEqualToString:@"Warning"]  &&
             [[obj valueForKeyPath:@"response.message"] isEqualToString:@"You are not logged in."]) {
             UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Session time out!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             alertView = nil;
             
             NSError *error = [NSError errorWithDomain:@"SessionTimeOut" code:103 userInfo:@{@"LocalizedDescription": @"Session time out."}];
             
         }
         else{
             [[NSUserDefaults standardUserDefaults]setObject:[obj valueForKeyPath:@"response.message"] forKey:@"Re-SendUrl"];
                 success (obj);
             
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"error: %@", [operation error]);
         UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
         alertView = nil;
         failure (error);
     }];
    
    // DISABLE CACHE //
    [operation setCacheResponseBlock:
     ^NSCachedURLResponse *(NSURLConnection *connection, NSCachedURLResponse *cachedResponse) {
         return nil;
     }];
    
    //call start on your request operation
    [operation start];
}


+ (void)callURLString4Session:(NSString *)URLString
          withRequest:(NSMutableDictionary *)requestDictionary
            andMethod:(NSString *)method
          withSuccess:(void (^)(NSDictionary *))success
              failure:(void (^)(NSError *))failure{
    
    NSURL *baseURL = [NSURL URLWithString:URLString];
    
    //build normal NSMutableURLRequest objects
    //make sure to setHTTPMethod to "POST".
    //from https://github.com/AFNetworking/AFNetworking
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    [httpClient defaultValueForHeader:@"Accept"];
    
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    
    NSMutableURLRequest *request;
    
//    URLString = [URLString stringByAppendingString:@".json"];
    URLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"\n\nURL: %@\n\n", URLString);
    NSLog(@"\n\nMethod: %@\n\n", method);
    NSLog(@"\n\nParameter: %@\n\n\n", requestDictionary);
    
    if ([method isEqualToString:@"POST"]) {
        request = [httpClient multipartFormRequestWithMethod:method path:URLString parameters:requestDictionary constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
            // Aditoinal form data params.
        }];
        
    }
    else{
        request = [httpClient requestWithMethod:method path:URLString parameters:requestDictionary];
    }
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject) {
         
         NSString *response = [operation responseString];
         NSLog(@"response: %@",response);
         
         NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
         success (obj);
         
//         if ([[obj valueForKeyPath:@"response.status"] isEqualToString:@"Warning"]  &&  [[obj valueForKeyPath:@"response.message"] isEqualToString:@"You are not logged in."]) {
//             
//             UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Session time out!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//             alertView = nil;
//             
//             NSError *error = [NSError errorWithDomain:@"SessionTimeOut" code:103 userInfo:@{@"LocalizedDescription": @"Session time out."}];
//         }
//         else {
//             success (obj);
//         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
         alertView = nil;
         
         failure (error);
     }];
    
    // DISABLE CACHE //
    [operation setCacheResponseBlock:
     ^NSCachedURLResponse *(NSURLConnection *connection, NSCachedURLResponse *cachedResponse) {
         return nil;
     }];
    
    //call start on your request operation
    [operation start];
}



@end
