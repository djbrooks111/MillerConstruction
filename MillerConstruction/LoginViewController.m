//
//  ViewController.m
//  MillerConstruction
//
//  Created by David Brooks on 3/15/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

#pragma mark - UIViewController Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Login Methods

/**
 *  Called when the user presses the Login button
 *
 *  @param sender The Login button
 */
-(void)login:(UIButton *)sender {
    User *user = [[User alloc] initWithUsername:[self.usernameTextField text] andPassword:[self.passwordTextField text]];
    UserLoginType loginResult = [user login];
    
    UIAlertView *alert;
    
    switch (loginResult) {
        case SuccessfulLogin:
            //TODO: Put Segue with ID = goToMainMenu
            //TODO: [self performSegueWithIdentifier:@"goToMainMenu" sender:self];
            NSLog(@"SuccessfulLogin");
            break;
        case IncorrectPassword:
            //alert = [[UIAlertView alloc] initWithTitle:@"Incorrect Password" message:@"The password you entered is incorrect. Please try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            //[alert show];
            NSLog(@"IncorrectPassword");
            [self.passwordTextField setText:@""];
            break;
        case WrongUsername:
            //TODO: Change TECHNOLOGY SUPPORT in the alert message
            //alert = [[UIAlertView alloc] initWithTitle:@"Username Not Recognized" message:@"The username you entered was not recognized. The username might not be registered. Please contact TECHNOLOGY SUPPORT." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            //[alert show];
            NSLog(@"WrongUsername");
            [self.passwordTextField setText:@""];
            break;
            
        default:
            break;
    }
    
}

@end
