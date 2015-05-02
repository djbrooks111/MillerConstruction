//
//  GenerateReportSearchHelper.h
//  MillerConstruction
//
//  Created by David Brooks on 4/16/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GenerateReportSearchHelper : NSObject

#pragma mark - ReportType

typedef NS_ENUM(NSInteger, ReportType) {
    ActiveReport,
    ProposalReport,
    BudgetaryReport,
    InactiveReport,
    ClosedReport
};

@property (nonatomic, retain) NSArray *reportNamesArray;

-(NSArray *)projectInformationForReport:(NSString *)report andReportType:(ReportType)reportType;

@end
