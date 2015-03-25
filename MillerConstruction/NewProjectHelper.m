//
//  NewProjectHelper.m
//  MillerConstruction
//
//  Created by David Brooks on 3/23/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import "NewProjectHelper.h"
#import "DatabaseConnector.h"
#import "ProjectTypes.h"
#import "Warehouse.h"
#import "ProjectClassification.h"

@implementation NewProjectHelper {
    DatabaseConnector *database;
}

-(id)init {
    if (self = [super init]) {
        // Configure init
        database = [DatabaseConnector sharedDatabaseConnector];
        [self initializeWarehouseArrays];
        [self initializeProjectClassificationArray];
        [self initializeProjectAttributesNamesArray];
        [self initializeProjectAttributesKeysArray];
    }
    
    return self;
}

/**
 *  Retreives all the warehouses from the database
 */
-(void)initializeWarehouseArrays {
    NSArray *resultArray = [database fetchWarehouses];
    NSMutableArray *unsortedArray = [[NSMutableArray alloc] init];
    for (NSDictionary *warehouseRow in resultArray) {
        NSNumber *warehouseRowID = [warehouseRow objectForKey:@"warehouse.id"];
        NSString *warehouseState = [warehouseRow objectForKey:@"warehouse.state"];
        NSNumber *warehouseID = [warehouseRow objectForKey:@"warehouse.warehouseID"];
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
 *  Retreives all the project classifications from the database
 */
-(void)initializeProjectClassificationArray {
    NSArray *resultArray = [database fetchProjectClassifications];
    NSMutableArray *unsortedArray = [[NSMutableArray alloc] init];
    for (NSDictionary *projectClassificationRow in resultArray) {
        NSNumber *projectClassificationRowID = [projectClassificationRow objectForKey:@"id"];
        NSString *projectClassificationName = [projectClassificationRow objectForKey:@"name"];
        [unsortedArray addObject:[[ProjectClassification alloc] initWithRowID:projectClassificationRowID andName:projectClassificationName]];
    }
    NSSortDescriptor *sortDescripter = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    self.projectClassificationArray = [unsortedArray sortedArrayUsingDescriptors:@[sortDescripter]];
}

/**
 *  Extracts all the project classification names from the project classification array
 */
-(void)initializeProjectClassificationNamesArray {
    NSMutableArray *namesArray = [[NSMutableArray alloc] init];
    for (ProjectClassification *projectClassification in self.projectClassificationArray) {
        NSString *projectClassificationName = [projectClassification name];
        [namesArray addObject:projectClassificationName];
    }
    self.projectAttributesNames = [namesArray copy];
}

-(void)initializeProjectArray {
    NSArray *resultArray = [database fetchProjectTypes];
    NSMutableArray *unsortedArray = [[NSMutableArray alloc] init];
    for (NSDictionary *projectTypeRow in resultArray) {
        NSNumber *projectTypeNumber = [projectTypeRow objectForKey:@"id"];
        NSString *projectTypeName = [projectTypeRow objectForKey:@"name"];
        [unsortedArray addObject:[[ProjectTypes alloc] initWithName:projectTypeName andNumber:[projectTypeNumber intValue]]];
    }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    self.projectArray = [unsortedArray sortedArrayUsingDescriptors:@[sortDescriptor]];
}

-(void)initializeProjectAttributesNamesArray {
    self.projectAttributesNames = @[
                                    @"MCS Project#:",
                                    @"Warehouse:",
                                    @"Project Classification:",
                                    @"Project:",
                                    @"Project Manager:",
                                    @"Supervisor:",
                                    @"Project Stage:",
                                    @"Project Status:",
                                    @"Project Type:",
                                    @"Project Scope:",
                                    @"Project Initiation Date:",
                                    @"Site Survey Date:",
                                    @"Costco Due Date:",
                                    @"Proposal Submitted Date:",
                                    @"As-Builts Date:",
                                    @"Punch List Date:",
                                    @"Alarm / HVAC Form Date:",
                                    @"Verisae Report Date:",
                                    @"Closeout Notes Date:",
                                    @"Scheduled Start Date:",
                                    @"Scheduled Turnover:",
                                    @"Actual Turnover:",
                                    @"Air Gas:",
                                    @"Permit Application:",
                                    @"Permits Closed:",
                                    @"Salvage Value Date:",
                                    @"Salvage Value Amount:",
                                    @"Should Invoice %:",
                                    @"Actual Invoice %:",
                                    @"Project / Financial Notes:",
                                    @"Zach Notes:",
                                    @"Project Cost:",
                                    @"Customer Number:"];
}

-(void)initializeProjectAttributesKeysArray {
    self.projectAttributesKeys = @[
                                   @"mcsNumber",
                                   @"warehouse_id",
                                   @"projectClass_id",
                                   @"projectItem_id",
                                   @"",
                                   @"",
                                   @"stage_id",
                                   @"status_id",
                                   @"projectType_id",
                                   @"scope",
                                   @"projectInitiatedDate",
                                   @"siteSurvey",
                                   @"costcoDueDate",
                                   @"proposalSubmitted",
                                   @"",
                                   @"",
                                   @"",
                                   @"",
                                   @"",
                                   @"scheduledStartDate",
                                   @"SchedulesTurnover",
                                   @"actualTurnover",
                                   @"",
                                   @"permitApplication",
                                   @"",
                                   @"",
                                   @"",
                                   @"shouldInvoice",
                                   @"invoiced",
                                   @"projectNotes",
                                   @"zachUpdates",
                                   @"cost",
                                   @"customerNumber"];
}

@end
