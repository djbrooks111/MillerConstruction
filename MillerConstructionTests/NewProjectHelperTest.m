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
    [database connectToDatabase];
    newProjectHelper = [[NewProjectHelper alloc] initForTesting];
}

-(void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    database.databaseConnection = nil;
    [super tearDown];
}

-(void)testImplementation {
    XCTAssertEqualObjects(NSStringFromClass([[NewProjectHelper new] class]), NSStringFromClass([NewProjectHelper class]));
}

-(void)testProjectAttributesNamesArray {
    [newProjectHelper initializeProjectAttributesNamesArray];
    XCTAssertNotNil([newProjectHelper projectAttributesNames], @"Array should be populated");
}

-(void)testProjectAttributesKeysArray {
    [newProjectHelper initializeProjectAttributesKeysArray];
    XCTAssertNotNil([newProjectHelper projectAttributesKeys], @"Array should be populated");
}

-(void)testWarehouseArrays {
    NSArray *resultArray = [database fetchWarehouses];
    [newProjectHelper initializeWarehouseArrays];
    XCTAssertNotNil([newProjectHelper warehouseNamesArray], @"Array should be populated");
    XCTAssertNotEqualObjects(resultArray, [newProjectHelper warehouseArray], @"Arrays should not be equal, i.e. unsorted vs sorted");
}

-(void)testProjectClassificationArrays {
    NSArray *resultArray = [database fetchProjectClassifications];
    [newProjectHelper initializeProjectClassificationArray];
    XCTAssertNotNil([newProjectHelper projectClassificationNameArray], @"Array should be populated");
    XCTAssertNotEqualObjects(resultArray, [newProjectHelper projectClassificationArray], @"Arrays should not be equal, i.e. unsorted vs sorted");
}

-(void)testProjectItemArrays {
    NSArray *resultArray = [database fetchProjectItem];
    [newProjectHelper initializeProjectArray];
    XCTAssertNotNil([newProjectHelper projectNameArray], @"Array should be populated");
    XCTAssertNotEqualObjects(resultArray, [newProjectHelper projectArray], @"Arrays should not be equal, i.e. unsorted vs sorted");
}

-(void)testProjectMangerArrays {
    NSArray *resultArray = [database fetchProjectPeople];
    [newProjectHelper initializeProjectManagerArray];
    XCTAssertNotNil([newProjectHelper projectManagerNameArray], @"Array should be populated");
    XCTAssertNotEqualObjects(resultArray, [newProjectHelper projectManagerArray], @"Arrays should not be equal, i.e. unsorted vs sorted");
}

-(void)testProjectSupervisorArrays {
    NSArray *resultArray = [database fetchProjectPeople];
    [newProjectHelper initializeProjectSupervisorArray];
    XCTAssertNotNil([newProjectHelper projectSupervisorNameArray], @"Array should be populated");
    XCTAssertNotEqualObjects(resultArray, [newProjectHelper projectSupervisorArray], @"Arrays should not be equal, i.e. unsorted vs sorted");
}

-(void)testProjectStageArrays {
    NSArray *resultArray = [database fetchProjectStage];
    [newProjectHelper initializeProjectStageArray];
    XCTAssertNotNil([newProjectHelper projectStageNameArray], @"Array should be populated");
    XCTAssertNotEqualObjects(resultArray, [newProjectHelper projectStageArray], @"Arrays should not be equal, i.e. unsorted vs sorted");
}

-(void)testProjectStatusArrays {
    NSArray *resultArray = [database fetchProjectStatus];
    [newProjectHelper initializeProjectStatusArray];
    XCTAssertNotNil([newProjectHelper projectStatusNameArray], @"Array should be populated");
    XCTAssertNotEqualObjects(resultArray, [newProjectHelper projectStatusArray], @"Arrays should not be equal, i.e. unsorted vs sorted");
}

-(void)testProjectTypeArrays {
    NSArray *resultArray = [database fetchProjectType];
    [newProjectHelper initializeProjectTypeArray];
    XCTAssertNotNil([newProjectHelper projectTypeNameArray], @"Array should be populated");
    XCTAssertNotEqualObjects(resultArray, [newProjectHelper projectTypeArray], @"Arrays should not be equal, i.e. unsorted vs sorted");
}

@end
