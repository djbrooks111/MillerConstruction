//
//  NewProjectHelper.h
//  MillerConstruction
//
//  Created by David Brooks on 3/23/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewProjectHelper : NSObject

@property (nonatomic, retain) NSArray *warehouseArray;
@property (nonatomic, retain) NSArray *warehouseNamesArray;

@property (nonatomic, retain) NSArray *projectClassificationArray;
@property (nonatomic, retain) NSArray *projectClassificationNameArray;

@property (nonatomic, retain) NSArray *projectArray;
@property (nonatomic, retain) NSArray *projectNameArray;

@property (nonatomic, retain) NSArray *projectManagerArray;
@property (nonatomic, retain) NSArray *projectManagerNameArray;

@property (nonatomic, retain) NSArray *projectSupervisorArray;
@property (nonatomic, retain) NSArray *projectSupervisorNameArray;

@property (nonatomic, retain) NSArray *projectStageArray;
@property (nonatomic, retain) NSArray *projectStageNameArray;

@property (nonatomic, retain) NSArray *projectStatusArray;
@property (nonatomic, retain) NSArray *projectStatusNameArray;

@property (nonatomic, retain) NSArray *projectTypeArray;
@property (nonatomic, retain) NSArray *projectTypeNameArray;

@property (nonatomic, retain) NSArray *projectAttributesNames;
@property (nonatomic, retain) NSArray *projectAttributesKeys;

-(void)initializeProjectAttributesNamesArray;
-(void)initializeProjectAttributesKeysArray;
-(void)initializeWarehouseArrays;
-(void)initializeProjectClassificationArray;
-(void)initializeProjectArray;
-(void)initializeProjectManagerArray;
-(void)initializeProjectSupervisorArray;
-(void)initializeProjectStageArray;
-(void)initializeProjectStatusArray;
-(void)initializeProjectTypeArray;

-(NSNumber *)rowIDOfWarehouseFromFullName:(NSString *)fullName;
-(NSNumber *)rowIDOfProjectClassificationFromName:(NSString *)name;
-(NSNumber *)rowIDOfProjectItemFromName:(NSString *)name;
-(NSNumber *)rowIDOfProjectManagerFromName:(NSString *)name;
-(NSNumber *)rowIDOfProjectSupervisorFromName:(NSString *)name;
-(NSNumber *)rowIDOfProjectStageFromName:(NSString *)name;
-(NSNumber *)rowIDOfProjectStatusFromName:(NSString *)name;
-(NSNumber *)rowIDOfProjectTypeFromName:(NSString *)name;

// Init used for testing only
-(id)initForTesting;

@end
