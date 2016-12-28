//
//  InnerCircleCell.h
//  GYMatch
//
//  Created by Ram Gautam on 11/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Friend.h"

#define kInnerCircleCell @"InnerCircleCell"

@interface InnerCircleCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;

- (void)fillWithPhoto:(Friend *)aFriend;

@end
