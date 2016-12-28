//
//  Team.h
//  GYMatch
//
//  Created by Ram on 25/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    TeamTypeTrainer,
    TeamTypeOwner
} TeamType;

@interface Team : NSObject

@property (nonatomic,assign)NSInteger ID;
@property (nonatomic,retain)NSString *description;
@property (nonatomic,retain)NSString *name;
@property (nonatomic,retain)NSString *image;
@property (nonatomic,retain)NSString *designation;
@property (nonatomic,assign)NSInteger spotlightID;

- (id)initWithDictionary:(NSDictionary *)dictionary andType:(TeamType)type;

+ (NSArray *)trainersFromArray:(NSArray *)array;

+ (NSArray *)ownersFromArray:(NSArray *)array;

@end
