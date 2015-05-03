//
//  GenerateReportSearchHelper.m
//  MillerConstruction
//
//  Created by David Brooks on 4/16/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import "GenerateReportSearchHelper.h"
#import "DatabaseConnector.h"

@implementation GenerateReportSearchHelper {
    DatabaseConnector *database;
}

-(id)init {
    if (self = [super init]) {
        [self initializeReportNamesArray];
        [self initializeWeeklyReportHeaders];
        [self initializeSteveMeyerReportHeaders];
        [self initializeSouthEastRefrigerationReportHeaders];
        [self initializeNorthEastRefrigerationReportHeaders];
        [self initializeJDempseyReportHeaders];
        [self initializeInvoiceReportHeaders];
        [self initializeCompletedReportHeaders];
        [self initializeConstructionReportHeaders];
        [self initializeRepairReportHeaders];
        [self initializeHVACReportHeaders];
        database = [DatabaseConnector sharedDatabaseConnector];
    }
    
    return self;
}

-(void)initializeReportNamesArray {
    self.reportNamesArray = @[
                              @"Weekly",
                              @"Steve Meyer",
                              @"South East Refrigeration",
                              @"North East Refrigeration",
                              @"J Dempsey",
                              @"Invoice",
                              @"Completed",
                              @"Construction",
                              @"Repair",
                              @"HVAC"];
}

-(void)initializeWeeklyReportHeaders {
    self.weeklyActiveReportHeaders = @[
                                 @"MCS Number",
                                 @"Stage",
                                 @"Warehouse",
                                 @"Item",
                                 @"Project Scope",
                                 @"Project Classification",
                                 @"Manager",
                                 @"Supervisor",
                                 @"Region",
                                 @"Project Status",
                                 @"Scheduled Start Date",
                                 @"Scheduled Turn Over",
                                 @"Actual Turn Over",
                                 @"Type",
                                 @"As-Builts",
                                 @"Punch List",
                                 @"Alarm/HVAC Form",
                                 @"Air Gas",
                                 @"Permits Closed",
                                 @"Verisae/Shut Down Report",
                                 @"Invoiced %",
                                 @"Should Invoice %",
                                 @"Project and Financial Notes"];
    
    self.weeklyProposalReportHeaders = @[
                                         @"Stage",
                                         @"Warehouse",
                                         @"Item",
                                         @"Project Scope",
                                         @"Project Classification",
                                         @"Manager",
                                         @"Supervisor",
                                         @"Region",
                                         @"Project Status",
                                         @"Initiated Date",
                                         @"Site Survey",
                                         @"Costco Due Date",
                                         @"Proposal Submitted",
                                         @"Type",
                                         @"Project and Financial Notes"];
    
    self.weeklyBudgetaryReportHeaders = @[
                                          @"Stage",
                                          @"Warehouse",
                                          @"Item",
                                          @"Project Scope",
                                          @"Project Classification",
                                          @"Manager",
                                          @"Supervisor",
                                          @"Region",
                                          @"Project Status",
                                          @"Initiated Date",
                                          @"Site Survey",
                                          @"Costco Due Date",
                                          @"Proposal Submitted",
                                          @"Type",
                                          @"Project and Financial Notes"];
    
    self.weeklyInactiveReportHeaders = @[
                                         @"Stage",
                                         @"Item",
                                         @"Project Scope",
                                         @"Project Status"];
    
    self.weeklyClosedReportHeaders = @[
                                       @"MCS Number",
                                       @"Stage",
                                       @"Warehouse",
                                       @"Item",
                                       @"Project Scope",
                                       @"Manager",
                                       @"Supervisor",
                                       @"Region",
                                       @"Project Status",
                                       @"Initiated Date",
                                       @"Type",
                                       @"Costco Due Date",
                                       @"Proposal Submitted",
                                       @"Scheduled Start Date",
                                       @"Scheduled Turn Over",
                                       @"As-Builts",
                                       @"Punch List",
                                       @"Alarm/HVAC Form",
                                       @"Air Gas",
                                       @"Permits Closed",
                                       @"Should Invoice %",
                                       @"Invoiced %",
                                       @"Project and Financial Notes"];
}

