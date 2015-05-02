//
//  Trigger.m
//  MillerConstruction
//
//  Created by David Brooks on 5/1/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import "Trigger.h"

@implementation Trigger

-(id)initWithProjectID:(NSNumber *)projectID andProjectInfo:(NSString *)projectInfo andTriggerInfo:(NSString *)triggerInfo {
    if (self = [super init]) {
        [self setProjectID:projectID];
        [self setProjectInfo:projectInfo];
        [self setTriggerInfo:triggerInfo];
    }
    
    return self;
}

@end
