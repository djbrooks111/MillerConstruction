//
//  ViewExistingProjectTableViewController.m
//  MillerConstruction
//
//  Created by David Brooks on 4/6/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import "ViewExistingProjectTableViewController.h"
#import "ProjectHelper.h"
#import "JGProgressHUD.h"
#import "ProjectTableViewCell.h"
#import "ActionSheetStringPicker.h"
#import "ActionSheetDatePicker.h"

#define NUMBER_CELLS 33

@interface ViewExistingProjectTableViewController ()

@end

@implementation ViewExistingProjectTableViewController {
    ProjectHelper *helper;
    NSMutableArray *cellArray;
    NSMutableArray *projectStrings;
    NSArray *projectAttributesNames;
    NSArray *requiredInformation;
    NSArray *optionalInformation;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"id: %@", self.projectID);
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editProject:)];
    [self.navigationItem setRightBarButtonItem:editButton];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationItem.title = @"View Project";
    
    JGProgressHUD *HUD = self.prototypeHUD;
    HUD.textLabel.text = @"Loading data...";
    [HUD showInView:self.view];
    helper = [[ProjectHelper alloc] init];
    [helper setProjectID:self.projectID];
    [helper getProjectInformationFromDatabase];
    projectAttributesNames = [helper projectAttributesNames];
    requiredInformation = [projectAttributesNames subarrayWithRange:NSMakeRange(0, 10)];
    optionalInformation = [projectAttributesNames subarrayWithRange:NSMakeRange(10, 23)];
    
    cellArray = [[NSMutableArray alloc] initWithArray:[helper projectInformation]];
    projectStrings = [[NSMutableArray alloc] initWithArray:[helper projectInformation]];
    
    /*
    cellArray = [[NSMutableArray alloc] initWithCapacity:NUMBER_CELLS];
    projectStrings = [[NSMutableArray alloc] initWithCapacity:NUMBER_CELLS];
    for (int i = 0; i < NUMBER_CELLS; i++) {
        [cellArray addObject:[NSNull null]];
        [projectStrings addObject:[NSNull null]];
    }
     */
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
    
    [HUD dismissAfterDelay:1.5];
    
    [self.tableView reloadData];
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

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
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
        return @"Required Information";
    } else {
        return @"Optional Information";
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSArray *usedArray;
    if (indexPath.section == 0) {
        usedArray = requiredInformation;
    } else {
        usedArray = optionalInformation;
    }
    cell.label.text = [usedArray objectAtIndex:indexPath.row];
    int cellTag = [[NSString stringWithFormat:@"%ld%ld", (long)indexPath.section + 5, (long)indexPath.row] intValue];
    [cell.textField setTag:cellTag];
    int index = cellTag;
    if (index <= 59) {
        // Section 0
        index = [[[NSString stringWithFormat:@"%d", index] substringFromIndex:1] intValue];
    } else {
        index = [[[NSString stringWithFormat:@"%d", index] substringFromIndex:1] intValue] + 10;
    }
    if ([projectStrings objectAtIndex:index] == [NSNull null]) {
        [cell.textField setText:@""];
    } else {
        [cell.textField setText:[projectStrings objectAtIndex:index]];
    }
    [cell.textField setDelegate:self];
    [cell.textField setReturnKeyType:UIReturnKeyDone];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (indexPath.section == 0) {
        // Section 0 - Required Information
        [cell.textField removeTarget:nil action:NULL forControlEvents:UIControlEventEditingDidBegin];
        if (indexPath.row == 1) {
            // Warehouse
            [cell.textField addTarget:nil action:@selector(warehouseTextFieldActive:) forControlEvents:UIControlEventEditingDidBegin];
        } else if (indexPath.row == 2) {
            // Project Classification
            [cell.textField addTarget:nil action:@selector(projectClassificationTextFieldActive:) forControlEvents:UIControlEventEditingDidBegin];
        } else if (indexPath.row == 3) {
            // Project
            [cell.textField addTarget:nil action:@selector(projectTextFieldActive:) forControlEvents:UIControlEventEditingDidBegin];
        } else if (indexPath.row == 4) {
            // Project Manager
            [cell.textField addTarget:nil action:@selector(projectManagerTextFieldActive:) forControlEvents:UIControlEventEditingDidBegin];
        } else if (indexPath.row == 5) {
            // Project Supervisor
            [cell.textField addTarget:nil action:@selector(projectSupervisorTextFieldActive:) forControlEvents:UIControlEventEditingDidBegin];
        } else if (indexPath.row == 6) {
            // Project Stage
            [cell.textField addTarget:nil action:@selector(projectStageTextFieldActive:) forControlEvents:UIControlEventEditingDidBegin];
        } else if (indexPath.row == 7) {
            // Project Status
            [cell.textField addTarget:nil action:@selector(projectStatusTextFieldActive:) forControlEvents:UIControlEventEditingDidBegin];
        } else if (indexPath.row == 8) {
            // Project Type
            [cell.textField addTarget:nil action:@selector(projectTypeTextFieldActive:) forControlEvents:UIControlEventEditingDidBegin];
        }
    } else if (indexPath.section == 1) {
        // Section 1 - Optional Information
        [cell.textField removeTarget:nil action:NULL forControlEvents:UIControlEventEditingDidBegin];
        if (indexPath.row <= 15) {
            [cell.textField addTarget:nil action:@selector(dateTextFieldActive:) forControlEvents:UIControlEventEditingDidBegin];
        }
    }
    
    return cell;
}

