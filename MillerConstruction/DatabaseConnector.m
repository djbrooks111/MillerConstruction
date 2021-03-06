//
//  DatabaseConnector.m
//  MillerConstruction
//
//  Created by David Brooks on 3/15/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import "DatabaseConnector.h"
#import "iPhoneMySQL/MysqlServer.h"
#import "iPhoneMySQL/MysqlInsert.h"
#import "iPhoneMySQL/MysqlUpdate.h"

#define DB_HOST @"50.253.23.2"
#define DB_USERNAME @"appconnection"
#define DB_PASSWORD @"shouldchangethis"
#define DB_SCHEMA @"testdb"
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
    MysqlServer *server = [[MysqlServer alloc] initWithHost:DB_HOST andUser:DB_USERNAME andPassword:DB_PASSWORD andSchema:DB_SCHEMA];
    self.databaseConnection = [MysqlConnection connectToServer:server];
    if (self.databaseConnection == nil) {
        NSLog(@"Failed to connect to the database");
        
        return false;
    } else {
        NSLog(@"Connected to the database");
        
        return true;
    }
}

#pragma mark - MySQL

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
    NSString *requiredInfoFetch = [NSString stringWithFormat:@"SELECT project.mcsNumber, warehouse.state, warehouse.warehouseID, city.name, projectclass.name, projectitem.name, projectstage.name, projectstatus.name, projecttype.name, project.scope FROM project, warehouse, city, projectclass, projectitem, projectstage, projectstatus, projecttype WHERE project.id = %d AND project.warehouse_id = warehouse.id AND warehouse.city_id = city.id AND project.projectClass_id = projectclass.id AND project.projectItem_id = projectitem.id AND project.stage_id = projectstage.id AND project.status_id = projectstatus.id AND project.projectType_id = projecttype.id", [projectID intValue]];
    NSLog(@"requiredInfoFetch: %@", requiredInfoFetch);
    MysqlFetch *fetch = [self fetchWithCommand:requiredInfoFetch];
    NSLog(@"%@", [fetch results]);
    NSArray *requiredInfoArray = [fetch results];
    NSDictionary *requiredInfo = [requiredInfoArray firstObject];
    [projectInfo addObject:[requiredInfo valueForKey:@"mcsNumber"]];
    [projectInfo addObject:[NSString stringWithFormat:@"%@, %@ -- #%@", [requiredInfo valueForKey:@"city.name"], [requiredInfo valueForKey:@"warehouse.state"], [requiredInfo valueForKey:@"warehouse.warehouseID"]]];
    [projectInfo addObject:[requiredInfo valueForKey:@"projectclass.name"]];
    [projectInfo addObject:[requiredInfo valueForKey:@"projectitem.name"]];
    
    NSString *managerFetch = [NSString stringWithFormat:@"SELECT person.name FROM person, project_managers WHERE project_managers.project_id = %d AND project_managers.id = person.id", [projectID intValue]];
    NSLog(@"managerFetch: %@", managerFetch);
    fetch = [self fetchWithCommand:managerFetch];
    NSLog(@"%@", [fetch results]);
    [projectInfo addObject:[[[fetch results] firstObject] valueForKey:@"name"]];
    
    NSString *supervisorFetch = [NSString stringWithFormat:@"SELECT person.name FROM person, project_supervisors WHERE project_supervisors.project_id = %d AND project_supervisors.id = person.id", [projectID intValue]];
    NSLog(@"supervisorFetch: %@", supervisorFetch);
    fetch = [self fetchWithCommand:supervisorFetch];
    NSLog(@"%@", [fetch results]);
    [projectInfo addObject:[[[fetch results] firstObject] valueForKey:@"name"]];
    [projectInfo addObject:[requiredInfo valueForKey:@"projectstage.name"]];
    [projectInfo addObject:[requiredInfo valueForKey:@"projectstatus.name"]];
    [projectInfo addObject:[requiredInfo valueForKey:@"projecttype.name"]];
    [projectInfo addObject:[requiredInfo valueForKey:@"project.scope"]];
    
    // Optional Information
    NSString *optionalInfoFetch = [NSString stringWithFormat:@"SELECT project.projectInitiatedDate, project.siteSurvey, project.costcoDueDate, project.proposalSubmitted, closeoutdetails.asBuilts, closeoutdetails.punchList, closeoutdetails.alarmHvacForm, closeoutdetails.verisaeShutdownReport, closeoutdetails.closeoutNotes, project.scheduledStartDate, project.scheduledTurnover, project.actualTurnover, closeoutdetails.airGas, project.permitApplication, closeoutdetails.permitsClosed, project.shouldInvoice, project.invoiced, project.projectNotes, project.zachUpdates, project.cost, project.customerNumber FROM project, closeoutdetails WHERE project.id = %d AND project.closeoutDetails_id = closeoutdetails.id", [projectID intValue]];
    NSLog(@"optionalInfoFetch: %@", optionalInfoFetch);
    fetch = [self fetchWithCommand:optionalInfoFetch];
    NSLog(@"%@", [fetch results]);
    NSArray *optionalInfoArray = [fetch results];
    NSDictionary *optionalInfo = [optionalInfoArray firstObject];
    [projectInfo addObject:[optionalInfo valueForKey:@"projectInitiatedDate"]];
    [projectInfo addObject:[optionalInfo valueForKey:@"siteSurvey"]];
    [projectInfo addObject:[optionalInfo valueForKey:@"costcoDueDate"]];
    [projectInfo addObject:[optionalInfo valueForKey:@"proposalSubmitted"]];
    [projectInfo addObject:[optionalInfo valueForKey:@"closeoutdetails.asBuilts"]];
    [projectInfo addObject:[optionalInfo valueForKey:@"closeoutdetails.punchList"]];
    [projectInfo addObject:[optionalInfo valueForKey:@"closeoutdetails.alarmHvacForm"]];
    [projectInfo addObject:[optionalInfo valueForKey:@"closeoutdetails.verisaeShutdownReport"]];
    [projectInfo addObject:[optionalInfo valueForKey:@"closeoutdetails.closeoutNotes"]];
    [projectInfo addObject:[optionalInfo valueForKey:@"project.scheduledStartDate"]];
    [projectInfo addObject:[optionalInfo valueForKey:@"project.scheduledTurnover"]];
    [projectInfo addObject:[optionalInfo valueForKey:@"project.actualTurnover"]];
    [projectInfo addObject:[optionalInfo valueForKey:@"closeoutdetails.airGas"]];
    [projectInfo addObject:[optionalInfo valueForKey:@"project.permitApplication"]];
    [projectInfo addObject:[optionalInfo valueForKey:@"closeoutdetails.permitsClosed"]];
    
    NSString *salvageFetch = [NSString stringWithFormat:@"SELECT salvagevalue.date, salvagevalue.value FROM salvagevalue, project, closeoutdetails WHERE project.id = %d AND project.closeoutDetails_id = closeoutdetails.id AND closeoutdetails.salvageValue_id = salvagevalue.id", [projectID intValue]];
    NSLog(@"salvageFetch: %@", salvageFetch);
    fetch = [self fetchWithCommand:salvageFetch];
    NSLog(@"%@", [fetch results]);
    NSLog(@"%lu", (unsigned long)[[fetch results] count]);
    if ([[fetch results] count] == 0) {
        // No salvage info
        [projectInfo addObject:[NSNull null]];
        [projectInfo addObject:[NSNumber numberWithInt:0]];
    } else {
        [projectInfo addObject:[[[fetch results] firstObject] valueForKey:@"date"]];
        [projectInfo addObject:[[[fetch results] firstObject] valueForKey:@"value"]];
    }
    [projectInfo addObject:[optionalInfo valueForKey:@"project.shouldInvoice"]];
    [projectInfo addObject:[optionalInfo valueForKey:@"project.invoiced"]];
    [projectInfo addObject:[optionalInfo valueForKey:@"project.projectNotes"]];
    [projectInfo addObject:[optionalInfo valueForKey:@"project.zachUpdates"]];
    [projectInfo addObject:[optionalInfo valueForKey:@"project.cost"]];
    [projectInfo addObject:[optionalInfo valueForKey:@"project.customerNumber"]];
    
    return projectInfo;
}

