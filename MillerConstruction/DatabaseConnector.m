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
    
    self.databaseConnection = [MysqlConnection connectToHost:DB_HOST user:DB_USERNAME password:DB_PASSWORD schema:DB_SCHEMA flags:MYSQL_DEFAULT_CONNECTION_FLAGS];
    if (self.databaseConnection == nil) {
        NSLog(@"Failed to connect to the database");
        
        return false;
    } else {
        NSLog(@"Connected to the database");
        
        return true;
    }
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
    MysqlFetch *checkUserInDatabase = [MysqlFetch fetchWithCommand:usernameCommand onConnection:self.databaseConnection];
    if ([checkUserInDatabase.results count] == 0) {
        // User not in database
        return WrongUsername;
    } else {
        NSString *passwordCommand = [NSString stringWithFormat:@"SELECT password FROM user WHERE name = \"%@\"", [user username]];
        MysqlFetch *passwordFetch = [MysqlFetch fetchWithCommand:passwordCommand onConnection:self.databaseConnection];
        NSString *userPassword = [[passwordFetch.results firstObject] objectForKey:@"password"];
        NSLog(@"userPassword: %@", userPassword);
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

-(NSArray *)fetchProjectTypes {
    NSString *projectTypesCommand = @"SELECT * FROM projectitem";
    MysqlFetch *getProjectTypes = [MysqlFetch fetchWithCommand:projectTypesCommand onConnection:self.databaseConnection];
    NSLog(@"%@", [getProjectTypes results]);
    
    return [getProjectTypes results];
}

-(BOOL)addNewProject:(NSArray *)projectInformation andKeys:(NSArray *)keys {
    NSMutableDictionary *insertDictionary = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < [projectInformation count]; i++) {
        NSString *value = [projectInformation objectAtIndex:i];
        NSString *valueKey = [keys objectAtIndex:i];
        if ([value isEqualToString:@""]) {
            // Do nothing, does not involve the projec table
        } else {
            NSDictionary *subDictionary = [NSDictionary dictionaryWithObject:value forKey:valueKey];
            [insertDictionary addEntriesFromDictionary:subDictionary];
        }
    }
    MysqlInsert *insertCommand = [MysqlInsert insertWithConnection:self.databaseConnection];
    [insertCommand setTable:@"project"];
    [insertCommand setRowData:[insertDictionary copy]];
    [insertCommand execute];
    NSNumber *rowid = [insertCommand rowid];
    NSNumber *affectedRows = [insertCommand affectedRows];
    NSLog(@"Auto Increment rowid: %@", rowid);
    NSLog(@"AffectedRows: %@", affectedRows);
    if (affectedRows > 0) {
        // Success, add other data to tables
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [projectInformation objectAtIndex:4], @"id",
                                    rowid, @"project_id",
                                    nil];
        [insertCommand setTable:@"project_managers"];
        [insertCommand setRowData:dictionary];
        [insertCommand execute];
        affectedRows = [insertCommand affectedRows];
        if (affectedRows > 0) {
            // Success, add other data to tables
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [projectInformation objectAtIndex:5], @"id",
                                        rowid, @"project_id",
                                        nil];
            [insertCommand setTable:@"project_supervisors"];
            [insertCommand setRowData:dictionary];
            [insertCommand execute];
            affectedRows = [insertCommand affectedRows];
            if (affectedRows > 0) {
                // Success, add other data to tables;
                [insertDictionary removeAllObjects];
                NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [projectInformation objectAtIndex:14], @"asBuilts",
                                            [projectInformation objectAtIndex:15], @"punchList",
                                            nil];
            }
        }
    } else {
        // Failure
        return false;
    }
}

@end