#pragma mark - UITextFieldDelegate

-(void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"textFieldDidEndEditing: %d", [textField tag]);
    if ([textField tag] == 50) {
        // MCS Project #
        [cellArray replaceObjectAtIndex:0 withObject:[NSNumber numberWithInteger:[[textField text] integerValue]]];
        [projectStrings replaceObjectAtIndex:0 withObject:[textField text]];
    } else if ([textField tag] == 59) {
        // Project Scope
        [cellArray replaceObjectAtIndex:9 withObject:[textField text]];
        [projectStrings replaceObjectAtIndex:9 withObject:[textField text]];
    } else if ([textField tag] >= 616) {
        // Non-date fields in section 1
        int index = [[[NSString stringWithFormat:@"%d", [textField tag] + 10] substringFromIndex:1] intValue];
        [cellArray replaceObjectAtIndex:index withObject:[textField text]];
        [projectStrings replaceObjectAtIndex:index withObject:[textField text]];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"textFieldShouldReturn: %d", [textField tag]);
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - UITextField methods

/**
 *  Displays an ActionSheetStringPicker when the Warehouse UITextField is clicked
 *
 *  @param textField The Warehouse UITextField
 */
-(void)warehouseTextFieldActive:(UITextField *)textField {
    [textField resignFirstResponder];
    [ActionSheetStringPicker showPickerWithTitle:@"Set Warehouse" rows:[helper warehouseNamesArray] initialSelection:0 target:self successAction:@selector(warehousePicked:element:) cancelAction:nil origin:textField];
}

/**
 *  Callback method from the ActionSheetStringPicker
 *
 *  @param selectedIndex The selected index of the Warehouse
 *  @param sender        The Warehouse UITextField
 */
-(void)warehousePicked:(NSNumber *)selectedIndex element:(UITextField *)sender {
    NSArray *warehouseNamesArray = [helper warehouseNamesArray];
    [sender setText:[warehouseNamesArray objectAtIndex:[selectedIndex integerValue]]];
    [self insertObject:[helper rowIDOfWarehouseFromFullName:[sender text]] intoArrayWithTag:[sender tag]];
    [self addObjectToProjectStrings:[sender text] withTag:[sender tag]];
}

/**
 *  Displays an ActionSheetStringPicker when the Project Classification UITextField is clicked
 *
 *  @param textField The Project Classification UITextField
 */
-(void)projectClassificationTextFieldActive:(UITextField *)textField {
    [textField resignFirstResponder];
    [ActionSheetStringPicker showPickerWithTitle:@"Set Project Classification" rows:[helper projectClassificationNameArray] initialSelection:0 target:self successAction:@selector(projectClassificationPicked:element:) cancelAction:nil origin:textField];
}

/**
 *  Callback method from the ActionSheetStringPicker
 *
 *  @param selectedIndex The selected index of the Project Classification
 *  @param sender        The Project Classification UITextField
 */
-(void)projectClassificationPicked:(NSNumber *)selectedIndex element:(UITextField *)sender {
    NSArray *projectClassificationNameArray = [helper projectClassificationNameArray];
    [sender setText:[projectClassificationNameArray objectAtIndex:[selectedIndex integerValue]]];
    [self insertObject:[helper rowIDOfProjectClassificationFromName:[sender text]] intoArrayWithTag:[sender tag]];
    [self addObjectToProjectStrings:[sender text] withTag:[sender tag]];
}

/**
 *  Displays an ActionSheetStringPicker when the Project UITextField is clicked
 *
 *  @param textField The Project UITextField
 */
-(void)projectTextFieldActive:(UITextField *)textField {
    [textField resignFirstResponder];
    [ActionSheetStringPicker showPickerWithTitle:@"Set Project" rows:[helper projectNameArray] initialSelection:0 target:self successAction:@selector(projectPicked:element:) cancelAction:nil origin:textField];
}

/**
 *  Callback method from the ActionSheetStringPicker
 *
 *  @param selectedIndex The selected index of the Project
 *  @param sender        The Project UITextField
 */
