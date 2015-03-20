//
//  MainMenuViewController.h
//  MillerConstruction
//
//  Created by David Brooks on 3/15/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainMenuViewController : UIViewController

typedef NS_ENUM(NSInteger, ButtonTag) {
    CreateNewProjectTag,
    ViewExistingProjectTag,
    GenerateReportTag,
    ViewTriggersTag
};

@property (strong, nonatomic) IBOutlet UIButton *createNewProjectButton;
@property (strong, nonatomic) IBOutlet UIButton *viewExistingProjectButton;
@property (strong, nonatomic) IBOutlet UIButton *generateReportButton;
@property (strong, nonatomic) IBOutlet UIButton *viewTriggersButton;

-(IBAction)mainMenuButtonsPressed:(UIButton *)sender;

@end
