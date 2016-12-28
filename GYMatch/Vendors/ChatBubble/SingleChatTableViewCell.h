//
//  SingleChatTableViewCell.h
//  GYMatch
//
//  Created by User on 12/24/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSBubbleData.h"
@protocol SingleChatCellDelegate <NSObject>
-(void) successDeleteChat;
@end
@interface SingleChatTableViewCell : UITableViewCell



@property (nonatomic, strong) NSBubbleData *data;
@property (nonatomic) BOOL showAvatar;
@property (assign)  NSInteger senderIndex ;
@property(nonatomic, weak)id <SingleChatCellDelegate> delegate;

-(void)addLineView;
-(void)addLineViewWithHeight:(CGFloat)height;
@end
