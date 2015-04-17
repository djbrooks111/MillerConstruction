//
//  projectHelperTest.m
//  MillerConstruction
//
//  Created by David Brooks on 3/29/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DatabaseConnector.h"
#import "ProjectHelper.h"

@interface projectHelperTest : XCTestCase

@end

@implementation projectHelperTest {
    DatabaseConnector *database;
    ProjectHelper *projectHelper;
}

-(void)setUp {
    [super setUp];
    database = [DatabaseConnector sharedDatabaseConnector];
    [database connectToDatabase];
    projectHelper = [[ProjectHelper alloc] initForTesting];
}

-(void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    database.databaseConnection = nil;
    [super tearDown];
}

-(void)testImplementation {
    XCTAssertEqualObjects(NSStringFromClass([[ProjectHelper new] class]), NSStringFromClass([ProjectHelper class]));
}

-(void)testProjectAttributesNamesArray {
    [projectHelper initializeProjectAttributesNamesArray];
    XCTAssertNotNil([projectHelper projectAttributesNames], @"Array should be populated");
}

-(void)testProjectAttributesKeysArray {
    [projectHelper initializeProjectAttributesKeysArray];
    XCTAssertNotNil([projectHelper projectAttributesKeys], @"Array should be populated");
}

-(void)testWarehouseArrays {
    NSArray *resultArray = [database fetchWarehouses];
    [projectHelper initializeWarehouseArrays];
    XCTAssertNotNil([projectHelper warehouseNamesArray], @"Array should be populated");
    XCTAssertNotEqualObjects(resultArray, [projectHelper warehouseArray], @"Arrays should not be equal, i.e. unsorted vs sorted");
}

-(void)testProjectClassificationArrays {
    NSArray *resultArray = [database fetchProjectClassifications];
    [projectHelper initializeProjectClassificationArray];
    XCTAssertNotNil([projectHelper projectClassificationNameArray], @"Array should be populated");
    XCTAssertNotEqualObjects(resultArray, [projectHelper projectClassificationArray], @"Arrays should not be equal, i.e. unsorted vs sorted");
}

-(void)testProjectItemArrays {
    NSArray *resultArray = [database fetchProjectItem];
    [projectHelper initializeProjectArray];
    XCTAssertNotNil([projectHelper projectNameArray], @"Array should be populated");
    XCTAssertNotEqualObjects(resultArray, [projectHelper projectArray], @"Arrays should not be equal, i.e. unsorted vs sorted");
}

-(void)testProjectMangerArrays {
    NSArray *resultArray = [database fetchProjectPeople];
    [projectHelper initializeProjectManagerArray];
    XCTAssertNotNil([projectHelper projectManagerNameArray], @"Array should be populated");
    XCTAssertNotEqualObjects(resultArray, [projectHelper projectManagerArray], @"Arrays should not be equal, i.e. unsorted vs sorted");
}

-(void)testProjectSupervisorArrays {
    NSArray *resultArray = [database fetchProjectPeople];
    [projectHelper initializeProjectSupervisorArray];
    XCTAssertNotNil([projectHelper projectSupervisorNameArray], @"Array should be populated");
    XCTAssertNotEqualObjects(resultArray, [projectHelper projectSupervisorArray], @"Arrays should not be equal, i.e. unsorted vs sorted");
}

-(void)testProjectStageArrays {
    NSArray *resultArray = [database fetchProjectStage];
    [projectHelper initializeProjectStageArray];
    XCTAssertNotNil([projectHelper projectStageNameArray], @"Array should be populated");
    XCTAssertNotEqualObjects(resultArray, [projectHelper projectStageArray], @"Arrays should not be equal, i.e. unsorted vs sorted");
}

-(void)testProjectStatusArrays {
    NSArray *resultArray = [database fetchProjectStatus];
    [projectHelper initializeProjectStatusArray];
    XCTAssertNotNil([projectHelper projectStatusNameArray], @"Array should be populated");
    XCTAssertNotEqualObjects(resultArray, [projectHelper projectStatusArray], @"Arrays should not be equal, i.e. unsorted vs sorted");
}

-(void)testProjectTypeArrays {
    NSArray *resultArray = [database fetchProjectType];
    [projectHelper initializeProjectTypeArray];
    XCTAssertNotNil([projectHelper projectTypeNameArray], @"Array should be populated");
    XCTAssertNotEqualObjects(resultArray, [projectHelper projectTypeArray], @"Arrays should not be equal, i.e. unsorted vs sorted");
}

@end
