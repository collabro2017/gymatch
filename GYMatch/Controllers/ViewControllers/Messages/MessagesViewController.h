//
//  MessagesViewController.h
//  GYMatch
//
//  Created by Ram Gautam on 10/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MessagesViewControllerDelegate <NSObject>

- (void)hideLoadingBar;
- (void)didSelectFriend:(Friend *)aFriend;

@end

@interface MessagesViewController : UIViewController <UISearchBarDelegate>
{
    __weak IBOutlet UITableView *friendsTableView;
    __weak IBOutlet UISearchBar *searchBar;
    __weak IBOutlet UIView *noMessagesView;
    IBOutlet UIButton *backBtn;
    
    
}

@property(nonatomic, weak) Friend *currentSelectedFriend;
@property (nonatomic, weak) UITableView *friendsTableView;
@property(nonatomic, weak)id <MessagesViewControllerDelegate> delegate;
@property(nonatomic, strong) IBOutlet UIButton *chatBtn;
@property(nonatomic, strong) NSMutableArray *friendsArray;
@property(nonatomic, strong) NSMutableArray *searchFriendsArray;
//@property(nonatomic, strong) IBOutlet UIButton *teamChatBtn;
@property(nonatomic, strong) UIButton *backBtn;

- (void)callTableSelectionMethod:(NSInteger)indexValue;

-(IBAction)backbuttonPressed:(id)sender;
-(void)setSelectedFriend:(Friend *)user;

@end
