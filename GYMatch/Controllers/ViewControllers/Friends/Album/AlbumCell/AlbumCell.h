//
//  AlbumCell.h
//  GYMatch
//
//  Created by Ram Gautam on 11/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"

#define kAlbumCell @"AlbumCell"

@interface AlbumCell : UICollectionViewCell{
    
    __weak IBOutlet UIImageView *imageView;
}

- (void)fillWithPhoto:(Photo *)aPhoto;

@end
