//
//  LoginViewController.h
//  MillerConstruction
//
//  Created by David Brooks on 3/15/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

-(IBAction)login:(UIButton *)sender;

@end

