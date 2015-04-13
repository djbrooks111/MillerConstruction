//
//  LoginViewControllerTest.m
//  MillerConstruction
//
//  Created by David Brooks on 3/20/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>
#import "LoginViewController.h"

#define USERNAME @"djbrooks"
#define PASSWORD @"ylxwpliyok"
#define WRONG @"wrong"

@interface LoginViewControllerTest : XCTestCase

@end

@implementation LoginViewControllerTest {
    LoginViewController *viewController;
}

-(void)setUp {
    [super setUp];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    viewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [viewController view];
}

-(void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testImplementation {
    XCTAssertEqualObjects(NSStringFromClass([[LoginViewController new] class]), NSStringFromClass([LoginViewController class]));
}

-(void)testViewControllerViewExists {
    XCTAssertNotNil([viewController view], @"LoginViewController should contain a view");
}

-(void)testUsernameTextFieldConnection {
    XCTAssertNotNil([viewController usernameTextField], @"usernameTextField should be connected");
}

-(void)testPasswordTextFieldConnection {
    XCTAssertNotNil([viewController passwordTextField], @"passwordTextField should be connected");
}

-(void)testLoginButtonConnection {
    XCTAssertNotNil([viewController loginButton], @"loginButton should be connected");
}

-(void)testLoginButtonIBActionConnection {
    NSArray *actions = [viewController.loginButton actionsForTarget:viewController forControlEvent:UIControlEventTouchUpInside];
    XCTAssertTrue([actions containsObject:@"login:"], @"loginButton should have the login method connected");
}

-(void)testSegueToMainMenu {
    [UIApplication sharedApplication].keyWindow.rootViewController = viewController;
    [viewController performSegueWithIdentifier:@"goToMainMenu" sender:nil];
    XCTAssertNotNil(viewController.presentedViewController, @"Main Menu should be presented");
}

@end
