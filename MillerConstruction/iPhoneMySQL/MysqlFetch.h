//
//  MysqlFetch.h
//  mysql_connector
//
//  Created by Karl Kraft on 4/25/07.
//  Copyright 2007-2014 Karl Kraft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MysqlConnection;

@interface MysqlFetch : NSObject

@property(readonly) NSArray *fieldNames;
@property(readonly) NSArray *fields;
@property(readonly) NSArray *results;


+ (MysqlFetch *)fetchWithCommand:(NSString *)s onConnection:(MysqlConnection *)connection extendedNames:(BOOL)useExtendedNames;

// calls above method with useExtendedNames==NO
+ (MysqlFetch *)fetchWithCommand:(NSString *)s onConnection:(MysqlConnection *)connection;

@end