-(BOOL)updateProjectWithID:(NSNumber *)projectID andData:(NSArray *)projectInformation andKeys:(NSArray *)keys andSalvageExists:(BOOL)salvageExists {
    @try {
        NSLog(@"projectInformation: %@", projectInformation);
        NSLog(@"keys: %@", keys);
        // Project Table
        NSMutableDictionary *updateDictionary = [[NSMutableDictionary alloc] init];
        for (int i = 0; i < [projectInformation count]; i++) {
            NSString *value = [projectInformation objectAtIndex:i];
            NSString *valueKey = [keys objectAtIndex:i];
            if ([valueKey isEqualToString:@""]) {
                // Do nothing, does not involve the project table
            } else {
                NSDictionary *subDictionary = [NSDictionary dictionaryWithObject:value forKey:valueKey];
                [updateDictionary addEntriesFromDictionary:subDictionary];
            }
        }
        MysqlUpdate *updateCommand = [MysqlUpdate updateWithConnection:self.databaseConnection];
        [updateCommand setTable:@"project"];
        [updateCommand setQualifier:[NSDictionary dictionaryWithObject:projectID forKey:@"id"]];
        [updateCommand setRowData:updateDictionary];
        [updateCommand execute];
        // Manager Table
        NSDictionary *managerDictionary = [NSDictionary dictionaryWithObject:[projectInformation objectAtIndex:4] forKey:@"id"];
        [updateCommand setTable:@"project_managers"];
        [updateCommand setQualifier:[NSDictionary dictionaryWithObject:projectID forKey:@"project_id"]];
        [updateCommand setRowData:managerDictionary];
        [updateCommand execute];
        // Supervisor Table
        NSDictionary *supervisorDictionary = [NSDictionary dictionaryWithObject:[projectInformation objectAtIndex:5] forKey:@"id"];
        [updateCommand setTable:@"project_supervisors"];
        [updateCommand setQualifier:[NSDictionary dictionaryWithObject:projectID forKey:@"project_id"]];
        [updateCommand setRowData:supervisorDictionary];
        [updateCommand execute];
        // Salvage Table
        if (salvageExists) {
            // Update table
            NSDictionary *salvageDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [projectInformation objectAtIndex:25], @"date",
                                               [projectInformation objectAtIndex:26], @"value",
                                               nil];
            NSString *fetchCommand = [NSString stringWithFormat:@"SELECT closeoutdetails.salvageValue_id FROM project, closeoutdetails WHERE project.id = %@ AND project.closeoutDetails_id = closeoutdetails.id", projectID];
            MysqlFetch *fetch = [self fetchWithCommand:fetchCommand];
            NSNumber *salvageID = [NSNumber numberWithInteger:[[[[fetch results] firstObject] objectForKey:@"salvageValue_id"] integerValue]];
            [updateCommand setTable:@"salvagevalue"];
            [updateCommand setQualifier:[NSDictionary dictionaryWithObject:salvageID forKey:@"id"]];
            [updateCommand setRowData:salvageDictionary];
            [updateCommand execute];
        } else {
            NSDictionary *salvageDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [projectInformation objectAtIndex:25], @"date",
                                               [projectInformation objectAtIndex:26], @"value",
                                               nil];
            MysqlInsert *insert = [self insertIntoTable:@"salvagevalue" withData:salvageDictionary];
            NSNumber *salvageRowID = [insert rowid];
            NSString *fetchCommand = [NSString stringWithFormat:@"SELECT closeoutDetails_id FROM project WHERE project.id = %@", projectID];
            MysqlFetch *fetch = [self fetchWithCommand:fetchCommand];
            NSNumber *closeoutID = [NSNumber numberWithInteger:[[[[fetch results] firstObject] objectForKey:@"closeoutDetails_id"] integerValue]];
            [updateCommand setTable:@"closeoutdetails"];
            [updateCommand setQualifier:[NSDictionary dictionaryWithObject:closeoutID forKey:@"id"]];
            [updateCommand setRowData:[NSDictionary dictionaryWithObject:salvageRowID forKey:@"salvageValue_id"]];
            [updateCommand execute];
        }
        // Closeoutdetails Table
        NSDictionary *closeoutDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [projectInformation objectAtIndex:14], @"asBuilts",
                                            [projectInformation objectAtIndex:15], @"punchList",
                                            [projectInformation objectAtIndex:16], @"alarmHvacForm",
                                            [projectInformation objectAtIndex:17], @"verisaeShutdownReport",
                                            [projectInformation objectAtIndex:18], @"closeoutNotes",
                                            [projectInformation objectAtIndex:22], @"airGas",
                                            [projectInformation objectAtIndex:24], @"permitsClosed",
                                            nil];
        NSString *fetchCommand = [NSString stringWithFormat:@"SELECT closeoutDetails_id FROM project WHERE project.id = %@", projectID];
        MysqlFetch *fetch = [self fetchWithCommand:fetchCommand];
        NSNumber *closeoutID = [NSNumber numberWithInteger:[[[[fetch results] firstObject] objectForKey:@"closeoutDetails_id"] integerValue]];
        [updateCommand setTable:@"closeoutdetails"];
        [updateCommand setQualifier:[NSDictionary dictionaryWithObject:closeoutID forKey:@"id"]];
        [updateCommand setRowData:closeoutDictionary];
        [updateCommand execute];
    }
    @catch (NSException *exception) {
        
        return FALSE;
    }
    
    return TRUE;
}

#pragma mark - Generate Report

