//
//  DatabaseConnector.m
//  MillerConstruction
//
//  Created by David Brooks on 3/15/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import "DatabaseConnector.h"
#import "iPhoneMySQL/MysqlServer.h"
#import "iPhoneMySQL/MysqlFetch.h"
#import "iPhoneMySQL/MysqlInsert.h"
#import "iPhoneMySQL/MysqlUpdate.h"

#define DB_HOST @"50.253.23.2"
#define DB_USERNAME @"appconnection"
#define DB_PASSWORD @"shouldchangethis"
#define DB_SCHEMA @"testdb"
//TODO: REMOVE DB_TEST_SCHEMA
#define DB_TEST_SCHEMA @"ipadtestdatabase"

@implementation DatabaseConnector

#pragma mark - Singleton Methods

+(id)sharedDatabaseConnector {
    static DatabaseConnector * sharedDatabaseConnector = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDatabaseConnector = [[self alloc] init];
    });
    
    return sharedDatabaseConnector;
}

-(id)init {
    if (self = [super init]) {
        // Configure init
        [self connectToDatabase];
    }
    
    return self;
}

#pragma mark - Database Connection

/**
 *  Connects to the database
 *
 *  @return true if the connection was successful, false otherwise
 */
-(BOOL)connectToDatabase {
    //TODO: SET SCHEMA BACK TO PRODUCTION
    MysqlServer *server = [[MysqlServer alloc] initWithHost:DB_HOST andUser:DB_USERNAME andPassword:DB_PASSWORD andSchema:DB_TEST_SCHEMA];
    self.databaseConnection = [MysqlConnection connectToServer:server];
    if (self.databaseConnection == nil) {
        NSLog(@"Failed to connect to the database");
        
        return false;
    } else {
        NSLog(@"Connected to the database");
        
        return true;
    }
}

#pragma mark - Fetch MySQL

/**
 *  Helper method that takes care of ending and recreating a database connection. Performs the fetch of the database
 *
 *  @param command NSString * of fetch command
 *
 *  @return MysqlFetch * that contains the results of the fetch
 */
-(MysqlFetch *)fetchWithCommand:(NSString *)command {
    //[self connectToDatabase];
    MysqlFetch *fetch = [MysqlFetch fetchWithCommand:command onConnection:self.databaseConnection];
    //self.databaseConnection = nil;
    
    return fetch;
}

/**
 *  Helper method that takes care of ending and recreating a database connection. Performs the insert of the database
 *
 *  @param table   NSString * name of table to insert data into
 *  @param data    NSDictionary * object and key values to insert
 *
 *  @return MysqlInsert * that contains the results of the insert
 */
-(MysqlInsert *)insertIntoTable:(NSString *)table withData:(NSDictionary *)data {
    //[self connectToDatabase];
    MysqlInsert *insert = [MysqlInsert insertWithConnection:self.databaseConnection];
    [insert setTable:table];
    [insert setRowData:data];
    [insert execute];
    //self.databaseConnection = nil;
    
    return insert;
}

#pragma mark - Database User Login

/**
 *  Checks the registration of the User
 *
 *  @param user The User to be authenticated
 *
 *  @return UserLoginType of login result
 */
-(UserLoginType)loginUserToDatabase:(User *)user {
    [self connectToDatabase];
    NSString *usernameCommand = [NSString stringWithFormat:@"SELECT id FROM user WHERE name = \"%@\"", [user username]];
    MysqlFetch *checkUserInDatabase = [self fetchWithCommand:usernameCommand];
    if ([checkUserInDatabase.results count] == 0) {
        // User not in database
        self.databaseConnection = nil;
        
        return WrongUsername;
    } else {
        NSString *passwordCommand = [NSString stringWithFormat:@"SELECT password FROM user WHERE name = \"%@\"", [user username]];
        MysqlFetch *passwordFetch = [self fetchWithCommand:passwordCommand];
        NSString *userPassword = [[passwordFetch.results firstObject] objectForKey:@"password"];
        self.databaseConnection = nil;
        if (![user isPasswordEqual:userPassword]) {
            // Not equal
            return IncorrectPassword;
        } else {
            // Correct password, allow access
            return SuccessfulLogin;
        }
    }
}

#pragma mark - Database New Project Methods

/**
 *  Fetches the different project items from the database
 *
 *  @return NSArray * of the project itmes
 */
