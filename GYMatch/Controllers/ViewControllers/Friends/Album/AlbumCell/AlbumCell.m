//
//  AlbumCell.m
//  GYMatch
//
//  Created by Ram Gautam on 11/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "AlbumCell.h"
#import "UIImageView+WebCache.h"

@implementation AlbumCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)fillWithPhoto:(Photo *)aPhoto{
    
    NSURL *imageURL = [NSURL URLWithString:[aPhoto.image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [imageView setImageWithURL:imageURL placeholderImage:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}

#pragma mark - IBActions



@end
