//
//  GenerateReportSearchHelper.m
//  MillerConstruction
//
//  Created by David Brooks on 4/16/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import "GenerateReportSearchHelper.h"

@implementation GenerateReportSearchHelper

-(id)init {
    if (self = [super init]) {
        [self initializeReportNamesArray];
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
                              @"HVAC"
                              ];
}

@end
