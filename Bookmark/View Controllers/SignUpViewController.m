//
//  SignUpViewController.m
//  Bookmark
//
//  Created by Amrutha Srikanth on 7/13/21.
//

#import "SignUpViewController.h"
#import "Parse/Parse.h"

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *passwordCheckField;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)signUpButtonClicked:(id)sender {
    [self registerUser];
}

- (void)registerUser {
    if([self.usernameField.text isEqualToString:@""] || [self.passwordField.text isEqualToString:@""] || [self.passwordCheckField.text isEqualToString:@""]){
        [self errorOccured:@"Please fill out all fields before signing up."];
        NSLog(@"Empty fields when signing up");
    }
    else if(![self.passwordField.text isEqualToString:self.passwordCheckField.text]){
        [self errorOccured:@"The password fields must match in order to create a new account."];
        NSLog(@"Password fields do not match");
    }
    else
    {
        PFUser *newUser = [PFUser user];
        
        newUser.username = self.usernameField.text;
        newUser.password = self.passwordField.text;
        
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error != nil) {
                [self errorOccured:error.localizedDescription];
                NSLog(@"Error: %@", error.localizedDescription);
            } else {
                NSLog(@"User registered successfully");
                
                [self performSegueWithIdentifier:@"signUpToTabSegue" sender:nil];
            
            }
        }];
    }
}

-(void) errorOccured: (NSString *)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid Input"
                                                                               message:error
                                                                        preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                             
                                                     }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:^{
    
    }];
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