-(NSArray *)fetchWeeklyReportWithReportType:(NSInteger)reportType {
    NSMutableArray *projects = [[NSMutableArray alloc] init];
    if (reportType == 0) {
        // Active
        NSString *fetchCommand = [NSString stringWithFormat:@"SELECT project.mcsNumber, projectstage.name, warehouse.warehouseID, warehouse.state, city.name, projectitem.name, project.scope, projectclass.name, warehouse.region, projectstatus.name, project.scheduledStartDate, project.scheduledTurnover, project.actualTurnover, projecttype.name, closeoutdetails.asBuilts, closeoutdetails.punchList, closeoutdetails.alarmHvacForm, closeoutdetails.airGas, closeoutdetails.permitsClosed, closeoutdetails.verisaeShutdownReport, project.invoiced, project.shouldInvoice, project.projectNotes FROM project, projectstage, warehouse, city, projectitem, projectclass, projectstatus, projecttype, closeoutdetails WHERE project.stage_id = projectstage.id AND projectstage.name = \"Active\" AND project.warehouse_id = warehouse.id AND warehouse.city_id = city.id AND project.projectItem_id = projectitem.id AND project.projectClass_id = projectclass.id AND project.status_id = projectstatus.id AND project.projectType_id = projecttype.id AND project.closeoutDetails_id = closeoutdetails.id"];
        MysqlFetch *fetch = [self fetchWithCommand:fetchCommand];
        NSArray *results = [[fetch results] copy];
        fetch = [self fetchWithCommand:@"SELECT person.name FROM person, project, project_managers, projectstage WHERE project.stage_id = projectstage.id AND projectstage.name = \"Active\" AND project.id = project_managers.project_id AND project_managers.id = person.id"];
        NSArray *managers = [[fetch results] copy];
        fetch = [self fetchWithCommand:@"SELECT person.name FROM person, project, project_supervisors, projectstage WHERE project.stage_id = projectstage.id AND projectstage.name = \"Active\" AND project.id = project_supervisors.project_id AND project_supervisors.id = person.id"];
        NSArray *supervisors = [[fetch results] copy];
        for (int i = 0; i < [results count]; i++) {
            NSMutableArray *projectArray = [[NSMutableArray alloc] init];
            NSDictionary *project = [results objectAtIndex:i];
            [projectArray addObject:[project valueForKey:@"mcsNumber"]];
            [projectArray addObject:[project valueForKey:@"projectstage.name"]];
            [projectArray addObject:[NSString stringWithFormat:@"%@, %@-#%@", [project valueForKey:@"city.name"], [project valueForKey:@"warehouse.state"], [project valueForKey:@"warehouse.warehouseID"]]];
            [projectArray addObject:[project valueForKey:@"projectitem.name"]];
            [projectArray addObject:[project valueForKey:@"project.scope"]];
            [projectArray addObject:[project valueForKey:@"projectclass.name"]];
            [projectArray addObject:[[managers objectAtIndex:i] valueForKey:@"name"]];
            [projectArray addObject:[[supervisors objectAtIndex:i] valueForKey:@"name"]];
            [projectArray addObject:[project valueForKey:@"warehouse.region"]];
            [projectArray addObject:[project valueForKey:@"projectstatus.name"]];
            [projectArray addObject:[project valueForKey:@"project.scheduledStartDate"]];
            [projectArray addObject:[project valueForKey:@"project.scheduledTurnover"]];
            [projectArray addObject:[project valueForKey:@"project.actualTurnover"]];
            [projectArray addObject:[project valueForKey:@"projecttype.name"]];
            [projectArray addObject:[project valueForKey:@"closeoutdetails.asBuilts"]];
            [projectArray addObject:[project valueForKey:@"closeoutdetails.punchList"]];
            [projectArray addObject:[project valueForKey:@"closeoutdetails.alarmHvacForm"]];
            [projectArray addObject:[project valueForKey:@"closeoutdetails.airGas"]];
            [projectArray addObject:[project valueForKey:@"closeoutdetails.permitsClosed"]];
            [projectArray addObject:[project valueForKey:@"closeoutdetails.verisaeShutdownReport"]];
            [projectArray addObject:[project valueForKey:@"project.invoiced"]];
            [projectArray addObject:[project valueForKey:@"project.shouldInvoice"]];
            [projectArray addObject:[project valueForKey:@"project.projectNotes"]];
            [projects addObject:projectArray];
        }
    } else if (reportType == 1) {
        // Proposal
        NSString *fetchCommand = [NSString stringWithFormat:@"SELECT projectstage.name, warehouse.warehouseID, warehouse.state, city.name, projectitem.name, project.scope, projectclass.name, warehouse.region, projectstatus.name, project.projectInitiatedDate, project.siteSurvey, project.costcoDueDate, project.proposalSubmitted, projecttype.name, project.projectNotes FROM projectstage, warehouse, city, project, projectitem, projectclass, projectstatus, projecttype WHERE projectstage.name = \"Proposal\" AND projectstage.id = project.stage_id AND project.warehouse_id = warehouse.id AND warehouse.city_id = city.id AND project.projectItem_id = projectitem.id AND project.projectClass_id = projectclass.id AND project.status_id = projectstatus.id AND project.projectType_id = projecttype.id"];
        MysqlFetch *fetch = [self fetchWithCommand:fetchCommand];
        NSArray *results = [[fetch results] copy];
        fetch = [self fetchWithCommand:@"SELECT person.name FROM person, project, project_managers, projectstage WHERE project.stage_id = projectstage.id AND projectstage.name = \"Proposal\" AND project.id = project_managers.project_id AND project_managers.id = person.id"];
        NSArray *managers = [[fetch results] copy];
        fetch = [self fetchWithCommand:@"SELECT person.name FROM person, project, project_supervisors, projectstage WHERE project.stage_id = projectstage.id AND projectstage.name = \"Proposal\" AND project.id = project_supervisors.project_id AND project_supervisors.id = person.id"];
        NSArray *supervisors = [[fetch results] copy];
        for (int i = 0; i < [results count]; i++) {
            NSMutableArray *projectArray = [[NSMutableArray alloc] init];
            NSDictionary *project = [results objectAtIndex:i];
            [projectArray addObject:[project valueForKey:@"name"]];
            [projectArray addObject:[NSString stringWithFormat:@"%@, %@-#%@", [project valueForKey:@"city.name"], [project valueForKey:@"warehouse.state"], [project valueForKey:@"warehouse.warehouseID"]]];
            [projectArray addObject:[project valueForKey:@"projectitem.name"]];
            [projectArray addObject:[project valueForKey:@"project.scope"]];
            [projectArray addObject:[project valueForKey:@"projectclass.name"]];
            [projectArray addObject:[[managers objectAtIndex:i] valueForKey:@"name"]];
            [projectArray addObject:[[supervisors objectAtIndex:i] valueForKey:@"name"]];
            [projectArray addObject:[project valueForKey:@"warehouse.region"]];
            [projectArray addObject:[project valueForKey:@"projectstatus.name"]];
            [projectArray addObject:[project valueForKey:@"project.projectInitiatedDate"]];
            [projectArray addObject:[project valueForKey:@"project.siteSurvey"]];
            [projectArray addObject:[project valueForKey:@"project.costcoDueDate"]];
            [projectArray addObject:[project valueForKey:@"project.proposalSubmitted"]];
            [projectArray addObject:[project valueForKey:@"projecttype.name"]];
            [projectArray addObject:[project valueForKey:@"project.projectNotes"]];
            [projects addObject:projectArray];
        }
    } else if (reportType == 2) {
        // Budgetary
        NSString *fetchCommand = [NSString stringWithFormat:@"SELECT projectstage.name, warehouse.warehouseID, warehouse.state, city.name, projectitem.name, project.scope, projectclass.name, warehouse.region, projectstatus.name, project.projectInitiatedDate, project.siteSurvey, project.costcoDueDate, project.proposalSubmitted, projecttype.name, project.projectNotes FROM projectstage, warehouse, city, project, projectitem, projectclass, projectstatus, projecttype WHERE projectstage.name = \"Budgetary\" AND projectstage.id = project.stage_id AND project.warehouse_id = warehouse.id AND warehouse.city_id = city.id AND project.projectItem_id = projectitem.id AND project.projectClass_id = projectclass.id AND project.status_id = projectstatus.id AND project.projectType_id = projecttype.id"];
        MysqlFetch *fetch = [self fetchWithCommand:fetchCommand];
        NSArray *results = [[fetch results] copy];
        fetch = [self fetchWithCommand:@"SELECT person.name FROM person, project, project_managers, projectstage WHERE project.stage_id = projectstage.id AND projectstage.name = \"Budgetary\" AND project.id = project_managers.project_id AND project_managers.id = person.id"];
        NSArray *managers = [[fetch results] copy];
        fetch = [self fetchWithCommand:@"SELECT person.name FROM person, project, project_supervisors, projectstage WHERE project.stage_id = projectstage.id AND projectstage.name = \"Budgetary\" AND project.id = project_supervisors.project_id AND project_supervisors.id = person.id"];
        NSArray *supervisors = [[fetch results] copy];
        for (int i = 0; i < [results count]; i++) {
            NSMutableArray *projectArray = [[NSMutableArray alloc] init];
            NSDictionary *project = [results objectAtIndex:i];
            [projectArray addObject:[project valueForKey:@"name"]];
            [projectArray addObject:[NSString stringWithFormat:@"%@, %@-#%@", [project valueForKey:@"city.name"], [project valueForKey:@"warehouse.state"], [project valueForKey:@"warehouse.warehouseID"]]];
            [projectArray addObject:[project valueForKey:@"projectitem.name"]];
            [projectArray addObject:[project valueForKey:@"project.scope"]];
            [projectArray addObject:[project valueForKey:@"projectclass.name"]];
            [projectArray addObject:[[managers objectAtIndex:i] valueForKey:@"name"]];
            [projectArray addObject:[[supervisors objectAtIndex:i] valueForKey:@"name"]];
            [projectArray addObject:[project valueForKey:@"warehouse.region"]];
            [projectArray addObject:[project valueForKey:@"projectstatus.name"]];
            [projectArray addObject:[project valueForKey:@"project.projectInitiatedDate"]];
            [projectArray addObject:[project valueForKey:@"project.siteSurvey"]];
            [projectArray addObject:[project valueForKey:@"project.costcoDueDate"]];
            [projectArray addObject:[project valueForKey:@"project.proposalSubmitted"]];
            [projectArray addObject:[project valueForKey:@"projecttype.name"]];
            [projectArray addObject:[project valueForKey:@"project.projectNotes"]];
            [projects addObject:projectArray];
        }
    } else if (reportType == 3) {
        // Inactive
        NSString *fetchCommand = [NSString stringWithFormat:@"SELECT projectstage.name, projectitem.name, project.scope, projectstatus.name FROM projectstage, projectitem, project, projectstatus WHERE projectstage.name = \"Inactive\" AND projectstage.id = project.stage_id AND project.projectItem_id = projectitem.id AND project.status_id = projectstatus.id"];
        MysqlFetch *fetch = [self fetchWithCommand:fetchCommand];
        for (int i = 0; i < [[fetch results] count]; i++) {
            NSMutableArray *projectArray = [[NSMutableArray alloc] init];
            NSDictionary *project = [[fetch results] objectAtIndex:i];
            [projectArray addObject:[project valueForKey:@"name"]];
            [projectArray addObject:[project valueForKey:@"projectitem.name"]];
            [projectArray addObject:[project valueForKey:@"project.scope"]];
            [projectArray addObject:[project valueForKey:@"projectstatus.name"]];
            [projects addObject:projectArray];
        }
    } else if (reportType == 4) {
        // Closed
        NSString *fetchCommand = [NSString stringWithFormat:@"SELECT project.mcsNumber, projectstage.name, warehouse.warehouseID, warehouse.state, city.name, projectitem.name, project.scope, warehouse.region, projectstatus.name, project.projectInitiatedDate, projecttype.name, project.costcoDueDate, project.proposalSubmitted, project.scheduledStartDate, project.scheduledTurnover, closeoutdetails.asBuilts, closeoutdetails.punchList, closeoutdetails.alarmHvacForm, closeoutdetails.airGas, closeoutdetails.permitsClosed, project.shouldInvoice, project.invoiced, project.projectNotes FROM project, projectstage, warehouse, city, projectitem, projectstatus, projecttype, closeoutdetails WHERE projectstage.name = \"Closed\" AND projectstage.id = project.stage_id AND project.warehouse_id = warehouse.id AND warehouse.city_id = city.id AND project.projectItem_id = projectitem.id AND project.status_id = projectstatus.id AND project.projectType_id = projecttype.id AND project.closeoutDetails_id = closeoutdetails.id"];
        MysqlFetch *fetch = [self fetchWithCommand:fetchCommand];
        NSArray *results = [[fetch results] copy];
        fetch = [self fetchWithCommand:@"SELECT person.name FROM person, project, project_managers, projectstage WHERE project.stage_id = projectstage.id AND projectstage.name = \"Closed\" AND project.id = project_managers.project_id AND project_managers.id = person.id"];
        NSArray *managers = [[fetch results] copy];
        fetch = [self fetchWithCommand:@"SELECT person.name FROM person, project, project_supervisors, projectstage WHERE project.stage_id = projectstage.id AND projectstage.name = \"Closed\" AND project.id = project_supervisors.project_id AND project_supervisors.id = person.id"];
        NSArray *supervisors = [[fetch results] copy];
        for (int i = 0; i < [results count]; i++) {
            NSMutableArray *projectArray = [[NSMutableArray alloc] init];
            NSDictionary *project = [results objectAtIndex:i];
            [projectArray addObject:[project valueForKey:@"mcsNumber"]];
            [projectArray addObject:[project valueForKey:@"projectstage.name"]];
            [projectArray addObject:[NSString stringWithFormat:@"%@, %@-#%@", [project valueForKey:@"city.name"], [project valueForKey:@"warehouse.state"], [project valueForKey:@"warehouse.warehouseID"]]];
            [projectArray addObject:[project valueForKey:@"projectitem.name"]];
            [projectArray addObject:[project valueForKey:@"project.scope"]];
            [projectArray addObject:[[managers objectAtIndex:i] valueForKey:@"name"]];
            [projectArray addObject:[[supervisors objectAtIndex:i] valueForKey:@"name"]];
            [projectArray addObject:[project valueForKey:@"warehouse.region"]];
            [projectArray addObject:[project valueForKey:@"projectstatus.name"]];
            [projectArray addObject:[project valueForKey:@"project.projectInitiatedDate"]];
            [projectArray addObject:[project valueForKey:@"projecttype.name"]];
            [projectArray addObject:[project valueForKey:@"project.costcoDueDate"]];
            [projectArray addObject:[project valueForKey:@"project.proposalSubmitted"]];
            [projectArray addObject:[project valueForKey:@"project.scheduledStartDate"]];
            [projectArray addObject:[project valueForKey:@"project.scheduledTurnover"]];
            [projectArray addObject:[project valueForKey:@"closeoutdetails.asBuilts"]];
            [projectArray addObject:[project valueForKey:@"closeoutdetails.punchList"]];
            [projectArray addObject:[project valueForKey:@"closeoutdetails.alarmHvacForm"]];
            [projectArray addObject:[project valueForKey:@"closeoutdetails.airGas"]];
            [projectArray addObject:[project valueForKey:@"closeoutdetails.permitsClosed"]];
            [projectArray addObject:[project valueForKey:@"project.shouldInvoice"]];
            [projectArray addObject:[project valueForKey:@"project.invoiced"]];
            [projectArray addObject:[project valueForKey:@"project.projectNotes"]];
            [projects addObject:projectArray];
        }
    }
    
    return [projects copy];
}

