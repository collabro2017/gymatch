//
//  UIBubbleTableViewCell.h
//
//  Created by Alex Barinov
//  Project home page: http://alexbarinov.github.com/UIBubbleTableView/
//
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//

#import <UIKit/UIKit.h>
#import "NSBubbleData.h"
@protocol BubbleCellDelegate <NSObject>
-(void) successDeleteChatBubble;
@end
@interface UIBubbleTableViewCell : UITableViewCell

@property (nonatomic, strong) NSBubbleData *data;
@property (nonatomic) BOOL showAvatar;
@property(nonatomic, weak)id <BubbleCellDelegate> delegate;

-(void)setCellBubbleData:(NSBubbleData *)data;
@end
