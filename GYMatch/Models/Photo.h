//
//  Photo.h
//  GYMatch
//
//  Created by Ram on 18/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject{
    
    NSString *title;
    NSString *location;
    NSString *visibility;
    
    CGFloat latitude;
    CGFloat longitude;
}

@property(nonatomic)NSString *image;
@property(nonatomic, assign)NSInteger ID;;

- (id)initWithDictionary:(NSDictionary *)dictionary;

- (void)fullURLWithBaseURL:(NSString *)baseURL;

@end
