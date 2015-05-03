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
#import <JGProgressHUD/JGProgressHUDSuccessIndicatorView.h>
#import <JGProgressHUD/JGProgressHUDErrorIndicatorView.h>
#import "ProjectTableViewCell.h"
#import "ActionSheetStringPicker.h"
#import "ActionSheetDatePicker.h"
#import "DatabaseConnector.h"

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
    BOOL isEditing;
    JGProgressHUD *HUD;
    BOOL didHaveSalvageInDatabase;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editProject:)];
    [self.navigationItem setRightBarButtonItem:editButton];
    
    isEditing = FALSE;
    
    HUD = self.prototypeHUD;
    HUD.textLabel.text = @"Loading data...";
    [HUD showInView:self.view];
    [self.view bringSubviewToFront:HUD];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationItem.title = @"View Project";
    
    //HUD = self.prototypeHUD;
    //HUD.textLabel.text = @"Loading data...";
    //[HUD showInView:self.view];
    helper = [[ProjectHelper alloc] init];
    [helper setProjectID:self.projectID];
    [helper getProjectInformationFromDatabase];
    projectAttributesNames = [helper projectAttributesNames];
    requiredInformation = [projectAttributesNames subarrayWithRange:NSMakeRange(0, 10)];
    optionalInformation = [projectAttributesNames subarrayWithRange:NSMakeRange(10, 23)];
    if ([[helper projectInformation] objectAtIndex:25] != [NSNull null] || [[helper projectInformation] objectAtIndex:26] != [NSNull null]) {
        // Salvage has been created already
        didHaveSalvageInDatabase = TRUE;
    } else {
        didHaveSalvageInDatabase = FALSE;
    }
    
    cellArray = [[NSMutableArray alloc] initWithArray:[helper projectInformation]];
    projectStrings = [[NSMutableArray alloc] initWithArray:[helper projectInformation]];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
    
    [HUD dismiss];
    
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
        [cell.textField setText:[NSString stringWithFormat:@"%@", [projectStrings objectAtIndex:index]]];
    }
    [cell.textField setDelegate:self];
    [cell.textField setReturnKeyType:UIReturnKeyDone];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (isEditing) {
        // Allow editing, add targets
        [cell.textField setUserInteractionEnabled:TRUE];
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
    } else {
        [cell.textField removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
        [cell.textField setUserInteractionEnabled:FALSE];
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
        [saveButton setTintColor:[UIColor colorWithRed:117.0 / 255.0 green:6.0 / 255.0 blue:10.0 / 255.0 alpha:1.0]];
        [self.navigationItem setRightBarButtonItem:saveButton];
        isEditing = TRUE;
        [self.tableView reloadData];
    } else {
        // Saving is shown
        // Save project
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editProject:)];
        [editButton setTintColor:[UIColor colorWithRed:117.0 / 255.0 green:6.0 / 255.0 blue:10.0 / 255.0 alpha:1.0]];
        [self.navigationItem setRightBarButtonItem:editButton];
        isEditing = FALSE;
        [self.tableView reloadData];
        [self.view endEditing:YES];
        [self save];
    }
}

