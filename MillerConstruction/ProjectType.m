//
//  ProjectType.m
//  MillerConstruction
//
//  Created by David Brooks on 3/29/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import "ProjectType.h"

@implementation ProjectType

/**
 *  Custom initializer
 *
 *  @param rowID ProjectType's rowID
 *  @param name  ProjectType's name
 *
 *  @return Initialized ProjectType
 */
-(id)initWithRowID:(NSNumber *)rowID andName:(NSString *)name {
    if (self = [super init]) {
        [self setRowID:rowID];
        [self setName:name];
    }
    
    return self;
}

@end
