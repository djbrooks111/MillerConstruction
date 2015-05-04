//
//  ViewExistingProjectTableViewControllerTest.m
//  MillerConstruction
//
//  Created by David Brooks on 5/3/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ViewExistingProjectTableViewController.h"

@interface ViewExistingProjectTableViewControllerTest : XCTestCase

@end

@implementation ViewExistingProjectTableViewControllerTest {
    ViewExistingProjectTableViewController *viewController;
}

-(void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    viewController = [storyboard instantiateViewControllerWithIdentifier:@"ViewExistingProjectTableViewController"];
    [viewController view];
}

-(void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testImplementation {
    XCTAssertEqualObjects(NSStringFromClass([[ViewExistingProjectTableViewController new] class]), NSStringFromClass([ViewExistingProjectTableViewController class]));
}

-(void)testViewControllerViewExists {
    XCTAssertNotNil([viewController view], @"ViewExistingProjectTableViewController should contain a view");
}

@end
