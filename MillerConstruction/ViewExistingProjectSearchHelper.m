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

#pragma mark - Project Searching

/**
 *  Used when finding existing projects, searches for projects matching the selected warehouse and stage
 *
 *  @param warehouseID    The id of the warehouse
 *  @param projectStageID The id of the stage
 *
 *  @return Array of project information
 */
-(NSArray *)availableProjectsForWarehouseID:(NSNumber *)warehouseID andProjectStageID:(NSNumber *)projectStageID {
    [database connectToDatabase];
    NSArray *availableProjects = [database fetchProjectsWithWarehouseID:warehouseID andProjectStageID:projectStageID];
    database.databaseConnection = nil;
    
    return availableProjects;
}

/**
 *  Searches the Warehouse array from the name
 *
 *  @param fullName The full name of the Warehouse
 *
 *  @return The rowID of the Warehouse
 */
-(NSNumber *)rowIDOfWarehouseFromFullName:(NSString *)fullName {
    for (int i = 0; i < [self.warehouseArray count]; i++) {
        Warehouse *warehouse = [self.warehouseArray objectAtIndex:i];
        if ([[warehouse fullName] isEqualToString:fullName]) {
            
            return [warehouse rowID];
        }
    }
    
    return nil;
}

/**
 *  Searches the Project Stage array for the name
 *
 *  @param name The name of the Project Stage
 *
 *  @return The rowID of the Project Stage
 */
-(NSNumber *)rowIDOfProjectStageFromName:(NSString *)name {
    for (int i = 0; i < [self.projectStageArray count]; i++) {
        ProjectStage *stage = [self.projectStageArray objectAtIndex:i];
        if ([[stage name] isEqualToString:name]) {
            
            return [stage rowID];
        }
    }
    
    return nil;
}

@end