-(NSArray *)fetchSteveMeyerReportWithReportType:(NSInteger)reportType {
    NSMutableArray *projects = [[NSMutableArray alloc] init];
    if (reportType == 0) {
        // Active
        NSString *fetchCommand = [NSString stringWithFormat:@"SELECT project.mcsNumber, warehouse.warehouseID, warehouse.state, city.name, projectitem.name, project.scope, projectclass.name, warehouse.region, projectstatus.name, project.scheduledStartDate, project.scheduledTurnover FROM project, warehouse, city, projectitem, projectclass, projectstatus, projectstage WHERE project.warehouse_id = warehouse.id AND warehouse.city_id = city.id AND project.projectItem_id = projectitem.id AND project.projectClass_id = projectclass.id AND project.status_id = projectstatus.id AND projectstage.name = \"Active\" AND projectstage.id = project.stage_id AND (project.status_id = 26 OR project.status_id = 29 OR project.status_id = 27 OR project.status_id = 31 OR project.status_id = 30) AND (project.projectType_id = 1 OR project.projectType_id = 5 OR project.projectType_id = 6)"];
        MysqlFetch *fetch = [self fetchWithCommand:fetchCommand];
        NSArray *results = [[fetch results] copy];
        fetch = [self fetchWithCommand:@"SELECT person.name FROM person, project, project_managers, projectstage WHERE projectstage.name = \"Active\" AND projectstage.id = project.stage_id AND (project.status_id = 26 OR project.status_id = 29 OR project.status_id = 27 OR project.status_id = 31 OR project.status_id = 30) AND (project.projectType_id = 1 OR project.projectType_id = 5 OR project.projectType_id = 6) AND project.id = project_managers.project_id AND project_managers.id = person.id"];
        NSArray *managers = [[fetch results] copy];
        fetch = [self fetchWithCommand:@"SELECT person.name FROM person, project, project_supervisors, projectstage WHERE projectstage.name = \"Active\" AND projectstage.id = project.stage_id AND (project.status_id = 26 OR project.status_id = 29 OR project.status_id = 27 OR project.status_id = 31 OR project.status_id = 30) AND (project.projectType_id = 1 OR project.projectType_id = 5 OR project.projectType_id = 6) AND project.id = project_supervisors.project_id AND project_supervisors.id = person.id"];
        NSArray *supervisors = [[fetch results] copy];
        for (int i = 0; i < [results count]; i++) {
            NSMutableArray *projectArray = [[NSMutableArray alloc] init];
            NSDictionary *project = [results objectAtIndex:i];
            [projectArray addObject:[project valueForKey:@"mcsNumber"]];
            [projectArray addObject:[NSString stringWithFormat:@"%@, %@-#%@", [project valueForKey:@"city.name"], [project valueForKey:@"warehouse.state"], [project valueForKey:@"warehouse.warehouseID"]]];
            [projectArray addObject:[project valueForKey:@"projectitem.name"]];
            [projectArray addObject:[project valueForKey:@"project.scope"]];
            [projectArray addObject:[project valueForKey:@"projectclass.name"]];
            [projectArray addObject:[[managers objectAtIndex:i] valueForKey:@"name"]];
            [projectArray addObject:[[supervisors objectAtIndex:i] valueForKey:@"name"]];
            [projectArray addObject:[project valueForKey:@"warehouse.region"]];
            [projectArray addObject:[project valueForKey:@"projectstatus.name"]];
            [projectArray addObject:[project valueForKey:@"project.scheduledStartDate"]];
            [projectArray addObject:[project valueForKey:@"project.scheduledTurnover"]];
            [projects addObject:projectArray];
        }
    } else {
        // Proposal
        NSString *fetchCommand = [NSString stringWithFormat:@"SELECT warehouse.region, projectitem.name, warehouse.state, warehouse.warehouseID, city.name, project.scope, projectclass.name, projectstatus.name, project.projectInitiatedDate, project.proposalSubmitted FROM warehouse, project, projectitem, city, projectclass, projectstatus, projectstage WHERE projectstage.name = \"Proposal\" AND projectstage.id = project.stage_id AND project.warehouse_id = warehouse.id AND project.projectItem_id = projectitem.id AND warehouse.city_id = city.id AND project.projectClass_id = projectclass.id AND project.status_id = projectstatus.id AND (warehouse.region = \"NE\" OR warehouse.region = \"SE\" OR warehouse.region = \"PR\") AND (project.projectType_id = 1 OR project.projectType_id = 6) AND (project.status_id = 1 OR project.status_id = 6 OR project.status_id = 3 OR project.status_id = 4 OR project.status_id = 12 OR project.status_id = 11 OR project.status_id = 14 OR project.status_id = 7 OR project.status_id = 22 OR project.status_id = 23 OR project.status_id = 20 OR project.status_id = 5)"];
        MysqlFetch *fetch = [self fetchWithCommand:fetchCommand];
        NSArray *results = [[fetch results] copy];
        fetch = [self fetchWithCommand:@"SELECT person.name FROM person, project, project_managers, projectstage, warehouse WHERE projectstage.name = \"Proposal\" AND projectstage.id = project.stage_id AND project.warehouse_id = warehouse.id AND (warehouse.region = \"NE\" OR warehouse.region = \"SE\" OR warehouse.region = \"PR\") AND (project.projectType_id = 1 OR project.projectType_id = 6) AND (project.status_id = 1 OR project.status_id = 6 OR project.status_id = 3 OR project.status_id = 4 OR project.status_id = 12 OR project.status_id = 11 OR project.status_id = 14 OR project.status_id = 7 OR project.status_id = 22 OR project.status_id = 23 OR project.status_id = 20 OR project.status_id = 5) AND project.id = project_managers.project_id AND project_managers.id = person.id"];
        NSArray *managers = [[fetch results] copy];
        fetch = [self fetchWithCommand:@"SELECT person.name FROM person, project, project_supervisors, projectstage, warehouse WHERE projectstage.name = \"Proposal\" AND projectstage.id = project.stage_id AND project.warehouse_id = warehouse.id AND (warehouse.region = \"NE\" OR warehouse.region = \"SE\" OR warehouse.region = \"PR\") AND (project.projectType_id = 1 OR project.projectType_id = 6) AND (project.status_id = 1 OR project.status_id = 6 OR project.status_id = 3 OR project.status_id = 4 OR project.status_id = 12 OR project.status_id = 11 OR project.status_id = 14 OR project.status_id = 7 OR project.status_id = 22 OR project.status_id = 23 OR project.status_id = 20 OR project.status_id = 5) AND project.id = project_supervisors.project_id AND project_supervisors.id = person.id"];
        NSArray *supervisors = [[fetch results] copy];
        for (int i = 0; i < [results count]; i++) {
            NSMutableArray *projectArray = [[NSMutableArray alloc] init];
            NSDictionary *project = [results objectAtIndex:i];
            [projectArray addObject:[project valueForKey:@"region"]];
            [projectArray addObject:[project valueForKey:@"projectitem.name"]];
            [projectArray addObject:[NSString stringWithFormat:@"%@, %@-#%@", [project valueForKey:@"city.name"], [project valueForKey:@"warehouse.state"], [project valueForKey:@"warehouse.warehouseID"]]];
            [projectArray addObject:[project valueForKey:@"project.scope"]];
            [projectArray addObject:[project valueForKey:@"projectclass.name"]];
            [projectArray addObject:[[managers objectAtIndex:i] valueForKey:@"name"]];
            [projectArray addObject:[[supervisors objectAtIndex:i] valueForKey:@"name"]];
            [projectArray addObject:[project valueForKey:@"projectstatus.name"]];
            [projectArray addObject:[project valueForKey:@"project.projectInitiatedDate"]];
            [projectArray addObject:[project valueForKey:@"project.proposalSubmitted"]];
            [projects addObject:projectArray];
        }
    }
    
    return [projects copy];
}

