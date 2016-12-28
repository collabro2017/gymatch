//
//  PersonalTraining.m
//  GYMatch
//
//  Created by Ram on 25/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "PersonalTraining.h"

@implementation PersonalTraining

- (id)initWithDictionary:(NSDictionary *)dictionary{
    
    self = [super init];
    
    if (self) {
        
        self.ID = [[dictionary objectForKey:@"id"] integerValue];
        self.hour = [[dictionary objectForKey:@"hour"] integerValue];
        self.rate = [[dictionary objectForKey:@"rate"] floatValue];
        
        NSString *type = [dictionary objectForKey:@"hour_type"];
        
        if ([type isEqualToString:@"FULL"]) {
            self.type = PersonalTrainingHourTypeFull;
            
        }
        else if ([type isEqualToString:@"HALF"]) {
            
            self.type = PersonalTrainingHourTypeHalf;
        }
        
    }
    
    return self;
    
}

+ (NSArray *)halfTrainingsFromArray:(NSArray *)array{
    
    NSMutableArray *tempArray = [NSMutableArray new];
    
    for (NSDictionary *dictionary in array) {
        PersonalTraining *team = [[PersonalTraining alloc] initWithDictionary:dictionary];
        if (team.type == PersonalTrainingHourTypeHalf) {
            [tempArray addObject:team];
        }
    }
    
    return tempArray;
    
}

+ (NSArray *)fullTrainingsFromArray:(NSArray *)array{
    
    NSMutableArray *tempArray = [NSMutableArray new];
    
    for (NSDictionary *dictionary in array) {
        PersonalTraining *team = [[PersonalTraining alloc]initWithDictionary:dictionary];
        if (team.type == PersonalTrainingHourTypeFull) {
            [tempArray addObject:team];
        }
    }
    
    return tempArray;
    
}
@end
