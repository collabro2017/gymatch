//
//  Photo.m
//  GYMatch
//
//  Created by Ram on 18/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "Photo.h"

@implementation Photo

- (id)initWithDictionary:(NSDictionary *)dictionary{
    self = [self init];
    
    if (self) {
        
        self.ID = [[dictionary objectForKey:@"id"] integerValue];
        
        self.image = [dictionary objectForKey:@"image"];
        title = [dictionary objectForKey:@"title"];
        visibility = [dictionary objectForKey:@"visibility"];
        
        latitude = [[dictionary objectForKey:@"latitude"] floatValue];
        longitude = [[dictionary objectForKey:@"longitude"] floatValue];
        
        [self avoidNSNULLvalues];
        
        
    }
    
    return self;
}


- (void)avoidNSNULLvalues{
    
    if ([title isMemberOfClass:[NSNull class]]) {
        title = nil;
    }
    
    if ([self.image isMemberOfClass:[NSNull class]]) {
        self.image = nil;
    }
    
    if ([visibility isMemberOfClass:[NSNull class]]) {
        visibility = nil;
    }
    
}

- (void)fullURLWithBaseURL:(NSString *)baseURL{
    if (self.image) {
        
        self.image = [baseURL stringByAppendingPathComponent:self.image];
        
    }
}

@end