-(NSArray *)fetchSouthEastReportWithReportType:(NSInteger)reportType {
    NSMutableArray *projects = [[NSMutableArray alloc] init];
    if (reportType == 0) {
        // Active
        NSString *fetchCommand = [NSString stringWithFormat:@"SELECT warehouse.warehouseID, warehouse.state, city.name, projectitem.name, project.scope, warehouse.region, projectstatus.name, project.permitApplication, project.scheduledStartDate, project.scheduledTurnover, closeoutdetails.asBuilts, closeoutdetails.alarmHvacForm, project.projectNotes FROM warehouse, city, project, projectitem, projectstatus, closeoutdetails, projectstage WHERE project.warehouse_id = warehouse.id AND warehouse.city_id = city.id AND project.projectItem_id = projectitem.id AND project.status_id = projectstatus.id AND project.closeoutDetails_id = closeoutdetails.id AND project.stage_id = projectstage.id AND projectstage.name = \"Active\" AND (warehouse.region = \"PR\" OR warehouse.region = \"SE\") AND (project.projectType_id = 6 OR project.projectType_id = 7 OR project.projectType_id = 5)"];
        MysqlFetch *fetch = [self fetchWithCommand:fetchCommand];
        NSArray *results = [[fetch results] copy];
        for (int i = 0; i < [results count]; i++) {
            NSMutableArray *projectArray = [[NSMutableArray alloc] init];
            NSDictionary *project = [results objectAtIndex:i];
            [projectArray addObject:[NSString stringWithFormat:@"%@, %@-#%@", [project valueForKey:@"city.name"], [project valueForKey:@"state"], [project valueForKey:@"warehouseID"]]];
            [projectArray addObject:[project valueForKey:@"projectitem.name"]];
            [projectArray addObject:[project valueForKey:@"project.scope"]];
            [projectArray addObject:[project valueForKey:@"warehouse.region"]];
            [projectArray addObject:[project valueForKey:@"projectstatus.name"]];
            [projectArray addObject:[project valueForKey:@"project.scheduledStartDate"]];
            [projectArray addObject:[project valueForKey:@"project.scheduledTurnover"]];
            [projectArray addObject:[project valueForKey:@"closeoutdetails.asBuilts"]];
            [projectArray addObject:[project valueForKey:@"closeoutdetails.alarmHvacForm"]];
            [projectArray addObject:[project valueForKey:@"project.projectNotes"]];
            [projects addObject:projectArray];
        }
    } else {
        // Proposal
        NSString *fetchCommand = [NSString stringWithFormat:@"SELECT warehouse.warehouseID, warehouse.state, city.name, projectitem.name, project.scope, warehouse.region, projectstatus.name, project.permitApplication, project.projectInitiatedDate, project.costcoDueDate, project.proposalSubmitted, project.projectNotes FROM warehouse, city, project, projectitem, projectstatus, projectstage WHERE project.warehouse_id = warehouse.id AND warehouse.city_id = city.id AND project.projectItem_id = projectitem.id AND project.status_id = projectstatus.id AND project.stage_id = projectstage.id AND projectstage.name = \"Proposal\" AND (warehouse.region = \"PR\" OR warehouse.region = \"SE\") AND (project.projectType_id = 6 OR project.projectType_id = 7 OR project.projectType_id = 5)"];
        MysqlFetch *fetch = [self fetchWithCommand:fetchCommand];
        NSArray *results = [[fetch results] copy];
        for (int i = 0; i < [results count]; i++) {
            NSMutableArray *projectArray = [[NSMutableArray alloc] init];
            NSDictionary *project = [results objectAtIndex:i];
            [projectArray addObject:[NSString stringWithFormat:@"%@, %@-#%@", [project valueForKey:@"city.name"], [project valueForKey:@"state"], [project valueForKey:@"warehouseID"]]];
            [projectArray addObject:[project valueForKey:@"projectitem.name"]];
            [projectArray addObject:[project valueForKey:@"project.scope"]];
            [projectArray addObject:[project valueForKey:@"warehouse.region"]];
            [projectArray addObject:[project valueForKey:@"projectstatus.name"]];
            [projectArray addObject:[project valueForKey:@"project.permitApplication"]];
            [projectArray addObject:[project valueForKey:@"project.projectInitiatedDate"]];
            [projectArray addObject:[project valueForKey:@"project.costcoDueDate"]];
            [projectArray addObject:[project valueForKey:@"project.proposalSubmitted"]];
            [projectArray addObject:[project valueForKey:@"project.projectNotes"]];
            [projects addObject:projectArray];
        }
    }
    
    return [projects copy];
}

-(NSArray *)fetchNorthEastReportWithReportType:(NSInteger)reportType {
    NSMutableArray *projects = [[NSMutableArray alloc] init];
    if (reportType == 0) {
        // Active
        NSString *fetchCommand = [NSString stringWithFormat:@"SELECT warehouse.warehouseID, warehouse.state, city.name, projectitem.name, project.scope, warehouse.region, projectstatus.name, project.permitApplication, project.scheduledStartDate, project.scheduledTurnover, closeoutdetails.asBuilts, closeoutdetails.alarmHvacForm, project.projectNotes FROM warehouse, city, project, projectitem, projectstatus, closeoutdetails, projectstage WHERE project.warehouse_id = warehouse.id AND warehouse.city_id = city.id AND project.projectItem_id = projectitem.id AND project.status_id = projectstatus.id AND project.closeoutDetails_id = closeoutdetails.id AND project.stage_id = projectstage.id AND projectstage.name = \"Active\" AND warehouse.region = \"NE\" AND project.projectType_id = 6"];
        MysqlFetch *fetch = [self fetchWithCommand:fetchCommand];
        NSArray *results = [[fetch results] copy];
        for (int i = 0; i < [results count]; i++) {
            NSMutableArray *projectArray = [[NSMutableArray alloc] init];
            NSDictionary *project = [results objectAtIndex:i];
            [projectArray addObject:[NSString stringWithFormat:@"%@, %@-#%@", [project valueForKey:@"city.name"], [project valueForKey:@"state"], [project valueForKey:@"warehouseID"]]];
            [projectArray addObject:[project valueForKey:@"projectitem.name"]];
            [projectArray addObject:[project valueForKey:@"project.scope"]];
            [projectArray addObject:[project valueForKey:@"warehouse.region"]];
            [projectArray addObject:[project valueForKey:@"projectstatus.name"]];
            [projectArray addObject:[project valueForKey:@"project.permitApplication"]];
            [projectArray addObject:[project valueForKey:@"project.scheduledStartDate"]];
            [projectArray addObject:[project valueForKey:@"project.scheduledTurnover"]];
            [projectArray addObject:[project valueForKey:@"closeoutdetails.asBuilts"]];
            [projectArray addObject:[project valueForKey:@"closeoutdetails.alarmHvacForm"]];
            [projectArray addObject:[project valueForKey:@"project.projectNotes"]];
            [projects addObject:projectArray];
        }
    } else {
        // Proposal
        NSString *fetchCommand = [NSString stringWithFormat:@"SELECT warehouse.warehouseID, warehouse.state, city.name, projectitem.name, project.scope, warehouse.region, projectstatus.name, project.permitApplication, project.scheduledStartDate, project.scheduledTurnover, closeoutdetails.asBuilts, closeoutdetails.alarmHvacForm, project.projectNotes FROM warehouse, city, project, projectitem, projectstatus, closeoutdetails, projectstage WHERE project.warehouse_id = warehouse.id AND warehouse.city_id = city.id AND project.projectItem_id = projectitem.id AND project.status_id = projectstatus.id AND project.closeoutDetails_id = closeoutdetails.id AND project.stage_id = projectstage.id AND projectstage.name = \"Proposal\" AND warehouse.region = \"NE\" AND project.projectType_id = 6"];
        MysqlFetch *fetch = [self fetchWithCommand:fetchCommand];
        NSArray *results = [[fetch results] copy];
        for (int i = 0; i < [results count]; i++) {
            NSMutableArray *projectArray = [[NSMutableArray alloc] init];
            NSDictionary *project = [results objectAtIndex:i];
            [projectArray addObject:[NSString stringWithFormat:@"%@, %@-#%@", [project valueForKey:@"city.name"], [project valueForKey:@"state"], [project valueForKey:@"warehouseID"]]];
            [projectArray addObject:[project valueForKey:@"projectitem.name"]];
            [projectArray addObject:[project valueForKey:@"project.scope"]];
            [projectArray addObject:[project valueForKey:@"warehouse.region"]];
            [projectArray addObject:[project valueForKey:@"projectstatus.name"]];
            [projectArray addObject:[project valueForKey:@"project.permitApplication"]];
            [projectArray addObject:[project valueForKey:@"project.scheduledStartDate"]];
            [projectArray addObject:[project valueForKey:@"project.scheduledTurnover"]];
            [projectArray addObject:[project valueForKey:@"closeoutdetails.asBuilts"]];
            [projectArray addObject:[project valueForKey:@"closeoutdetails.alarmHvacForm"]];
            [projectArray addObject:[project valueForKey:@"project.projectNotes"]];
            [projects addObject:projectArray];
        }
    }
    
    return [projects copy];
}