-(void)initializeSteveMeyerReportHeaders {
    self.steveMeyerActiveReportHeaders = @[
                                           @"MCS Number",
                                           @"Warehouse",
                                           @"Item",
                                           @"Project Scope",
                                           @"Project Classification",
                                           @"Manager",
                                           @"Supervisor",
                                           @"Region",
                                           @"Project Status",
                                           @"Scheduled Start Date",
                                           @"Scheduled Turn Over"];
    
    self.southEastProposalReportHeaders = @[
                                            @"Region",
                                            @"Item",
                                            @"Warehouse",
                                            @"Project Scope",
                                            @"Project Classification",
                                            @"Manager",
                                            @"Supervisor",
                                            @"Project Status",
                                            @"Initiated Date",
                                            @"Proposal Submitted"];
}

-(void)initializeSouthEastRefrigerationReportHeaders {
    self.southEastActiveReportHeaders = @[
                                          @"Warehouse",
                                          @"Item",
                                          @"Project Scope",
                                          @"Region",
                                          @"Project Status",
                                          @"Permit Application",
                                          @"Scheduled Start Date",
                                          @"Scheduled Turn Over",
                                          @"As-Builts",
                                          @"Alarm/HVAC Form",
                                          @"Regrigeration Notes"];
    
    self.southEastProposalReportHeaders = @[
                                            @"Warehouse",
                                            @"Item",
                                            @"Project Scope",
                                            @"Region",
                                            @"Project Status",
                                            @"Permit Application",
                                            @"Initiated Date",
                                            @"Costco Due Date",
                                            @"Proposal Submitted",
                                            @"Refrigeration Notes"];
}

-(void)initializeNorthEastRefrigerationReportHeaders {
    self.northEastActiveReportHeaders = @[
                                          @"Warehouse",
                                          @"Item",
                                          @"Project Scope",
                                          @"Region",
                                          @"Project Status",
                                          @"Permit Application",
                                          @"Scheduled Start Date",
                                          @"Scheduled Turn Over",
                                          @"As-Builts",
                                          @"Alarm/HVAC Form",
                                          @"Regrigeration Notes"];
    
    self.northEastProposalReportHeaders = @[
                                            @"Warehouse",
                                            @"Item",
                                            @"Project Scope",
                                            @"Region",
                                            @"Project Status",
                                            @"Permit Application",
                                            @"Scheduled Start Date",
                                            @"Scheduled Turn Over",
                                            @"As-Builts",
                                            @"Alarm/HVAC Form",
                                            @"Regrigeration Notes"];
}

-(void)initializeJDempseyReportHeaders {
    self.jDempseyActiveReportHeaders = @[
                                         @"MCS Number",
                                         @"Warehouse",
                                         @"Item",
                                         @"Project Scope",
                                         @"Project Classification",
                                         @"Manager",
                                         @"Supervisor",
                                         @"Region",
                                         @"Project Status",
                                         @"Scheduled Start Date",
                                         @"Scheduled Turn Over"];
    
    self.jDempseyProposalReportHeaders = @[
                                           @"Warehouse",
                                           @"Item",
                                           @"Project Scope",
                                           @"Project Classification",
                                           @"Manager",
                                           @"Supervisor",
                                           @"Region",
                                           @"Project Status",
                                           @"Initiated Date",
                                           @"Proposal Submitted"];
}

-(void)initializeInvoiceReportHeaders {
    self.invoiceActiveReportHeaders = @[
                                        @"MCS Number",
                                        @"Warehouse",
                                        @"Item",
                                        @"Project Classification",
                                        @"Scheduled Start Date",
                                        @"Scheduled Turn Over",
                                        @"Invoiced %",
                                        @"Should Invoice %",
                                        @"Project and Financial Notes"];
    
    self.invoiceProposalReportHeaders = @[
                                          @"MCS Number",
                                          @"Warehouse",
                                          @"Item",
                                          @"Project Classification",
                                          @"Scheduled Start Date",
                                          @"Scheduled Turn Over",
                                          @"Invoiced %",
                                          @"Should Invoice %",
                                          @"Project and Financial Notes"];
}

