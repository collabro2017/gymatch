//
//  GTVCell.m
//  GYMatch
//
//  Created by Ram on 28/04/14.
//  Copyright (c) 2014 xtreem. All rights reserved.
//

#import "GTVCell.h"
#import "UIImageView+WebCache.h" 

@implementation GTVCell

- (void)awakeFromNib
{
    // Initialization code
    CGFloat fontSize = 16.0f;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        fontSize = 20.0f;
         descriptionLbl.font = [UIFont fontWithName:@"ProximaNova-Regular" size:17.0f];
    }
    else
         descriptionLbl.font = [UIFont fontWithName:@"ProximaNova-Regular" size:13.0f];

    GTVTitleLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:fontSize];
    
//    iconImageView.layer.borderWidth = 2.5f;
//    iconImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
//    iconImageView.layer.cornerRadius = iconImageView.frame.size.width / 2.0;
//    iconImageView.layer.masksToBounds = YES;
    borderView.layer.borderWidth = 1.0f;
    borderView.layer.borderColor = [[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0f] CGColor];
    borderView.layer.cornerRadius = borderView.frame.size.width / 2.0f;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillWithGTV:(GTV *)gtv parent:(GTVViewController *)parent index:(int)index_num{
    
    GTVTitleLabel.text = gtv.name;
    index = index_num;

    descriptionLbl.text = gtv.m_description;
    
  //  if (gtv.type == GTVTypeBuzz) //yt22July
  //  {
        
        switch (gtv.mediaType) {
            case MediaTypeTypeArticle:
                iconImageView.hidden = YES;
                [button setTitle:@"Read" forState:UIControlStateNormal];
                break;
            case MediaTypeTypeImage:
            {
                //http://gymatch.com/uploads/photos/1401653882_supplement.jpg
                //  http://gymatch.com//uploads/album/
                // @"1349463403image_1.jpg"
                // album1381210647_image.jpg
                //   NSString *imageURL = [NSString stringWithFormat:@"%@/uploads/photos/%@", SITE_URL, gtv.image];
                NSString *imageURL = [NSString stringWithFormat:@"%@/uploads/photos/%@", SITE_URL, [gtv.image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                [iconImageView sd_setImageWithURL:[NSURL URLWithString:imageURL]];

                if(iconImageView == nil)
                {
                    NSString *imageURL = [NSString stringWithFormat:@"%@/uploads/photos/%@", SITE_URL, @"album1389823820_image.jpg"];
                    [iconImageView sd_setImageWithURL:[NSURL URLWithString:imageURL]];
                }

                iconImageView.hidden = NO;   //22July
                [button setTitle:@"View" forState:UIControlStateNormal];
            }
                break;
            case MediaTypeTypeVideo:
            {
                //set video thumbnail image
                NSString *thumbUrl = gtv.videoUrl;
                if(![thumbUrl isEqual:[NSNull null]])
                {
                    thumbUrl = [gtv.videoUrl lastPathComponent];
                    thumbUrl = [NSString stringWithFormat:@"http://img.youtube.com/vi/%@/0.jpg",thumbUrl];
                    [iconImageView sd_setImageWithURL:[NSURL URLWithString:thumbUrl]];
                }
                
                button.hidden = NO;
                iconImageView.hidden = NO;
                [button setTitle:@"Watch" forState:UIControlStateNormal];
            }
                break;
    //    }
        
    }
    parentView = parent;
}

- (IBAction)onClkComment:(id)sender {
   if (containView.hidden)
       containView.hidden = NO;
    else
        containView.hidden = YES;
}

- (IBAction)onClkLike:(id)sender {
    [containView setHidden:YES];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Thank you for the Like!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
    likeLabel.text = [NSString stringWithFormat:@"%d", likeLabel.text.intValue+1];
}

- (IBAction)onClkGshare:(id)sender {
    [containView setHidden:YES];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Thank you for the GShare!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
    gshareLabel.text = [NSString stringWithFormat:@"%d", gshareLabel.text.intValue+1];
}

- (IBAction)onClkPhoto:(id)sender {
    [parentView didSelectedWithIndex:index type:0];
}

- (IBAction)onCancel:(id)sender {
    [containView setHidden:YES];
}

- (IBAction)onDelete:(id)sender {
    [containView setHidden:YES];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
    [alertView show];
}

- (IBAction)onReport:(id)sender {
    [containView setHidden:YES];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Coming Soon!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

@end
