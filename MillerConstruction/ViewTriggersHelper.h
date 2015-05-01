//
//  ViewTriggersHelper.h
//  MillerConstruction
//
//  Created by David Brooks on 4/16/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewTriggersHelper : NSObject

@property (nonatomic, retain) NSMutableArray *infoTriggers;
@property (nonatomic, retain) NSMutableArray *warningTriggers;
@property (nonatomic, retain) NSMutableArray *severeTriggers;

-(void)lookForTriggers;

@end
