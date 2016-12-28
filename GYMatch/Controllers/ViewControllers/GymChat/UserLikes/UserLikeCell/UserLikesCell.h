//
//  UserLikesCell.h
//  GYMatch
//
//  Created by Dev on 11/12/15.
//  Copyright © 2015 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileImageView.h"
#import "Likes.h"

@interface UserLikesCell : UITableViewCell
{
    Likes *userLikes;
}
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

- (void)fillWithLikes:(Likes *)aLike;
@end
