//
//  CreateNewProjectTableViewController.m
//  MillerConstruction
//
//  Created by David Brooks on 3/20/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import "CreateNewProjectTableViewController.h"
#import "ActionSheetStringPicker.h"
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
    
    self.navigationItem.title = @"Create New Project";
    
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
        return 23;
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
    NSArray *requiredInformation = [projectAttributesNames subarrayWithRange:NSMakeRange(0, 10)];
    NSArray *optionalInformation = [projectAttributesNames subarrayWithRange:NSMakeRange(10, 23)];
    NSArray *usedArray;
    if (indexPath.section == 0) {
        usedArray = requiredInformation;
    } else {
        usedArray = optionalInformation;
    }
    cell.label.text = [usedArray objectAtIndex:indexPath.row];
    cell.textField.text = @"";
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (indexPath.row == 1) {
        // Warehouse
        NSLog(@"added Target");
        [cell.textField addTarget:nil action:@selector(warehouseTextFieldActive:) forControlEvents:UIControlEventEditingDidBegin];
    }
    
    return cell;
}

#pragma mark - UITextField methods

/**
 *  Displays an ActionSheetStringPicker when the Warehouse UITextField is clicked
 *
 *  @param textField The Warehouse UITextField
 */
-(void)warehouseTextFieldActive:(UITextField *)textField {
    NSLog(@"Called method");
    [ActionSheetStringPicker showPickerWithTitle:@"Set Warehouse" rows:[newProjectHelper warehouseNamesArray] initialSelection:0 target:self successAction:@selector(warehousePicked:element:) cancelAction:nil origin:textField];
}

/**
 *  Callback method from the ActionSheetStringPicker
 *
 *  @param selectedIndex The selected index of the Warehouse
 *  @param sender        The object that called this method
 */
-(void)warehousePicked:(NSNumber *)selectedIndex element:(id)sender {
    UITextField *textField = (UITextField *)sender;
    NSArray *warehouseNamesArray = [newProjectHelper warehouseNamesArray];
    [textField setText:[warehouseNamesArray objectAtIndex:[selectedIndex integerValue]]];
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
    NSArray *keys = [newProjectHelper projectAttributesKeys];
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
