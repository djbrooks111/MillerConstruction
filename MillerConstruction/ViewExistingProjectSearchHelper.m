//
//  ViewExistingProjectSearchHelper.m
//  MillerConstruction
//
//  Created by David Brooks on 4/6/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import "ViewExistingProjectSearchHelper.h"
#import "DatabaseConnector.h"
#import "Warehouse.h"
#import "ProjectStage.h"

@implementation ViewExistingProjectSearchHelper {
    DatabaseConnector *database;
}

-(id)init {
    if (self = [super init]) {
        // Configure init
        database = [DatabaseConnector sharedDatabaseConnector];
        [database connectToDatabase];
        [self initializeWarehouseArrays];
        [self initializeProjectStageArrays];
        database.databaseConnection = nil;
    }
    
    return self;
}

#pragma mark - Initialization methods

/**
 *  Retreives all the warehouses from the database
 */
-(void)initializeWarehouseArrays {
    NSArray *resultArray = [database fetchWarehouses];
    NSMutableArray *unsortedArray = [[NSMutableArray alloc] init];
    for (NSDictionary *warehouseRow in resultArray) {
        NSNumber *warehouseRowID = [warehouseRow objectForKey:@"id"];
        NSString *warehouseState = [warehouseRow objectForKey:@"state"];
        NSNumber *warehouseID = [warehouseRow objectForKey:@"warehouseID"];
        NSString *warehouseCity = [warehouseRow objectForKey:@"city.name"];
        [unsortedArray addObject:[[Warehouse alloc] initWithRowID:warehouseRowID andState:warehouseState andWarehouseID:warehouseID andCity:warehouseCity]];
    }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"city" ascending:YES];
    self.warehouseArray = [unsortedArray sortedArrayUsingDescriptors:@[sortDescriptor]];
    [self initializeWarehouseNamesArray];
}

/**
 *  Extracts the warehouse names from the warehouse array
 */
-(void)initializeWarehouseNamesArray {
    NSMutableArray *namesArray = [[NSMutableArray alloc] init];
    for (Warehouse *warehouse in self.warehouseArray) {
        NSString *warehouseFullName = [warehouse fullName];
        [namesArray addObject:warehouseFullName];
    }
    self.warehouseNamesArray = [namesArray copy];
}

/**
 *  Retreives all the project stages from the database
 */
-(void)initializeProjectStageArrays {
    NSArray *resultArray = [database fetchProjectStage];
    NSMutableArray *unsortedArray = [[NSMutableArray alloc] init];
    for (NSDictionary *projectStageRow in resultArray) {
        NSNumber *projectStageNumber = [projectStageRow objectForKey:@"id"];
        NSString *projectStageName = [projectStageRow objectForKey:@"name"];
        [unsortedArray addObject:[[ProjectStage alloc] initWithRowID:projectStageNumber andName:projectStageName]];
    }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    self.projectStageArray = [unsortedArray sortedArrayUsingDescriptors:@[sortDescriptor]];
    [self initializeProjectStageNamesArray];
}

/**
 *  Extracts all the project stage names from the project stage array
 */
-(void)initializeProjectStageNamesArray {
    NSMutableArray *namesArray = [[NSMutableArray alloc] init];
    for (ProjectStage *stage in self.projectStageArray) {
        NSString *stageName = [stage name];
        [namesArray addObject:stageName];
    }
    self.projectStageNameArray = [namesArray copy];
}



@end
