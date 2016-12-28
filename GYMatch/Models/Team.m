//
//  Team.m
//  GYMatch
//
//  Created by Ram on 25/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "Team.h"
#import "Utility.h"

@implementation Team

/*
 {
 "team_description" : "DIR of Sales",
 "spotlight_id" : "250",
 "id" : "1377076806",
 "team_name" : "Abdul Hadid",
 "team_image" : "_1378880116_photodune_2068322_serious_man_m_jpg.jpg",
 "team_designation" : "Director of Sales"
 }
 */

- (id)initWithDictionary:(NSDictionary *)dictionary andType:(TeamType)type{
   
    self = [super init];
    
    if (self) {
        
        self.ID = [[dictionary objectForKey:@"id"] integerValue];
        self.spotlightID = [[dictionary objectForKey:@"spotlight_id"] integerValue];
        
        if (type == TeamTypeOwner) {
            
            self.name = [dictionary objectForKey:@"owner_name"];
            self.image = [dictionary objectForKey:@"owner_image"];
            self.designation = [dictionary objectForKey:@"owner_designation"];
            //self.description = [dictionary objectForKey:@"owner_description"];
            
        }else if (type == TeamTypeTrainer){
            
            self.name = [dictionary objectForKey:@"team_name"];
            self.image = [dictionary objectForKey:@"team_image"];
            self.designation = [dictionary objectForKey:@"team_designation"];
            //self.description = [dictionary objectForKey:@"team_description"];
            
        }
        
        [self avoidNSNULLvalues];
        
        self.image = [NSString stringWithFormat:@"%@uploads/spotlight/%@", SITE_URL, self.image];
        
    }
    
    return self;
    
}

+ (NSArray *)trainersFromArray:(NSArray *)array{
    
    NSMutableArray *tempArray = [NSMutableArray new];
    
    for (NSDictionary *dictionary in array) {
        Team *team = [[Team alloc]initWithDictionary:dictionary andType:TeamTypeTrainer];
        [tempArray addObject:team];
    }
    return tempArray;
    
}

+ (NSArray *)ownersFromArray:(NSArray *)array{
    
    NSMutableArray *tempArray = [NSMutableArray new];
    
    for (NSDictionary *dictionary in array) {
        Team *team = [[Team alloc]initWithDictionary:dictionary andType:TeamTypeOwner];
        [tempArray addObject:team];
    }
    return tempArray;
    
}

- (void)avoidNSNULLvalues{
    
    self.name = [Utility removeNSNULL:self.name];
    self.image = [Utility removeNSNULL:self.image];
    self.designation = [Utility removeNSNULL:self.designation];
    //self.description = [Utility removeNSNULL:self.description];
    
}
@end