-(void)initializeCompletedReportHeaders {
    self.completedActiveReportHeaders = @[
                                          @"MCS Number",
                                          @"Warehouse",
                                          @"Item",
                                          @"Project Scope",
                                          @"Region",
                                          @"Scheduled Start Date",
                                          @"Scheduled Turn Over",
                                          @"As-Builts",
                                          @"Punch List",
                                          @"Alarm/HVAC Form",
                                          @"Permits Closed",
                                          @"Should Invoice %",
                                          @"Invoiced %",
                                          @"Project and Financial Notes"];
}

-(void)initializeConstructionReportHeaders {
    self.constructionActiveReportHeaders = @[
                                             @"MCS Number",
                                             @"Stage",
                                             @"Warehouse",
                                             @"Item",
                                             @"Project Scope",
                                             @"Project Classification",
                                             @"Manager",
                                             @"Supervisor",
                                             @"Region",
                                             @"Project Status",
                                             @"Scheduled Start Date",
                                             @"Scheduled Turn Over",
                                             @"Actual Turn Over",
                                             @"Type",
                                             @"As-Builts",
                                             @"Punch List",
                                             @"Alarm/HVAC Form",
                                             @"Air Gas",
                                             @"Permits Closed",
                                             @"Verisae/Shut Down Report",
                                             @"Invoiced %",
                                             @"Should Invoice %",
                                             @"Project and Financial Notes"];
}

-(void)initializeRepairReportHeaders {
    self.repairActiveReportHeaders = @[
                                       @"MCS Number",
                                       @"Stage",
                                       @"Warehouse",
                                       @"Item",
                                       @"Project Scope",
                                       @"Project Classification",
                                       @"Manager",
                                       @"Supervisor",
                                       @"Region",
                                       @"Project Status",
                                       @"Scheduled Start Date",
                                       @"Scheduled Turn Over",
                                       @"Actual Turn Over",
                                       @"Type",
                                       @"As-Builts",
                                       @"Alarm/HVAC Form",
                                       @"Air Gas",
                                       @"Permits Closed",
                                       @"Verisae/Shut Down Report",
                                       @"Invoiced %",
                                       @"Should Invoice %",
                                       @"Project and Financial Notes"];
}

-(void)initializeHVACReportHeaders {
    self.hvacActiveReportHeaders = @[
                                     @"Warehouse",
                                     @"Item",
                                     @"Project Scope",
                                     @"Region",
                                     @"Project Status",
                                     @"Scheduled Start Date",
                                     @"Project and Financial Notes"];
    
    self.hvacProposalReportHeaders = @[
                                       @"Warehouse",
                                       @"Item",
                                       @"Project Scope",
                                       @"Region",
                                       @"Project Status",
                                       @"Initiated Date",
                                       @"Site Survey",
                                       @"Costco Due Date",
                                       @"Proposal Submitted"];
}

-(NSArray *)projectInformationForReport:(NSString *)report andReportType:(ReportType)reportType {
    NSArray *returnArray;
    [database connectToDatabase];
    if ([report isEqualToString:@"Weekly"]) {
        returnArray = [database fetchWeeklyReportWithReportType:reportType];
    } else if ([report isEqualToString:@"Steve Meyer"]) {
        returnArray = [database fetchSteveMeyerReportWithReportType:reportType];
    } else if ([report isEqualToString:@"South East Refrigeration"]) {
        returnArray = [database fetchSouthEastReportWithReportType:reportType];
    } else if ([report isEqualToString:@"North East Refrigeration"]) {
        returnArray = [database fetchNorthEastReportWithReportType:reportType];
    } else if ([report isEqualToString:@"J Dempsey"]) {
        returnArray = [database fetchJDempseyReportWithReportType:reportType];
    } else if ([report isEqualToString:@"Invoice"]) {
        returnArray = [database fetchInvoiceReportWithReportType:reportType];
    } else if ([report isEqualToString:@"Completed"]) {
        returnArray = [database fetchCompletedReportWithReportType:reportType];
    } else if ([report isEqualToString:@"Construction"]) {
        returnArray = [database fetchConstructionReportWithReportType:reportType];
    } else if ([report isEqualToString:@"Repair"]) {
        returnArray = [database fetchRepairReportWithReportType:reportType];
    } else {
        returnArray = [database fetchHVACReportWithReportType:reportType];
    }
    database.databaseConnection = nil;
    
    return returnArray;
}

@end
