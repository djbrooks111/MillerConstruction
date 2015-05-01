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
    NSArray *mcsNumberTriggers = [database fetchInfoMCSNumberTriggers];
    for (int i = 0; i < [mcsNumberTriggers count]; i++) {
        NSDictionary *trigger = [mcsNumberTriggers objectAtIndex:i];
        NSString *projectInfo = [NSString stringWithFormat:@"%@|%@|%@", [trigger valueForKey:@"mcsNumber"], [trigger valueForKey:@"city.name"], [trigger valueForKey:@"projectitem.name"]];
        [self.infoTriggers addObject:[[Trigger alloc] initWithProjectID:[trigger valueForKey:@"id"] andProjectInfo:projectInfo andTriggerInfo:@"MCS Number not assigned"]];
    }
}

-(void)lookForWarningTriggers {
    
}

-(void)lookForSevereTriggers {
    
}

@end
