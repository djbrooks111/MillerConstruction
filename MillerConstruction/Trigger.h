//
//  Trigger.h
//  MillerConstruction
//
//  Created by David Brooks on 5/1/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Trigger : NSObject

@property (nonatomic, retain) NSString *projectInfo;
@property (nonatomic, retain) NSString *triggerInfo;
@property (nonatomic, retain) NSNumber *projectID;

-(id)initWithProjectID:(NSNumber *)projectID andProjectInfo:(NSString *)projectInfo andTriggerInfo:(NSString *)triggerInfo;

@end
