//
//  NewProjectHelperTest.m
//  MillerConstruction
//
//  Created by David Brooks on 3/29/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DatabaseConnector.h"
#import "NewProjectHelper.h"

@interface NewProjectHelperTest : XCTestCase

@end

@implementation NewProjectHelperTest {
    DatabaseConnector *database;
    NewProjectHelper *newProjectHelper;
}

-(void)setUp {
    [super setUp];
    database = [DatabaseConnector sharedDatabaseConnector];
    newProjectHelper = [[NewProjectHelper alloc] init];
}

-(void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testImplementation {
    XCTAssertEqualObjects(NSStringFromClass([[NewProjectHelper new] class]), NSStringFromClass([NewProjectHelper class]));
}

-(void)testWarehouseArrays {
    NSArray *resultArray = [database fetchWarehouses];
    XCTAssertNotEqualObjects(resultArray, [newProjectHelper warehouseArray], @"Arrays should not be equal, i.e. unsorted vs sorted");
    XCTAssertNotNil([newProjectHelper warehouseNamesArray], @"Array should be populated");
}

@end
