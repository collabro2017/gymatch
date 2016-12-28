//
//  Friend.m
//  GYMatch
//
//  Created by Ram on 17/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "Friend.h"
#import "NSString+HTML.h"

@implementation Friend

/*
 *
 Dictionary Format
 Appuser =                 {
 address = " N/A";
 aerobics = 1;
 age = 22;
 camping = 1;
 cardio = 0;
 city = " N/A";
 conditioning = 1;
 "country_id" = " N/A";
 "cross_training" = 1;
 cycling = 1;
 firstname = Utkarsha;
 gender = Female;
 id = 2;
 image = "profile_1379489084_image.jpg";
 jogging = 0;
 loginStatus = 0;
 "martial_arts" = 1;
 pilates = 1;
 state = " N/A";
 swimming = 0;
 "weight_training" = 0;
 yoga = 0;r
 };
 *
 */

- (id)initWithDictionary:(NSDictionary *)dictionary{
    self = [self init];
    
    if (self) {
        
        self.ID                      = [[dictionary objectForKey:@"id"] integerValue];
        
        self.firstName               = [dictionary objectForKey:@"firstname"];
        self.lastName                = [dictionary objectForKey:@"lastname"];
        self.username                = [dictionary objectForKey:@"username"];
        
        self.email                   = [dictionary objectForKey:@"email"];
        self.gender                  = [dictionary objectForKey:@"gender"];
        self.image                   = [dictionary objectForKey:@"image"];
        self.bgImage                 = [dictionary objectForKey:@"bg_image"];
        self.address                 = [dictionary objectForKey:@"address"];
        self.location                = [dictionary objectForKey:@"location"];
        self.city                    = [dictionary objectForKey:@"city"];
        self.city                    = [self.city stringByRemovingNewLinesAndWhitespace];
        self.state                   = [dictionary objectForKey:@"state"];
        self.state                   = [self.state stringByRemovingNewLinesAndWhitespace];
        self.gymType                 = [dictionary objectForKey:@"gym_type"];
        
        self.age                     = [[dictionary objectForKey:@"age"] integerValue];
        
        self.isOnline                = [[dictionary objectForKey:@"loginStatus"] integerValue];
        self.isFromUS                = [[dictionary objectForKey:@"is_from_us"] boolValue];
        self.enabledPushNotification = [[dictionary objectForKey:@"enabledPushNotification"] boolValue];
        
        self.isFriend                = [[dictionary objectForKey:@"is_friend"] boolValue];
        self.isBlocked               = [[dictionary objectForKey:@"did_block"] boolValue];
        self.isDeleted               = [[dictionary objectForKey:@"is_deleted"] integerValue];
        self.didYouBlock             = [[dictionary objectForKey:@"did_you_blocked"] boolValue];
        
        self.aerobics                = [self boolForKey:@"aerobics" inDictionary:dictionary];
        self.camping                 = [self boolForKey:@"camping" inDictionary:dictionary];
        self.cardio                  = [self boolForKey:@"cardio" inDictionary:dictionary];
        self.conditioning            = [self boolForKey:@"conditioning" inDictionary:dictionary];
        self.crossTraining           = [self boolForKey:@"cross_training" inDictionary:dictionary];
        self.cycling                 = [self boolForKey:@"cycling" inDictionary:dictionary];
        self.jogging                 = [self boolForKey:@"jogging" inDictionary:dictionary];
        self.martialArts             = [self boolForKey:@"martial_arts" inDictionary:dictionary];
        self.pilates                 = [self boolForKey:@"pilates" inDictionary:dictionary];
        self.swimming                = [self boolForKey:@"swimming" inDictionary:dictionary];
        self.weightTraining          = [self boolForKey:@"weight_training" inDictionary:dictionary];
        self.yoga                    = [self boolForKey:@"yoga" inDictionary:dictionary];
        self.dancing                 = [self boolForKey:@"dancing" inDictionary:dictionary];
        self.beachActivities                 = [self boolForKey:@"beach_activities" inDictionary:dictionary];
        self.mmaFitness                 = [self boolForKey:@"mma_fitness" inDictionary:dictionary];
        self.gymnastics                 = [self boolForKey:@"gymnastics" inDictionary:dictionary];
        self.userType               = @"user";
        
        
        // Details
        
        self.status                  = [dictionary objectForKey:@"userstatus"];
        self.statusDetail            = [dictionary objectForKey:@"userstatusDetail"];
        self.aboutMe                 = [[dictionary objectForKey:@"aboutme"] stringByDecodingHTMLEntities];
        
        NSInteger point_refer_business = [[dictionary objectForKey:@"point_refer_business"] integerValue];
        NSInteger point_refer_friend = [[dictionary objectForKey:@"point_refer_friend"] integerValue];
        NSInteger point_refer_gym = [[dictionary objectForKey:@"point_refer_gym"] integerValue];
        NSInteger point_refer_trainer = [[dictionary objectForKey:@"point_refer_trainer"] integerValue];
        
        self.oReferralPoints         =  point_refer_business + point_refer_friend + point_refer_gym + point_refer_trainer;
        self.points                  = [[dictionary objectForKey:@"points"] integerValue];
        self.pictureCount            = [[dictionary objectForKey:@"picture_count"] integerValue];
        self.friendCount             = [[dictionary objectForKey:@"friend_count"] integerValue];
        
        [self avoidNSNULLvalues];
        self.name                    = [self fullName];
        self.fullAddress             = [self getAddress];
    }
    
    return self;
}