-(NSArray *)fetchJDempseyReportWithReportType:(NSInteger)reportType {
    NSMutableArray *projects = [[NSMutableArray alloc] init];
    if (reportType == 0) {
        // Active
        NSString *fetchCommand = [NSString stringWithFormat:@"SELECT project.mcsNumber, warehouse.state, warehouse.warehouseID, city.name, projectitem.name, project.scope, projectclass.name, warehouse.region, projectstatus.name, project.scheduledStartDate, project.scheduledTurnover FROM project, warehouse, city, projectitem, projectclass, projectstatus, projectstage WHERE project.warehouse_id = warehouse.id AND warehouse.city_id = city.id AND project.projectItem_id = projectitem.id AND project.projectClass_id = projectclass.id AND project.status_id = projectstatus.id AND projectstage.name = \"Active\" AND projectstage.id = project.stage_id AND (warehouse.region = \"SE\" OR warehouse.region = \"PR\") AND (project.status_id = 26 OR project.status_id = 29 OR project.status_id = 27 OR project.status_id = 31 OR project.status_id = 30) AND (project.projectType_id = 1 OR project.projectType_id = 5 OR project.projectType_id = 6)"];
        MysqlFetch *fetch = [self fetchWithCommand:fetchCommand];
        NSArray *results = [[fetch results] copy];
        fetch = [self fetchWithCommand:@"SELECT person.name FROM project, person, project_managers, projectstage, warehouse WHERE projectstage.name = \"Active\" AND projectstage.id = project.stage_id AND project.warehouse_id = warehouse.id AND project.id = project_managers.project_id AND project_managers.id = person.id AND (warehouse.region = \"SE\" OR warehouse.region = \"PR\") AND (project.status_id = 26 OR project.status_id = 29 OR project.status_id = 27 OR project.status_id = 31 OR project.status_id = 30) AND (project.projectType_id = 1 OR project.projectType_id = 5 OR project.projectType_id = 6)"];
        NSArray *managers = [[fetch results] copy];
        fetch = [self fetchWithCommand:@"SELECT person.name FROM project, person, project_supervisors, projectstage, warehouse WHERE projectstage.name = \"Active\" AND projectstage.id = project.stage_id AND project.warehouse_id = warehouse.id AND project.id = project_supervisors.project_id AND project_supervisors.id = person.id AND (warehouse.region = \"SE\" OR warehouse.region = \"PR\") AND (project.status_id = 26 OR project.status_id = 29 OR project.status_id = 27 OR project.status_id = 31 OR project.status_id = 30) AND (project.projectType_id = 1 OR project.projectType_id = 5 OR project.projectType_id = 6)"];
        NSArray *supervisors = [[fetch results] copy];
        for (int i = 0; i < [results count]; i++) {
            NSMutableArray *projectArray = [[NSMutableArray alloc] init];
            NSDictionary *project = [results objectAtIndex:i];
            [projectArray addObject:[project valueForKey:@"mcsNumber"]];
            [projectArray addObject:[NSString stringWithFormat:@"%@, %@-#%@", [project valueForKey:@"city.name"], [project valueForKey:@"warehouse.state"], [project valueForKey:@"warehouse.warehouseID"]]];
            [projectArray addObject:[project valueForKey:@"projectitem.name"]];
            [projectArray addObject:[project valueForKey:@"project.scope"]];
            [projectArray addObject:[project valueForKey:@"projectclass.name"]];
            [projectArray addObject:[[managers objectAtIndex:i] valueForKey:@"name"]];
            [projectArray addObject:[[supervisors objectAtIndex:i] valueForKey:@"name"]];
            [projectArray addObject:[project valueForKey:@"warehouse.region"]];
            [projectArray addObject:[project valueForKey:@"projectstatus.name"]];
            [projectArray addObject:[project valueForKey:@"project.scheduledStartDate"]];
            [projectArray addObject:[project valueForKey:@"project.scheduledTurnover"]];
            [projects addObject:projectArray];
        }
    } else {
        // Proposal
        NSString *fetchCommand = [NSString stringWithFormat:@"SELECT warehouse.state, warehouse.warehouseID, city.name, projectitem.name, project.scope, projectclass.name, warehouse.region, projectstatus.name, project.projectInitiatedDate, project.proposalSubmitted FROM project, warehouse, city, projectitem, projectclass, projectstatus, projectstage WHERE project.warehouse_id = warehouse.id AND warehouse.city_id = city.id AND project.projectItem_id = projectitem.id AND project.projectClass_id = projectclass.id AND project.status_id = projectstatus.id AND projectstage.name = \"Proposal\" AND projectstage.id = project.stage_id AND (warehouse.region = \"SE\" OR warehouse.region = \"PR\") AND (project.status_id = 1 OR project.status_id = 3 OR project.status_id = 6 OR project.status_id = 4 OR project.status_id = 12) AND (project.projectType_id = 1 OR project.projectType_id = 6)"];
        MysqlFetch *fetch = [self fetchWithCommand:fetchCommand];
        NSArray *results = [[fetch results] copy];
        fetch = [self fetchWithCommand:@"SELECT person.name FROM project, person, project_managers, projectstage, warehouse WHERE project.warehouse_id = warehouse.id AND project.id = project_managers.project_id AND project_managers.id = person.id AND projectstage.name = \"Proposal\" AND projectstage.id = project.stage_id AND (warehouse.region = \"SE\" OR warehouse.region = \"PR\") AND (project.status_id = 1 OR project.status_id = 3 OR project.status_id = 6 OR project.status_id = 4 OR project.status_id = 12) AND (project.projectType_id = 1 OR project.projectType_id = 6)"];
        NSArray *managers = [[fetch results] copy];
        fetch = [self fetchWithCommand:@"SELECT person.name FROM project, person, project_supervisors, projectstage, warehouse WHERE project.warehouse_id = warehouse.id AND project.id = project_supervisors.project_id AND project_supervisors.id = person.id AND projectstage.name = \"Proposal\" AND projectstage.id = project.stage_id AND (warehouse.region = \"SE\" OR warehouse.region = \"PR\") AND (project.status_id = 1 OR project.status_id = 3 OR project.status_id = 6 OR project.status_id = 4 OR project.status_id = 12) AND (project.projectType_id = 1 OR project.projectType_id = 6)"];
        NSArray *supervisors = [[fetch results] copy];
        for (int i = 0; i < [results count]; i++) {
            NSMutableArray *projectArray = [[NSMutableArray alloc] init];
            NSDictionary *project = [results objectAtIndex:i];
            [projectArray addObject:[NSString stringWithFormat:@"%@, %@-#%@", [project valueForKey:@"city.name"], [project valueForKey:@"state"], [project valueForKey:@"warehouseID"]]];
            [projectArray addObject:[project valueForKey:@"projectitem.name"]];
            [projectArray addObject:[project valueForKey:@"project.scope"]];
            [projectArray addObject:[project valueForKey:@"projectclass.name"]];
            [projectArray addObject:[[managers objectAtIndex:i] valueForKey:@"name"]];
            [projectArray addObject:[[supervisors objectAtIndex:i] valueForKey:@"name"]];
            [projectArray addObject:[project valueForKey:@"warehouse.region"]];
            [projectArray addObject:[project valueForKey:@"projectstatus.name"]];
            [projectArray addObject:[project valueForKey:@"project.projectInitiatedDate"]];
            [projectArray addObject:[project valueForKey:@"project.proposalSubmitted"]];
            [projects addObject:projectArray];
        }
    }
    
    return [projects copy];
}