-(NSArray *)fetchProjectItem {
    NSString *projectTypesCommand = @"SELECT * FROM projectitem";
    MysqlFetch *getProjectTypes = [self fetchWithCommand:projectTypesCommand];
    
    return [getProjectTypes results];
}

/**
 *  Fetches the different warehouse information from the database
 *
 *  @return NSArray * of the warehouses
 */
-(NSArray *)fetchWarehouses {
    NSString *warehouseCommand = @"SELECT warehouse.id, warehouse.state, warehouse.warehouseID, city.name FROM warehouse, city WHERE warehouse.city_id = city.id";
    MysqlFetch *getWarehouses = [self fetchWithCommand:warehouseCommand];
    
    return [getWarehouses results];
}

/**
 *  Fetches the different project classifications from the database
 *
 *  @return NSArray * of the project classifications
 */
-(NSArray *)fetchProjectClassifications {
    NSString *projectClassificationCommand = @"SELECT * FROM projectclass";
    MysqlFetch *getProjectClassifications = [self fetchWithCommand:projectClassificationCommand];
    
    return [getProjectClassifications results];
}

/**
 *  Fetches the different people from the database
 *
 *  @return NSArray * of the people
 */
-(NSArray *)fetchProjectPeople {
    NSString *projectPeopleCommand = @"SELECT * FROM person";
    MysqlFetch *getProjectPeople = [self fetchWithCommand:projectPeopleCommand];
    
    return [getProjectPeople results];
}

/**
 *  Fetches the different project stages from the database
 *
 *  @return NSArray * of the project stages
 */
-(NSArray *)fetchProjectStage {
    NSString *projectStageCommand = @"SELECT * FROM projectstage";
    MysqlFetch *getProjectStage = [self fetchWithCommand:projectStageCommand];
    
    return [getProjectStage results];
}

/**
 *  Fetches the different project status from the database
 *
 *  @return NSArray * of the project status
 */
-(NSArray *)fetchProjectStatus {
    NSString *projectStatusCommand = @"SELECT * FROM projectstatus";
    MysqlFetch *getProjectStatus = [self fetchWithCommand:projectStatusCommand];
    
    return [getProjectStatus results];
}

/**
 *  Fetches the different project types from the database
 *
 *  @return NSArray * of the project types
 */
-(NSArray *)fetchProjectType {
    NSString *projectTypeCommand = @"SELECT * FROM projecttype";
    MysqlFetch *getProjectType = [self fetchWithCommand:projectTypeCommand];
    
    return [getProjectType results];
}

/**
 *  Inserts a new project into the database
 *
 *  @param projectInformation The information associated with the project
 *  @param keys               The MySQL keys the data will be inserted under
 *
 *  @return true if successful insertion, false otherwise
 */
