//
//  TopNavigationControllerDelegate.m
//  GYMatch
//
//  Created by Ram on 23/05/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "TopNavigationControllerDelegate.h"
#import "FriendDetailsViewController.h"
#import "SearchViewController.h"
#import "LocatorViewController.h"
#import "GymChatViewController.h"
#import "GTVViewController.h"
#import "CheckinViewController.h"
#import "ChatViewController.h"
#import "RegisterViewController.h"
#import "TeamDetailsViewController.h"
#import "EditProfileViewController.h"
#import "PasswordViewController.h"
#import "FiltersViewController.h"
#import "ForgotPassViewController.h"
#import "AlbumViewController.h"
#import "GymFiltersViewController.h"
#import "SpotlightDetailsViewController.h"
#import "PictureViewController.h"

@implementation TopNavigationControllerDelegate

- (void)navigationController:(TopNavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    BOOL myProfileFlag = false, searchFlag = false, gtvFlag = false, gymChatFlag = false, gymLocatorFlag = false;
    
    for (id vc in [navigationController viewControllers]) {
        
        if ([vc isMemberOfClass:[FriendDetailsViewController class]]) {
            
            if([(FriendDetailsViewController *)vc aFriend].ID == [APP_DELEGATE loggedInUser].ID){
                [[navigationController myProfileButton] setSelected:YES];
                myProfileFlag = true;
            }
            
        }
        if ([vc isMemberOfClass:[SearchViewController class]]) {
            
            [[navigationController searchButton] setSelected:YES];
            searchFlag = true;
            
        }
        if ([vc isMemberOfClass:[GTVViewController class]]) {
            
            [[navigationController gtvButton] setSelected:YES];
            gtvFlag = true;
            
        }
        if ([vc isMemberOfClass:[GymChatViewController class]]) {
            
            [[navigationController gymChatButton] setSelected:YES];
            
            gymChatFlag = true;
        }
        if ([vc isMemberOfClass:[LocatorViewController class]]) {
            
            [[navigationController gymLocatorButton] setSelected:YES];
            gymLocatorFlag = true;
            
        }
        if ([vc isMemberOfClass:[SpotlightDetailsViewController class]]
//            || [vc isMemberOfClass:[GymChatViewController class]]
            || [vc isMemberOfClass:[AlbumViewController class]]
            || [vc isMemberOfClass:[ChatViewController class]]) {
            
            [navigationController hideProfileMenu];
        }
        
    }
    
    if (!myProfileFlag) {
        [[navigationController myProfileButton] setSelected:NO];

    }
    if (!searchFlag) {
        [[navigationController searchButton] setSelected:NO];

    }
    if (!gymLocatorFlag) {
        [[navigationController gymLocatorButton] setSelected:NO];

    }
    if (!gymChatFlag) {
        [[navigationController gymChatButton] setSelected:NO];
    }
    if (!gtvFlag) {
        
        [[navigationController gtvButton] setSelected:NO];
        
    }
    
    
}

- (void)navigationController:(TopNavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if ([viewController isMemberOfClass:[CheckinViewController class]] ||
        [viewController isMemberOfClass:[RegisterViewController class]] ||
        [viewController isMemberOfClass:[TeamDetailsViewController class]] ||
        [viewController isMemberOfClass:[EditProfileViewController class]] ||
        [viewController isMemberOfClass:[PasswordViewController class]] ||
        [viewController isMemberOfClass:[FiltersViewController class]] ||
        [viewController isMemberOfClass:[ForgotPassViewController class]] ||
        [viewController isMemberOfClass:[AlbumViewController class]] ||
//        [viewController isMemberOfClass:[GymChatViewController class]] ||
        [viewController isMemberOfClass:[GymFiltersViewController class]] ||
        [viewController isMemberOfClass:[PictureViewController class]]) {
        
        [[navigationController friendNavigationBar] setHidden:YES];
        
        
    }else{
        
        [[navigationController friendNavigationBar] setHidden:NO];
        
    }
}

#pragma mark - UISplitViewController

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation{
    return NO;
}

@end