-(void)save {
    // MCS Project #
    if ([[cellArray objectAtIndex:0] isKindOfClass:[NSString class]]) {
        NSNumber *number = [NSNumber numberWithInteger:[[cellArray objectAtIndex:0] integerValue]];
        [cellArray replaceObjectAtIndex:0 withObject:number];
    }
    // Warehouse
    if ([[cellArray objectAtIndex:1] isKindOfClass:[NSString class]]) {
        [cellArray replaceObjectAtIndex:1 withObject:[helper rowIDOfWarehouseFromFullName:[cellArray objectAtIndex:1]]];
    }
    // Project CLassification
    if ([[cellArray objectAtIndex:2] isKindOfClass:[NSString class]]) {
        [cellArray replaceObjectAtIndex:2 withObject:[helper rowIDOfProjectClassificationFromName:[cellArray objectAtIndex:2]]];
    }
    // Project
    if ([[cellArray objectAtIndex:3] isKindOfClass:[NSString class]]) {
        [cellArray replaceObjectAtIndex:3 withObject:[helper rowIDOfProjectItemFromName:[cellArray objectAtIndex:3]]];
    }
    // Project Manager
    if ([[cellArray objectAtIndex:4] isKindOfClass:[NSString class]]) {
        [cellArray replaceObjectAtIndex:4 withObject:[helper rowIDOfProjectManagerFromName:[cellArray objectAtIndex:4]]];
    }
    // Supervisor
    if ([[cellArray objectAtIndex:5] isKindOfClass:[NSString class]]) {
        [cellArray replaceObjectAtIndex:5 withObject:[helper rowIDOfProjectSupervisorFromName:[cellArray objectAtIndex:5]]];
    }
    // Project Stage
    if ([[cellArray objectAtIndex:6] isKindOfClass:[NSString class]]) {
        [cellArray replaceObjectAtIndex:6 withObject:[helper rowIDOfProjectStageFromName:[cellArray objectAtIndex:6]]];
    }
    // Project Status
    if ([[cellArray objectAtIndex:7] isKindOfClass:[NSString class]]) {
        [cellArray replaceObjectAtIndex:7 withObject:[helper rowIDOfProjectStatusFromName:[cellArray objectAtIndex:7]]];
    }
    // Project Type
    if ([[cellArray objectAtIndex:8] isKindOfClass:[NSString class]]) {
        [cellArray replaceObjectAtIndex:8 withObject:[helper rowIDOfProjectTypeFromName:[cellArray objectAtIndex:8]]];
    }
    // Salvage Value Amount
    if ([[cellArray objectAtIndex:26] isKindOfClass:[NSString class]]) {
        NSNumber *number = [NSNumber numberWithInteger:[[cellArray objectAtIndex:26] integerValue]];
        [cellArray replaceObjectAtIndex:26 withObject:number];
    }
    // Should invoice
    if ([[cellArray objectAtIndex:27] isKindOfClass:[NSString class]]) {
        NSNumber *number = [NSNumber numberWithInteger:[[cellArray objectAtIndex:27] integerValue]];
        [cellArray replaceObjectAtIndex:27 withObject:number];
    }
    // Actual invoice
    if ([[cellArray objectAtIndex:28] isKindOfClass:[NSString class]]) {
        NSNumber *number = [NSNumber numberWithInteger:[[cellArray objectAtIndex:28] integerValue]];
        [cellArray replaceObjectAtIndex:28 withObject:number];
    }
    // Project cost
    if ([[cellArray objectAtIndex:31] isKindOfClass:[NSString class]]) {
        NSNumber *number = [NSNumber numberWithInteger:[[cellArray objectAtIndex:31] integerValue]];
        [cellArray replaceObjectAtIndex:31 withObject:number];
    }
    // Customer Number
    if ([[cellArray objectAtIndex:32] isKindOfClass:[NSString class]]) {
        NSNumber *number = [NSNumber numberWithInteger:[[cellArray objectAtIndex:32] integerValue]];
        [cellArray replaceObjectAtIndex:32 withObject:number];
    }
    if ([self isRequiredInformationFilled]) {
        // All Good
        HUD = self.prototypeHUD;
        HUD.textLabel.text = @"Saving project...";
        [HUD showInView:self.view];
        DatabaseConnector *database = [DatabaseConnector sharedDatabaseConnector];
        [database connectToDatabase];
        NSArray *keys = [helper projectAttributesKeys];
        BOOL result = [database updateProjectWithID:self.projectID andData:cellArray andKeys:keys andSalvageExists:didHaveSalvageInDatabase];
        database.databaseConnection = nil;
        if (result == TRUE) {
            // Success
            NSLog(@"Successful save!");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                HUD.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc] init];
                HUD.textLabel.text = @"Success!";
            });
            [HUD dismissAfterDelay:1];
        } else {
            // Failure
            NSLog(@"Failed to save!");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                HUD.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
                HUD.textLabel.text = @"Failed to save, please try again!";
            });
            [HUD dismissAfterDelay:1];
        }
    } else {
        // Notify user
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Required Information" message:@"You must fill out all the Required Information at a minimum" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
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
