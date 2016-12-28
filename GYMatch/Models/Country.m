//
//  Country.m
//  gymatch
//
//  Created by Ram on 20/05/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "Country.h"

@implementation Country

- (id)initWithDictionary:(NSDictionary *)dictionary{
    
    self = [super init];
    
    if (self) {
        
        self.ID = [[dictionary objectForKey:@"id"] integerValue];
        
        self.name = [dictionary objectForKey:@"name"];
        
    }
    
    return self;
    
}

@end
