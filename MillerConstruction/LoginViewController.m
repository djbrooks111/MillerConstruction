//
//  ViewController.m
//  MillerConstruction
//
//  Created by David Brooks on 3/15/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"
#import "JGProgressHUD.h"
#import "JGProgressHUDSuccessIndicatorView.h"
#import "JGProgressHUDErrorIndicatorView.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

#pragma mark - UIViewController Methods

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - JGProgressHUD

/**
 *  Creates a new JGProgressHUD
 *
 *  @return The new JGProgressHUD
 */
-(JGProgressHUD *)prototypeHUD {
    JGProgressHUD *HUD = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleDark];
    HUD.interactionType = JGProgressHUDInteractionTypeBlockAllTouches;
    HUD.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
    HUD.HUDView.layer.shadowColor = [UIColor blackColor].CGColor;
    HUD.HUDView.layer.shadowOffset = CGSizeZero;
    HUD.HUDView.layer.shadowOpacity = 0.4f;
    HUD.HUDView.layer.shadowRadius = 8.0f;
    
    return HUD;
}

#pragma mark - Login Methods

/**
 *  Called when the user presses the Login button
 *
 *  @param sender The Login button
 */
-(void)login:(UIButton *)sender {
    [self.view endEditing:YES];
    //[self.usernameTextField resignFirstResponder];
    //[self.passwordTextField resignFirstResponder];
    JGProgressHUD *HUD = self.prototypeHUD;
    HUD.textLabel.text = @"Logging you in...";
    [HUD showInView:self.view];
    
    User *user = [[User alloc] initWithUsername:[self.usernameTextField text] andPassword:[self.passwordTextField text]];
    UserLoginType loginResult = [user login];
    
    UIAlertView *alert;
    if (loginResult == SuccessfulLogin) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            HUD.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc] init];
            HUD.textLabel.text = @"Success!";
        });
        [HUD dismissAfterDelay:1];
        [self performSelector:@selector(goToMainMenu) withObject:nil afterDelay:2];
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            HUD.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
            HUD.textLabel.text = @"Error!";
        });
        [HUD dismissAfterDelay:1];
        if (loginResult == IncorrectPassword) {
            alert = [[UIAlertView alloc] initWithTitle:@"Incorrect Password" message:@"The password you entered is incorrect. Please try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            [alert performSelector:@selector(show) withObject:nil afterDelay:2];
            [self.passwordTextField setText:@""];
        } else {
            alert = [[UIAlertView alloc] initWithTitle:@"Username Not Recognized" message:@"The username you entered was not recognized. The username might not be registered. Please contact Andy Miller." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            [alert performSelector:@selector(show) withObject:nil afterDelay:2];
            [self.passwordTextField setText:@""];
        }
    }
}

/**
 *  Extracted method to go to the Main Menu
 */
-(void)goToMainMenu {
    [self performSegueWithIdentifier:@"goToMainMenu" sender:self];
}

@end
