//
//  CreateNewProjectTableViewController.m
//  MillerConstruction
//
//  Created by David Brooks on 3/20/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import "CreateNewProjectTableViewController.h"
#import "NewProjectHelper.h"
#import "NewProjectTableViewCell.h"
#import "DatabaseConnector.h"

@interface CreateNewProjectTableViewController ()

@end

@implementation CreateNewProjectTableViewController {
    NewProjectHelper *newProjectHelper;
    NSArray *projectAttributesNames;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    newProjectHelper = [[NewProjectHelper alloc] init];
    projectAttributesNames = [newProjectHelper projectAttributesNames];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Section 1 - Required, Section 2 - Optional
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
        return 10;
    } else {
        return 24;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Required Information:";
    } else {
        return @"Optional Information:";
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewProjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.label.text = [projectAttributesNames objectAtIndex:indexPath.row];
    cell.textField.text = @"";
    
    return cell;
}

#pragma mark - Save method

-(void)save:(UIButton *)sender {
    NSMutableArray *projectInformation = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.tableView numberOfSections]; i++) {
        NSIndexPath *index = [NSIndexPath indexPathWithIndex:i];
        NewProjectTableViewCell *cell = (NewProjectTableViewCell *)[self.tableView cellForRowAtIndexPath:index];
        NSString *labelText = [cell.label text];
        NSLog(@"%@", labelText);
        [projectInformation addObject:labelText];
    }
    
    DatabaseConnector *database = [DatabaseConnector sharedDatabaseConnector];
    BOOL result = [database addNewProject:projectInformation andKeys:keys];
    if (result == true) {
        // Success
    } else {
        // Failure
    }
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
