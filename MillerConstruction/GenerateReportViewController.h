//
//  GenerateReportViewController.h
//  MillerConstruction
//
//  Created by David Brooks on 4/16/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenerateReportSearchHelper.h"

@interface GenerateReportViewController : UIViewController 

@property (nonatomic, readwrite) ReportType reportType;
@property (nonatomic, retain) NSString *report;

@end