-(BOOL)addNewProject:(NSArray *)projectInformation andKeys:(NSArray *)keys {
    NSLog(@"projectInformation: %@", projectInformation);
    NSLog(@"keys: %@", keys);
    NSMutableDictionary *insertDictionary = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < [projectInformation count]; i++) {
        NSString *value = [projectInformation objectAtIndex:i];
        NSString *valueKey = [keys objectAtIndex:i];
        if ([valueKey isEqualToString:@""]) {
            // Do nothing, does not involve the project table
        } else {
            NSDictionary *subDictionary = [NSDictionary dictionaryWithObject:value forKey:valueKey];
            [insertDictionary addEntriesFromDictionary:subDictionary];
        }
    }
    MysqlInsert *insertCommand = [self insertIntoTable:@"project" withData:[insertDictionary copy]];
    NSNumber *projectRowID = [insertCommand rowid];
    NSNumber *affectedRows = [insertCommand affectedRows];
    if (affectedRows > 0) {
        NSLog(@"Success project table");
        // Success, add other data to tables
        NSDictionary *managerDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [projectInformation objectAtIndex:4], @"id",
                                    projectRowID, @"project_id",
                                    nil];
        insertCommand = [self insertIntoTable:@"project_managers" withData:managerDictionary];
        affectedRows = [insertCommand affectedRows];
        if (affectedRows > 0) {
            NSLog(@"Success manager table");
            // Success, add other data to tables
            NSDictionary *supervisorsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [projectInformation objectAtIndex:5], @"id",
                                        projectRowID, @"project_id",
                                        nil];
            insertCommand = [self insertIntoTable:@"project_supervisors" withData:supervisorsDictionary];
            affectedRows = [insertCommand affectedRows];
            if (affectedRows > 0) {
                NSLog(@"Success supervisor table");
                // Success, add other data to tables;
                [insertDictionary removeAllObjects];
                NSDictionary *salvageDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   [projectInformation objectAtIndex:25], @"date",
                                                   [projectInformation objectAtIndex:26], @"value",
                                                   nil];
                insertCommand = [self insertIntoTable:@"salvagevalue" withData:salvageDictionary];
                NSNumber *salvageRowID = [insertCommand rowid];
                affectedRows = [insertCommand affectedRows];
                if (affectedRows > 0) {
                    NSLog(@"Success salvagevalue table");
                    NSDictionary *closeoutDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                [projectInformation objectAtIndex:14], @"asBuilts",
                                                [projectInformation objectAtIndex:15], @"punchList",
                                                [projectInformation objectAtIndex:16], @"alarmHvacForm",
                                                [projectInformation objectAtIndex:17], @"verisaeShutdownReport",
                                                [projectInformation objectAtIndex:18], @"closeoutNotes",
                                                [projectInformation objectAtIndex:22], @"airGas",
                                                [projectInformation objectAtIndex:24], @"permitsClosed",
                                                salvageRowID, @"salvageValue_id",
                                                nil];
                    insertCommand = [self insertIntoTable:@"closeoutdetails" withData:closeoutDictionary];
                    NSNumber *closeoutdetailsRowID = [insertCommand rowid];
                    affectedRows = [insertCommand affectedRows];
                    if (affectedRows > 0) {
                        NSLog(@"Success closeout table");
                        MysqlUpdate *update = [MysqlUpdate updateWithConnection:self.databaseConnection];
                        [update setTable:@"project"];
                        [update setQualifier:[NSDictionary dictionaryWithObject:projectRowID forKey:@"id"]];
                        [update setRowData:[NSDictionary dictionaryWithObject:closeoutdetailsRowID forKey:@"closeoutDetails_id"]];
                        [update execute];
                        affectedRows = [update affectedRows];
                        if (affectedRows > 0) {
                            // Final success
                            NSLog(@"Success save!");
                            
                            return true;
                        } else {
                            // Final failure
                            NSLog(@"Failed project update!");
                            
                            return false;
                        }
                    } else {
                        // Closeout Failure
                        NSLog(@"Failed closeout");
                        
                        return false;
                    }
                } else {
                    // Salvage Failure
                    NSLog(@"Failed salvage");
                    
                    return false;
                }
            } else {
                // Supervisors Failure
                NSLog(@"Failed supervisors");
                
                return false;
            }
        } else {
            // Managers Failure
            NSLog(@"Failed managers");
            
            return false;
        }
    } else {
        // Project Failure
        NSLog(@"Failed project");
        
        return false;
    }
}

#pragma mark - View Existing Project

/**
 *  Fetches the projects matching the warehouse id and stage id
 *
 *  @param warehouseID    The id of the warehouse
 *  @param projectStageID The id of the project stage
 *
 *  @return NSArray * of NSDictionaries with the projectitem.name and project.id
 */
-(NSArray *)fetchProjectsWithWarehouseID:(NSNumber *)warehouseID andProjectStageID:(NSNumber *)projectStageID {
    NSString *fetchCommand = [NSString stringWithFormat:@"SELECT projectitem.name, project.id FROM project, projectitem WHERE project.warehouse_id = %d AND project.stage_id = %d AND project.projectItem_id = projectitem.id", [warehouseID intValue], [projectStageID intValue]];
    NSLog(@"fetchCommand: %@", fetchCommand);
    MysqlFetch *fetch = [self fetchWithCommand:fetchCommand];
    NSLog(@"%@", [fetch results]);
    
    return [fetch results];
}