-(void)projectPicked:(NSNumber *)selectedIndex element:(UITextField *)sender {
    NSArray *projectNameArray = [helper projectNameArray];
    [sender setText:[projectNameArray objectAtIndex:[selectedIndex integerValue]]];
    [self insertObject:[helper rowIDOfProjectItemFromName:[sender text]] intoArrayWithTag:[sender tag]];
    [self addObjectToProjectStrings:[sender text] withTag:[sender tag]];
}

/**
 *  Displays an ActionSheetStringPicker when the Project Manager UITextField is clicked
 *
 *  @param textField The Project Manager UITextField
 */
-(void)projectManagerTextFieldActive:(UITextField *)textField {
    [textField resignFirstResponder];
    [ActionSheetStringPicker showPickerWithTitle:@"Set Project Manager" rows:[helper projectManagerNameArray] initialSelection:0 target:self successAction:@selector(projectManagerPicked:element:) cancelAction:nil origin:textField];
}

/**
 *  Callback method from the ActionSheetStringPicker
 *
 *  @param selectedIndex The selected index of the Project Manager
 *  @param sender        The Project Manager UITextField
 */
-(void)projectManagerPicked:(NSNumber *)selectedIndex element:(UITextField *)sender {
    NSArray *projectManagerNameArray = [helper projectManagerNameArray];
    [sender setText:[projectManagerNameArray objectAtIndex:[selectedIndex integerValue]]];
    [self insertObject:[helper rowIDOfProjectManagerFromName:[sender text]] intoArrayWithTag:[sender tag]];
    [self addObjectToProjectStrings:[sender text] withTag:[sender tag]];
}

/**
 *  Displays an ActionSheetStringPicker when the Project Supervisor UITextField is clicked
 *
 *  @param textField The Project Supervisor UITextField
 */
-(void)projectSupervisorTextFieldActive:(UITextField *)textField {
    [textField resignFirstResponder];
    [ActionSheetStringPicker showPickerWithTitle:@"Set Project Supervisor" rows:[helper projectSupervisorNameArray] initialSelection:0 target:self successAction:@selector(projectSupervisorPicked:element:) cancelAction:nil origin:textField];
}

/**
 *  Callback method from the ActionSheetStringPicker
 *
 *  @param selectedIndex The selected index of the Project Supervisor
 *  @param sender        The Project Supervisor UITextField
 */
-(void)projectSupervisorPicked:(NSNumber *)selectedIndex element:(UITextField *)sender {
    NSArray *projectSupervisorNameArray = [helper projectSupervisorNameArray];
    [sender setText:[projectSupervisorNameArray objectAtIndex:[selectedIndex integerValue]]];
    [self insertObject:[helper rowIDOfProjectSupervisorFromName:[sender text]] intoArrayWithTag:[sender tag]];
    [self addObjectToProjectStrings:[sender text] withTag:[sender tag]];
}

/**
 *  Displays an ActionSheetStringPicker when the Project Stage UITextField is clicked
 *
 *  @param textField The Project Stage UITextField
 */
-(void)projectStageTextFieldActive:(UITextField *)textField {
    [textField resignFirstResponder];
    [ActionSheetStringPicker showPickerWithTitle:@"Set Project Stage" rows:[helper projectStageNameArray] initialSelection:0 target:self successAction:@selector(projectStagePicked:element:) cancelAction:nil origin:textField];
}

/**
 *  Callback method from the ActionSheetStringPicker
 *
 *  @param selectedIndex The selected index of the Project Stage
 *  @param sender        The Project Stage UITextField
 */
-(void)projectStagePicked:(NSNumber *)selectedIndex element:(UITextField *)sender {
    NSArray *projectStageNameArray = [helper projectStageNameArray];
    [sender setText:[projectStageNameArray objectAtIndex:[selectedIndex integerValue]]];
    [self insertObject:[helper rowIDOfProjectStageFromName:[sender text]] intoArrayWithTag:[sender tag]];
    [self addObjectToProjectStrings:[sender text] withTag:[sender tag]];
}

/**
 *  Displays an ActionSheetStringPicker when the Project Status UITextField is clicked
 *
 *  @param textField The Project Status UITextField
 */
-(void)projectStatusTextFieldActive:(UITextField *)textField {
    [textField resignFirstResponder];
    [ActionSheetStringPicker showPickerWithTitle:@"Set Project Status" rows:[helper projectStatusNameArray] initialSelection:0 target:self successAction:@selector(projectStatusPicked:element:) cancelAction:nil origin:textField];
}

/**
 *  Callback method from the ActionSheetStringPicker
 *
 *  @param selectedIndex The selected index of the Project Status
 *  @param sender        The Project Status UITextField
 */
