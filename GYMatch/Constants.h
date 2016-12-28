//
//  Constants.h
//  GYMatch
//
//  Created by Ram Gautam on 10/03/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#ifndef GYMatch_Constants_h
#define GYMatch_Constants_h

//Headers to pre build
#import "UIImageView+WebCache.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

// Hold time for splash screen
#define kSplashDisplayTime                  0.5f

// Key used to save user logged in info in NSUserDefaults
#define USER_ID_KEY                         @"LoggedInUserID"
#define USER_NAME_KEY                       @"LoggedInUserUsername"
#define USER_PASS_KEY                       @"LoggedInUserPassword"

// Types of spotlights
#define SPOTLIGHT_TYPE_TRAINER              @"Trainer"
#define SPOTLIGHT_TYPE_MOGUL                @"Mogul"
#define SPOTLIGHT_TYPE_GYMSTAR              @"Gymstar"
#define SPOTLIGHT_TYPE_INDIVIDUAL           @"Individual"
//#define SPOTLIGHT_TEMP_FILTER               @"Filter"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

// Shared instance of AppDelegate
#define APP_DELEGATE                        (AppDelegate *)[[UIApplication sharedApplication] delegate]

#define PASSWORD  @"PASSWORD"

#define GYMATCH_UNIVERSAL_ID                1

#define SITE_URL                              @"http://gymatch.com/"


#define SITE_URL_POINTS                     [SITE_URL stringByAppendingString:@"pages/gymatchpoints"]

#define SITE_URL_SPOTLIGHT                  [SITE_URL stringByAppendingString:@"spotlight/spotlights"]
// Rest API URLs
#define API_URL_BASE                        [SITE_URL stringByAppendingString:@"rest/"]

#define API_URL_LOGIN                       [API_URL_BASE stringByAppendingString:@"appusers/login"]
#define API_URL_FB_LOGIN                    [API_URL_BASE stringByAppendingString:@"appusers/fb_login"]
#define API_URL_FB_LOGIN_CHECKIN            [API_URL_BASE stringByAppendingString:@"appusers/fb_login_checking"]
#define API_URL_LOGOUT                      [API_URL_BASE stringByAppendingString:@"appusers/logout"]
#define API_URL_AVAILABLE                   [API_URL_BASE stringByAppendingString:@"appusers/available"]
#define API_URL_FRIENDS                     [API_URL_BASE stringByAppendingString:@"appusers/friends/"]
#define API_URL_FRIENDS_SEARCH              [API_URL_BASE stringByAppendingString:@"appusers/search"]
#define API_URL_COUNTRIES                   [API_URL_BASE stringByAppendingString:@"appusers/countries"]
#define API_URL_STATES                      [API_URL_BASE stringByAppendingString:@"appusers/states"]
#define API_URL_PN_STATUS                   [API_URL_BASE stringByAppendingString:@"appusers/push_notification_status"]
#define API_URL_SET_PN_STATUS               [API_URL_BASE stringByAppendingString:@"appusers/set_push_notification/"]
#define API_URL_FRIENDS_REFERS              [API_URL_BASE stringByAppendingString:@"appusers/searchingwork/keyword:"]
#define API_URL_FRIENDS_RECOMMEND           [API_URL_BASE stringByAppendingString:@"appusers/recommendedUser/keyword:"]
#define API_URL_PROFILE                     [API_URL_BASE stringByAppendingString:@"appusers/"]
#define API_URL_REGISTER                    [API_URL_BASE stringByAppendingString:@"appusers"]
#define API_URL_PROFILE_UPDATE              [API_URL_BASE stringByAppendingString:@"appusers/"]
#define API_URL_CHECKIN                     [API_URL_BASE stringByAppendingString:@"appusers/check_in"]
#define API_URL_CHANGE_PASSWORD             [API_URL_BASE stringByAppendingString:@"appusers/change_password"]
#define API_URL_FORGOT_PASSWORD             [API_URL_BASE stringByAppendingString:@"appusers/forgot_password"]
#define API_URL_PROFILE_REPORT              [API_URL_BASE stringByAppendingString:@"appusers/report"]

#define API_URL_ADD_FRIEND                  [API_URL_BASE stringByAppendingString:@"requestsends"]
#define API_URL_INVITE_FB                   [API_URL_BASE stringByAppendingString:@"appusers/fb_invite/"]
#define API_URL_REACTIVATE                  [API_URL_BASE stringByAppendingString:@"appusers/reactivate/"]
#define API_URL_FRIEND_REQUESTS             [API_URL_BASE stringByAppendingString:@"requestsends/index/"]
#define API_URL_FRIEND_RESPOND              [API_URL_BASE stringByAppendingString:@"requestsends/respond"]

#define API_URL_ALBUM                       [API_URL_BASE stringByAppendingString:@"albums"]
#define API_URL_ALBUM_VIEW                  [API_URL_BASE stringByAppendingString:@"albums/"]
#define API_URL_ALBUM_DELETE                [API_URL_BASE stringByAppendingString:@"albums"]

// michael
#define API_URL_SESSION                       @"http://jebcoolkids.com/gymatch_app/booking.php"
#define API_URL_SESSION_VIEW                  @"http://jebcoolkids.com/gymatch_app/booking.php?"
//#define API_URL_ALBUM_DELETE                [API_URL_BASE stringByAppendingString:@"albums"]

