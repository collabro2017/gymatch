//
//  GTV.m
//  GYMatch
//
//  Created by Ram on 08/04/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "GTV.h"
#import "Utility.h"

@implementation GTV

- (id)initWithDictionary:(NSDictionary *)dictionary{
    
    self = [super init];
    
    if (self) {
        
        self.ID = [[dictionary objectForKey:@"id"] integerValue];
        
        self.name = [dictionary objectForKey:@"name"];
        self.image = [dictionary objectForKey:@"image"];
        self.videoUrl = [dictionary objectForKey:@"video_link"];
        
        NSString *type = [dictionary objectForKey:@"gtv_type"];
        
        if ([type isEqualToString:@"Teaser"]) {
            
            self.type = GTVTypeTeaser;
            
        }else if ([type isEqualToString:@"Blockbuster"]) {
            
            self.type = GTVTypeBlockbuster;
            
        }else if ([type isEqualToString:@"Buzz"]) {
            
            self.type = GTVTypeBuzz;
            
        }
        
        
        NSString *mediaType = [dictionary objectForKey:@"mediatype"];
        
        if ([mediaType isEqualToString:@"video"]) {
            
            self.mediaType = MediaTypeTypeVideo;
            
        }else if ([mediaType isEqualToString:@"image"]) {
            
            self.mediaType = MediaTypeTypeImage;
            
        }else if ([mediaType isEqualToString:@"Article"]) {
            
            self.mediaType = MediaTypeTypeArticle;
            
        }
        
        self.m_description = [dictionary objectForKey:@"description"];
        
        NSLog(@"_m_description %@",_m_description);
        self.magzineImage = [dictionary objectForKey:@"magzine"];
        
        [self avoidNSNULLvalues];
        
    }
    
    return self;
    
}

- (void)avoidNSNULLvalues{
    
    self.name = [Utility removeNSNULL:self.name];
    self.image = [Utility removeNSNULL:self.image];
    self.videoUrl = [Utility removeNSNULL:self.videoUrl];
    self.m_description = [Utility removeNSNULL:self.m_description];
    self.magzineImage = [Utility removeNSNULL:self.magzineImage];
    
}

@end
