//
//  SingleChatTableViewCell.m
//  GYMatch
//
//  Created by User on 12/24/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "SingleChatTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "NSBubbleData.h"
#import "UIImageView+WebCache.h"
#import "Utility.h"
#import "ProfileImageView.h"
#import "MessageDataController.h"
#import "MBProgressHUD.h"

@interface SingleChatTableViewCell ()

@property (nonatomic, retain) UIView *customView;
@property (nonatomic, retain) ProfileImageView *avatarImage;
@property (nonatomic, retain) UIButton *timeButton;
@property (nonatomic, retain) UIImageView *availImage;
@property (nonatomic, retain) UILabel *userLabel;
@property (nonatomic, retain) UIView *brView;


- (void) setupInternalData;

@end


@implementation SingleChatTableViewCell

@synthesize data = _data;
@synthesize customView = _customView;
@synthesize showAvatar = _showAvatar;
@synthesize avatarImage = _avatarImage;
@synthesize timeButton = _timeButton;
@synthesize availImage = _availImage;
@synthesize userLabel = _userLabel;
@synthesize brView = _brView;
@synthesize senderIndex = _senderIndex ;
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setupInternalData];
}


- (void)setDataInternal:(NSBubbleData *)value
{
    self.data = value;
    [self setupInternalData];
    
}

- (void) setupInternalData
{
    [self setClipsToBounds:YES];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGFloat width = self.data.view.frame.size.width;
    CGFloat height = self.data.view.frame.size.height;
    
    CGFloat x = 0.0f;
    CGFloat y = 15;
    
    // Adjusting the x coordinate for avatar
    if (self.showAvatar)
    {
        [self.avatarImage removeFromSuperview];
        [self.timeButton removeFromSuperview];
        [self.userLabel removeFromSuperview];
        [self.availImage removeFromSuperview];
#if !__has_feature(objc_arc)
        self.avatarImage = [[[ProfileImageView alloc] initWithImage:(self.data.avatar ? self.data.avatar : [UIImage imageNamed:@"missingAvatar.png"])] autorelease];
#else
        self.avatarImage = [[ProfileImageView alloc] initWithImage:(self.data.avatar ? self.data.avatar : [UIImage imageNamed:@"missingAvatar.png"])];
#endif
        self.availImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"avail-%lD", self.data.userOnline]]];
        self.userLabel = [[UILabel alloc] init];
        
        if (self.data.avatarURL != (NSString *)[NSNull null]) {
            [self.avatarImage sd_setImageWithURL:[NSURL URLWithString:self.data.avatarURL] placeholderImage:[Utility placeHolderImage]];
        }
        
        CGFloat avatarX = 8;
        CGFloat avatarY = 8;
        
        self.avatarImage.frame = CGRectMake(avatarX, avatarY, 50, 50);
        
        [self.avatarImage setClipsToBounds:YES];
        self.avatarImage.layer.cornerRadius = self.avatarImage.frame.size.width / 2.0f;
        
        CGRect avatarRect = self.avatarImage.frame;

        self.availImage.frame = CGRectMake(avatarRect.origin.x+37, avatarRect.origin.y+37, 13, 13);

        self.userLabel.frame = CGRectMake(avatarRect.origin.x+68, avatarRect.origin.y+10, 125, 13);
        self.userLabel.text = self.data.userName;
        
        self.userLabel.font = [UIFont fontWithName:@"ProximaNova" size:15.0];
        
        self.userLabel.textAlignment = NSTextAlignmentLeft;
        self.userLabel.textColor = [UIColor colorWithRed:(50.0f/255.0f) green:(50.0f/255.0f) blue:(50.0f/255.0f) alpha:1.0f];
        self.userLabel.backgroundColor = [UIColor clearColor];
        
        CGFloat fontSize = 9.0f;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            fontSize = 13.0f;
        }
        
        self.timeButton = [[UIButton alloc] init];
        [self.timeButton setImage:[UIImage imageNamed:@"time"] forState:UIControlStateNormal] ;
        self.timeButton.frame = CGRectMake(self.frame.size.width-100, self.userLabel.frame.origin.y + 1, 90.0f, 13.0f);
        [self.timeButton setTitle:[NSString stringWithFormat:@" %@",[Utility friendlyStringFromDate:self.data.date]] forState:UIControlStateNormal];
        self.timeButton.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Light" size:11.0];
        self.timeButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [self.timeButton setContentHorizontalAlignment: UIControlContentHorizontalAlignmentRight];
        [self.timeButton setTitleColor:[UIColor colorWithRed:0.53f green:0.53f blue:0.53f alpha:1.0f] forState:UIControlStateNormal];

                /*self.brView = [[UIView alloc] init];
        [self.brView setBackgroundColor:[UIColor lightGrayColor]];
        [self.brView setFrame:CGRectMake(avatarRect.origin.x+68, 2, self.frame.size.width - avatarRect.origin.x - 80 , 1)];*/
        
        self.brView = [[UIView alloc] initWithFrame:CGRectMake(62, 0, self.frame.size.width-80, 1)];
        [self.brView setBackgroundColor:[UIColor colorWithRed:0.85f green:0.85f blue:0.85f alpha:1.0f]];
        
        [self addSubview:self.timeButton];
        [self addSubview:self.avatarImage];
        [self addSubview:self.userLabel];
        [self addSubview:self.availImage];
        [self addSubview:self.brView];
        //[self addLineView];
    }
    
    [self.customView removeFromSuperview];
    
    self.customView = self.data.view;
    
    self.customView.frame = CGRectMake(self.userLabel.frame.origin.x, self.userLabel.frame.origin.y + 20, self.frame.size.width - 120.0f, height);

    [self.contentView addSubview:self.customView];
    
    
    [self setClipsToBounds:YES];
    self.backgroundColor = [UIColor clearColor];
}

