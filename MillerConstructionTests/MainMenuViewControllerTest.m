//
//  MainMenuViewControllerTest.m
//  MillerConstruction
//
//  Created by David Brooks on 3/20/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "MainMenuViewController.h"

@interface MainMenuViewControllerTest : XCTestCase

@end

@implementation MainMenuViewControllerTest {
    MainMenuViewController *viewController;
}

-(void)setUp {
    [super setUp];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    viewController = [storyboard instantiateViewControllerWithIdentifier:@"MainMenuViewController"];
    [viewController view];
}

-(void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testViewControllerViewExists {
    XCTAssertNotNil([viewController view], @"MainMenuViewController should contain a view");
}

-(void)testCreateNewProjectButtonConnections {
    XCTAssertNotNil([viewController createNewProjectButton], @"createNewProjectButton should be connected");
}

-(void)testViewExistingProjectButtonConnection {
    XCTAssertNotNil([viewController viewExistingProjectButton], @"viewExistingProjectButton should be connected");
}

-(void)testGenerateReportButtonConnection {
    XCTAssertNotNil([viewController generateReportButton], @"generateReportButton should be connected");
}

-(void)testViewTriggersButtonConnection {
    XCTAssertNotNil([viewController viewTriggersButton], @"viewTriggersButton should be connected");
}

-(void)testCreateNewProjectButtonTag {
    XCTAssertEqual([[viewController createNewProjectButton] tag], CreateNewProjectTag, @"createNewProjectButton should have a tag of CreateNewProjectTag");
}

-(void)testViewExistingProjectButtonTag {
    XCTAssertEqual([[viewController viewExistingProjectButton] tag], ViewExistingProjectTag, @"viewExistingProjectButton should have a tag of ViewExistingProjectTag");
}

-(void)testGenerateReportButtonTag {
    XCTAssertEqual([[viewController generateReportButton] tag], GenerateReportTag, @"generateReportButton should have a tag of GenerateReportTag");
}

-(void)testViewTriggersButtonTag {
    XCTAssertEqual([[viewController viewTriggersButton] tag], ViewTriggersTag, @"viewTriggersButton should have a tag of ViewTriggersTag");
}

-(void)testCreateNewProjectButtonIBActionConnection {
    NSArray *actions = [viewController.createNewProjectButton actionsForTarget:viewController forControlEvent:UIControlEventTouchUpInside];
    XCTAssertTrue([actions containsObject:@"mainMenuButtonsPressed:"], @"createNewProjectButton should have the mainMenuButtonsPressed method connected");
}

-(void)testViewExistingProjectButtonIBActionConnection {
    NSArray *actions = [viewController.viewExistingProjectButton actionsForTarget:viewController forControlEvent:UIControlEventTouchUpInside];
    XCTAssertTrue([actions containsObject:@"mainMenuButtonsPressed:"], @"viewExistingProjectButton should have the mainMenuButtonsPressed method connected");
}

-(void)testGenerateReportButtonIBActionConnection {
    NSArray *actions = [viewController.generateReportButton actionsForTarget:viewController forControlEvent:UIControlEventTouchUpInside];
    XCTAssertTrue([actions containsObject:@"mainMenuButtonsPressed:"], @"generateReportButton should have the mainMenuButtonsPressed method connected");
}

-(void)testViewTriggersButtonIBActionConnection {
    NSArray *actions = [viewController.viewTriggersButton actionsForTarget:viewController forControlEvent:UIControlEventTouchUpInside];
    XCTAssertTrue([actions containsObject:@"mainMenuButtonsPressed:"], @"viewTriggersButton should have the mainMenuButtonsPressed method connected");
}

-(void)testSegueToCreateNewProject {
    [UIApplication sharedApplication].keyWindow.rootViewController = viewController;
    [viewController performSegueWithIdentifier:@"goToCreateNewProject" sender:nil];
    XCTAssertNotNil(viewController.presentedViewController, @"Create New Project should be presented");
}

-(void)testSegueToViewExistingProject {
    [UIApplication sharedApplication].keyWindow.rootViewController = viewController;
    [viewController performSegueWithIdentifier:@"goToViewExistingProject" sender:nil];
    XCTAssertNotNil(viewController.presentedViewController, @"View Existing Project should be presented");
}

-(void)testSegueToGenerateReport {
    [UIApplication  sharedApplication].keyWindow.rootViewController = viewController;
    [viewController performSegueWithIdentifier:@"goToGenerateReport" sender:nil];
    XCTAssertNotNil(viewController.presentedViewController, @"Generate Report should be presented");
}

-(void)testSegueToViewTriggers {
    [UIApplication sharedApplication].keyWindow.rootViewController = viewController;
    [viewController performSegueWithIdentifier:@"goToViewTriggers" sender:nil];
    XCTAssertNotNil(viewController.presentedViewController, @"View Triggers should be presented");
}

@end
