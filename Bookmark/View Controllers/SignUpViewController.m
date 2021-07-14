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
    // Do any additional setup after loading the view.
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
        // initialize a user object
        PFUser *newUser = [PFUser user];
        
        // set user properties
        newUser.username = self.usernameField.text;
        //newUser.email = self.emailField.text;
        newUser.password = self.passwordField.text;
        
        // call sign up function on the object
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error != nil) {
                [self errorOccured:error.localizedDescription];
                NSLog(@"Error: %@", error.localizedDescription);
            } else {
                NSLog(@"User registered successfully");
                
                // manually segue to logged in view
                [self performSegueWithIdentifier:@"signUpToTabSegue" sender:nil];
            
            }
        }];
    }
}

-(void) errorOccured: (NSString *)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid Input"
                                                                               message:error
                                                                        preferredStyle:(UIAlertControllerStyleAlert)];
    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                             // handle response here.
                                                     }];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:^{
        // optional code for what happens after the alert controller has finished presenting
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