-(void)projectStatusPicked:(NSNumber *)selectedIndex element:(UITextField *)sender {
    NSArray *projectStatusNameArray = [helper projectStatusNameArray];
    [sender setText:[projectStatusNameArray objectAtIndex:[selectedIndex integerValue]]];
    [self insertObject:[helper rowIDOfProjectStatusFromName:[sender text]] intoArrayWithTag:[sender tag]];
    [self addObjectToProjectStrings:[sender text] withTag:[sender tag]];
}

/**
 *  Displays an ActionSheetStringPicker when the Project Type UITextField is clicked
 *
 *  @param textField The Project Type UITextField
 */
-(void)projectTypeTextFieldActive:(UITextField *)textField {
    [textField resignFirstResponder];
    [ActionSheetStringPicker showPickerWithTitle:@"Set Project Type" rows:[helper projectTypeNameArray] initialSelection:0 target:self successAction:@selector(projectTypePicked:element:) cancelAction:nil origin:textField];
}

/**
 *  Callback method from the ActionSheetStringPicker
 *
 *  @param selectedIndex The selected index of the Project Type
 *  @param sender        The Project Type UITextField
 */
-(void)projectTypePicked:(NSNumber *)selectedIndex element:(UITextField *)sender {
    NSArray *projectTypeNameArray = [helper projectTypeNameArray];
    [sender setText:[projectTypeNameArray objectAtIndex:[selectedIndex integerValue]]];
    [self insertObject:[helper rowIDOfProjectTypeFromName:[sender text]] intoArrayWithTag:[sender tag]];
    [self addObjectToProjectStrings:[sender text] withTag:[sender tag]];
}

/**
 *  Displays an ActionSheetDatePicker when any UITextField is clicked that needs to show a date
 *
 *  @param textField The UITextField that was clicked
 */
-(void)dateTextFieldActive:(UITextField *)textField {
    [textField resignFirstResponder];
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:now];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *morningStart = [calendar dateFromComponents:components];
    [ActionSheetDatePicker showPickerWithTitle:@"Set Date" datePickerMode:UIDatePickerModeDate selectedDate:morningStart target:self action:@selector(datePicked:element:) origin:textField cancelAction:nil];
}

/**
 *  Callback method from the ActionSheetDatePicker
 *
 *  @param selectedDate The selected date of the picker
 *  @param sender       The UITextField that was clicked
 */
-(void)datePicked:(NSDate *)selectedDate element:(UITextField *)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [sender setText:[dateFormatter stringFromDate:selectedDate]];
    [self insertObject:[sender text] intoArrayWithTag:[sender tag]];
    [self addObjectToProjectStrings:[sender text] withTag:[sender tag]];
}

#pragma mark - Editing and Saving

-(void)editProject:(UIBarButtonItem *)sender {
    if ([sender.title isEqualToString:@"Edit"]) {
        // Editing is shown
        // Enable editing
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(editProject:)];
        [self.navigationItem setRightBarButtonItem:saveButton];
    } else {
        // Saving is shown
        // Save project
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editProject:)];
        [self.navigationItem setRightBarButtonItem:editButton];
    }
}

/**
 *  Checks that all Required UITextFields have been filled out
 *
 *  @return true if all Required UITextFields have been filled out, false otherwise
 */
-(BOOL)isRequiredInformationFilled {
    for (int i = 0; i < [requiredInformation count]; i++) {
        if ([cellArray objectAtIndex:i] == [NSNull null]) {
            return false;
        }
    }
    
    return true;
}

-(void)insertObject:(id)anObject intoArrayWithTag:(int)theTag {
    if ([[[NSString stringWithFormat:@"%d", theTag] substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"5"]) {
        // Section 0
        int index = [[[NSString stringWithFormat:@"%d", theTag] substringFromIndex:1] intValue];
        [cellArray replaceObjectAtIndex:index withObject:anObject];
    } else {
        // Section 1
        int index = [[[NSString stringWithFormat:@"%d", theTag] substringFromIndex:1] intValue] + 10;
        [cellArray replaceObjectAtIndex:index withObject:anObject];
    }
}

-(void)addObjectToProjectStrings:(id)anObject withTag:(int)theTag {
    if ([[[NSString stringWithFormat:@"%d", theTag] substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"5"]) {
        // Section 0
        int index = [[[NSString stringWithFormat:@"%d", theTag] substringFromIndex:1] intValue];
        [projectStrings replaceObjectAtIndex:index withObject:anObject];
    } else {
        // Section 1
        int index = [[[NSString stringWithFormat:@"%d", theTag] substringFromIndex:1] intValue] + 10;
        [projectStrings replaceObjectAtIndex:index withObject:anObject];
    }
}

-(void)hideKeyboard {
    [self.view endEditing:YES];
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
