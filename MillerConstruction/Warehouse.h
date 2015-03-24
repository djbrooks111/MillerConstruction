//
//  Warehouse.h
//  MillerConstruction
//
//  Created by David Brooks on 3/23/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Warehouse : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, readwrite) int value;

-(id)initWithName:(NSString *)name andValue:(int)value;
-(BOOL)isWarehouseNameEqual:(NSString *)otherName;

@end
