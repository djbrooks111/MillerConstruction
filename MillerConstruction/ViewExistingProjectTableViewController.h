//
//  ViewExistingProjectTableViewController.h
//  MillerConstruction
//
//  Created by David Brooks on 4/6/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewExistingProjectTableViewController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, retain) NSNumber *projectID;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *editButton;

-(IBAction)editProject:(UIBarButtonItem *)sender;

@end
