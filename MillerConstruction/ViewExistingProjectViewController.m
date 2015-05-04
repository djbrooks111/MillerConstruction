//
//  ViewExistingProjectViewController.m
//  MillerConstruction
//
//  Created by David Brooks on 4/6/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import "ViewExistingProjectViewController.h"
#import "ViewExistingProjectTableViewController.h"
#import "ViewExistingProjectSearchHelper.h"
#import "ActionSheetStringPicker.h"
#import "JGProgressHUD.h"

#define WAREHOUSE_INDEX 0
#define STAGE_INDEX 1
#define MAX_CRITERIA 2

@interface ViewExistingProjectViewController ()

@end

@implementation ViewExistingProjectViewController {
    ViewExistingProjectSearchHelper *helper;
    NSMutableArray *searchCriteria;
    NSArray *availableProjectItem;
    NSArray *availableProjectID;
    NSNumber *projectID;
}

#pragma mark - UIViewController Methods

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationItem.title = @"View Existing Project";
    
    JGProgressHUD *HUD = self.prototypeHUD;
    HUD.textLabel.text = @"Loading data...";
    [HUD showInView:self.view];
    helper = [[ViewExistingProjectSearchHelper alloc] init];
    searchCriteria = [[NSMutableArray alloc] initWithCapacity:MAX_CRITERIA];
    for (int i = 0; i < MAX_CRITERIA; i++) {
        [searchCriteria addObject:[NSNull null]];
    }
    
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

#pragma mark - IBActions

/**
 *  Displays an ActionSheetStringPicker when the Warehouse UIButton is pressed
 *
 *  @param sender The Warehouse UIButton
 */
-(void)selectWarehouse:(UIButton *)sender {
    [ActionSheetStringPicker showPickerWithTitle:@"Pick Warehouse" rows:[helper warehouseNamesArray] initialSelection:0 target:self successAction:@selector(warehousePicked:element:) cancelAction:nil origin:sender];
}

/**
 *  Displays an ActionSheetStringPicker when the Project Stage UIButton is pressed
 *
 *  @param sender The Project Stage UIButton
 */
-(void)selectProjectStage:(UIButton *)sender {
    [ActionSheetStringPicker showPickerWithTitle:@"Pick Project Stage" rows:[helper projectStageNameArray] initialSelection:0 target:self successAction:@selector(projectStagePicked:element:) cancelAction:nil origin:sender];
}

/**
 *  Searches the database for projects matching the search criteria
 *
 *  @param sender The UIButton that called this method
 */
-(void)searchForProject:(UIButton *)sender {
    if ([self isSearchCriteriaValid]) {
        // Valid criteria, look for a project
        NSArray *availableProjects = [helper availableProjectsForWarehouseID:[searchCriteria objectAtIndex:WAREHOUSE_INDEX] andProjectStageID:[searchCriteria objectAtIndex:STAGE_INDEX]];
        if ([availableProjects count] == 0) {
            // No available projects
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Matching Projects" message:@"There are no projects matching your search criteria" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            [alert show];
        } else {
            // Available projects
            availableProjectItem = [availableProjects valueForKey:@"name"];
            availableProjectID = [availableProjects valueForKey:@"project.id"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Choose A Project" message:@"Choose a project you would like to look at." delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            for (int i = 0; i < [availableProjectItem count]; i++) {
                [alert addButtonWithTitle:[NSString stringWithFormat:@"%@ - %@", [self.warehouseTextField text], [availableProjectItem objectAtIndex:i]]];
            }
            [alert show];
        }
    } else {
        // Invalid criteria
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Required Information" message:@"You must select a Warehouse and a Project Stage" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - Search Criteria Validation

/**
 *  Checks that both the warehouse and project stage have been filled out
 *
 *  @return true is both have been filled out, false otherwise
 */
-(BOOL)isSearchCriteriaValid {
    for (int i = 0; i < [searchCriteria count]; i++) {
        if ([searchCriteria objectAtIndex:i] == [NSNull null]) {
            return  false;
        }
    }
    
    return true;
}

#pragma mark - ActionSheet Callbacks

/**
 *  Callback method from the ActionSheetStringPicker
 *
 *  @param selectedIndex The selected index of the Warehouse
 *  @param sender        The Warehouse UIButton
 */
-(void)warehousePicked:(NSNumber *)selectedIndex element:(UIButton *)sender {
    NSString *warehouseFullName = [[helper warehouseNamesArray] objectAtIndex:[selectedIndex integerValue]];
    [self.warehouseTextField setText:warehouseFullName];
    [searchCriteria replaceObjectAtIndex:WAREHOUSE_INDEX withObject:[helper rowIDOfWarehouseFromFullName:warehouseFullName]];
}

/**
 *  Callback method from the ActionSheetStringPicker
 *
 *  @param selectedIndex The selected index of the Project Stage
 *  @param sender        The Project Stage UIButton
 */
-(void)projectStagePicked:(NSNumber *)selectedIndex element:(UIButton *)sender {
    NSString *projectStageName = [[helper projectStageNameArray] objectAtIndex:[selectedIndex integerValue]];
    [self.stageTextField setText:projectStageName];
    [searchCriteria replaceObjectAtIndex:STAGE_INDEX withObject:[helper rowIDOfProjectStageFromName:projectStageName]];
}

#pragma mark - UIAlertViewDelegate

/**
 *  UIAlertView Delegate Callback
 *
 *  @param alertView   The UIAlertView
 *  @param buttonIndex The index of the button clicked to dismiss the alert
 */
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    projectID = [availableProjectID objectAtIndex:buttonIndex];
    [self.warehouseTextField setText:@""];
    [self.stageTextField setText:@""];
    [self performSegueWithIdentifier:@"viewProject" sender:self];
}

#pragma mark - Navigation

/**
 *  Called right before this view segues to another view
 *
 *  @param segue  The Storyboard segue
 *  @param sender This view controller
 */
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"viewProject"]) {
        ViewExistingProjectTableViewController *viewController = [segue destinationViewController];
        [viewController setProjectID:projectID];
    }
}

@end
