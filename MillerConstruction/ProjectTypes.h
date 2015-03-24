//
//  ProjectTypes.h
//  MillerConstruction
//
//  Created by David Brooks on 3/23/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectTypes : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, readwrite) int number;

-(id)initWithName:(NSString *)name andNumber:(int)number;

@end
