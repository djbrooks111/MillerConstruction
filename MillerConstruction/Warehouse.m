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
 *  @param rowID       Warehouse's rowID
 *  @param state       Warehouse's state
 *  @param warehouseID Warehouse's warehouseID
 *  @param city        Warehouse's city
 *
 *  @return Initialized Warehouse
 */
-(id)initWithRowID:(NSNumber *)rowID andState:(NSString *)state andWarehouseID:(NSNumber *)warehouseID andCity:(NSString *)city {
    if (self = [super init]) {
        [self setRowID:rowID];
        [self setState:state];
        if ([warehouseID longValue] == 4294967295) {
            warehouseID = [NSNumber numberWithInteger:-1];
        }
        [self setWarehouseID:warehouseID];
        [self setCity:city];
        [self setFullName:[[NSString alloc] initWithFormat:@"%@, %@ -- #%@", city, state, warehouseID]];
        //[self setFullName:[NSString stringWithFormat:@"%@, %@ -- #%@", city, state, warehouseID]];
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
    if ([self.fullName isEqualToString:otherName]) {
        // Same name
        return true;
    } else {
        // Different name
        return false;
    }
}

@end
