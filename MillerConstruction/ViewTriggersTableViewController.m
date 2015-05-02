//
//  ViewTriggersTableViewController.m
//  MillerConstruction
//
//  Created by David Brooks on 4/16/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import "ViewTriggersTableViewController.h"
#import "ViewTriggersHelper.h"
#import "Trigger.h"
#import "ViewExistingProjectTableViewController.h"
#import "JGProgressHUD.h"

@interface ViewTriggersTableViewController ()

@end

@implementation ViewTriggersTableViewController {
    ViewTriggersHelper *helper;
    NSNumber *selectedProjectID;
    JGProgressHUD *HUD;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"View Triggers";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoaded:) name:@"DataLoaded" object:nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    helper = [[ViewTriggersHelper alloc] init];
    HUD = self.prototypeHUD;
    HUD.textLabel.text = @"Loading data...";
    [HUD showInView:self.view];
    [helper lookForTriggers];
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
    JGProgressHUD *HUDD = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleDark];
    HUDD.interactionType = JGProgressHUDInteractionTypeBlockAllTouches;
    HUDD.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
    HUDD.HUDView.layer.shadowColor = [UIColor blackColor].CGColor;
    HUDD.HUDView.layer.shadowOffset = CGSizeZero;
    HUDD.HUDView.layer.shadowOpacity = 0.4f;
    HUDD.HUDView.layer.shadowRadius = 8.0f;
    
    return HUDD;
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
        NSLog(@"info count: %d", [[helper infoTriggers] count]);
        
        return [[helper infoTriggers] count];
    } else if (section == 1) {
        return [[helper warningTriggers] count];
    } else {
        return [[helper severeTriggers] count];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Info";
    } else if (section == 1) {
        return @"Warning";
    } else {
        return @"Severe";
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    // Configure the cell...
    if (indexPath.section == 0) {
        // Info
        [cell.textLabel setText:[[[helper infoTriggers] objectAtIndex:indexPath.row] projectInfo]];
        [cell.detailTextLabel setText:[[[helper infoTriggers] objectAtIndex:indexPath.row] triggerInfo]];
    } else if (indexPath.section == 1) {
        // Warning
        [cell.textLabel setText:[[[helper warningTriggers] objectAtIndex:indexPath.row] projectInfo]];
        [cell.detailTextLabel setText:[[[helper warningTriggers] objectAtIndex:indexPath.row] triggerInfo]];
    } else {
        // Severe
        [cell.textLabel setText:[[[helper severeTriggers] objectAtIndex:indexPath.row] projectInfo]];
        [cell.detailTextLabel setText:[[[helper severeTriggers] objectAtIndex:indexPath.row] triggerInfo]];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        // Info
        selectedProjectID = [[[helper infoTriggers] objectAtIndex:indexPath.row] projectID];
    } else if (indexPath.section == 1) {
        // Warning
        selectedProjectID = [[[helper warningTriggers] objectAtIndex:indexPath.row] projectID];
    } else {
        // Severe
        selectedProjectID = [[[helper severeTriggers] objectAtIndex:indexPath.row] projectID];
    }
    [self performSegueWithIdentifier:@"viewProject" sender:self];
}

-(void)dataLoaded:(NSNotification *)notification {
    [HUD dismissAfterDelay:1.5];
    [self.tableView reloadData];
    NSLog(@"reloaded");
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"viewProject"]) {
        ViewExistingProjectTableViewController *viewController = [segue destinationViewController];
        [viewController setProjectID:selectedProjectID];
    }
}

@end
