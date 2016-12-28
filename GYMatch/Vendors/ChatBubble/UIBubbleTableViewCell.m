//
//  UIBubbleTableViewCell.m
//
//  Created by Alex Barinov
//  Project home page: http://alexbarinov.github.com/UIBubbleTableView/
//
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//

#import <QuartzCore/QuartzCore.h>
#import "UIBubbleTableViewCell.h"
#import "NSBubbleData.h"
#import "UIImageView+WebCache.h"
#import "Utility.h"
#import "ProfileImageView.h"
#import "MessageDataController.h"
#import "MBProgressHUD.h"

@interface UIBubbleTableViewCell ()

@property (nonatomic, retain) UIView *customView;
@property (nonatomic, retain) UIImageView *bubbleImage;
@property (nonatomic, retain) ProfileImageView *avatarImage;
@property (nonatomic, retain) UIImageView *borderImage;
@property (nonatomic, retain) UIImageView *timeView;
@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) UIImageView *availImage;
@property (nonatomic, retain) UILabel *userLabel;

- (void) setupInternalData;

@end

@implementation UIBubbleTableViewCell

@synthesize data = _data;
@synthesize customView = _customView;
@synthesize bubbleImage = _bubbleImage;
@synthesize showAvatar = _showAvatar;
@synthesize avatarImage = _avatarImage;
@synthesize borderImage = _borderImage;
@synthesize timeLabel = _timeLabel;
@synthesize timeView = _timeView;
@synthesize availImage = _availImage;
@synthesize userLabel = _userLabel;

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
//	[self setupInternalData];
}

-(void)setCellBubbleData:(NSBubbleData *)data
{
    self.data = data;
    [self setupCellSubFrame];
}

#define TAG_BUBBLE_IMAGE  30
#define TAG_AVATAR_IMAGE  31
#define TAG_BORDER_IMAGE  32
#define TAG_AVAIL_IMAGE   33
#define TAG_USER_LABEL    34
#define TAG_TIME_VIEW     35
#define TAG_TIME_LABEL    36
#define TAG_CUSTOM_VIEW   37

#define SEND_TIME_VIEW_X  120
#define RECV_TIME_VIEW_X  80
#define TIME_LABEL_WIDTH  140.0f

