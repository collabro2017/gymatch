//
//  AlbumViewController.h
//  GYMatch
//
//  Created by Ram Gautam on 11/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumViewController : UIViewController
<UICollectionViewDataSource, UICollectionViewDelegate>
{
    
    __weak IBOutlet UICollectionView *albumCollectionView;
}

@property(nonatomic, assign)NSInteger userID;

@end
