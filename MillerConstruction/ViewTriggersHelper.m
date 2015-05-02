//
//  ViewTriggersHelper.m
//  MillerConstruction
//
//  Created by David Brooks on 4/16/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import "ViewTriggersHelper.h"
#import "DatabaseConnector.h"
#import "Trigger.h"

@implementation ViewTriggersHelper {
    DatabaseConnector *database;
}

-(id)init {
    if (self = [super init]) {
        database = [DatabaseConnector sharedDatabaseConnector];
        self.infoTriggers = [[NSMutableArray alloc] init];
        self.warningTriggers = [[NSMutableArray alloc] init];
        self.severeTriggers = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(void)lookForTriggers {
    [database connectToDatabase];
    [self lookForInfoTriggers];
    [self lookForWarningTriggers];
    [self lookForSevereTriggers];
    database.databaseConnection = nil;
}

-(void)lookForInfoTriggers {
    // MCS Number Not Assigned
    NSArray *mcsNumberTriggers = [database fetchInfoMCSNumberTriggers];
    for (int i = 0; i < [mcsNumberTriggers count]; i++) {
        NSDictionary *trigger = [mcsNumberTriggers objectAtIndex:i];
        NSString *projectInfo = [NSString stringWithFormat:@"%@|%@|%@", [trigger valueForKey:@"mcsNumber"], [trigger valueForKey:@"city.name"], [trigger valueForKey:@"projectitem.name"]];
        [self.infoTriggers addObject:[[Trigger alloc] initWithProjectID:[trigger valueForKey:@"project.id"] andProjectInfo:projectInfo andTriggerInfo:@"MCS Number Not Assigned"]];
    }
}

-(void)lookForWarningTriggers {
    // Should Invoice/Acutal Invoice Difference Less Than 20%
    NSArray *invoiceTriggers = [database fetchWarningInvoiceTriggers];
    for (int i = 0; i < [invoiceTriggers count]; i++) {
        NSDictionary *trigger = [invoiceTriggers objectAtIndex:i];
        NSString *projectInfo = [NSString stringWithFormat:@"%@|%@|%@", [trigger valueForKey:@"mcsNumber"], [trigger valueForKey:@"city.name"], [trigger valueForKey:@"projectitem.name"]];
        [self.warningTriggers addObject:[[Trigger alloc] initWithProjectID:[trigger valueForKey:@"project.id"] andProjectInfo:projectInfo andTriggerInfo:@"Should Invoice/Actual Invoice Difference Less Than 20%"]];
    }
    // Costco Due Date Is Within 3 Days
    NSArray *costcoDueDateTriggers = [database fetchWarningCostcoDueDateTriggers];
    for (int i = 0; i < [costcoDueDateTriggers count]; i++) {
        NSDictionary *trigger = [costcoDueDateTriggers objectAtIndex:i];
        NSString *projectInfo = [NSString stringWithFormat:@"%@|%@|%@", [trigger valueForKey:@"mcsNumber"], [trigger valueForKey:@"city.name"], [trigger valueForKey:@"projectitem.name"]];
        [self.warningTriggers addObject:[[Trigger alloc] initWithProjectID:[trigger valueForKey:@"project.id"] andProjectInfo:projectInfo andTriggerInfo:[NSString stringWithFormat:@"Costco Due Date: %@ Is Within 3 Days", [trigger valueForKey:@"costcoDueDate"]]]];
    }
    // Scheduled Turn Over has passed
    NSArray *turnOverTriggers = [database fetchWarningTurnOverTriggers];
    for (int i = 0; i < [turnOverTriggers count]; i++) {
        NSDictionary *trigger = [turnOverTriggers objectAtIndex:i];
        NSString *projectInfo = [NSString stringWithFormat:@"%@|%@|%@", [trigger valueForKey:@"mcsNumber"], [trigger valueForKey:@"city.name"], [trigger valueForKey:@"projectitem.name"]];
        [self.warningTriggers addObject:[[Trigger alloc] initWithProjectID:[trigger valueForKey:@"project.id"] andProjectInfo:projectInfo andTriggerInfo:@"Scheduled Turn Over Has Passed"]];
    }
}

-(void)lookForSevereTriggers {
    // Costco Due Date Has Passed
    NSArray *costcoDueDateTriggers = [database fetchSevereCostcoDueDateTriggers];
    for (int i = 0; i < [costcoDueDateTriggers count]; i++) {
        NSDictionary *trigger = [costcoDueDateTriggers objectAtIndex:i];
        NSString *projectInfo = [NSString stringWithFormat:@"%@|%@|%@", [trigger valueForKey:@"mcsNumber"], [trigger valueForKey:@"city.name"], [trigger valueForKey:@"projectitem.name"]];
        [self.severeTriggers addObject:[[Trigger alloc] initWithProjectID:[trigger valueForKey:@"project.id"] andProjectInfo:projectInfo andTriggerInfo:@"Costco Due Data Has Passed"]];
    }
    // Should Invoice/Actual Invoice Difference More Than 20%
    NSArray *invoiceTriggers = [database fetchSevereInvoiceTriggers];
    for (int i = 0; i < [invoiceTriggers count]; i++) {
        NSDictionary *trigger = [invoiceTriggers objectAtIndex:i];
        NSString *projectInfo = [NSString stringWithFormat:@"%@|%@|%@", [trigger valueForKey:@"mcsNumber"], [trigger valueForKey:@"city.name"], [trigger valueForKey:@"projectitem.name"]];
        [self.severeTriggers addObject:[[Trigger alloc] initWithProjectID:[trigger valueForKey:@"project.id"] andProjectInfo:projectInfo andTriggerInfo:@"Should Invoice/Actual Invoice Difference More Than 20%"]];
    }
}

@end
