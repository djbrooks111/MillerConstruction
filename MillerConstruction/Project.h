//
//  Project.h
//  MillerConstruction
//
//  Created by David Brooks on 4/24/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Warehouse.h"
#import "ProjectClassification.h"
#import "ProjectItem.h"
#import "Person.h"
#import "ProjectStage.h"
#import "ProjectStatus.h"
#import "ProjectType.h"

@interface Project : NSObject

// Required Information
@property (nonatomic, retain) NSString *mcsNumber;
@property (nonatomic, retain) Warehouse *warehouse;
@property (nonatomic, retain) ProjectClassification *projectClassification;
@property (nonatomic, retain) ProjectItem *projectItem;
@property (nonatomic, retain) Person *manager;
@property (nonatomic, retain) Person *supervisor;
@property (nonatomic, retain) ProjectStage *projectStage;
@property (nonatomic, retain) ProjectStatus *projectStatus;
@property (nonatomic, retain) ProjectType *projectType;
@property (nonatomic, retain) NSString *projectScope;

// Optional Information
@property (nonatomic, retain) NSDate *projectInitiationDate;
@property (nonatomic, retain) NSDate *siteSurveyDate;
@property (nonatomic, retain) NSDate *costcoDueDate;
@property (nonatomic, retain) NSDate *proposalSubmittedDate;
@property (nonatomic, retain) NSDate *asBuiltsDate;
@property (nonatomic, retain) NSDate *punchListDate;
@property (nonatomic, retain) NSDate *alarmHVACFormDate;
@property (nonatomic, retain) NSDate *verisaeReportDate;
@property (nonatomic, retain) NSDate *closeoutNotesDate;
@property (nonatomic, retain) NSDate *scheduledStartDate;
@property (nonatomic, retain) NSDate *scheduledTurnoverDate;
@property (nonatomic, retain) NSDate *actualTurnoverDate;
@property (nonatomic, retain) NSDate *airGasDate;
@property (nonatomic, retain) NSDate *permitApplicationDate;
@property (nonatomic, retain) NSDate *permitsClosedDate;
@property (nonatomic, retain) NSDate *salvageValueDate;
@property (nonatomic, retain) NSString *salvageValueAmount;
@property (nonatomic, retain) NSString *shouldInvoiceAmount;
@property (nonatomic, retain) NSString *actualInvoiceAmount;
@property (nonatomic, retain) NSString *projectFinancialNotes;
@property (nonatomic, retain) NSString *zachNotes;
@property (nonatomic, retain) NSString *projectCost;
@property (nonatomic, retain) NSString *customerNumber;

@end
