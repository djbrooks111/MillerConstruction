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
// Weekly
@property (nonatomic, retain) NSArray *weeklyActiveReportHeaders;
@property (nonatomic, retain) NSArray *weeklyProposalReportHeaders;
@property (nonatomic, retain) NSArray *weeklyBudgetaryReportHeaders;
@property (nonatomic, retain) NSArray *weeklyInactiveReportHeaders;
@property (nonatomic, retain) NSArray *weeklyClosedReportHeaders;
// Steve Meyer
@property (nonatomic, retain) NSArray *steveMeyerActiveReportHeaders;
@property (nonatomic, retain) NSArray *steveMeyerProposalReportHeaders;
// South East Refrigeration
@property (nonatomic, retain) NSArray *southEastActiveReportHeaders;
@property (nonatomic, retain) NSArray *southEastProposalReportHeaders;
// North East Regrigeration
@property (nonatomic, retain) NSArray *northEastActiveReportHeaders;
@property (nonatomic, retain) NSArray *northEastProposalReportHeaders;
// J Dempsey
@property (nonatomic, retain) NSArray *jDempseyActiveReportHeaders;
@property (nonatomic, retain) NSArray *jDempseyProposalReportHeaders;
// Invoice
@property (nonatomic, retain) NSArray *invoiceActiveReportHeaders;
@property (nonatomic, retain) NSArray *invoiceProposalReportHeaders;
// Completed
@property (nonatomic, retain) NSArray *completedActiveReportHeaders;
// Construction
@property (nonatomic, retain) NSArray *constructionActiveReportHeaders;
// Repair
@property (nonatomic, retain) NSArray *repairActiveReportHeaders;
// HVAC
@property (nonatomic, retain) NSArray *hvacActiveReportHeaders;
@property (nonatomic, retain) NSArray *hvacProposalReportHeaders;

-(NSArray *)projectInformationForReport:(NSString *)report andReportType:(ReportType)reportType;

@end
