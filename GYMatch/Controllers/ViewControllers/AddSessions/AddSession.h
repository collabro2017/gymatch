//
//  AddSession.h
//  GYMatch
//
//  Created by bluesky on 03/07/16.
//  Copyright © 2016 xtreem. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <StoreKit/StoreKit.h>
#import "PayPalMobile.h"
@interface AddSession : UIViewController <PayPalPaymentDelegate, PayPalFuturePaymentDelegate, PayPalProfileSharingDelegate,UITableViewDataSource, UITableViewDelegate>
{
    
    NSArray *arrSessions;
}

@property (strong) NSDate *date;
@property (strong, nonatomic) IBOutlet UITableView *tblSession;

@property(readwrite) float price;

//for paypal

@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property(nonatomic, strong, readwrite) NSString *resultText;
@end
