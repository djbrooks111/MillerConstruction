//
//  ProjectHelper.m
//  MillerConstruction
//
//  Created by David Brooks on 3/23/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import "ProjectHelper.h"
#import "DatabaseConnector.h"
#import "ProjectItem.h"
#import "Warehouse.h"
#import "ProjectClassification.h"
#import "Person.h"
#import "ProjectStage.h"
#import "ProjectStatus.h"
#import "ProjectType.h"

@implementation ProjectHelper {
    DatabaseConnector *database;
}

-(id)init {
    if (self = [super init]) {
        // Configure init
        database = [DatabaseConnector sharedDatabaseConnector];
        [database connectToDatabase];
        [self initializeProjectAttributesNamesArray];
        [self initializeProjectAttributesKeysArray];
        [self initializeWarehouseArrays];
        [self initializeProjectClassificationArray];
        [self initializeProjectArray];
        [self initializeProjectManagerArray];
        [self initializeProjectSupervisorArray];
        [self initializeProjectStageArray];
        [self initializeProjectStatusArray];
        [self initializeProjectTypeArray];
        database.databaseConnection = nil;
    }
    
    return self;
}

-(id)initForTesting {
    if (self = [super init]) {
        // init used for testing
        database = [DatabaseConnector sharedDatabaseConnector];
    }
    
    return self;
}

#pragma mark - Initializing methods

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
    [self initializeProjectClassificationNamesArray];
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
    self.projectClassificationNameArray = [namesArray copy];
}

/**
 *  Retreives all the project items from the database
 */
-(void)initializeProjectArray {
    NSArray *resultArray = [database fetchProjectItem];
    NSMutableArray *unsortedArray = [[NSMutableArray alloc] init];
    for (NSDictionary *projectTypeRow in resultArray) {
        NSNumber *projectTypeNumber = [projectTypeRow objectForKey:@"id"];
        NSString *projectTypeName = [projectTypeRow objectForKey:@"name"];
        [unsortedArray addObject:[[ProjectItem alloc] initWithRowID:projectTypeNumber andName:projectTypeName]];
    }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    self.projectArray = [unsortedArray sortedArrayUsingDescriptors:@[sortDescriptor]];
    [self initializeProjectNameArray];
}

/**
 *  Extracts all the project item names from the project item array
 */
-(void)initializeProjectNameArray {
    NSMutableArray *namesArray = [[NSMutableArray alloc] init];
    for (ProjectItem *projectItem in self.projectArray) {
        NSString *projectName = [projectItem name];
        [namesArray addObject:projectName];
    }
    self.projectNameArray = [namesArray copy];
}

/**
 *  Retreives all the project managers from the database
 */
-(void)initializeProjectManagerArray {
    NSArray *resultArray = [database fetchProjectPeople];
    NSMutableArray *unsortedArray = [[NSMutableArray alloc] init];
    for (NSDictionary *projectPersonRow in resultArray) {
        NSNumber *projectPersonNumber = [projectPersonRow objectForKey:@"id"];
        NSString *projectPersonName = [projectPersonRow objectForKey:@"name"];
        [unsortedArray addObject:[[Person alloc] initWithName:projectPersonName andIDNumber:projectPersonNumber]];
    }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    self.projectManagerArray = [unsortedArray sortedArrayUsingDescriptors:@[sortDescriptor]];
    [self initializeProjectManagerNameArray];
}

/**
 *  Extracts all the project manager names from the project manager array
 */
-(void)initializeProjectManagerNameArray {
    NSMutableArray *namesArray = [[NSMutableArray alloc] init];
    for (Person *person in self.projectManagerArray) {
        NSString *personName = [person name];
        [namesArray addObject:personName];
    }
    self.projectManagerNameArray = [namesArray copy];
}

/**
 *  Retreives all the project supervisors from the database
 */
-(void)initializeProjectSupervisorArray {
    NSArray *resultArray = [database fetchProjectPeople];
    NSMutableArray *unsortedArray = [[NSMutableArray alloc] init];
    for (NSDictionary *projectPersonRow in resultArray) {
        NSNumber *projectPersonNumber = [projectPersonRow objectForKey:@"id"];
        NSString *projectPersonName = [projectPersonRow objectForKey:@"name"];
        [unsortedArray addObject:[[Person alloc] initWithName:projectPersonName andIDNumber:projectPersonNumber]];
    }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    self.projectSupervisorArray = [unsortedArray sortedArrayUsingDescriptors:@[sortDescriptor]];
    [self initializeProjectSupervisorNameArray];
}

