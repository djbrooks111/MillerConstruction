//
//  Warehouse.m
//  MillerConstruction
//
//  Created by David Brooks on 3/23/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import "Warehouse.h"

@implementation Warehouse

/**
 *  Custom initializer
 *
 *  @param name  Warehouse's name
 *  @param value Warehouse's value
 *
 *  @return Initialized Warehouse
 */
-(id)initWithName:(NSString *)name andValue:(int)value {
    if (self = [super init]) {
        [self setName:name];
        [self setValue:value];
    }
    
    return self;
}

/**
 *  Checks if the provided name is equal to this Warehouse's name
 *
 *  @param otherName Name of other Warehouse to be checked
 *
 *  @return true if the names match, false otherwise
 */
-(BOOL)isWarehouseNameEqual:(NSString *)otherName {
    if ([self.name isEqualToString:otherName]) {
        // Same name
        return true;
    } else {
        // Different name
        return false;
    }
}

@end