-(NSArray *)fetchProjectInformationForID:(NSNumber *)projectID {
    // Required Information
    NSMutableArray *projectInfo = [[NSMutableArray alloc] init];
    NSString *requiredInfoFetch = [NSString stringWithFormat:@"SELECT project.mcsNumber, warehouse.state, warehouse.warehouseID, city.name, projectclass.name, projectitem.name, projectstage.name, projectstatus.name, projecttype.name, project.scope FROM project, warehouse, city, projectclass, projectitem, projectstage, projectstatus, projecttype WHERE project.id = %d AND project.id = warehouse.id AND warehouse.city_id = city.id AND project.projectClass_id = projectclass.id AND project.projectItem_id = projectitem.id AND project.stage_id = projectstage.id AND project.status_id = projectstatus.id AND project.projectType_id = projecttype.id", [projectID intValue]];
    NSLog(@"requiredInfoFetch: %@", requiredInfoFetch);
    MysqlFetch *fetch = [self fetchWithCommand:requiredInfoFetch];
    NSLog(@"%@", [fetch results]);
    NSArray *requiredInfo = [fetch results];
    [projectInfo addObject:[requiredInfo valueForKey:@"mcsNumber"]];
    [projectInfo addObject:[NSString stringWithFormat:@"%@, %@ -- #%@", [requiredInfo valueForKey:@"city.name"], [requiredInfo valueForKey:@"warehouse.state"], [requiredInfo valueForKey:@"warehouse.warehouseID"]]];
    [projectInfo addObject:[requiredInfo valueForKey:@"projectclass.name"]];
    [projectInfo addObject:[requiredInfo valueForKey:@"projectitem.name"]];
    
    NSString *managerFetch = [NSString stringWithFormat:@"SELECT person.name FROM person, project_managers WHERE project_managers.project_id = %d AND project_managers.id = person.id", [projectID intValue]];
    NSLog(@"managerFetch: %@", managerFetch);
    fetch = [self fetchWithCommand:managerFetch];
    NSLog(@"%@", [fetch results]);
    [projectInfo addObject:[[fetch results] valueForKey:@"name"]];
    
    NSString *supervisorFetch = [NSString stringWithFormat:@"SELECT person.name FROM person, project_supervisors WHERE project_supervisors.project_id = %d AND project_supervisors.id = person.id", [projectID intValue]];
    NSLog(@"supervisorFetch: %@", supervisorFetch);
    fetch = [self fetchWithCommand:supervisorFetch];
    NSLog(@"%@", [fetch results]);
    [projectInfo addObject:[[fetch results] valueForKey:@"name"]];
    [projectInfo addObject:[requiredInfo valueForKey:@"projectstage.name"]];
    [projectInfo addObject:[requiredInfo valueForKey:@"projectstatus.name"]];
    [projectInfo addObject:[requiredInfo valueForKey:@"projecttype.name"]];
    [projectInfo addObject:[requiredInfo valueForKey:@"project.scope"]];
    
    // Optional Information
    NSString *optionalInfoFetch = [NSString stringWithFormat:@"SELECT project.projectInitiatedDate, project.siteSurvey, project.costcoDueDate, project.proposalSubmitted, closeoutdetails.asBuilts, closeoutdetails.punchList, closeoutdetails.alarmHvacForm, closeoutdetails.verisaeShutdownReport, closeoutdetails.closeoutNotes, project.scheduledStartDate, project.scheduledTurnover, closeoutdetails.airGas, project.permitApplication, closeoutdetails.permitsClosed, project.shouldInvoice, project.invoiced, project.projectNotes, project.zachUpdates, project.cost, project.customerNumber FROM project, closeoutdetails WHERE project.id = %d AND project.closeoutDetails_id = closeoutdetails.id", [projectID intValue]];
    // Does not include salvage, need to do that next
    
    return projectInfo;
}

#pragma mark - View Triggers

/**
 *  Retreives all the projects with an MCS Number of -1
 *
 *  @return Array of Dictionaries with the project info
 */
-(NSArray *)fetchInfoMCSNumberTriggers {
    NSString *fetchCommand = [NSString stringWithFormat:@"SELECT DISTINCTROW project.mcsNumber, city.name, projectitem.name, project.id FROM project, warehouse, projectitem, city WHERE project.mcsNumber = -1 AND project.warehouse_id = warehouse.id AND warehouse.city_id = city.id AND project.projectItem_id = projectitem.id AND project.stage_id = 2"];
    MysqlFetch *fetch = [self fetchWithCommand:fetchCommand];
    NSLog(@"%@", [fetch results]);
    
    return [fetch results];
}

/**
 *  Retreives all the projects with no assigned Costco Due Date
 *
 *  @return Array of Dictionaries with the project info
 */
-(NSArray *)fetchInfoCostcoTriggers {
    NSString *fetchCommand = [NSString stringWithFormat:@"SELECT DISTINCTROW project.mcsNumber, city.name, projectitem.name, project.id FROM project, warehouse, projectitem, city WHERE project.costcoDueDate IS NULL AND project.mcsNumber != -1 AND project.warehouse_id = warehouse.id AND warehouse.city_id = city.id AND project.projectItem_id = projectitem.id AND project.stage_id = 2"];
    MysqlFetch *fetch = [self fetchWithCommand:fetchCommand];
    NSLog(@"%@", [fetch results]);
    
    return [fetch results];
}

