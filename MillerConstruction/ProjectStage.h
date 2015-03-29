//
//  ProjectStage.h
//  MillerConstruction
//
//  Created by David Brooks on 3/29/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectStage : NSObject

@property (nonatomic, retain) NSNumber *rowID;
@property (nonatomic, retain) NSString *name;

-(id)initWithRowID:(NSNumber *)rowID andName:(NSString *)name;

@end
