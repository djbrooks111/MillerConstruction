//
//  ProjectItem.m
//  MillerConstruction
//
//  Created by David Brooks on 3/25/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import "ProjectItem.h"

@implementation ProjectItem

/**
 *  Custom initializer
 *
 *  @param rowID ProjectItem's rowId
 *  @param name  ProjectItem's name
 *
 *  @return Initialized ProjectItem
 */
-(id)initWithRowID:(NSNumber *)rowID andName:(NSString *)name {
    if (self = [super init]) {
        [self setRowID:rowID];
        [self setName:name];
    }
    
    return self;
}

@end
