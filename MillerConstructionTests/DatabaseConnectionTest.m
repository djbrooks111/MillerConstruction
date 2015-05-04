//
//  DatabaseConnectionTest.m
//  MillerConstruction
//
//  Created by David Brooks on 3/23/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DatabaseConnector.h"

@interface DatabaseConnectionTest : XCTestCase

@end

@implementation DatabaseConnectionTest {
    DatabaseConnector *database;
}

-(void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    database = [DatabaseConnector sharedDatabaseConnector];
    [database connectToDatabase];
}

-(void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    database.databaseConnection = nil;
}

-(void)testImplementation {
    XCTAssertEqualObjects(NSStringFromClass([[DatabaseConnector new] class]), NSStringFromClass([DatabaseConnector class]));
}

-(void)testFetchProjectItem {
    XCTAssertNotNil([database fetchProjectItem]);
}

-(void)testFetchWarehouses {
    XCTAssertNotNil([database fetchWarehouses]);
}

-(void)testFetchProjectClassifications {
    XCTAssertNotNil([database fetchProjectClassifications]);
}

-(void)testFetchProjectPeople {
    XCTAssertNotNil([database fetchProjectPeople]);
}

-(void)testFetchProjectStage {
    XCTAssertNotNil([database fetchProjectStage]);
}

-(void)testFetchProjectStatus {
    XCTAssertNotNil([database fetchProjectStatus]);
}

-(void)testFetchProjectType {
    XCTAssertNotNil([database fetchProjectType]);
}

-(void)testFetchWeeklyReport {
    XCTAssertNotNil([database fetchWeeklyReportWithReportType:0]);
    XCTAssertNotNil([database fetchWeeklyReportWithReportType:1]);
    XCTAssertNotNil([database fetchWeeklyReportWithReportType:2]);
    XCTAssertNotNil([database fetchWeeklyReportWithReportType:3]);
    XCTAssertNotNil([database fetchWeeklyReportWithReportType:4]);
    
}

-(void)testFetchSteveMeyerReport {
    XCTAssertNotNil([database fetchSteveMeyerReportWithReportType:0]);
    XCTAssertNotNil([database fetchSteveMeyerReportWithReportType:1]);
}

-(void)testFetchSouthEastReport {
    XCTAssertNotNil([database fetchSouthEastReportWithReportType:0]);
    XCTAssertNotNil([database fetchSouthEastReportWithReportType:1]);
}

-(void)testFetchNorthEastReport {
    XCTAssertNotNil([database fetchNorthEastReportWithReportType:0]);
    XCTAssertNotNil([database fetchNorthEastReportWithReportType:1]);
}

-(void)testFetchJDempseyReport {
    XCTAssertNotNil([database fetchJDempseyReportWithReportType:0]);
    XCTAssertNotNil([database fetchJDempseyReportWithReportType:1]);
}

-(void)testFetchInvoiceReport {
    XCTAssertNotNil([database fetchInvoiceReportWithReportType:0]);
    XCTAssertNotNil([database fetchInvoiceReportWithReportType:1]);
}

-(void)testFetchCompletedReport {
    XCTAssertNotNil([database fetchCompletedReportWithReportType:0]);
}

-(void)testFetchConstructionReport {
    XCTAssertNotNil([database fetchConstructionReportWithReportType:0]);
}

-(void)testFetchRepairReport {
    XCTAssertNotNil([database fetchRepairReportWithReportType:0]);
}

-(void)testFetchInfoTriggers {
    XCTAssertNotNil([database fetchInfoMCSNumberTriggers]);
}

-(void)testFetchWarningTriggers {
    XCTAssertNotNil([database fetchWarningInvoiceTriggers]);
    XCTAssertNotNil([database fetchWarningCostcoDueDateTriggers]);
    XCTAssertNotNil([database fetchWarningTurnOverTriggers]);
}

-(void)testFetchSevereTriggers {
    XCTAssertNotNil([database fetchSevereCostcoDueDateTriggers]);
    XCTAssertNotNil([database fetchSevereInvoiceTriggers]);
}

@end