-(void)addLineView {
    
    CGRect lineFrame ;
    
     NSLog(@"sender index is : %ld" , (long)self.senderIndex);
    switch (self.senderIndex) {
        case 1:
            //lineFrame = CGRectMake(userImageView.center.x, self.frame.size.height-userImageView.frame.origin.y-2, 1, self.frame.size.height+2);
            NSLog(@"First row");
            lineFrame = CGRectMake(self.avatarImage.center.x, self.frame.size.height-self.avatarImage.frame.origin.y-2, 1, self.frame.size.height-(self.frame.size.height-self.avatarImage.frame.origin.y-2));
            
            break;
            
        case -1:
            lineFrame = CGRectMake(self.avatarImage.center.x, -1, 1, self.avatarImage.frame.origin.y+2);
            break;
            
        default:
            lineFrame = CGRectMake(self.avatarImage.center.x, -1, 1, self.frame.size.height);
            break;
    }
    NSLog(@"Centre of the avatar image is : %f " , self.avatarImage.center.x ) ;
    
               lineFrame = CGRectMake(35 , -1, 1, 400);
    
    UIView *lineView = [[UIView alloc]initWithFrame:lineFrame];
    
    [lineView setBackgroundColor:[UIColor colorWithRed:208.0/255.0 green:208.0/255.0 blue:208.0/255.0 alpha:255.0/255.0]];
    [self addSubview:lineView];
    [self sendSubviewToBack:lineView];
}

-(void)addLineViewWithHeight:(CGFloat)height {
    
    CGRect lineFrame ;
    
    NSLog(@"sender index is : %ld" , (long)self.senderIndex);
    switch (self.senderIndex) {
        case 1:
            //lineFrame = CGRectMake(userImageView.center.x, self.frame.size.height-userImageView.frame.origin.y-2, 1, self.frame.size.height+2);
            NSLog(@"First row");
            lineFrame = CGRectMake(self.avatarImage.center.x, self.frame.size.height-self.avatarImage.frame.origin.y-2, 1, self.frame.size.height-(self.frame.size.height-self.avatarImage.frame.origin.y-2));
            
            break;
            
        case -1:
            lineFrame = CGRectMake(self.avatarImage.center.x, -1, 1, self.avatarImage.frame.origin.y+2);
            break;
            
        default:
            lineFrame = CGRectMake(self.avatarImage.center.x, -1, 1, self.frame.size.height);
            break;
    }
    NSLog(@"Centre of the avatar image is : %f " , self.avatarImage.center.x ) ;
    
    lineFrame = CGRectMake(35 , -1, 1, height);
    
    UIView *lineView = [[UIView alloc]initWithFrame:lineFrame];
    
    [lineView setBackgroundColor:[UIColor colorWithRed:208.0/255.0 green:208.0/255.0 blue:208.0/255.0 alpha:255.0/255.0]];
    [self addSubview:lineView];
    [self sendSubviewToBack:lineView];
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
        [self successDeleteChat];

        //        [MBProgressHUD hideAllHUDsForView:self animated:YES];
    } failure:^(NSError *error) {
        //        [MBProgressHUD hideAllHUDsForView:self animated:YES];
    }];
    
}
-(void)successDeleteChat{
    [self.delegate successDeleteChat];
}

@end
