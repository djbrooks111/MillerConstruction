//
//  NSString_MysqlEscape.h
//  mysql_connector
//
//  Created by Karl Kraft on 6/12/08.
//  Copyright 2008 Karl Kraft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString(MysqlEscape)
- (NSString *)mysqlEscapeInConnection:(MysqlConnection *)connection;

@end
