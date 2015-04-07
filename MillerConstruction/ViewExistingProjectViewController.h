//
//  ViewExistingProjectViewController.h
//  MillerConstruction
//
//  Created by David Brooks on 4/6/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewExistingProjectViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIButton *warehouseButton;
@property (nonatomic, retain) IBOutlet UIButton *projectStageButton;
@property (nonatomic, retain) IBOutlet UIButton *searchButton;

-(IBAction)selectWarehouse:(id)sender;
-(IBAction)selectProjectStage:(id)sender;
-(IBAction)searchForProject:(id)sender;

@end
