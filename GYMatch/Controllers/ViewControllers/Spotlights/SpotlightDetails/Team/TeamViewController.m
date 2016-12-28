//
//  TeamViewController.m
//  GYMatch
//
//  Created by Ram on 08/05/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "TeamViewController.h"
#import <MessageUI/MessageUI.h>
#import "TeamCell.h"

@interface TeamViewController ()

@end

@implementation TeamViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    UINib *nib = [UINib nibWithNibName:kTeamCell bundle:nil];
    [(UITableView *)self.view registerNib:nib forCellReuseIdentifier:kTeamCell];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITable View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.members count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TeamCell *cell = [tableView dequeueReusableCellWithIdentifier:kTeamCell];
    [cell fillWithTeam:self.members[indexPath.row]];
    [cell.sendButton addTarget:self action:@selector(sendMessageButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    cell.sendButton.tag = indexPath.row;
    
    // Gourav june 23 start
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClicked:)];
    [cell.profileImageView addGestureRecognizer:gesture];
    
    // Gourav june 23 end
    
    return cell;
}


-(void)imageClicked : (UITapGestureRecognizer *)gesture {
   
    
    UIImageView *view = (UIImageView *)gesture.view;
    
    _pictureView = [[AvatorViewController alloc] initWithNibName:@"AvatorViewController" bundle:nil];
    _pictureView.image = view.image;
    //[self.navigationController pushViewController:_pictureView animated:NO];
    [self.view addSubview:_pictureView.view];
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromRight;
    [_pictureView.view.window.layer addAnimation:transition forKey:kCATransition];
    
}


- (IBAction)sendMessageButtonPressed:(UIButton *)sender {

    
    
//    NSString *message = [NSString stringWithFormat:@"Hello %@,", [(Team *)self.members[sender.tag] name]];
//    
//    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
//    controller.mailComposeDelegate = self;
//    [controller setToRecipients:@[self.email]];
//    [controller setSubject:@"Contact us"];
//    [controller setMessageBody:message isHTML:NO];
//    
//    if (controller)
//        [self presentViewController:controller animated:YES completion:nil];
    
    
    
    
    // Gourav june 23 start
    
    
    if ([MFMailComposeViewController canSendMail])
    {
        //NSString *message = [NSString stringWithFormat:@"Hello %@,", [(Team *)self.members[sender.tag] name]];
        NSString *message = @"";
        
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        
        mailer.mailComposeDelegate = self;
    
        [mailer setSubject:@"Contact us"];
        
        NSArray *toRecipients = [NSArray arrayWithObjects:self.email, nil];
        [mailer setToRecipients:toRecipients];
    
        [mailer setMessageBody:message isHTML:NO];
        
        if (mailer)
            [self presentViewController:mailer animated:YES completion:nil];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
    
    // Gouran june 23 end
    
}

#pragma mark - Mail Composer delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    
    // Remove the mail view
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    
    
}

@end
