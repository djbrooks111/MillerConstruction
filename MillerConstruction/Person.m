//
//  Person.m
//  MillerConstruction
//
//  Created by David Brooks on 3/29/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import "Person.h"

@implementation Person

/**
 *  Custom initializer
 *
 *  @param name     Person's Name
 *  @param idNumber Person's idNumber
 *
 *  @return Initialized Person
 */
-(id)initWithName:(NSString *)name andIDNumber:(NSNumber *)idNumber {
    if (self = [super init]) {
        [self setName:name];
        [self setIdNumber:idNumber];
    }
    
    return self;
}

@end
