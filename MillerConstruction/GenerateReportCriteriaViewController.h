//
//  GenerateReportCriteriaViewController.h
//  MillerConstruction
//
//  Created by David Brooks on 4/16/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GenerateReportCriteriaViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIButton *reportTypeButton;
@property (nonatomic, retain) IBOutlet UITextField *reportTypeTextField;
@property (nonatomic, retain) IBOutlet UIButton *activeButton;
@property (nonatomic, retain) IBOutlet UIButton *proposalsButton;
@property (nonatomic, retain) IBOutlet UIButton *budgetaryButton;
@property (nonatomic, retain) IBOutlet UIButton *inactiveButton;
@property (nonatomic, retain) IBOutlet UIButton *closedButton;

-(IBAction)selectAReport:(UIButton *)sender;
-(IBAction)generateReport:(UIButton *)sender;

@end