- (void)setupCellSubFrame
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.bubbleImage = [self.contentView viewWithTag:TAG_BUBBLE_IMAGE];
    if (self.bubbleImage == nil)
    {
#if !__has_feature(objc_arc)
        self.bubbleImage = [[[UIImageView alloc] init] autorelease];
#else
        self.bubbleImage = [[UIImageView alloc] init];
#endif
        self.bubbleImage.tag = TAG_BUBBLE_IMAGE;
        [self.contentView addSubview:self.bubbleImage];
    }
    
    NSBubbleData *bb = self.data;
    
    
    CGRect selfFrame = self.frame;
    CGRect dataFrame = self.data.view.frame;
    
    CGFloat x = (self.data.type == BubbleTypeSomeoneElse) ? 0.0f : CGRectGetWidth(selfFrame) - CGRectGetWidth(dataFrame) - self.data.insets.left - self.data.insets.right;
    CGFloat y = 15;
    
    if (self.showAvatar)
    {
        self.avatarImage = [self.contentView viewWithTag:TAG_AVATAR_IMAGE];
        if (self.avatarImage == nil)
        {
#if !__has_feature(objc_arc)
            self.avatarImage = [[[ProfileImageView alloc] initWithImage:(self.data.avatar ? self.data.avatar : [UIImage imageNamed:@"missingAvatar.png"])] autorelease];
#else
            self.avatarImage = [[ProfileImageView alloc] initWithImage:(self.data.avatar ? self.data.avatar : [UIImage imageNamed:@"missingAvatar.png"])];
#endif
            [self.avatarImage setContentMode:UIViewContentModeScaleAspectFill];
            self.avatarImage.layer.masksToBounds = YES;
            [self.avatarImage setTag:TAG_AVATAR_IMAGE];
            [self.contentView addSubview:self.avatarImage];
        }
        
        if (self.data.avatarURL != (NSString *)[NSNull null])
        {
            [self.avatarImage sd_setImageWithURL:[NSURL URLWithString:self.data.avatarURL] placeholderImage:[Utility placeHolderImage]];
            
        }
        
        
        if ([self.contentView viewWithTag:TAG_BORDER_IMAGE] == nil)
        {
            self.borderImage = [[UIImageView alloc] init];
            [self.borderImage setTag:TAG_BORDER_IMAGE];
            [self.contentView addSubview:self.borderImage];
        }
        
        if ([self.contentView viewWithTag:TAG_AVAIL_IMAGE] == nil)
        {
            self.availImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avail_0"]];
            self.availImage.tag = TAG_AVAIL_IMAGE;
            [self.contentView addSubview:self.availImage];
            [self.avatarImage setClipsToBounds:YES];
        }
        
        CGFloat avatarX = (self.data.type == BubbleTypeSomeoneElse) ? 8 : CGRectGetWidth(selfFrame) - 56;
        CGFloat avatarY = CGRectGetHeight(selfFrame) - 62;
        
        if (self.data.type == BubbleTypeMine)
        {
            self.avatarImage.frame = CGRectMake(avatarX, avatarY, 50, 50);
        }else{
            self.avatarImage.frame = CGRectMake(avatarX, avatarY, 50, 50);
        }
        self.avatarImage.layer.cornerRadius = self.avatarImage.frame.size.width / 2.0f;
        
        CGRect avatarRect = self.avatarImage.frame;
        
        
        self.borderImage.frame = CGRectMake(avatarRect.origin.x-1, avatarRect.origin.y-1, avatarRect.size.width+2, avatarRect.size.height+2);
        self.availImage.frame = CGRectMake(avatarRect.origin.x+38, avatarRect.origin.y+38, 11, 11);
        
        
        if ([self.contentView viewWithTag:TAG_USER_LABEL] == nil)
        {
            self.userLabel = [[UILabel alloc] init];
            self.userLabel.tag = TAG_USER_LABEL;
            [self.contentView addSubview:self.userLabel];
        }
        
        if (self.data.type == BubbleTypeMine) {
            self.userLabel.frame = CGRectMake(avatarRect.origin.x-78, avatarRect.origin.y+60, 125, 14);
            self.userLabel.text = self.data.userName;
        }
        else {
            self.userLabel.frame = CGRectMake(avatarRect.origin.x, avatarRect.origin.y+60, 100, 14);
            self.userLabel.text = [NSString stringWithFormat:@"%@", self.data.userName]; // Gourav june 15
        }
        
        self.userLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:13.0];//Deepesh
        
        
        if (self.data.type == BubbleTypeMine)
            self.userLabel.textAlignment = NSTextAlignmentRight;
        else
            self.userLabel.textAlignment = NSTextAlignmentLeft;
        self.userLabel.textColor = [UIColor colorWithRed:(50.0f/255.0f) green:(50.0f/255.0f) blue:(50.0f/255.0f) alpha:1.0f];
        self.userLabel.backgroundColor = [UIColor clearColor];
        self.userLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        
        self.avatarImage.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.avatarImage.layer.borderWidth = 2.5f;
        self.borderImage.layer.borderColor = [[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.00f] CGColor];
        self.borderImage.layer.borderWidth = 1.f;
        self.borderImage.layer.cornerRadius = self.borderImage.frame.size.width / 2;
        self.borderImage.layer.masksToBounds = YES;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        NSString *text = [dateFormatter stringFromDate:self.data.date];
        
        CGFloat fontSize = 9.0f;
        CGFloat textFieldWidth = TIME_LABEL_WIDTH;
        
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            fontSize = 13.0f;
            textFieldWidth = 140.0f;
        }
        
        if ([self.contentView viewWithTag:TAG_TIME_VIEW] == nil)
        {
            self.timeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"time"]];
            [self.timeView setTag:TAG_TIME_VIEW];
            [self.contentView addSubview:self.timeView];
        }

        if ([self.contentView viewWithTag:TAG_TIME_LABEL] == nil)
        {
            self.timeLabel = [[UILabel alloc] init];
            self.timeLabel.text = text;
            self.timeLabel.font = [UIFont fontWithName:@"ProximaNova-Light" size:fontSize];
            self.timeLabel.textAlignment = NSTextAlignmentLeft;
            self.timeLabel.textColor = [UIColor blackColor];
            self.timeLabel.backgroundColor = [UIColor clearColor];
            [self.timeLabel setTag:TAG_TIME_LABEL];
            [self.contentView addSubview:self.timeLabel];
        }
        
        
        if (self.data.type == BubbleTypeMine) {
            self.timeLabel.frame = CGRectMake(148, 21, TIME_LABEL_WIDTH, 18);
            self.timeView.frame = CGRectMake(SEND_TIME_VIEW_X+16, 25, 10, 10);
        } else {
            self.timeLabel.frame = CGRectMake(92, 21, TIME_LABEL_WIDTH, 18);
            self.timeView.frame = CGRectMake(RECV_TIME_VIEW_X, 25, 10, 10);
        }
        
        if (self.data.type == BubbleTypeSomeoneElse) x += 45;
        if (self.data.type == BubbleTypeMine) x -= 41;
    }
    
    [self.customView removeFromSuperview];
    
    
    CGRect custF;
    
    if (self.data.type == BubbleTypeMine) {
        custF = CGRectMake(x+self.data.insets.left, y+self.data.insets.top, self.frame.size.width - 120.0f, CGRectGetHeight(dataFrame));
    } else {
        custF = CGRectMake(x+self.data.insets.left, y+self.data.insets.top, self.frame.size.width - 120.0f, CGRectGetHeight(dataFrame));
    }
    
    //CGRect orgDataF = self.data.view.frame;
    
    self.customView = [[UIView alloc] initWithFrame:custF];
    [self.customView addSubview:self.data.view];
    
    [self.contentView addSubview:self.customView];
    
    //CGRect afterDataF = self.data.view.frame;
    if (self.data.type == BubbleTypeSomeoneElse)
    {
        self.bubbleImage.image = [[UIImage imageNamed:@"chat_form_1"] resizableImageWithCapInsets:UIEdgeInsetsMake(20.0f, 33.0f, 30.0f, 18.0f) resizingMode:UIImageResizingModeStretch];
        
    }
    else {
        self.bubbleImage.image = [[UIImage imageNamed:@"chat_form_0"] resizableImageWithCapInsets:UIEdgeInsetsMake(20.0f, 18.0f, 30.0f, 33.0f) resizingMode:UIImageResizingModeStretch];
        
    }
    
    float bubblewWidth = 0.0;
    
    
    bubblewWidth = CGRectGetWidth(dataFrame) + self.data.insets.left + self.data.insets.right;
    
    if(self.data.type == BubbleTypeSomeoneElse) //recv
    {
        if( (x+bubblewWidth)<(RECV_TIME_VIEW_X+TIME_LABEL_WIDTH+15) )
        {
            x=45;
            bubblewWidth = 250;
        }
        else if ( (x+bubblewWidth) > (CGRectGetWidth(selfFrame)+5) )
        {
            bubblewWidth = CGRectGetWidth(selfFrame)-x-10;
        }
    }
    else  //send
    {
        if ( x > SEND_TIME_VIEW_X )
        {
            x=SEND_TIME_VIEW_X;
            bubblewWidth = CGRectGetWidth(selfFrame)-x-42;
        }
        else if (x < 5)
        {
            x = 6;
            bubblewWidth = CGRectGetWidth(selfFrame)-x-42;
        }
    }
    
    
    
    
    CGRect bubble = CGRectMake(x, y, bubblewWidth, CGRectGetHeight(dataFrame) + self.data.insets.top + self.data.insets.bottom);
    self.bubbleImage.frame = bubble;
    self.backgroundColor = [UIColor clearColor];
    
}

