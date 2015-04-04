//
//  MysqlFetchField.m
//  mysql_connector
//
//  Created by Karl Kraft on 10/22/09.
//  Copyright 2009-2014 Karl Kraft. All rights reserved.
//

#import "MysqlFetchField.h"

@implementation MysqlFetchField
{
  NSString *name;
  enum enum_field_types fieldType;
  NSUInteger width;
  NSUInteger decimals;
  BOOL primaryKey;
}

@synthesize name,fieldType,width,primaryKey,decimals;

@end
