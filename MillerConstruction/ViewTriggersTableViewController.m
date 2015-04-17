//
//  ViewTriggersTableViewController.m
//  MillerConstruction
//
//  Created by David Brooks on 4/16/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import "ViewTriggersTableViewController.h"
#import "ViewTriggersHelper.h"

@interface ViewTriggersTableViewController ()

@end

@implementation ViewTriggersTableViewController {
    ViewTriggersHelper *helper;
    NSMutableArray *infoProjects;
    NSMutableArray *warningProjects;
    NSMutableArray *severeProjects;
    NSMutableArray *infoProjectDetail;
    NSMutableArray *warningProjectDetail;
    NSMutableArray *severeProjectDetail;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"View Triggers";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    helper = [[ViewTriggersHelper alloc] init];
    [helper lookForTriggers];
    [infoProjects addObjectsFromArray:[helper infoMCSNumberProjects]];
    [infoProjects addObjectsFromArray:[helper infoCostcoProjects]];
    [infoProjects addObjectsFromArray:[helper infoTurnOverProjects]];
    [infoProjects addObjectsFromArray:[helper infoProjectsStartingSoon]];
    for (int i = 0; i < [infoProjects count]; i++) {
        if (i < [[helper infoMCSNumberProjects] count]) {
            [infoProjectDetail addObject:@"MCS Number not assigned"];
        } else if (i < [[helper infoCostcoProjects] count] + [[helper infoMCSNumberProjects] count]) {
            [infoProjectDetail addObject:@"Costco due date is unassigned"];
        } else if (i < [[helper infoTurnOverProjects] count] + [[helper infoCostcoProjects] count] + [[helper infoMCSNumberProjects] count]) {
            [infoProjectDetail addObject:@"Turn over is unassigned"];
        } else {
            [infoProjectDetail addObject:@"Project starting within two weeks"];
        }
    }
    [warningProjects addObjectsFromArray:[helper warningInvoiceProjects]];
    [warningProjects addObjectsFromArray:[helper warningProjectStartingSoon]];
    for (int i = 0; i < [warningProjects count]; i++) {
        if (i < [[helper warningInvoiceProjects] count]) {
            [warningProjectDetail addObject:@"Should Invoice/Actual Invoice Mismatch"];
        } else {
            [warningProjectDetail addObject:@"Project is starting with one week"];
        }
    }
    [severeProjects addObjectsFromArray:[helper severeProjects]];
    for (int i = 0; i < [severeProjects count]; i++) {
        [severeProjectDetail addObject:@"Turn over is within one day"];
    }
    
    [self.tableView reloadData];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
        return [infoProjects count];
    } else if (section == 1) {
        return [warningProjects count];
    } else {
        return [severeProjects count];
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
    // Configure the cell...
    if (indexPath.section == 0) {
        // Info Triggers
        NSDictionary *info = [infoProjects objectAtIndex:indexPath.row];
        [cell.textLabel setText:[NSString stringWithFormat:@"%@|%@|%@", [info valueForKey:@"mcsNumber"], [info valueForKey:@"city.name"], [info valueForKey:@"projectitem.name"]]];
        [cell.detailTextLabel setText:[infoProjectDetail objectAtIndex:indexPath.row]];
    } else if (indexPath.section == 1) {
        // Warning
        NSDictionary *warning = [warningProjects objectAtIndex:indexPath.row];
        [cell.textLabel setText:[NSString stringWithFormat:@"%@|%@|%@", [warning valueForKey:@"mcsNumber"], [warning valueForKey:@"city.name"], [warning valueForKey:@"projectitem.name"]]];
        [cell.detailTextLabel setText:[warningProjectDetail objectAtIndex:indexPath.row]];
    } else {
        // Severe
        NSDictionary *severe = [severeProjects objectAtIndex:indexPath.row];
        [cell.textLabel setText:[NSString stringWithFormat:@"%@|%@|%@", [severe valueForKey:@"mcsNumber"], [severe valueForKey:@"city.name"], [severe valueForKey:@"projectitem.name"]]];
        [cell.detailTextLabel setText:[severeProjectDetail objectAtIndex:indexPath.row]];
    }
    
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
