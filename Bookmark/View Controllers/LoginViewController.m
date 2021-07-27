//
//  LoginViewController.m
//  Bookmark
//
//  Created by Amrutha Srikanth on 7/13/21.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)loginButtonClicked:(id)sender {
    [self loginUser];
}

- (IBAction)signUpButtonClicked:(id)sender {
    [self performSegueWithIdentifier:@"loginToSignupSegue" sender:nil];
}

- (void)loginUser {
    
    
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
            [self performSegueWithIdentifier:@"loginToTabSegue" sender:nil];
        }
    }];
}

@end