/**
 *  Extracts all the project supervisor names from the project supervisor array
 */
-(void)initializeProjectSupervisorNameArray {
    NSMutableArray *namesArray = [[NSMutableArray alloc] init];
    for (Person *person in self.projectSupervisorArray) {
        NSString *personName = [person name];
        [namesArray addObject:personName];
    }
    self.projectSupervisorNameArray = [namesArray copy];
}

/**
 *  Retreives all the project stages from the database
 */
-(void)initializeProjectStageArray {
    NSArray *resultArray = [database fetchProjectStage];
    NSMutableArray *unsortedArray = [[NSMutableArray alloc] init];
    for (NSDictionary *projectStageRow in resultArray) {
        NSNumber *projectStageNumber = [projectStageRow objectForKey:@"id"];
        NSString *projectStageName = [projectStageRow objectForKey:@"name"];
        [unsortedArray addObject:[[ProjectStage alloc] initWithRowID:projectStageNumber andName:projectStageName]];
    }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    self.projectStageArray = [unsortedArray sortedArrayUsingDescriptors:@[sortDescriptor]];
    [self initializeProjectStageNameArray];
}

/**
 *  Extracts all the project stage names from the project stage array
 */
-(void)initializeProjectStageNameArray {
    NSMutableArray *namesArray = [[NSMutableArray alloc] init];
    for (ProjectStage *stage in self.projectStageArray) {
        NSString *stageName = [stage name];
        [namesArray addObject:stageName];
    }
    self.projectStageNameArray = [namesArray copy];
}

/**
 *  Retreives all the project status from the database
 */
-(void)initializeProjectStatusArray {
    NSArray *resultArray = [database fetchProjectStatus];
    NSMutableArray *unsortedArray = [[NSMutableArray alloc] init];
    for (NSDictionary *projectStatusRow in resultArray) {
        NSNumber *projectStatusNumber = [projectStatusRow objectForKey:@"id"];
        NSString *projectStatusName = [projectStatusRow objectForKey:@"name"];
        [unsortedArray addObject:[[ProjectStatus alloc] initWithRowID:projectStatusNumber andName:projectStatusName]];
    }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    self.projectStatusArray = [unsortedArray sortedArrayUsingDescriptors:@[sortDescriptor]];
    [self initializeProjectStatusNameArray];
}

/**
 *  Extracts all the project status names from the project status array
 */
-(void)initializeProjectStatusNameArray {
    NSMutableArray *namesArray = [[NSMutableArray alloc] init];
    for (ProjectStatus *status in self.projectStatusArray) {
        NSString *statusName = [status name];
        [namesArray addObject:statusName];
    }
    self.projectStatusNameArray = [namesArray copy];
}

/**
 *  Retreives all the project types from the database
 */
-(void)initializeProjectTypeArray {
    NSArray *resultArray = [database fetchProjectType];
    NSMutableArray *unsortedArray = [[NSMutableArray alloc] init];
    for (NSDictionary *projectTypeRow in resultArray) {
        NSNumber *projectTypeNumber = [projectTypeRow objectForKey:@"id"];
        NSString *projectTypeName = [projectTypeRow objectForKey:@"name"];
        [unsortedArray addObject:[[ProjectType alloc] initWithRowID:projectTypeNumber andName:projectTypeName]];
    }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    self.projectTypeArray = [unsortedArray sortedArrayUsingDescriptors:@[sortDescriptor]];
    [self initializeProjectTypeNameArray];
}

/**
 *  Extracts all the project type names from the project type array
 */
-(void)initializeProjectTypeNameArray {
    NSMutableArray *namesArray = [[NSMutableArray alloc] init];
    for (ProjectType *type in self.projectTypeArray) {
        NSString *typeName = [type name];
        [namesArray addObject:typeName];
    }
    self.projectTypeNameArray = [namesArray copy];
}

/**
 *  The titles of each UITableView row, the labels that tell the user what the row is for
 */
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

/**
 *  Used when saving a project into the database, only contains attributes of the Project table
 */
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
                                   @"scheduledTurnover",
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

#pragma mark - Saving methods

/**
 *  Searches the Warehouse array for the name
 *
 *  @param fullName The full name of the Warehouse
 *
 *  @return The rowID of the Warehouse
 */
