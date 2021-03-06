//
//  MysqlLiteral.h
//  mysql_connector
//
//  Created by Karl Kraft on 8/29/09.
//  Copyright 2009-2014 Karl Kraft. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface MysqlLiteral : NSObject

@property(readonly) NSString *string;

+(MysqlLiteral *)literalWithString:(NSString *)s;

@end
