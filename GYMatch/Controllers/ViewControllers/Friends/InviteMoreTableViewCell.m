//
//  TableViewCell.m
//  GYMatch
//
//  Created by iPHTech2 on 16/10/15.
//  Copyright (c) 2015 xtreem. All rights reserved.
//

#import "InviteMoreTableViewCell.h"



@implementation InviteMoreTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


-(IBAction)inviteMoreFriends:(id)sender
{
    FBSDKAppInviteContent *content =[[FBSDKAppInviteContent alloc] init];
    //content.appLinkURL = [NSURL URLWithString:@"https://itunes.apple.com/us/app/gymatch/id727555004?ls=1&mt=8"];
    content.appLinkURL = [NSURL URLWithString:@"https://fb.me/1636647776611353"];

    //content.appLinkURL = [NSURL URLWithString:@"https://apps.facebook.com/1374768389465961/"];//Deep to test
    //content.appLinkURL = [NSURL URLWithString:@"http://www.iphmusic.com/GyMatch/file.html"];
    //content.appLinkURL = [NSURL URLWithString:@"http://www.oureuphoria.com/file.html"];
    //optionally set previewImageURL
    //content.appInvitePreviewImageURL = [NSURL URLWithString:@"https://www.mydomain.com/my_invite_image.jpg"];
    // present the dialog. Assumes self implements protocol `FBSDKAppInviteDialogDelegate`
    
    [FBSDKAppInviteDialog showWithContent:content delegate:self];    
}

//uv these two methods to avoid crash
- (void)appInviteDialog:(FBSDKAppInviteDialog *)dialog didCompleteWithResults:(NSDictionary *)results
{
    NSLog(@"Invite dialog done!");
}
- (void)appInviteDialog:(FBSDKAppInviteDialog *)dialog didFailWithError:(NSError *)error
{
    NSLog(@"Invite dialog failed %@!", [error description]);
}

@end