#define API_URL_GYM                         [API_URL_BASE stringByAppendingString:@"gyms/"]
#define API_URL_GYM_CITY_SEARCH             [API_URL_BASE stringByAppendingString:@"gyms/citysearch/keyword:"]
#define API_URL_GYM_LOCATOR_SEARCH          [API_URL_BASE stringByAppendingString:@"gyms/gymlocatorsearch/keyword:"]
#define API_URL_GYM_SEARCH                  [API_URL_BASE stringByAppendingString:@"gyms/gymsearch/"]
#define API_URL_GYM_LOCATOR                 [API_URL_BASE stringByAppendingString:@"gyms/gymlocator/"]
#define API_URL_GYM_ADD                     [API_URL_BASE stringByAppendingString:@"gyms"]

#define API_URL_MESSAGES                    [API_URL_BASE stringByAppendingString:@"chats/"]
#define API_URL_MESSAGE_SEND                [API_URL_BASE stringByAppendingString:@"chats"]
#define API_URL_MESSAGE_READ                [API_URL_BASE stringByAppendingString:@"chats/unread"]
#define API_URL_MESSAGE_UNREAD              [API_URL_BASE stringByAppendingString:@"chats/unread_new"]
#define API_URL_MESSAGE_DELETE              [API_URL_BASE stringByAppendingString:@"chats/delete_chat/"]
#define API_URL_MESSAGE_GROUP               [API_URL_BASE stringByAppendingString:@"chats/group/"]

#define API_URL_GYMCHAT                     [API_URL_BASE stringByAppendingString:@"postmessages/index/"]
#define API_URL_GYMCHAT_SEND                [API_URL_BASE stringByAppendingString:@"postmessages"]
#define API_URL_GYMCHAT_LIKE                [API_URL_BASE stringByAppendingString:@"postmessages/like"]
#define API_URL_GYMCHAT_COMMENT             [API_URL_BASE stringByAppendingString:@"postmessages/comment"]
#define API_URL_GYMCHAT_COMMENTS            [API_URL_BASE stringByAppendingString:@"postmessages/allcomments/"]
#define API_URL_GYMCHAT_USERLIKES           [API_URL_BASE stringByAppendingString:@"postmessages/alllikes"]

#define API_URL_SPOTLIGHT                   [API_URL_BASE stringByAppendingString:@"spotlights/index/"]
#define API_URL_SPOTLIGHT_FILTER            @"http://www.jebcoolkids.com/gymatch_app/spotlight_search.php"
#define API_URL_SPOTLIGHT_DETAIL            [API_URL_BASE stringByAppendingString:@"spotlights/view/"]
#define API_URL_SPOTLIGHT_LIKE              [API_URL_BASE stringByAppendingString:@"spotlights/like"]
#define API_URL_SPOTLIGHT_RATE              [API_URL_BASE stringByAppendingString:@"spotlights/rate"]
#define API_URL_SPOTLIGHT_BOOKTRAINER       [API_URL_BASE stringByAppendingString:@"trainers/book_trainer.json"]

#define API_URL_GET_USER_TYPE               [API_URL_BASE stringByAppendingString:@"appusers/myaccountinfo"]
#define API_URL_SEND_BOOKING_REQUEST        [API_URL_BASE stringByAppendingString:@"trainers/booking_request"]
#define API_URL_GET_BOOKING_REQUEST         [API_URL_BASE stringByAppendingString:@"trainers/get_booking_request"]
#define API_URL_MANAGE_BOOKING_REQUEST      [API_URL_BASE stringByAppendingString:@"trainers/accept_decline_booking_request"]
#define API_URL_GET_MANAGED_BOOKING_REQUEST [API_URL_BASE stringByAppendingString:@"trainers/user_bookings"]
#define API_URL_REGISTER_BOOKING            [API_URL_BASE stringByAppendingString:@"trainers/booking_action"]
#define API_URL_GET_REGISTERD_BOOKING       [API_URL_BASE stringByAppendingString:@"trainers/get_booking_request_accepted"]
#define API_URL_JOIN_GYM                    [API_URL_BASE stringByAppendingString:@"trainers/join_gym"]

#define APT_URL_RECOMMENDED_FILTER          [API_URL_BASE stringByAppendingString:@"appusers/search_recommendedUser"]
#define API_URL_GTV                         [API_URL_BASE stringByAppendingString:@"gtvs/index/type:"]

#define DUMMY_MODE FALSE

// Used for saving to NSUserDefaults that a PIN has been set and as the unique identifier for the Keychain
#define PIN_SAVED                           @"hasSavedPIN"

// Used for saving the users name to NSUserDefaults
#define USERNAME                            @"username"



// Used to specify the Application used in Keychain accessing
#define APP_NAME                            [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]

// Used to help secure the PIN
// Ideally, this is randomly generated, but to avoid unneccessary complexity and overhead of storing the Salt seperately we will standardize on this key.
// !!KEEP IT A SECRET!!
#define SALT_HASH                           @"FvTivrfxaZ84oGqZXqT8TGRyVHRsKdNRpxdAojXYaSOB1pvfm02wvGadj7RLHV8GsgLLx1v3PA8g9iAj"

// #define DEFAULT_BG_COLOR [UIColor colorWithRed:103.0/255.0 green:135.0/255.0 blue:234.0/255.0 alpha:1.00f]  //previous
//#define DEFAULT_BG_COLOR [UIColor colorWithRed:47.0/255.0 green:22.0/255.0 blue:227.0/255.0 alpha:1.00f] //yt1
#define DEFAULT_BG_COLOR [UIColor colorWithRed:45.0/255.0 green:68.0/255.0 blue:134.0/255.0 alpha:1.00f] //yt2

#define DEFAULT_NAV_COLOR [UIColor colorWithRed:46.0/255.0 green:46.0/255.0 blue:46.0/255.0 alpha:1.00f]

#endif
