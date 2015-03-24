//
//  NewProjectTableViewCell.h
//  MillerConstruction
//
//  Created by David Brooks on 3/23/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewProjectTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) IBOutlet UITextField *textField;

@end