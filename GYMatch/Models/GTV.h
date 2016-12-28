//
//  GTV.h
//  GYMatch
//
//  Created by Ram on 08/04/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    GTVTypeTeaser,
    GTVTypeBlockbuster,
    GTVTypeBuzz,
} GTVType;

typedef enum : NSUInteger {
    MediaTypeTypeVideo,
    MediaTypeTypeImage,
    MediaTypeTypeArticle,
} MediaType;

@interface GTV : NSObject

@property (nonatomic,assign)NSInteger ID;
@property (nonatomic,retain) NSString *m_description;
@property (nonatomic,retain)NSString *magzineImage;
@property (nonatomic,retain)NSString *name;
@property (nonatomic,retain)NSString *image;
@property (nonatomic,retain)NSString *videoUrl;
@property (nonatomic, assign)MediaType mediaType;
@property (nonatomic, assign)GTVType type;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