- (BOOL)boolForKey:(NSString *)key inDictionary:(NSDictionary *)dictionary{
    NSString *string = [dictionary objectForKey:key];
    if ([string isMemberOfClass:[NSNull class]]) {
        string = nil;
    }
    return [string boolValue];
}

- (NSString *)stringForTrainingPreferences{
    
    NSArray *prefs = [self arrayForTrainingPrefs];
    
    NSString * result = [prefs componentsJoinedByString:@", "];
    
    return result;
}

- (NSArray *)arrayForTrainingPrefs{
    
    NSMutableArray *prefs = [NSMutableArray new];
    
    /*if (self.aerobics) {
     [prefs addObject:@"Aerobics"];
     }
     if (self.camping) {
     [prefs addObject:@"Camping"];
     }
     
     if (self.cardio) {
     [prefs addObject:@"Cardio"];
     }
     
     if (self.conditioning) {
     [prefs addObject:@"Conditioning"];
     }
     
     if (self.crossTraining) {
     [prefs addObject:@"Cross Training"];
     }
     
     if (self.cycling) {
     [prefs addObject:@"Cycling"];
     }
     
     if (self.jogging) {
     [prefs addObject:@"Jogging"];
     }
     
     if (self.martialArts) {
     [prefs addObject:@"Martial Arts"];
     }
     
     if (self.pilates) {
     [prefs addObject:@"Pilates"];
     }
     
     if (self.swimming) {
     [prefs addObject:@"Swimming"];
     }
     
     if (self.weightTraining) {
     [prefs addObject:@"Weight Training"];
     }
     
     if (self.yoga) {
     [prefs addObject:@"Yoga"];
     }
     */
    
    if (self.aerobics) {
        [prefs addObject:@"Aerobics Classes"];
    }
    if (self.camping) {
        [prefs addObject:@"Boot Camp"];
    }
    
    if (self.cardio) {
        [prefs addObject:@"Cardio"];
    }
    
    if (self.conditioning) {
        [prefs addObject:@"Conditioning"];
    }
    
    if (self.crossTraining) {
        [prefs addObject:@"Cross Training"];
    }
    
    if (self.cycling) {
        [prefs addObject:@"Studio Cycling"];
    }
    
    if (self.jogging) {
        [prefs addObject:@"Jogging"];
    }
    
    if (self.martialArts) {
        [prefs addObject:@"Martial Arts"];
    }
    
    if (self.pilates) {
        [prefs addObject:@"Pilates"];
    }
    
    if (self.swimming) {
        [prefs addObject:@"Swimming"];
    }
    
    if (self.weightTraining) {
        [prefs addObject:@"Free Weight Training"];
    }
    
    if (self.yoga) {
        [prefs addObject:@"Yoga"];
    }
    if (self.dancing) {
        [prefs addObject:@"Dancing"];
    }
    if (self.beachActivities) {
        [prefs addObject:@"Beach Activities"];
    }
    if (self.mmaFitness) {
        [prefs addObject:@"MMA Fitness"];
    }
    if (self.gymnastics) {
        [prefs addObject:@"Gymnastics"];
    }
    
    
    
    return prefs;
}