-(NSArray *)fetchInvoiceReportWithReportType:(NSInteger)reportType {
    NSMutableArray *projects = [[NSMutableArray alloc] init];
    if (reportType == 0) {
        // Active
        NSString *fetchCommand = [NSString stringWithFormat:@"SELECT project.mcsNumber, warehouse.warehouseID, warehouse.state, city.name, projectitem.name, projectclass.name, project.scheduledStartDate, project.scheduledTurnover, project.invoiced, project.shouldInvoice, project.projectNotes FROM project, warehouse, city, projectitem, projectclass, projectstage WHERE project.warehouse_id = warehouse.id AND warehouse.city_id = city.id AND project.projectItem_id = projectitem.id AND project.projectClass_id = projectclass.id AND projectstage.name = \"Active\" AND projectstage.id = project.stage_id"];
        MysqlFetch *fetch = [self fetchWithCommand:fetchCommand];
        NSArray *results = [[fetch results] copy];
        for (int i = 0; i < [results count]; i++) {
            NSMutableArray *projectArray = [[NSMutableArray alloc] init];
            NSDictionary *project = [results objectAtIndex:i];
            [projectArray addObject:[project valueForKey:@"mcsNumber"]];
            [projectArray addObject:[NSString stringWithFormat:@"%@, %@-#%@", [project valueForKey:@"city.name"], [project valueForKey:@"warehouse.state"], [project valueForKey:@"warehouse.warehouseID"]]];
            [projectArray addObject:[project valueForKey:@"projectitem.name"]];
            [projectArray addObject:[project valueForKey:@"projectclass.name"]];
            [projectArray addObject:[project valueForKey:@"project.scheduledStartDate"]];
            [projectArray addObject:[project valueForKey:@"project.scheduledTurnover"]];
            [projectArray addObject:[project valueForKey:@"project.invoiced"]];
            [projectArray addObject:[project valueForKey:@"project.shouldInvoice"]];
            [projectArray addObject:[project valueForKey:@"project.projectNotes"]];
            [projects addObject:projectArray];
        }
    } else {
        // Proposal
        NSString *fetchCommand = [NSString stringWithFormat:@"SELECT project.mcsNumber, warehouse.warehouseID, warehouse.state, city.name, projectitem.name, projectclass.name, project.scheduledStartDate, project.scheduledTurnover, project.invoiced, project.shouldInvoice, project.projectNotes FROM project, warehouse, city, projectitem, projectclass, projectstage WHERE project.warehouse_id = warehouse.id AND warehouse.city_id = city.id AND project.projectItem_id = projectitem.id AND project.projectClass_id = projectclass.id AND projectstage.name = \"Proposal\" AND projectstage.id = project.stage_id"];
        MysqlFetch *fetch = [self fetchWithCommand:fetchCommand];
        NSArray *results = [[fetch results] copy];
        for (int i = 0; i < [results count]; i++) {
            NSMutableArray *projectArray = [[NSMutableArray alloc] init];
            NSDictionary *project = [results objectAtIndex:i];
            [projectArray addObject:[project valueForKey:@"mcsNumber"]];
            [projectArray addObject:[NSString stringWithFormat:@"%@, %@-#%@", [project valueForKey:@"city.name"], [project valueForKey:@"warehouse.state"], [project valueForKey:@"warehouse.warehouseID"]]];
            [projectArray addObject:[project valueForKey:@"projectitem.name"]];
            [projectArray addObject:[project valueForKey:@"projectclass.name"]];
            [projectArray addObject:[project valueForKey:@"project.scheduledStartDate"]];
            [projectArray addObject:[project valueForKey:@"project.scheduledTurnover"]];
            [projectArray addObject:[project valueForKey:@"project.invoiced"]];
            [projectArray addObject:[project valueForKey:@"project.shouldInvoice"]];
            [projectArray addObject:[project valueForKey:@"project.projectNotes"]];
            [projects addObject:projectArray];
        }
    }
    
    return [projects copy];
}

-(NSArray *)fetchCompletedReportWithReportType:(NSInteger)reportType {
    // Active
    NSMutableArray *projects = [[NSMutableArray alloc] init];
    NSString *fetchCommand = [NSString stringWithFormat:@"SELECT project.mcsNumber, warehouse.warehouseID, warehouse.state, city.name, projectitem.name, project.scope, warehouse.region, project.scheduledStartDate, project.scheduledTurnover, closeoutdetails.asBuilts, closeoutdetails.punchList, closeoutdetails.alarmHvacForm, closeoutdetails.permitsClosed, project.shouldInvoice, project.invoiced, project.projectNotes FROM project, warehouse, city, projectitem, closeoutdetails, projectstage WHERE project.warehouse_id = warehouse.id AND warehouse.city_id = city.id AND project.projectItem_id = projectitem.id AND project.closeoutDetails_id = closeoutdetails.id AND projectstage.name = \"Active\" AND projectstage.id = project.stage_id AND project.status_id = 28"];
    MysqlFetch *fetch = [self fetchWithCommand:fetchCommand];
    NSArray *results = [[fetch results] copy];
    for (int i = 0; i < [results count]; i++) {
        NSMutableArray *projectArray = [[NSMutableArray alloc] init];
        NSDictionary *project = [results objectAtIndex:i];
        [projectArray addObject:[project valueForKey:@"mcsNumber"]];
        [projectArray addObject:[NSString stringWithFormat:@"%@, %@-#%@", [project valueForKey:@"city.name"], [project valueForKey:@"warehouse.state"], [project valueForKey:@"warehouse.warehouseID"]]];
        [projectArray addObject:[project valueForKey:@"projectitem.name"]];
        [projectArray addObject:[project valueForKey:@"project.scope"]];
        [projectArray addObject:[project valueForKey:@"warehouse.region"]];
        [projectArray addObject:[project valueForKey:@"project.scheduledStartDate"]];
        [projectArray addObject:[project valueForKey:@"project.scheduledTurnover"]];
        [projectArray addObject:[project valueForKey:@"closeoutdetails.asBuilts"]];
        [projectArray addObject:[project valueForKey:@"closeoutdetails.punchList"]];
        [projectArray addObject:[project valueForKey:@"closeoutdetails.alarmHvacForm"]];
        [projectArray addObject:[project valueForKey:@"closeoutdetails.permitsClosed"]];
        [projectArray addObject:[project valueForKey:@"project.shouldInvoice"]];
        [projectArray addObject:[project valueForKey:@"project.invoiced"]];
        [projectArray addObject:[project valueForKey:@"project.projectNotes"]];
        [projects addObject:projectArray];
    }
    
    return projects;
}

-(NSArray *)fetchConstructionReportWithReportType:(NSInteger)reportType {
    // Active
    NSMutableArray *projects = [[NSMutableArray alloc] init];
    NSString *fetchCommand = [NSString stringWithFormat:@"SELECT project.mcsNumber, projectstage.name, warehouse.warehouseID, warehouse.state, city.name, projectitem.name, project.scope, projectclass.name, warehouse.region, projectstatus.name, project.scheduledStartDate, project.scheduledTurnover, project.actualTurnover, projecttype.name, closeoutdetails.asBuilts, closeoutdetails.punchList, closeoutdetails.alarmHvacForm, closeoutdetails.airGas, closeoutdetails.permitsClosed, closeoutdetails.verisaeShutdownReport, project.invoiced, project.shouldInvoice, project.projectNotes FROM project, warehouse, city, projectstage, projectitem, projectclass, projectstatus, projecttype, closeoutdetails WHERE project.warehouse_id = warehouse.id AND warehouse.city_id = city.id AND project.stage_id = projectstage.id AND project.projectItem_id = projectitem.id AND project.projectClass_id = projectclass.id AND project.status_id = projectstatus.id AND project.projectType_id = projecttype.id AND project.closeoutDetails_id = closeoutdetails.id AND projectstage.name = \"Active\" AND (project.projectType_id = 1 OR project.projectType_id = 5 OR project.projectType_id = 6 OR project.projectType_id = 7)"];
    MysqlFetch *fetch = [self fetchWithCommand:fetchCommand];
    NSArray *results = [[fetch results] copy];
    fetch = [self fetchWithCommand:@"SELECT person.name FROM project, project_managers, person, projectstage WHERE project_managers.project_id = project.id AND project_managers.id = person.id AND project.stage_id = projectstage.id AND projectstage.name = \"Active\" AND (project.projectType_id = 1 OR project.projectType_id = 5 OR project.projectType_id = 6 OR project.projectType_id = 7)"];
    NSArray *managers = [[fetch results] copy];
    fetch = [self fetchWithCommand:@"SELECT person.name FROM project, project_supervisors, person, projectstage WHERE project_supervisors.project_id = project.id AND project_supervisors.id = person.id AND project.stage_id = projectstage.id AND projectstage.name = \"Active\" AND (project.projectType_id = 1 OR project.projectType_id = 5 OR project.projectType_id = 6 OR project.projectType_id = 7)"];
    NSArray *supervisors = [[fetch results] copy];
    for (int i = 0; i < [results count]; i++) {
        NSMutableArray *projectArray = [[NSMutableArray alloc] init];
        NSDictionary *project = [results objectAtIndex:i];
        [projectArray addObject:[project valueForKey:@"mcsNumber"]];
        [projectArray addObject:[project valueForKey:@"projectstage.name"]];
        [projectArray addObject:[NSString stringWithFormat:@"%@, %@-#%@", [project valueForKey:@"city.name"], [project valueForKey:@"warehouse.state"], [project valueForKey:@"warehouse.warehouseID"]]];
        [projectArray addObject:[project valueForKey:@"projectitem.name"]];
        [projectArray addObject:[project valueForKey:@"project.scope"]];
        [projectArray addObject:[project valueForKey:@"projectclass.name"]];
        [projectArray addObject:[[managers objectAtIndex:i] valueForKey:@"name"]];
        [projectArray addObject:[[supervisors objectAtIndex:i] valueForKey:@"name"]];
        [projectArray addObject:[project valueForKey:@"warehouse.region"]];
        [projectArray addObject:[project valueForKey:@"projectstatus.name"]];
        [projectArray addObject:[project valueForKey:@"project.scheduledStartDate"]];
        [projectArray addObject:[project valueForKey:@"project.scheduledTurnover"]];
        [projectArray addObject:[project valueForKey:@"project.actualTurnover"]];
        [projectArray addObject:[project valueForKey:@"projecttype.name"]];
        [projectArray addObject:[project valueForKey:@"closeoutdetails.asBuilts"]];
        [projectArray addObject:[project valueForKey:@"closeoutdetails.punchList"]];
        [projectArray addObject:[project valueForKey:@"closeoutdetails.alarmHvacForm"]];
        [projectArray addObject:[project valueForKey:@"closeoutdetails.airGas"]];
        [projectArray addObject:[project valueForKey:@"closeoutdetails.permitsClosed"]];
        [projectArray addObject:[project valueForKey:@"closeoutdetails.verisaeShutdownReport"]];
        [projectArray addObject:[project valueForKey:@"project.invoiced"]];
        [projectArray addObject:[project valueForKey:@"project.shouldInvoice"]];
        [projectArray addObject:[project valueForKey:@"project.projectNotes"]];
        [projects addObject:projectArray];
    }
    
    return projects;
}

