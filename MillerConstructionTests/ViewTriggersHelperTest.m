//
//  ViewTriggersHelperTest.m
//  MillerConstruction
//
//  Created by David Brooks on 5/3/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ViewTriggersHelper.h"

@interface ViewTriggersHelperTest : XCTestCase

@end

@implementation ViewTriggersHelperTest {
    ViewTriggersHelper *helper;
}

-(void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    helper = [[ViewTriggersHelper alloc] init];
}

-(void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testImplementation {
    XCTAssertEqualObjects(NSStringFromClass([[ViewTriggersHelper new] class]), NSStringFromClass([ViewTriggersHelper class]));
}

-(void)testLookForTriggers {
    [helper lookForTriggers];
    XCTAssertNotNil([helper infoTriggers]);
    XCTAssertNotNil([helper warningTriggers]);
    XCTAssertNotNil([helper severeTriggers]);
}

@end
