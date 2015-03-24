//
//  CreateNewProjectTableViewController.h
//  MillerConstruction
//
//  Created by David Brooks on 3/20/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateNewProjectTableViewController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UIButton *saveButton;

-(IBAction)save:(UIButton *)sender;

@end
