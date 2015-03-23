//
//  MainMenuViewController.m
//  MillerConstruction
//
//  Created by David Brooks on 3/15/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import "MainMenuViewController.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

#pragma mark - UIViewController Methods

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Setting tags of the buttons to identify them
    [self.createNewProjectButton setTag:CreateNewProjectTag];
    [self.viewExistingProjectButton setTag:ViewExistingProjectTag];
    [self.generateReportButton setTag:GenerateReportTag];
    [self.viewTriggersButton setTag:ViewTriggersTag];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Main Menu Buttons Method

/**
 *  Called when the user presses any of the Menu buttons
 *
 *  @param sender The button who called this method
 */
-(void)mainMenuButtonsPressed:(UIButton *)sender {
    int buttonTag = (int)[sender tag];
    switch (buttonTag) {
        case CreateNewProjectTag:
            // Create New Project
            //TODO: Put Segue with ID = goToCreateNewProject
            [self performSegueWithIdentifier:@"goToCreateNewProject" sender:self];
            break;
            
        case ViewExistingProjectTag:
            // View Existing Project
            //TODO: Put Segue with ID = goToViewExistingProject
            [self performSegueWithIdentifier:@"goToViewExistingProject" sender:self];
            break;
            
        case GenerateReportTag:
            // Generate Report
            //TODO: Put Segue with ID = goToGenerateReport
            [self performSegueWithIdentifier:@"goToGenerateReport" sender:self];
            break;
            
        case ViewTriggersTag:
            // View Triggers
            //TODO: Put Segue with ID = goToViewTriggers
            [self performSegueWithIdentifier:@"goToViewTriggers" sender:self];
            break;
            
        default:
            break;
    }
}

@end
