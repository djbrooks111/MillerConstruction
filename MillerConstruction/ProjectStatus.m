//
//  ProjectStatus.m
//  MillerConstruction
//
//  Created by David Brooks on 3/29/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import "ProjectStatus.h"

@implementation ProjectStatus

/**
 *  Custom initializer
 *
 *  @param rowID ProjectStatus' rowID
 *  @param name  ProjectStatus' name
 *
 *  @return Initialized ProjectStatus
 */
-(id)initWithRowID:(NSNumber *)rowID andName:(NSString *)name {
    if (self = [super init]) {
        [self setRowID:rowID];
        [self setName:name];
    }
    
    return self;
}

@end
