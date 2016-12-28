//
//  InnerCircleViewController.h
//  GYMatch
//
//  Created by Ram Gautam on 11/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InnerCircleViewController : UIViewController
<UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate>
{
    
    __weak IBOutlet UICollectionView *albumCollectionView;
    __weak IBOutlet UISearchBar *searchView;
}

@property(nonatomic, assign)NSInteger userID;

@end