- (void)avoidNSNULLvalues{
    
    if ([self.firstName isMemberOfClass:[NSNull class]]) {
        self.firstName = nil;
    }
    
    if ([self.lastName isMemberOfClass:[NSNull class]]) {
        self.lastName = nil;
    }
    
    if ([self.username isMemberOfClass:[NSNull class]]) {
        self.username = nil;
    }
    
    if ([self.gender isMemberOfClass:[NSNull class]]) {
        self.gender = nil;
    }
    
    if ([self.image isMemberOfClass:[NSNull class]]) {
        self.image = nil;
    }
    
    if ([self.bgImage isMemberOfClass:[NSNull class]]) {
        self.bgImage = nil;
    }
    
    if ([self.address isMemberOfClass:[NSNull class]]) {
        self.address = nil;
    }
    
    if ([self.location isMemberOfClass:[NSNull class]]) {
        self.location = nil;
    }
    
    if ([self.city isMemberOfClass:[NSNull class]] || [self.city isEqualToString:@"N/A"]) {
        self.city = nil;
    }
    
    if ([self.state isMemberOfClass:[NSNull class]] || [self.state isEqualToString:@"N/A"]) {
        self.state = nil;
    }
    
    if ([self.status isMemberOfClass:[NSNull class]]) {
        self.status = nil;
    }
    
    if ([self.statusDetail isMemberOfClass:[NSNull class]]) {
        self.statusDetail = nil;
    }
    
    if ([self.aboutMe isMemberOfClass:[NSNull class]]) {
        self.aboutMe = nil;
    }
    
    if ([self.gymType isMemberOfClass:[NSNull class]]) {
        self.gymType = @"Gym";
    }
}

- (NSString *)fullName{
    
    NSString *tempName;
    
    if (self.firstName != nil && self.lastName != nil) {
        tempName = [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
    }else if(self.firstName != nil && self.lastName == nil){
        tempName = self.firstName;
    }else if(self.firstName == nil && self.lastName != nil){
        tempName = self.lastName;
    }
    
    tempName = [tempName stringByRemovingNewLinesAndWhitespace];
    
    if (tempName == nil || [tempName isEqualToString:@""]) {
        tempName = self.username;
    }
    
    return tempName;
    
}

- (NSString *)getAddress{
    
    NSString *tempName;
    
    if (self.city != nil && self.state != nil) {
        if (![self.city isEqualToString:@""]) {
            tempName = self.city;
        }
        
        if (![self.state isEqualToString:@""]) {
            tempName = [tempName stringByAppendingString:[NSString stringWithFormat:@", %@", self.state]];
        }
    }
    else if(self.city != nil && self.state == nil){
        if (![self.city isEqualToString:@""]) {
            tempName = self.city;
        }
    }
    else if(self.city == nil && self.state != nil) {
        if (![self.state isEqualToString:@""]) {
            tempName = self.state;
        }
    }
    else {
        tempName = self.country;
    }
    
    tempName = [tempName stringByRemovingNewLinesAndWhitespace];
    
    if (tempName == nil || [tempName isEqualToString:@""]) {
        tempName = self.location;
    }
    
    return tempName;
    
}

@end