-(NSNumber *)rowIDOfWarehouseFromFullName:(NSString *)fullName {
    for (int i = 0; i < [self.warehouseArray count]; i++) {
        Warehouse *warehouse = [self.warehouseArray objectAtIndex:i];
        if ([[warehouse fullName] isEqualToString:fullName]) {
            NSLog(@"Warehouse: %@", [warehouse rowID]);
            
            return [warehouse rowID];
        }
    }
    
    return nil;
}

/**
 *  Searches the Project Classification array for the name
 *
 *  @param name The name of the Project Classification
 *
 *  @return The rowID of the Project Classification
 */
-(NSNumber *)rowIDOfProjectClassificationFromName:(NSString *)name {
    for (int i = 0; i < [self.projectClassificationArray count]; i++) {
        ProjectClassification *projectClassification = [self.projectClassificationArray objectAtIndex:i];
        if ([[projectClassification name] isEqualToString:name]) {
            NSLog(@"Project Classification: %@", [projectClassification rowID]);
            
            return [projectClassification rowID];
        }
    }
    
    return nil;
}

/**
 *  Searches the Project Item array for the name
 *
 *  @param name The name of the Project Item
 *
 *  @return The rowID of the Project Item
 */
-(NSNumber *)rowIDOfProjectItemFromName:(NSString *)name {
    for (int i = 0; i < [self.projectArray count]; i++) {
        ProjectItem *projectItem = [self.projectArray objectAtIndex:i];
        if ([[projectItem name] isEqualToString:name]) {
            NSLog(@"Project Item: %@", [projectItem rowID]);
            
            return [projectItem rowID];
        }
    }
    
    return nil;
}

/**
 *  Searches the Project Manager array for the name
 *
 *  @param name The name of the Project Manager
 *
 *  @return The rowID of the Project Manager
 */
-(NSNumber *)rowIDOfProjectManagerFromName:(NSString *)name {
    for (int i = 0; i < [self.projectManagerArray count]; i++) {
        Person *person = [self.projectManagerArray objectAtIndex:i];
        if ([[person name] isEqualToString:name]) {
            NSLog(@"Manager: %@", [person idNumber]);
            
            return [person idNumber];
        }
    }
    
    return nil;
}

/**
 *  Searches the Project Supervisor array for the name
 *
 *  @param name The name of the Project Supervisor
 *
 *  @return The rowID of the Project Supervisor
 */
-(NSNumber *)rowIDOfProjectSupervisorFromName:(NSString *)name {
    for (int i = 0; i < [self.projectSupervisorArray count]; i++) {
        Person *person = [self.projectSupervisorArray objectAtIndex:i];
        if ([[person name] isEqualToString:name]) {
            NSLog(@"Supervisor: %@", [person idNumber]);
            
            return [person idNumber];
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
            NSLog(@"Project Stage: %@", [stage rowID]);
            
            return [stage rowID];
        }
    }
    
    return nil;
}

/**
 *  Searches the Project Status array for the name
 *
 *  @param name The name of the Project Status
 *
 *  @return The rowID of the Project Status
 */
-(NSNumber *)rowIDOfProjectStatusFromName:(NSString *)name {
    for (int i = 0; i < [self.projectStatusArray count]; i++) {
        ProjectStatus *status = [self.projectStatusArray objectAtIndex:i];
        if ([[status name] isEqualToString:name]) {
            NSLog(@"Project Status: %@", [status rowID]);
            
            return [status rowID];
        }
    }
    
    return nil;
}

/**
 *  Searches the Project Type array for the name
 *
 *  @param name The name of the Project Type
 *
 *  @return The rowID of the Project Type
 */
-(NSNumber *)rowIDOfProjectTypeFromName:(NSString *)name {
    for (int i = 0; i < [self.projectTypeArray count]; i++) {
        ProjectType *type = [self.projectTypeArray objectAtIndex:i];
        if ([[type name] isEqualToString:name]) {
            NSLog(@"Project Type: %@", [type rowID]);
            
            return [type rowID];
        }
    }
    
    return nil;
}

#pragma mark - Existing Project Methods

/**
 *  Given a projectID, get the information of a project to show for a user to view/edit
 */
-(void)getProjectInformationFromDatabase {
    [database connectToDatabase];
    self.projectInformation = [database fetchProjectInformationForID:self.projectID];
    database.databaseConnection = nil;
}

@end
