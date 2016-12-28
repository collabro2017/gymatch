//
//  ActiveDropDownViewController.h
//  GYMatch
//
//  Created by Ram on 08/04/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DropDownDelegate <NSObject>

- (void)didSelectItemAtIndex:(NSInteger)index;
- (void)didEnterText:(NSString *)text;

@end

@interface ActiveDropDownViewController : UIViewController
<UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, weak) id <DropDownDelegate> delegate;

@property (nonatomic, assign) BOOL isSearching;
@property (nonatomic, retain) NSArray *resultsArray;

@end
