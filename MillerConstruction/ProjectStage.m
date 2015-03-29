//
//  ProjectStage.m
//  MillerConstruction
//
//  Created by David Brooks on 3/29/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import "ProjectStage.h"

@implementation ProjectStage

/**
 *  Custom initializer
 *
 *  @param rowID ProjectStage's rowID
 *  @param name  ProjectStage's name
 *
 *  @return Initialized ProjectStage
 */
-(id)initWithRowID:(NSNumber *)rowID andName:(NSString *)name {
    if (self = [super init]) {
        [self setRowID:rowID];
        [self setName:name];
    }
    
    return self;
}

@end
