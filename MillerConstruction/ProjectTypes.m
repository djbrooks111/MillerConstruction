//
//  ProjectTypes.m
//  MillerConstruction
//
//  Created by David Brooks on 3/23/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import "ProjectTypes.h"

@implementation ProjectTypes

/**
 *  Custom initializer
 *
 *  @param name   ProjectType's name
 *  @param number ProjectType's number
 *
 *  @return Initialized ProjectType
 */
-(id)initWithName:(NSString *)name andNumber:(int)number {
    if (self = [super init]) {
        [self setName:name];
        [self setNumber:number];
    }
    
    return self;
}

@end
