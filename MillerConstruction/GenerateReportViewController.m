//
//  GenerateReportViewController.m
//  MillerConstruction
//
//  Created by David Brooks on 4/16/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import "GenerateReportViewController.h"

@interface GenerateReportViewController ()

@end

@implementation GenerateReportViewController {
    GenerateReportSearchHelper *helper;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    helper = [[GenerateReportSearchHelper alloc] init];
    
    int indexOfReport = [[helper reportNamesArray] indexOfObject:self.report];
    
    NSString *fetchCommand;
    switch (indexOfReport) {
        case 0:
            // Weekly
            fetchCommand = [NSString stringWithFormat:@"SELECT "];
            break;
            
        case 1:
            // Steve Meyer
            break;
            
        case 2:
            // South East Refrigeration
            break;
            
        case 3:
            // North East Refrigeration
            break;
            
        case 4:
            // J Dempsey
            break;
            
        case 5:
            // Invoice
            break;
            
        case 6:
            // Completed
            break;
            
        case 7:
            // Construction
            break;
            
        case 8:
            // Repair
            break;
            
        case 9:
            // HVAC
            break;
            
        default:
            break;
    }
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
