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

// Login
-(UserLoginType)loginUserToDatabase:(User *)user;

-(NSArray *)fetchProjectItem;
-(NSArray *)fetchWarehouses;
-(NSArray *)fetchProjectClassifications;
-(NSArray *)fetchProjectPeople;
-(NSArray *)fetchProjectStage;
-(NSArray *)fetchProjectStatus;
-(NSArray *)fetchProjectType;

// Create New Project
-(BOOL)addNewProject:(NSArray *)projectInformation andKeys:(NSArray *)keys;

-(NSArray *)fetchProjectsWithWarehouseID:(NSNumber *)warehouseID andProjectStageID:(NSNumber *)projectStageID;

-(NSArray *)fetchProjectInformationForID:(NSNumber *)projectID;

// View Triggers
-(NSArray *)fetchInfoMCSNumberTriggers;
-(NSArray *)fetchWarningInvoiceTriggers;
-(NSArray *)fetchWarningCostcoDueDateTriggers;
-(NSArray *)fetchWarningTurnOverTriggers;
-(NSArray *)fetchSevereCostcoDueDateTriggers;
-(NSArray *)fetchSevereInvoiceTriggers;

// View Existing Rpoject
-(BOOL)updateProjectWithID:(NSNumber *)projectID andData:(NSArray *)projectInformation andKeys:(NSArray *)keys andSalvageExists:(BOOL)salvageExists;

@end
