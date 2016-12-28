//
//  JoinGYMViewController.m
//  GYMatch
//
//  Created by osvinuser on 5/27/16.
//  Copyright © 2016 xtreem. All rights reserved.
//

#import "JoinGYMViewController.h"
#import "Spotlight.h"
#import "calenderVC.h"
#import "SpotlightDataController.h"

@interface JoinGYMViewController () <UITextFieldDelegate, UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource> {

    IBOutlet UITextField *textField_FirstName;
    
    IBOutlet UITextField *textField_LastName;
    
    IBOutlet UITextField *textField_Email;
    
    IBOutlet UITextField *textField_PhoneNumber;
    
    IBOutlet UITextField *textField_MatchLocation;
    
    IBOutlet UITextField *textField_ClubLocation;
    
    IBOutlet UITableView *tableView_DropDown;
    
    IBOutlet UIView *view_subOptions;
    
    NSArray *clubLocation;
    
}

@end

@implementation JoinGYMViewController
@synthesize aSpotlight;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = NO;
    self.title = @"join Gym";
    
    [[UITextField appearance] setTintColor:[UIColor whiteColor]];
    
    clubLocation = [NSArray new];
    clubLocation = [aSpotlight.clubLocations componentsSeparatedByString:@","];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [(TopNavigationController *)[[APP_DELEGATE tabBarController] selectedViewController] showProfileMenuOnlyCalendar];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    // return NO to not change text
    if ([string  isEqualToString:@" "]) {
        return false;
    }
    
    return true;
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;  {

     // return NO to disallow editing.
    
    if (textField.tag == 4){
    
       
    } else if (textField.tag == 5) {
        
         view_subOptions.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:view_subOptions];
        
        return false;

    }
    
    return true;
    
}



#pragma mark - UIActionSheet
- (IBAction)joinNow:(id)sender {

    if (textField_FirstName.text.length > 0 && textField_LastName.text.length > 0 && textField_Email.text.length > 0 && textField_MatchLocation.text.length > 0 && textField_ClubLocation.text.length > 0) {
    
        if ([self emailValidation:textField_Email.text]) {
        
            if ([self validatePhone:textField_PhoneNumber.text]) {
                
                // Call calender view controller.
//                calenderVC *calenderViewC = [[calenderVC alloc] initWithNibName:@"calenderVC" bundle:[NSBundle mainBundle]];
//                calenderViewC.aSpotlight = self.aSpotlight;
//                calenderViewC.selectedType = SPOTLIGHT_TYPE_GYMSTAR;
//                self.navigationController.navigationBarHidden = NO;
//                [self.navigationController pushViewController:calenderViewC animated:YES];
                
                NSDictionary *requestDictionary = @{@"user_id": [NSString stringWithFormat:@"%d", (int)[APP_DELEGATE loggedInUser].ID],
                                                    @"first_name": textField_FirstName.text,
                                                    @"last_name": textField_LastName.text,
                                                    @"email": textField_Email.text,
                                                    @"phone": textField_PhoneNumber.text,
                                                    @"your_match_location": textField_MatchLocation.text,
                                                    @"club" : textField_ClubLocation.text,
                                                    };
            
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                SpotlightDataController *sDC = [SpotlightDataController new];
                
                [sDC joinGYM:requestDictionary withSuccess:^(NSDictionary *spotlight) {
                    [[[UIAlertView alloc] initWithTitle:@"GYMatch" message:@"Success." delegate:nil cancelButtonTitle:@"okay" otherButtonTitles:nil] show];
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                } failure:^(NSError *error) {
                    [[[UIAlertView alloc] initWithTitle:@"GYMatch" message:@"Failure." delegate:nil cancelButtonTitle:@"okay" otherButtonTitles:nil] show];
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                }];
            } else {
                
                [[[UIAlertView alloc] initWithTitle:@"GYMatch" message:@"Please enter valid number." delegate:nil cancelButtonTitle:@"okay" otherButtonTitles:nil] show];
                
            }
            
        } else {
        
            [[[UIAlertView alloc] initWithTitle:@"GYMatch" message:@"Please enter valid email." delegate:nil cancelButtonTitle:@"okay" otherButtonTitles:nil] show];
            
        }
        
        
    } else {
    
        [[[UIAlertView alloc] initWithTitle:@"GYMatch" message:@"Please fill all fields data." delegate:nil cancelButtonTitle:@"okay" otherButtonTitles:nil] show];
        
    }

    
}

- (BOOL)emailValidation:(NSString *)emailTxt {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailTxt];
    
}


- (BOOL)validatePhone:(NSString *)phoneNumber
{
    NSString *phoneRegex = @"^((\\+)|(00))[0-9]{6,14}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    return [phoneTest evaluateWithObject:phoneNumber];
}


#pragma mark - UITableView Data Source and Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [clubLocation count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        //create new cell
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [clubLocation objectAtIndex:indexPath.row];
    
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];

    cell.textLabel.textColor = [UIColor darkGrayColor];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    textField_ClubLocation.text = [clubLocation objectAtIndex:indexPath.row];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [view_subOptions removeFromSuperview];

}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    UIView *view = [UIView new];
    
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, tableView.frame.size.width, 0.5)];
    subView.backgroundColor = [UIColor lightGrayColor];
    
    [view addSubview:subView];
    
    return view;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
