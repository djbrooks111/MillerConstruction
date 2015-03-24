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

-(void)initializeWarehouseArrays {
    NSArray *resultArray = [database fetchWarehouses];
    NSMutableArray *unsortedArray = [[NSMutableArray alloc] init];
    for (NSDictionary *warehouseRow in resultArray) {
        NSNumber *warehouseRowID = [warehouseRow objectForKey:@"id"];
        NSString *warehouseState = [warehouseRow objectForKey:@"state"];
        NSNumber *warehouseID = [warehouseRow objectForKey:@"warehouseID"];
        NSString *warehouseCity = [warehouseRow objectForKey:@"name"];
        [unsortedArray addObject:[[Warehouse alloc] initWithRowID:warehouseRowID andState:warehouseState andWarehouseID:warehouseID andCity:warehouseCity]];
    }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"city" ascending:YES];
    self.warehouseArray = [unsortedArray sortedArrayUsingDescriptors:@[sortDescriptor]];
}

-(void)initializeProjectClassificationArray {
    self.projectClassificationArray = [NSArray arrayWithObjects:@"PO", @"AIA", @"Facility", @"HVAC", nil];
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
                                    @"Schedules Turnover:",
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
