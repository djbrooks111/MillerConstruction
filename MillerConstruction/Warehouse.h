//
//  Warehouse.h
//  MillerConstruction
//
//  Created by David Brooks on 3/23/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Warehouse : NSObject

@property (nonatomic, retain) NSNumber *rowID;
@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSNumber *warehouseID;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *fullName;

-(id)initWithRowID:(NSNumber *)rowID andState:(NSString *)state andWarehouseID:(NSNumber *)warehouseID andCity:(NSString *)city;
-(BOOL)isWarehouseNameEqual:(NSString *)otherName;

@end
