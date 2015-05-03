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
#import "iPhoneMySQL/MysqlFetch.h"

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

// Generate Report
-(NSArray *)fetchWeeklyReportWithReportType:(NSInteger)reportType;
-(NSArray *)fetchSteveMeyerReportWithReportType:(NSInteger)reportType;
-(NSArray *)fetchSouthEastReportWithReportType:(NSInteger)reportType;
-(NSArray *)fetchNorthEastReportWithReportType:(NSInteger)reportType;
-(NSArray *)fetchJDempseyReportWithReportType:(NSInteger)reportType;
-(NSArray *)fetchInvoiceReportWithReportType:(NSInteger)reportType;
-(NSArray *)fetchCompletedReportWithReportType:(NSInteger)reportType;
-(NSArray *)fetchConstructionReportWithReportType:(NSInteger)reportType;
-(NSArray *)fetchRepairReportWithReportType:(NSInteger)reportType;
-(NSArray *)fetchHVACReportWithReportType:(NSInteger)reportType;

// View Triggers
-(NSArray *)fetchInfoMCSNumberTriggers;
-(NSArray *)fetchWarningInvoiceTriggers;
-(NSArray *)fetchWarningCostcoDueDateTriggers;
-(NSArray *)fetchWarningTurnOverTriggers;
-(NSArray *)fetchSevereCostcoDueDateTriggers;
-(NSArray *)fetchSevereInvoiceTriggers;

// View Existing Rpoject
-(BOOL)updateProjectWithID:(NSNumber *)projectID andData:(NSArray *)projectInformation andKeys:(NSArray *)keys andSalvageExists:(BOOL)salvageExists;

// MySQL
-(MysqlFetch *)fetchWithCommand:(NSString *)command;

@end
