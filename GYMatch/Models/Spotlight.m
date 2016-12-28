//
//  Spotlight.m
//  GYMatch
//
//  Created by Ram on 23/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "Spotlight.h"
#import "Utility.h"
#import "Team.h"
#import "PersonalTraining.h"
#import "NSString+HTML.h"

@implementation OperatingHour

+ (NSArray *)operatingHoursFromDictionary:(NSDictionary *)dictionary{
    NSMutableArray *array = [NSMutableArray new];
    
    for (int i = 1; i <= 7; i ++) {
        
        OperatingHour *sunday = [OperatingHour new];
        NSString *openKey = [NSString stringWithFormat:@"ophours%d", i];
        sunday.opening = [[dictionary objectForKey:openKey] integerValue];
        
        NSString *closeKey = [NSString stringWithFormat:@"ophoursend%d", i];
        sunday.closing = [[dictionary objectForKey:closeKey] integerValue];
        [array addObject:sunday];
    }
    return array;
}

@end

@implementation Spotlight

/*
"Spotlight" : {
    "avgrate" : "3.1250",
    "id" : "253",
    "image" : "_1377088914_trainer_img.jpg",
    "total_likes" : "1",
    "name" : "Marc ",
    "is_like" : "0"
}*/


/*
 "gym_city": "",
 "gym_location": "",
 "location": "",
 "location_city": "Pune",
 "location_state": "",
 "location_us_state": "Florida",
 */

- (id)initWithDictionary:(NSDictionary *)dictionary{
    self = [self init];
    
    if (self) {
        
        self.ID = [[dictionary objectForKey:@"id"] integerValue];
        self.user_id = [[dictionary objectForKey:@"appusers_id"] integerValue];
        self.name = [dictionary objectForKey:@"name"];
        self.image = [dictionary objectForKey:@"image"];
        self.backgroundImage = [dictionary objectForKey:@"background_image"];
        self.gender = [dictionary objectForKey:@"gender"];
        self.type = [dictionary objectForKey:@"spotlight_type"];
        self.age = [[dictionary objectForKey:@"age"] integerValue];
        self.gymLocation = [dictionary objectForKey:@"gym_location"];
        self.address = [dictionary objectForKey:@"location"];
        
        self.likes = [[dictionary objectForKey:@"total_likes"] integerValue];

        self.location = [dictionary objectForKey:@"location"];
        self.location_city = [dictionary objectForKey:@"location_city"];
        self.location_state = [dictionary objectForKey:@"location_state"];
        self.location_us_state = [dictionary objectForKey:@"location_us_state"];
        
        self.countmyrate = [dictionary objectForKey:@"countmyrate"];
        if ([self.address isEqualToString:@""]) {
            self.address = [self getAddress];
         
        }


        NSString *rateString = [dictionary objectForKey:@"avgrate"];

        if (rateString != [NSNull null] && rateString != nil) {
            
            self.rate = [rateString floatValue];
            
        }else{
            
            self.rate = 0;
            
        }
        
        self.isLiked = [[dictionary objectForKey:@"is_like"] boolValue];
        
        [Utility removeNSNULL:self.image];
        [Utility removeNSNULL:self.gender];
        [Utility removeNSNULL:self.gymLocation];

        [Utility removeNSNULL:self.location];
        [Utility removeNSNULL:self.location_city];
        [Utility removeNSNULL:self.location_state];
        [Utility removeNSNULL:self.location_us_state];
    }
    
    return self;
}

