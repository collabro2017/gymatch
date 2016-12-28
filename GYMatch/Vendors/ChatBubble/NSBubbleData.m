//
//  NSBubbleData.m
//
//  Created by Alex Barinov
//  Project home page: http://alexbarinov.github.com/UIBubbleTableView/
//
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//

#import "NSBubbleData.h"
#import <QuartzCore/QuartzCore.h>

@implementation NSBubbleData

#pragma mark - Properties

@synthesize date = _date;
@synthesize type = _type;
@synthesize view = _view;
@synthesize insets = _insets;
@synthesize avatar = _avatar;
@synthesize userName = _userName;
@synthesize userOnline = _userOnline;

#pragma mark - Lifecycle

#if !__has_feature(objc_arc)
- (void)dealloc
{
    [_date release];
	_date = nil;
    [_view release];
    _view = nil;
    
    self.avatar = nil;

    [super dealloc];
}
#endif

#pragma mark - Text bubble

const UIEdgeInsets textInsetsMine = {25, 20, 12, 35};
const UIEdgeInsets textInsetsSomeone = {25, 35, 12, 20};

//const UIEdgeInsets textInsetsMine = {25, 20+10, 12, 35+10};
//const UIEdgeInsets textInsetsSomeone = {25, 35+10, 12, 20+10};

+ (id)dataWithText:(NSString *)text date:(NSDate *)date type:(NSBubbleType)type single:(BOOL)is_single
{
#if !__has_feature(objc_arc)
    return [[[NSBubbleData alloc] initWithText:text date:date type:type single:is_single] autorelease];
#else
    return [[NSBubbleData alloc] initWithText:text date:date type:type single:is_single];
#endif    
}

- (id)initWithText:(NSString *)text date:(NSDate *)date type:(NSBubbleType)type single:(BOOL)is_single
{
    
    CGFloat fontSize = 15.0f;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        fontSize = 16.0f;
    }
    
    UIFont *font = [UIFont fontWithName:@"ProximaNova-Regular" size:fontSize];
    
   // CGSize size = [(text ? text : @"") sizeWithFont:font constrainedToSize:CGSizeMake(200, 9999) lineBreakMode:NSLineBreakByWordWrapping];
    
    //NSLog(@"Previous Adjsuted size .width = %f, height = %f", size.width, size.height);
    
    //CGSize size = [(text ? text : @"") sizeWithFont:font constrainedToSize:CGSizeMake(200, 9999) lineBreakMode:NSLineBreakByWordWrapping];  // Gourav june 24
    
    
    // Gourav june 24 start
    
    NSLog(@"TEXT = %@",text);
    
    
    CGSize size_new = [(text ? text : @"                    ") sizeWithAttributes:@{NSFontAttributeName:font}];
   // if(!text)
   //     size_new.width = 322;
    // Values are fractional -- you should take the ceilf to get equivalent values
    
//    CGSize adjustedSize = CGSizeMake(ceilf(size_new.width), ceilf(size_new.height));
    
    CGSize adjustedSize;
    if (IS_IPAD) {
        adjustedSize = CGSizeMake(330, ceilf(size_new.height));
    }
    else {
        adjustedSize = CGSizeMake(200, ceilf(size_new.height));
    }
    
    NSLog(@"Adjsuted size .width = %f, height = %f", adjustedSize.width, adjustedSize.height);

    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, adjustedSize.width, adjustedSize.height)];
    
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.text = (text ? text : @"                     ");
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
    if (type == BubbleTypeMine && !is_single)
        label.textAlignment = NSTextAlignmentRight;
    
#if !__has_feature(objc_arc)
    [label autorelease];
#endif
    label.textColor = [UIColor colorWithRed:0.3f green:0.3f blue:0.3f alpha:1.0f];
    [label sizeToFit];
    
    UIEdgeInsets insets = (type == BubbleTypeMine ? textInsetsMine : textInsetsSomeone);

    return [self initWithView:label date:date type:type insets:insets];
}

#pragma mark - Image bubble

const UIEdgeInsets imageInsetsMine = {25, 20, 26, 30};
const UIEdgeInsets imageInsetsSomeone = {25, 30, 26, 20};

+ (id)dataWithImage:(UIImage *)image date:(NSDate *)date type:(NSBubbleType)type
{
#if !__has_feature(objc_arc)
    return [[[NSBubbleData alloc] initWithImage:image date:date type:type] autorelease];
#else
    return [[NSBubbleData alloc] initWithImage:image date:date type:type];
#endif    
}

- (id)initWithImage:(UIImage *)image date:(NSDate *)date type:(NSBubbleType)type
{
    CGSize size = image.size;
    if (size.width > 220)
    {
        size.height /= (size.width / 220);
        size.width = 220;
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    imageView.image = image;
//    imageView.layer.cornerRadius = 15.0;
    imageView.layer.masksToBounds = YES;
    imageView.layer.borderWidth = 0.0f;
    
#if !__has_feature(objc_arc)
    [imageView autorelease];
#endif
    
    UIEdgeInsets insets = (type == BubbleTypeMine ? imageInsetsMine : imageInsetsSomeone);
    return [self initWithView:imageView date:date type:type insets:insets];       
}

#pragma mark - Custom view bubble

+ (id)dataWithView:(UIView *)view date:(NSDate *)date type:(NSBubbleType)type insets:(UIEdgeInsets)insets
{
#if !__has_feature(objc_arc)
    return [[[NSBubbleData alloc] initWithView:view date:date type:type insets:insets] autorelease];
#else
    return [[NSBubbleData alloc] initWithView:view date:date type:type insets:insets];
#endif    
}

- (id)initWithView:(UIView *)view date:(NSDate *)date type:(NSBubbleType)type insets:(UIEdgeInsets)insets  
{
    self = [super init];
    if (self)
    {
#if !__has_feature(objc_arc)
        _view = [view retain];
        _date = [date retain];
#else
        _view = view;
        _date = date;
#endif
        _type = type;
        _insets = insets;
    }
    return self;
}


@end
