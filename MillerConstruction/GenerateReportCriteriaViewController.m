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
    [HUD dismissAfterDelay:1.5];
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

-(void)selectAReport:(UIButton *)sender {
    [ActionSheetStringPicker showPickerWithTitle:@"Pick a Report" rows:[helper reportNamesArray] initialSelection:0 target:self successAction:@selector(reportPicked:element:) cancelAction:nil origin:sender];
}

-(void)reportPicked:(NSNumber *)selectedIndex element:(UIButton *)sender {
    report = [[helper reportNamesArray] objectAtIndex:[selectedIndex intValue]];
    [self.reportTypeTextField setText:report];
}

-(void)generateReport:(UIButton *)sender {
    reportType = [sender tag];
    [self performSegueWithIdentifier:@"generateReport" sender:self];
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"generateReport"]) {
        GenerateReportViewController *viewController = [segue destinationViewController];
        [viewController setReportType:reportType];
        [viewController setReport:report];
    }
}

@end
