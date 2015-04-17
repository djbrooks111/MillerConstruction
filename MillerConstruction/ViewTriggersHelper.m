//
//  ViewTriggersHelper.m
//  MillerConstruction
//
//  Created by David Brooks on 4/16/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import "ViewTriggersHelper.h"
#import "DatabaseConnector.h"

@implementation ViewTriggersHelper {
    DatabaseConnector *database;
}

-(id)init {
    if (self = [super init]) {
        database = [DatabaseConnector sharedDatabaseConnector];
    }
    
    return self;
}

-(void)lookForTriggers {
    [database connectToDatabase];
    self.infoMCSNumberProjects = [database fetchInfoMCSNumberTriggers];
    self.infoCostcoProjects = [database fetchInfoCostcoTriggers];
    self.infoTurnOverProjects = [database fetchInfoTurnOverTriggers];
    self.infoProjectsStartingSoon = [database fetchInfoProjectStartingSoonTriggers];
    self.warningInvoiceProjects = [database fetchWarningInvoiceTriggers];
    self.warningProjectStartingSoon = [database fetchWarningProjectStartingSoonTriggers];
    self.severeProjects = [database fetchSevereTriggers];
    database.databaseConnection = nil;
}

@end