- (id)initWithDetails:(NSDictionary *)dictionary{
    
    self = [self init];
    
    if (self) {
        NSLog(@"%@",dictionary);
        
        NSDictionary *spotlightDict = [dictionary objectForKey:@"Spotlight"];
        self.user_id = [[spotlightDict objectForKey:@"appusers_id"] integerValue];
        self.ID = [[spotlightDict objectForKey:@"id"] integerValue];
        self.name = [spotlightDict objectForKey:@"name"];
        self.image = [spotlightDict objectForKey:@"image"];
        self.backgroundImage = [spotlightDict objectForKey:@"background_image"];
        self.likes = [[spotlightDict objectForKey:@"total_likes"] integerValue];
        self.rate = [[spotlightDict objectForKey:@"avgrate"] floatValue];
        self.isLiked = [[spotlightDict objectForKey:@"is_like"] boolValue];
        
        // Details
        self.age = [[spotlightDict objectForKey:@"age"] integerValue];
        self.gender = [spotlightDict objectForKey:@"gender"];
        self.type = [spotlightDict objectForKey:@"spotlight_type"];
        
        self.address = [spotlightDict objectForKey:@"location"];
        self.email = [spotlightDict objectForKey:@"email"];
        self.gymLocation = [spotlightDict objectForKey:@"gym_location"];
        self.location_gym_city = [spotlightDict objectForKey:@"location_gym_city"];
        
        self.gym = [spotlightDict objectForKey:@"gym_name"];
        self.bio = [[spotlightDict objectForKey:@"biography"] stringByDecodingHTMLEntities];
        self.desc = [[spotlightDict objectForKey:@"description"] stringByDecodingHTMLEntities];

        self.location = [dictionary objectForKey:@"location"];
        self.location_city = [dictionary objectForKey:@"location_city"];
        self.location_state = [dictionary objectForKey:@"location_state"];
        self.location_us_state = [dictionary objectForKey:@"location_us_state"];

        if ([self.address isEqualToString:@""]) {
            self.address = [self getAddress];
        }
        
      //  NSString *str  =[spotlightDict objectForKey:@"description"];
      //  NSLog(@"Spotlight Desc - %@",str);
        self.education = [spotlightDict objectForKey:@"certifications"];
        self.preferences = [spotlightDict objectForKey:@"training"];
        self.hobbies = [spotlightDict objectForKey:@"hobbies"];
        
        // Social links
        self.fbLink = [spotlightDict objectForKey:@"fblink"];
        self.twitterLink = [spotlightDict objectForKey:@"twitter"];
        self.instagramLink = [spotlightDict objectForKey:@"instagram"];
        self.siteLink = [spotlightDict objectForKey:@"websitelink"];
        self.gymatchLink = [spotlightDict objectForKey:@"gymatch"];
        
        self.complementaryBenefitsImage = [spotlightDict objectForKey:@"ComplimentryBenefit"];
        self.QRCodeImage = [spotlightDict objectForKey:@"barcode"];
        NSMutableArray *discounts = [NSMutableArray arrayWithArray:[[spotlightDict objectForKey:@"discounts"] componentsSeparatedByString:@","]];
        self.operatingHours = [OperatingHour operatingHoursFromDictionary:spotlightDict];
        self.team = [Team trainersFromArray:[dictionary objectForKey:@"Spotlightteam"]];
        
        self.gymFeatures = [self featuresFromDictionary:[dictionary objectForKey:@"SpotlightClubFeature"]];
        self.gymBenefits = [self benefitsFromDictionary:[dictionary objectForKey:@"SpotlightGymBenifitsFeature"]];
        
        self.clubLocations = [spotlightDict objectForKey:@"branches"];
        self.owners = [Team ownersFromArray:[dictionary objectForKey:@"Spotlightowner"]];
        
        self.halfPersonalTrainings = [PersonalTraining halfTrainingsFromArray:[dictionary objectForKey:@"SpotlightPersonalTraining"]];
        
        self.fullPersonalTrainings = [PersonalTraining fullTrainingsFromArray:[dictionary objectForKey:@"SpotlightPersonalTraining"]];

        [self avoidNSNULLvalues];
        
        if (discounts) {
            for (int i = 0; i < discounts.count; i++) {
                
                if ([[discounts[i] stringByRemovingNewLinesAndWhitespace] length] > 0) {
                    
                    discounts[i] = [NSString stringWithFormat:@"%@uploads/spotlight/%@", SITE_URL, discounts[i]];
                    
                }else{
                
                    discounts[i] = @"";
                
                }
            }
            self.discountsImage = discounts;
        }
    }
    
    return self;
}

- (void)avoidNSNULLvalues{
    
    self.image = [Utility removeNSNULL:self.image];
    self.gender = [Utility removeNSNULL:self.gender];
    self.type = [Utility removeNSNULL:self.type];
    self.email = [Utility removeNSNULL:self.email];
    self.address = [Utility removeNSNULL:self.address];
    self.gym = [Utility removeNSNULL:self.gym];
    self.bio = [Utility removeNSNULL:self.bio];
    //self.description = [Utility removeNSNULL:self.description];
    self.education = [Utility removeNSNULL:self.education];
    self.preferences = [Utility removeNSNULL:self.preferences];
    self.fbLink = [Utility removeNSNULL:self.fbLink];
    self.twitterLink = [Utility removeNSNULL:self.twitterLink];
    self.instagramLink = [Utility removeNSNULL:self.instagramLink];
    self.siteLink = [Utility removeNSNULL:self.siteLink];
    self.gymatchLink = [Utility removeNSNULL:self.gymatchLink];
    self.complementaryBenefitsImage = [Utility removeNSNULL:self.complementaryBenefitsImage];
    self.discountsImage = [Utility removeNSNULL:self.discountsImage];
    self.gymFeatures = [Utility removeNSNULL:self.gymFeatures];
    self.gymBenefits = [Utility removeNSNULL:self.gymBenefits];
    self.clubLocations = [Utility removeNSNULL:self.clubLocations];
    self.QRCodeImage = [Utility removeNSNULL:self.QRCodeImage];
    self.location = [Utility removeNSNULL:self.location];
    self.location_city = [Utility removeNSNULL:self.location_city];
    self.location_state = [Utility removeNSNULL:self.location_state];
    self.location_us_state = [Utility removeNSNULL:self.location_us_state];

}

- (NSArray *)featuresFromDictionary:(NSArray *)array{
    
    NSMutableArray *tempArray = [NSMutableArray new];
    
    for (NSDictionary *tempDict in array) {
        NSString *tempString = [tempDict objectForKey:@"club_feature_name"];
        if (tempString) {
            
            [tempArray addObject:tempString];
        }
    }
    
    return tempArray;
    
}

- (NSArray *)benefitsFromDictionary:(NSArray *)array{
    
    NSMutableArray *tempArray = [NSMutableArray new];
    
    for (NSDictionary *tempDict in array) {
        NSString *tempString = [tempDict objectForKey:@"gym_benifits_name"];
        if (tempString) {
            
            [tempArray addObject:tempString];
        }
    }
    
    return tempArray;
    
}

- (NSString *)getAddress{

    NSString *tempName;

    if (![[Utility removeNSNULL:self.location] isEqualToString:@""]) {
            tempName = self.location;
    }
    else if(![[Utility removeNSNULL:self.location_city] isEqualToString:@""] && [self.location isEqualToString:@""]){
            tempName = self.location_city;
    }
    else if(![[Utility removeNSNULL:self.location_state] isEqualToString:@""] && [self.location_city isEqualToString:@""]) {
            tempName = self.location_state;
    }
    else {
        tempName = self.location_us_state;
    }

    NSLog(@"%@ - %@ - %@ - %@", self.location, self.location_city, self.location_state, self.location_us_state);

    tempName = [tempName stringByRemovingNewLinesAndWhitespace];

    if (tempName == nil || [tempName isEqualToString:@""]) {
        tempName = self.location;
    }

    return tempName;
    
}

@end
