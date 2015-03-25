//
//  ProjectClassification.m
//  MillerConstruction
//
//  Created by David Brooks on 3/25/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import "ProjectClassification.h"

@implementation ProjectClassification

/**
 *  Custom initializer
 *
 *  @param rowID ID number of value in the database
 *  @param name  The name of the project classification
 *
 *  @return Initialized ProjectClassification
 */
-(id)initWithRowID:(NSNumber *)rowID andName:(NSString *)name {
    if (self = [super init]) {
        [self setRowID:rowID];
        [self setName:name];
    }
    
    return self;
}

@end
