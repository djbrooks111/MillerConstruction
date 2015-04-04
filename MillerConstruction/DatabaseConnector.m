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

@end
