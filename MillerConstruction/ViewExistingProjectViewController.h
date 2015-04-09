//
//  ViewExistingProjectViewController.h
//  MillerConstruction
//
//  Created by David Brooks on 4/6/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewExistingProjectViewController : UIViewController <UIAlertViewDelegate>

@property (nonatomic, retain) IBOutlet UIButton *warehouseButton;
@property (nonatomic, retain) IBOutlet UIButton *projectStageButton;
@property (nonatomic, retain) IBOutlet UIButton *searchButton;
@property (nonatomic, retain) IBOutlet UITextField *warehouseTextField;
@property (nonatomic, retain) IBOutlet UITextField *stageTextField;

-(IBAction)selectWarehouse:(UIButton *)sender;
-(IBAction)selectProjectStage:(UIButton *)sender;
-(IBAction)searchForProject:(UIButton *)sender;

@end
