//
//  GenerateReportViewControllerTest.m
//  MillerConstruction
//
//  Created by David Brooks on 5/3/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "GenerateReportViewController.h"

@interface GenerateReportViewControllerTest : XCTestCase

@end

@implementation GenerateReportViewControllerTest {
    GenerateReportViewController *viewController;
}

-(void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    viewController = [storyboard instantiateViewControllerWithIdentifier:@"GenerateReportViewController"];
    [viewController view];
}

-(void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testImplementation {
    XCTAssertEqualObjects(NSStringFromClass([[GenerateReportViewController new] class]), NSStringFromClass([GenerateReportViewController class]));
}

-(void)testViewControllerViewExists {
    XCTAssertNotNil([viewController view], @"GenerateReportViewController should contain a view");
}

@end
