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

@end
