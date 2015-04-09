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

-(NSArray *)fetchProjectItem;
-(NSArray *)fetchWarehouses;
-(NSArray *)fetchProjectClassifications;
-(NSArray *)fetchProjectPeople;
-(NSArray *)fetchProjectStage;
-(NSArray *)fetchProjectStatus;
-(NSArray *)fetchProjectType;

-(BOOL)addNewProject:(NSArray *)projectInformation andKeys:(NSArray *)keys;

-(NSArray *)fetchProjectsWithWarehouseID:(NSNumber *)warehouseID andProjectStageID:(NSNumber *)projectStageID;

@end
