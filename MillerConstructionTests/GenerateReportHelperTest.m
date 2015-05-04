//
//  GenerateReportHelperTest.m
//  MillerConstruction
//
//  Created by David Brooks on 5/3/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DatabaseConnector.h"
#import "GenerateReportSearchHelper.h"

@interface GenerateReportHelperTest : XCTestCase

@end

@implementation GenerateReportHelperTest {
    DatabaseConnector *database;
    GenerateReportSearchHelper *helper;
}

-(void)setUp {
    [super setUp];
    helper = [[GenerateReportSearchHelper alloc] init];
}

-(void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testImplementation {
    XCTAssertEqualObjects(NSStringFromClass([[GenerateReportSearchHelper new] class]), NSStringFromClass([GenerateReportSearchHelper class]));
}

-(void)testReportNamesArray {
    XCTAssertNotNil([helper reportNamesArray]);
}

-(void)testWeeklyReportArrays {
    XCTAssertNotNil([helper weeklyActiveReportHeaders]);
    XCTAssertNotNil([helper weeklyProposalReportHeaders]);
    XCTAssertNotNil([helper weeklyBudgetaryReportHeaders]);
    XCTAssertNotNil([helper weeklyInactiveReportHeaders]);
    XCTAssertNotNil([helper weeklyClosedReportHeaders]);
}

-(void)testSteveMeyerReportArrays {
    XCTAssertNotNil([helper steveMeyerActiveReportHeaders]);
    XCTAssertNotNil([helper steveMeyerProposalReportHeaders]);
}

-(void)testSouthEastReportArrays {
    XCTAssertNotNil([helper southEastActiveReportHeaders]);
    XCTAssertNotNil([helper southEastProposalReportHeaders]);
}

-(void)testNorthEastReportArrays {
    XCTAssertNotNil([helper northEastActiveReportHeaders]);
    XCTAssertNotNil([helper northEastProposalReportHeaders]);
}

-(void)testJDempseyReportArrays {
    XCTAssertNotNil([helper jDempseyActiveReportHeaders]);
    XCTAssertNotNil([helper jDempseyProposalReportHeaders]);
}

-(void)testInvoiceReportArrays {
    XCTAssertNotNil([helper invoiceActiveReportHeaders]);
    XCTAssertNotNil([helper invoiceProposalReportHeaders]);
}

-(void)testCompletedReportArray {
    XCTAssertNotNil([helper completedActiveReportHeaders]);
}

-(void)testConstructionReportArray {
    XCTAssertNotNil([helper constructionActiveReportHeaders]);
}

-(void)testRepairReportArray {
    XCTAssertNotNil([helper repairActiveReportHeaders]);
}

-(void)testProjectInformationForReport {
    database = [DatabaseConnector sharedDatabaseConnector];
    [database connectToDatabase];
    XCTAssertNotNil([helper projectInformationForReport:@"Weekly" andReportType:0]);
    XCTAssertNotNil([helper projectInformationForReport:@"Steve Meyer" andReportType:0]);
    XCTAssertNotNil([helper projectInformationForReport:@"South East Refrigeration" andReportType:0]);
    XCTAssertNotNil([helper projectInformationForReport:@"North East Refrigeration" andReportType:0]);
    XCTAssertNotNil([helper projectInformationForReport:@"J Dempsey" andReportType:0]);
    XCTAssertNotNil([helper projectInformationForReport:@"Invoice" andReportType:0]);
    XCTAssertNotNil([helper projectInformationForReport:@"Completed" andReportType:0]);
    XCTAssertNotNil([helper projectInformationForReport:@"Construction" andReportType:0]);
    XCTAssertNotNil([helper projectInformationForReport:@"Repair" andReportType:0]);
    database.databaseConnection = nil;
}

@end
