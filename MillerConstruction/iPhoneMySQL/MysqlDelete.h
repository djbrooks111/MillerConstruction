//
//  MysqlDelete.h
//  mysql_connector
//
//  Created by Karl Kraft on 9/28/08.
//  Copyright 2008-2014 Karl Kraft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MysqlConnection;

@interface MysqlDelete : NSObject

@property(copy) NSString *tableName;
@property(copy) NSString *qualifier;
@property(readonly) NSNumber *affectedRows;

+ (MysqlDelete *)deleteWithConnection:(MysqlConnection *)aConnection;
- (void)execute;

@end