#if !__has_feature(objc_arc)
- (void) dealloc
{
    self.data = nil;
    self.customView = nil;
    self.bubbleImage = nil;
    self.avatarImage = nil;
    self.borderImage = nil;
    [super dealloc];
}
#endif

- (void)setDataInternal:(NSBubbleData *)value
{
	self.data = value;
	[self setupInternalData];
    
}

- (void) setupInternalData
{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!self.bubbleImage)
    {
#if !__has_feature(objc_arc)
        self.bubbleImage = [[[UIImageView alloc] init] autorelease];
#else
        self.bubbleImage = [[UIImageView alloc] init];        
#endif
        [self addSubview:self.bubbleImage];
    }
    
    NSBubbleType type = self.data.type;
    
    CGFloat width  = self.data.view.frame.size.width;
    CGFloat height = self.data.view.frame.size.height;

    CGFloat x = (type == BubbleTypeSomeoneElse) ? 0.0f : self.frame.size.width - width - self.data.insets.left - self.data.insets.right;
    CGFloat y = 15;
    
    // Adjusting the x coordinate for avatar
    if (self.showAvatar)
    {
        [self.avatarImage removeFromSuperview];
        [self.borderImage removeFromSuperview];
        [self.timeView removeFromSuperview];
        [self.timeLabel removeFromSuperview];
        [self.userLabel removeFromSuperview];
        [self.availImage removeFromSuperview];
#if !__has_feature(objc_arc)
        self.avatarImage = [[[ProfileImageView alloc] initWithImage:(self.data.avatar ? self.data.avatar : [UIImage imageNamed:@"missingAvatar.png"])] autorelease];
#else
        self.avatarImage = [[ProfileImageView alloc] initWithImage:(self.data.avatar ? self.data.avatar : [UIImage imageNamed:@"missingAvatar.png"])];
#endif
        self.borderImage = [[UIImageView alloc] init];
        self.availImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avail_0"]];
        self.userLabel = [[UILabel alloc] init];
        [self.avatarImage setContentMode:UIViewContentModeScaleAspectFill];
        if (self.data.avatarURL != (NSString *)[NSNull null]) {
            [self.avatarImage sd_setImageWithURL:[NSURL URLWithString:self.data.avatarURL] placeholderImage:[Utility placeHolderImage]];
            
        }
        
        self.avatarImage.layer.masksToBounds = YES;
        
        CGFloat avatarX = (type == BubbleTypeSomeoneElse) ? 8 : self.frame.size.width - 56;
        CGFloat avatarY = self.frame.size.height - 62;
        
        if (type == BubbleTypeMine)
        {
            self.avatarImage.frame = CGRectMake(avatarX, avatarY, 50, 50);
        }else{
            self.avatarImage.frame = CGRectMake(avatarX, avatarY, 50, 50);
        }
        
        [self.avatarImage setClipsToBounds:YES];
        self.avatarImage.layer.cornerRadius = self.avatarImage.frame.size.width / 2.0f;
        
        CGRect avatarRect = self.avatarImage.frame;
        self.borderImage.frame = CGRectMake(avatarRect.origin.x-1, avatarRect.origin.y-1, avatarRect.size.width+2, avatarRect.size.height+2);
        self.availImage.frame = CGRectMake(avatarRect.origin.x+38, avatarRect.origin.y+38, 11, 11);
        if (type == BubbleTypeMine) {
            self.userLabel.frame = CGRectMake(avatarRect.origin.x-78, avatarRect.origin.y+60, 125, 14);
            self.userLabel.text = self.data.userName;
        }
        else {
            self.userLabel.frame = CGRectMake(avatarRect.origin.x, avatarRect.origin.y+60, 100, 14);
            self.userLabel.text = [NSString stringWithFormat:@"%@", self.data.userName]; // Gourav june 15
        }
        
        self.userLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:13.0];//Deepesh
        
      
        if (type == BubbleTypeMine)
            self.userLabel.textAlignment = NSTextAlignmentRight;
        else
            self.userLabel.textAlignment = NSTextAlignmentLeft;
        self.userLabel.textColor = [UIColor colorWithRed:(50.0f/255.0f) green:(50.0f/255.0f) blue:(50.0f/255.0f) alpha:1.0f];
        self.userLabel.backgroundColor = [UIColor clearColor];
        self.userLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        
        self.avatarImage.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.avatarImage.layer.borderWidth = 2.5f;
        self.borderImage.layer.borderColor = [[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.00f] CGColor];
        self.borderImage.layer.borderWidth = 1.f;
        self.borderImage.layer.cornerRadius = self.borderImage.frame.size.width / 2;
        self.borderImage.layer.masksToBounds = YES;

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        NSString *text = [dateFormatter stringFromDate:self.data.date];
        
        CGFloat fontSize = 9.0f,
        textFieldWidth = 100.0f;


        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            fontSize = 13.0f;
            textFieldWidth = 120.0f;
        }

        self.timeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"time"]];
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.text = text;
        self.timeLabel.font = [UIFont fontWithName:@"ProximaNova-Light" size:fontSize];
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        self.timeLabel.textColor = [UIColor blackColor];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        
        if (type == BubbleTypeMine) {
            self.timeLabel.frame = CGRectMake(148, 21, textFieldWidth, 18);
            self.timeView.frame = CGRectMake(136, 25, 10, 10);
        } else {
            self.timeLabel.frame = CGRectMake(92, 21, textFieldWidth, 18);
            self.timeView.frame = CGRectMake(80, 25, 10, 10);
        }
        
        [self addSubview:self.timeLabel];
        [self addSubview:self.timeView];
        
        [self addSubview:self.borderImage];
        [self addSubview:self.avatarImage];
        
        [self addSubview:self.userLabel];
        [self addSubview:self.availImage];
        
