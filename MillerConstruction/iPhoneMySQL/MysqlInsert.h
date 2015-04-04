//
//  MysqlInsert.h
//  mysql_connector
//
//  Created by Karl Kraft on 6/12/08.
//  Copyright 2008-2014 Karl Kraft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MysqlConnection;


@interface MysqlInsert : NSObject

@property(retain) NSString *table;
@property(retain) NSDictionary  *rowData;
@property(readonly) NSNumber *affectedRows;
@property(readonly) NSNumber *rowid;
@property(assign) BOOL ignoreDuplicateErrors;

+ (MysqlInsert *)insertWithConnection:(MysqlConnection *)aConnection;
- (void)execute;
@end
