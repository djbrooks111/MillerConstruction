//
//  DatabaseConnector.h
//  MillerConstruction
//
//  Created by David Brooks on 3/15/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MysqlConnection.h"
#import "User.h"

@interface DatabaseConnector : NSObject

@property (strong, nonatomic) MysqlConnection *databaseConnection;

+(id)sharedDatabaseConnector;
-(BOOL)connectToDatabase;
-(UserLoginType)loginUserToDatabase:(User *)user;

@end
