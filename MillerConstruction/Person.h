//
//  Person.h
//  MillerConstruction
//
//  Created by David Brooks on 3/29/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *idNumber;

-(id)initWithName:(NSString *)name andIDNumber:(NSNumber *)idNumber;

@end
