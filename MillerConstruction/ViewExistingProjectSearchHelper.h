//
//  ViewExistingProjectSearchHelper.h
//  MillerConstruction
//
//  Created by David Brooks on 4/6/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewExistingProjectSearchHelper : NSObject

@property (nonatomic, retain) NSArray *warehouseArray;
@property (nonatomic, retain) NSArray *warehouseNamesArray;

@property (nonatomic, retain) NSArray *projectStageArray;
@property (nonatomic, retain) NSArray *projectStageNameArray;

-(void)initializeWarehouseArrays;
-(void)initializeProjectStageArrays;

@end
