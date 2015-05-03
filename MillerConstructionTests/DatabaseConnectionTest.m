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
#import "ProjectItem.h"

@interface DatabaseConnectionTest : XCTestCase

@end

@implementation DatabaseConnectionTest {
    DatabaseConnector *database;
}

-(void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    database = [DatabaseConnector sharedDatabaseConnector];
}

-(void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testImplementation {
    XCTAssertEqualObjects(NSStringFromClass([[DatabaseConnector new] class]), NSStringFromClass([DatabaseConnector class]));
}

-(void)testFetchProjectItem {
    NSArray *resultArray = [database fetchProjectItem];
    NSMutableArray *unsortedArray = [[NSMutableArray alloc] init];
    for (NSDictionary *projectTypeRow in resultArray) {
        NSNumber *projectTypeNumber = [projectTypeRow objectForKey:@"id"];
        NSString *projectTypeName = [projectTypeRow objectForKey:@"name"];
        [unsortedArray addObject:[[ProjectItem alloc] initWithRowID:projectTypeNumber andName:projectTypeName]];
    }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortedArray = [unsortedArray sortedArrayUsingDescriptors:@[sortDescriptor]];
    XCTAssertNotEqualObjects(resultArray, sortedArray, @"Arrays should not be equal, i.e. unsorted vs sorted");
}

-(void)testThing {
    NSArray *resultArray = [database fetchProjectInformationForID:[NSNumber numberWithInt:1]];
    NSLog(@"%@", resultArray);
}

-(void)testSQL {
    [database connectToDatabase];
    MysqlFetch *fetch = [database fetchWithCommand:@"SELECT project.mcsNumber, projectstage.name, warehouse.warehouseID, warehouse.state, city.name, projectitem.name, project.scope, warehouse.region, projectstatus.name, project.projectInitiatedDate, projecttype.name, project.costcoDueDate, project.proposalSubmitted, project.scheduledStartDate, project.scheduledTurnover, closeoutdetails.asBuilts, closeoutdetails.punchList, closeoutdetails.alarmHvacForm, closeoutdetails.airGas, closeoutdetails.permitsClosed, project.shouldInvoice, project.invoiced, project.projectNotes FROM project, projectstage, warehouse, city, projectitem, projectstatus, projecttype, closeoutdetails WHERE projectstage.name = \"Closed\" AND projectstage.id = project.stage_id AND project.warehouse_id = warehouse.id AND warehouse.city_id = city.id AND project.projectItem_id = projectitem.id AND project.status_id = projectstatus.id AND project.projectType_id = projecttype.id AND project.closeoutDetails_id = closeoutdetails.id"];
    database.databaseConnection = nil;
    NSLog(@"%@", [fetch results]);
}

@end
