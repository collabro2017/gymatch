//
//  Country.h
//  gymatch
//
//  Created by Ram on 20/05/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Country : NSObject

@property (nonatomic,assign)NSInteger ID;
@property (nonatomic,retain)NSString *name;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
