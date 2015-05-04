//
//  GenerateReportCriteriaViewController.m
//  MillerConstruction
//
//  Created by David Brooks on 4/16/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import "GenerateReportCriteriaViewController.h"
#import "GenerateReportViewController.h"
#import "ActionSheetStringPicker.h"
#import "GenerateReportSearchHelper.h"
#import "JGProgressHUD.h"

@interface GenerateReportCriteriaViewController ()

@end

@implementation GenerateReportCriteriaViewController {
    GenerateReportSearchHelper *helper;
    ReportType reportType;
    NSString *report;
}

#pragma mark - UIViewController Methods

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.activeButton setTag:ActiveReport];
    [self.proposalsButton setTag:ProposalReport];
    [self.budgetaryButton setTag:BudgetaryReport];
    [self.inactiveButton setTag:InactiveReport];
    [self.closedButton setTag:ClosedReport];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationItem.title = @"Generate Report";
    
    JGProgressHUD *HUD = self.prototypeHUD;
    HUD.textLabel.text = @"Loading data...";
    [HUD showInView:self.view];
    helper = [[GenerateReportSearchHelper alloc] init];
    [HUD dismiss];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - JGProgressHUD

/**
 *  Creates a new JGProgressHUD
 *
 *  @return The new JGProgressHUD
 */
-(JGProgressHUD *)prototypeHUD {
    JGProgressHUD *HUD = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleDark];
    HUD.interactionType = JGProgressHUDInteractionTypeBlockAllTouches;
    HUD.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
    HUD.HUDView.layer.shadowColor = [UIColor blackColor].CGColor;
    HUD.HUDView.layer.shadowOffset = CGSizeZero;
    HUD.HUDView.layer.shadowOpacity = 0.4f;
    HUD.HUDView.layer.shadowRadius = 8.0f;
    
    return HUD;
}

/**
 *  Called when the user pressed the Select Report UIButton
 *
 *  @param sender The Select Report UIButton
 */
-(void)selectAReport:(UIButton *)sender {
    [ActionSheetStringPicker showPickerWithTitle:@"Pick a Report" rows:[helper reportNamesArray] initialSelection:0 target:self successAction:@selector(reportPicked:element:) cancelAction:nil origin:sender];
}

/**
 *  ActionSheetStringPicker callback method
 *
 *  @param selectedIndex The selected index of the picker
 *  @param sender        The button that called the picker
 */
-(void)reportPicked:(NSNumber *)selectedIndex element:(UIButton *)sender {
    report = [[helper reportNamesArray] objectAtIndex:[selectedIndex intValue]];
    [self.reportTypeTextField setText:report];
}

/**
 *  Validates user's report options and if valid, transitions to next view. It invalid, present alert to the user
 *
 *  @param sender The different report type buttons
 */
-(void)generateReport:(UIButton *)sender {
    reportType = [sender tag];
    if ([report isEqualToString:@""] || [self.reportTypeTextField.text isEqualToString:@""]) {
        // Invalid Criteria
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Criteria" message:@"You must select a report type first" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
    } else if ([report isEqualToString:@"Steve Meyer"] && (reportType == ClosedReport || reportType == InactiveReport || reportType == BudgetaryReport)) {
        // Invalid Report
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid report" message:@"That is not a valid report, choose again" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
    } else if ([report isEqualToString:@"South East Refrigeration"] && (reportType == ClosedReport || reportType == InactiveReport || reportType == BudgetaryReport)) {
        // Invalid Report
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid report" message:@"That is not a valid report, choose again" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
    } else if ([report isEqualToString:@"North East Refrigeration"] && (reportType == ClosedReport || reportType == InactiveReport || reportType == BudgetaryReport)) {
        // Invalid Report
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid report" message:@"That is not a valid report, choose again" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
    } else if ([report isEqualToString:@"J Dempsey"] && (reportType == ClosedReport || reportType == InactiveReport || reportType == BudgetaryReport)) {
        // Invalid Report
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid report" message:@"That is not a valid report, choose again" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
    } else if ([report isEqualToString:@"Invoice"] && (reportType == ClosedReport || reportType == InactiveReport || reportType == BudgetaryReport)) {
        // Invalid Report
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid report" message:@"That is not a valid report, choose again" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
    } else if ([report isEqualToString:@"Completed"] && reportType != ActiveReport) {
        // Invalid Report
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid report" message:@"That is not a valid report, choose again" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
    } else if ([report isEqualToString:@"Construction"] && reportType != ActiveReport) {
        // Invalid Report
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid report" message:@"That is not a valid report, choose again" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
    } else if ([report isEqualToString:@"Repair"] && reportType != ActiveReport) {
        // Invalid Report
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid report" message:@"That is not a valid report, choose again" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
    } else if ([report isEqualToString:@"HVAC"] && (reportType == ClosedReport || reportType == InactiveReport || reportType == BudgetaryReport)) {
        // Invalid Report
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid report" message:@"That is not a valid report, choose again" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        [self performSegueWithIdentifier:@"generateReport" sender:self];
    }
}

#pragma mark - Navigation

/**
 *  Called right before this view segues to another view
 *
 *  @param segue  The Storyboard segue
 *  @param sender This view controller
 */
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"generateReport"]) {
        GenerateReportViewController *viewController = [segue destinationViewController];
        [viewController setReportType:reportType];
        [viewController setReport:report];
    }
}

@end