/**
 *  Retreives all the projects with no assigned Turn Over Date
 *
 *  @return Array of Dictionaries with the project info
 */
-(NSArray *)fetchInfoTurnOverTriggers {
    NSString *fetchCommand = [NSString stringWithFormat:@"SELECT DISTINCTROW project.mcsNumber, city.name, projectitem.name, project.id FROM project, warehouse, projectitem, city WHERE project.scheduledTurnover IS NULL AND project.mcsNumber != -1 AND project.warehouse_id = warehouse.id AND warehouse.city_id = city.id AND project.projectItem_id = projectitem.id AND project.stage_id = 2"];
    MysqlFetch *fetch = [self fetchWithCommand:fetchCommand];
    NSLog(@"%@", [fetch results]);
    
    return [fetch results];
}

/**
 *  Retreives all the projects with a Scheduled Start Date within the next two weeks
 *
 *  @return Array of Dictionaries with the project info
 */
-(NSArray *)fetchInfoProjectStartingSoonTriggers {
    NSString *fetchCommand = [NSString stringWithFormat:@"SELECT DISTINCTROW project.mcsNumber, city.name, projectitem.name, project.id, project.scheduledStartDate FROM project, warehouse, projectitem, city WHERE project.scheduledStartDate >= curdate() AND project.scheduledStartDate <= date_add(curdate(), INTERVAL 14 DAY) AND project.mcsNumber != -1 AND project.warehouse_id = warehouse.id AND warehouse.city_id = city.id AND project.projectItem_id = projectitem.id AND project.stage_id = 2"];
    MysqlFetch *fetch = [self fetchWithCommand:fetchCommand];
    NSLog(@"%@", [fetch results]);
    
    return [fetch results];
}

/**
 *  Retreives all the projects with mismatched Invoiced amounts
 *
 *  @return Array of Dictionaries with the project info
 */
-(NSArray *)fetchWarningInvoiceTriggers {
    NSString *fetchCommand = [NSString stringWithFormat:@"SELECT DISTINCTROW project.mcsNumber, city.name, projectitem.name, project.id FROM project, warehouse, projectitem, city WHERE project.shouldInvoice != project.invoiced AND project.warehouse_id = warehouse.id AND warehouse.city_id = city.id AND project.projectItem_id = projectitem.id AND project.stage_id = 2"];
    MysqlFetch *fetch = [self fetchWithCommand:fetchCommand];
    NSLog(@"%@", [fetch results]);
    
    return [fetch results];
}

/**
 *  Retreives all the projects with a Scheduled Start Date within the next one week
 *
 *  @return Array of Dictionaries with the project info
 */
-(NSArray *)fetchWarningProjectStartingSoonTriggers {
    NSString *fetchCommand = [NSString stringWithFormat:@"SELECT DISTINCTROW project.mcsNumber, city.name, projectitem.name, project.id, project.scheduledStartDate FROM project, warehouse, projectitem, city WHERE project.scheduledStartDate >= curdate() AND project.scheduledStartDate <= date_add(curdate(), INTERVAL 7 DAY) AND project.mcsNumber != -1 AND project.warehouse_id = warehouse.id AND warehouse.city_id = city.id AND project.projectItem_id = projectitem.id AND project.stage_id = 2"];
    MysqlFetch *fetch = [self fetchWithCommand:fetchCommand];
    NSLog(@"%@", [fetch results]);
    
    return [fetch results];
}

/**
 *  Retreives all the projects with a Scheduled Turn Over Date within the next one day
 *
 *  @return Array of Dictionaries with the project info
 */
-(NSArray *)fetchSevereTriggers {
    NSString *fetchCommand = [NSString stringWithFormat:@"SELECT DISTINCTROW project.mcsNumber, city.name, projectitem.name, project.id, project.scheduledStartDate FROM project, warehouse, projectitem, city WHERE project.scheduledTurnover >= curdate() AND project.scheduledTurnover <= date_add(curdate(), INTERVAL 1 DAY) AND project.mcsNumber != -1 AND project.warehouse_id = warehouse.id AND warehouse.city_id = city.id AND project.projectItem_id = projectitem.id AND project.stage_id = 2"];
    MysqlFetch *fetch = [self fetchWithCommand:fetchCommand];
    NSLog(@"%@", [fetch results]);
    
    return [fetch results];
}

@end
