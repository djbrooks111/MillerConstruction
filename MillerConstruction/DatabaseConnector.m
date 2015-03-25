//
//  DatabaseConnector.m
//  MillerConstruction
//
//  Created by David Brooks on 3/15/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import "DatabaseConnector.h"
#import "MysqlFetch.h"
#import "MysqlInsert.h"

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
    if (self.databaseConnection != nil) {
        return true;
    }
    //TODO: SET SCHEMA BACK TO PRODUCTION
    self.databaseConnection = [MysqlConnection connectToHost:DB_HOST user:DB_USERNAME password:DB_PASSWORD schema:DB_TEST_SCHEMA flags:MYSQL_DEFAULT_CONNECTION_FLAGS];
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
    [self connectToDatabase];
    MysqlFetch *fetch = [MysqlFetch fetchWithCommand:command onConnection:self.databaseConnection];
    self.databaseConnection = nil;
    
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
    [self connectToDatabase];
    MysqlInsert *insert = [MysqlInsert insertWithConnection:self.databaseConnection];
    [insert setTable:table];
    [insert setRowData:data];
    [insert execute];
    self.databaseConnection = nil;
    
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
    NSString *usernameCommand = [NSString stringWithFormat:@"SELECT id FROM user WHERE name = \"%@\"", [user username]];
    MysqlFetch *checkUserInDatabase = [self fetchWithCommand:usernameCommand];
    if ([checkUserInDatabase.results count] == 0) {
        // User not in database
        return WrongUsername;
    } else {
        NSString *passwordCommand = [NSString stringWithFormat:@"SELECT password FROM user WHERE name = \"%@\"", [user username]];
        MysqlFetch *passwordFetch = [self fetchWithCommand:passwordCommand];
        NSString *userPassword = [[passwordFetch.results firstObject] objectForKey:@"password"];
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
 *  Fetches the different project types from the database
 *
 *  @return NSArray * of the project types
 */
-(NSArray *)fetchProjectTypes {
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
    NSString *projectClassificationCommand = @"SELECT id, name FROM projectclass";
    MysqlFetch *getProjectClassifications = [self fetchWithCommand:projectClassificationCommand];
    
    return [getProjectClassifications results];
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
    NSNumber *rowid = [insertCommand rowid];
    NSNumber *affectedRows = [insertCommand affectedRows];
    NSLog(@"Auto Increment rowid: %@", rowid);
    NSLog(@"AffectedRows: %@", affectedRows);
    if (affectedRows > 0) {
        // Success, add other data to tables
        NSDictionary *managerDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [projectInformation objectAtIndex:4], @"id",
                                    rowid, @"project_id",
                                    nil];
        insertCommand = [self insertIntoTable:@"project_managers" withData:managerDictionary];
        affectedRows = [insertCommand affectedRows];
        if (affectedRows > 0) {
            // Success, add other data to tables
            NSDictionary *supervisorsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [projectInformation objectAtIndex:5], @"id",
                                        rowid, @"project_id",
                                        nil];
            insertCommand = [self insertIntoTable:@"project_supervisors" withData:supervisorsDictionary];
            affectedRows = [insertCommand affectedRows];
            if (affectedRows > 0) {
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
                    affectedRows = [insertCommand affectedRows];
                    if (affectedRows > 0) {
                        // Finally return success
                        return true;
                    } else {
                        // Closeout Failure
                        return false;
                    }
                } else {
                    // Salvage Failure
                    return false;
                }
            } else {
                // Supervisors Failure
                return false;
            }
        } else {
            // Managers Failure
            return false;
        }
    } else {
        // Project Failure
        return false;
    }
}

@end