-(NSArray *)fetchRepairReportWithReportType:(NSInteger)reportType {
    // Active
    NSMutableArray *projects = [[NSMutableArray alloc] init];
    NSString *fetchCommand = [NSString stringWithFormat:@"SELECT project.mcsNumber, projectstage.name, warehouse.warehouseID, warehouse.state, city.name, projectitem.name, project.scope, projectclass.name, warehouse.region, projectstatus.name, project.scheduledStartDate, project.scheduledTurnover, project.actualTurnover, projecttype.name, closeoutdetails.asBuilts, closeoutdetails.punchList, closeoutdetails.alarmHvacForm, closeoutdetails.airGas, closeoutdetails.permitsClosed, closeoutdetails.verisaeShutdownReport, project.invoiced, project.shouldInvoice, project.projectNotes FROM project, warehouse, city, projectstage, projectitem, projectclass, projectstatus, projecttype, closeoutdetails WHERE project.warehouse_id = warehouse.id AND warehouse.city_id = city.id AND project.stage_id = projectstage.id AND project.projectItem_id = projectitem.id AND project.projectClass_id = projectclass.id AND project.status_id = projectstatus.id AND project.projectType_id = projecttype.id AND project.closeoutDetails_id = closeoutdetails.id AND projectstage.name = \"Active\" AND (project.projectType_id = 2 OR project.projectType_id = 3)"];
    MysqlFetch *fetch = [self fetchWithCommand:fetchCommand];
    NSArray *results = [[fetch results] copy];
    fetch = [self fetchWithCommand:@"SELECT person.name FROM project, project_managers, person, projectstage WHERE project_managers.project_id = project.id AND project_managers.id = person.id AND project.stage_id = projectstage.id AND projectstage.name = \"Active\" AND (project.projectType_id = 2 OR project.projectType_id = 3)"];
    NSArray *managers = [[fetch results] copy];
    fetch = [self fetchWithCommand:@"SELECT person.name FROM project, project_supervisors, person, projectstage WHERE project_supervisors.project_id = project.id AND project_supervisors.id = person.id AND project.stage_id = projectstage.id AND projectstage.name = \"Active\" AND (project.projectType_id = 2 OR project.projectType_id = 3)"];
    NSArray *supervisors = [[fetch results] copy];
    for (int i = 0; i < [results count]; i++) {
        NSMutableArray *projectArray = [[NSMutableArray alloc] init];
        NSDictionary *project = [results objectAtIndex:i];
        [projectArray addObject:[project valueForKey:@"mcsNumber"]];
        [projectArray addObject:[project valueForKey:@"projectstage.name"]];
        [projectArray addObject:[NSString stringWithFormat:@"%@, %@-#%@", [project valueForKey:@"city.name"], [project valueForKey:@"warehouse.state"], [project valueForKey:@"warehouse.warehouseID"]]];
        [projectArray addObject:[project valueForKey:@"projectitem.name"]];
        [projectArray addObject:[project valueForKey:@"project.scope"]];
        [projectArray addObject:[project valueForKey:@"projectclass.name"]];
        [projectArray addObject:[[managers objectAtIndex:i] valueForKey:@"name"]];
        [projectArray addObject:[[supervisors objectAtIndex:i] valueForKey:@"name"]];
        [projectArray addObject:[project valueForKey:@"warehouse.region"]];
        [projectArray addObject:[project valueForKey:@"projectstatus.name"]];
        [projectArray addObject:[project valueForKey:@"project.scheduledStartDate"]];
        [projectArray addObject:[project valueForKey:@"project.scheduledTurnover"]];
        [projectArray addObject:[project valueForKey:@"project.actualTurnover"]];
        [projectArray addObject:[project valueForKey:@"projecttype.name"]];
        [projectArray addObject:[project valueForKey:@"closeoutdetails.asBuilts"]];
        [projectArray addObject:[project valueForKey:@"closeoutdetails.punchList"]];
        [projectArray addObject:[project valueForKey:@"closeoutdetails.alarmHvacForm"]];
        [projectArray addObject:[project valueForKey:@"closeoutdetails.airGas"]];
        [projectArray addObject:[project valueForKey:@"closeoutdetails.permitsClosed"]];
        [projectArray addObject:[project valueForKey:@"closeoutdetails.verisaeShutdownReport"]];
        [projectArray addObject:[project valueForKey:@"project.invoiced"]];
        [projectArray addObject:[project valueForKey:@"project.shouldInvoice"]];
        [projectArray addObject:[project valueForKey:@"project.projectNotes"]];
        [projects addObject:projectArray];
    }
    
    return projects;
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
 *  Retreives all the projects with should invoice > invoiced and should invoice < 20
 *
 *  @return Array of Dictionaries with the project info
 */
-(NSArray *)fetchWarningInvoiceTriggers {
    NSString *fetchCommand = [NSString stringWithFormat:@"SELECT DISTINCTROW project.mcsNumber, city.name, projectitem.name, project.id FROM project, warehouse, projectitem, city WHERE project.shouldInvoice > project.invoiced AND project.shouldInvoice < project.invoiced + 20 AND project.warehouse_id = warehouse.id AND warehouse.city_id = city.id AND project.projectItem_id = projectitem.id"];
    MysqlFetch *fetch = [self fetchWithCommand:fetchCommand];
    NSLog(@"%@", [fetch results]);
    
    return [fetch results];
}

/**
 *  Retreives all the projects with a Costco Due Date within 3 days of current date
 *
 *  @return Array of Dictionaries with the project info
 */
-(NSArray *)fetchWarningCostcoDueDateTriggers {
    NSString *fetchCommand = [NSString stringWithFormat:@"SELECT DISTINCTROW project.mcsNumber, city.name, projectitem.name, project.id, project.costcoDueDate FROM project, warehouse, projectitem, city WHERE project.costcoDueDate <= date_add(curdate(), INTERVAL 3 DAY) AND project.costcoDueDate >= curdate() AND project.mcsNumber != -1 AND project.warehouse_id = warehouse.id AND warehouse.city_id = city.id AND project.projectItem_id = projectitem.id AND project.stage_id = 2"];
    MysqlFetch *fetch = [self fetchWithCommand:fetchCommand];
    NSLog(@"%@", [fetch results]);
    
    return [fetch results];
}

/**
 *  Retreives all the projects with a scheduled turn over date prior to the current date and project status not equal complete
 *
 *  @return Array of Dictionaries with the project info
 */
-(NSArray *)fetchWarningTurnOverTriggers {
    NSString *fetchCommand = [NSString stringWithFormat:@"SELECT DISTINCTROW project.mcsNumber, city.name, projectitem.name, project.id FROM project, warehouse, projectitem, city WHERE project.scheduledTurnover < curdate() AND project.status_id != 28 AND project.mcsNumber != -1 AND project.warehouse_id = warehouse.id AND warehouse.city_id = city.id AND project.projectItem_id = projectitem.id"];
    MysqlFetch *fetch = [self fetchWithCommand:fetchCommand];
    NSLog(@"%@", [fetch results]);
    
    return [fetch results];
}

/**
 *  Retreives all the projects with a Costco Due Date past the current date
 *
 *  @return Array of Dictionaries with the project info
 */
-(NSArray *)fetchSevereCostcoDueDateTriggers {
    NSString *fetchCommand = [NSString stringWithFormat:@"SELECT DISTINCTROW project.mcsNumber, city.name, projectitem.name, project.id, project.costcoDueDate FROM project, warehouse, projectitem, city WHERE project.costcoDueDate < curdate() AND project.mcsNumber != -1 AND project.warehouse_id = warehouse.id AND warehouse.city_id = city.id AND project.projectItem_id = projectitem.id AND project.stage_id = 2"];
    MysqlFetch *fetch = [self fetchWithCommand:fetchCommand];
    NSLog(@"%@", [fetch results]);
    
    return [fetch results];
}

/**
 *  Retreives all the project with should invoice >= invoiced + 20
 *
 *  @return Array of Dictionaries with the project info
 */
-(NSArray *)fetchSevereInvoiceTriggers {
    NSString *fetchCommand = [NSString stringWithFormat:@"SELECT DISTINCTROW project.mcsNumber, city.name, projectitem.name, project.id FROM project, warehouse, projectitem, city WHERE project.shouldInvoice >= project.invoiced + 20 AND project.warehouse_id = warehouse.id AND warehouse.city_id = city.id AND project.projectItem_id = projectitem.id"];
    MysqlFetch *fetch = [self fetchWithCommand:fetchCommand];
    NSLog(@"%@", [fetch results]);
    
    return [fetch results];
}

@end
