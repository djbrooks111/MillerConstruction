//
//  ViewTriggersHelper.h
//  MillerConstruction
//
//  Created by David Brooks on 4/16/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewTriggersHelper : NSObject

@property (nonatomic, retain) NSArray *infoMCSNumberProjects;
@property (nonatomic, retain) NSArray *infoCostcoProjects;
@property (nonatomic, retain) NSArray *infoTurnOverProjects;
@property (nonatomic, retain) NSArray *infoProjectsStartingSoon;
@property (nonatomic, retain) NSArray *warningInvoiceProjects;
@property (nonatomic, retain) NSArray *warningProjectStartingSoon;
@property (nonatomic, retain) NSArray *severeProjects;

-(void)lookForTriggers;

@end