//        CGFloat delta = self.frame.size.height - (self.data.insets.top + self.data.insets.bottom + self.data.view.frame.size.height);

//        if (delta > 0) y = delta - 15;
        
        if (type == BubbleTypeSomeoneElse) x += 45;
        if (type == BubbleTypeMine) x -= 41;
    }

    [self.customView removeFromSuperview];
    
    self.customView = self.data.view;
    
    if (type == BubbleTypeMine) {
        self.customView.frame = CGRectMake(x + self.data.insets.left, y + self.data.insets.top, self.frame.size.width - 120.0f, height);
    } else {
        self.customView.frame = CGRectMake(x + self.data.insets.left, y + self.data.insets.top, self.frame.size.width - 120.0f, height);
    }
    
    [self.contentView addSubview:self.customView];

    if (type == BubbleTypeSomeoneElse)
    {
//        self.bubbleImage.image = [[UIImage imageNamed:@"gray_quote"] stretchableImageWithLeftCapWidth:21 topCapHeight:14];
        self.bubbleImage.image = [[UIImage imageNamed:@"chat_form_1"] resizableImageWithCapInsets:UIEdgeInsetsMake(20.0f, 33.0f, 30.0f, 18.0f) resizingMode:UIImageResizingModeStretch];

    }
    else {
        self.bubbleImage.image = [[UIImage imageNamed:@"chat_form_0"] resizableImageWithCapInsets:UIEdgeInsetsMake(20.0f, 18.0f, 30.0f, 33.0f) resizingMode:UIImageResizingModeStretch];
        
    }
    
    float bubblewWidth = 0.0;
    
    if((width + self.data.insets.left + self.data.insets.right)<150){
        bubblewWidth = 255;
        x=24;
        if(type == BubbleTypeSomeoneElse)
        x=45;
    }
    else
        bubblewWidth = width + self.data.insets.left + self.data.insets.right;
    
    

  self.bubbleImage.frame = CGRectMake(x, y, bubblewWidth, height + self.data.insets.top + self.data.insets.bottom);
    
   //self.bubbleImage.frame = CGRectMake(x, y, self.bubbleImage.image.size.width, height + self.data.insets.top + self.data.insets.bottom);  // Gourav june 24
    
   // NSLog(@"Bubble Frame x= %f y = %f width = %f, height = %f",self.bubbleImage.frame.origin.x,self.bubbleImage.frame.origin.x,self.bubbleImage.frame.size.width,self.bubbleImage.frame.size.height);
    
    
    
 //   self.bubbleImage.layer.borderColor = [[UIColor bl] CGColor];
    self.backgroundColor = [UIColor clearColor];
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action
              withSender:(id)sender
{
    
    return (action == @selector(delete:));
    
}

- (void)delete:(id)sender {
//    [MBProgressHUD showHUDAddedTo:self animated:YES];
    MessageDataController *mDC = [MessageDataController new];
    [mDC deleteChat:self.data.ID withSuccess:^{
//        [MBProgressHUD hideAllHUDsForView:self animated:YES];
        [self.delegate successDeleteChatBubble];
    } failure:^(NSError *error) {
//        [MBProgressHUD hideAllHUDsForView:self animated:YES];
    }];
    
}


@end
