//
//  UserTest.m
//  MillerConstruction
//
//  Created by David Brooks on 3/15/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "User.h"

@interface UserTest : XCTestCase

@end

@implementation UserTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testUserCreation {
    User *user = [[User alloc] initWithUsername:@"TestUsername" andPassword:@"TestPassword"];
    XCTAssertEqualObjects(@"TestUsername", [user username], @"User's username should be TestUsername");
    XCTAssertEqualObjects(@"7bcf9d89298f1bfae16fa02ed6b61908fd2fa8de45dd8e2153a3c47300765328", [user password], @"User's password should be 7bcf9d89298f1bfae16fa02ed6b61908fd2fa8de45dd8e2153a3c47300765328, which is TestPassword hashed");
}

-(void)testSuccessfulLogin {
    User *user = [[User alloc] initWithUsername:@"djbrooks" andPassword:@"ylxwpliyok"];
    UserLoginType result = [user login];
    XCTAssertEqual(SuccessfulLogin, result, @"User's login should return SuccessfulLogin");
}

-(void)testIncorrectPassword {
    User *user = [[User alloc] initWithUsername:@"djbrooks" andPassword:@"wrong"];
    UserLoginType result = [user login];
    XCTAssertEqual(IncorrectPassword, result, @"User's login should return IncorrectPassword");
}

-(void)testWrongUsername {
    User *user = [[User alloc] initWithUsername:@"wrong" andPassword:@"wrong"];
    UserLoginType result = [user login];
    XCTAssertEqual(WrongUsername, result, @"User's login should return WrongUsername");
}

@end
