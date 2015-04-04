//
//  MysqlServer.h
//  mysql_connector
//
//  Created by Karl Kraft on 3/19/11.
//  Copyright 2011-2015 Karl Kraft. All rights reserved.
//


#import <UIKit/UIKit.h>
@interface MysqlServer : NSObject

@property(copy) NSString *host;
@property(copy) NSString *user;
@property(copy) NSString *password;
@property(copy) NSString *schema;
@property(assign) unsigned short port;
@property(assign) unsigned long flags;
@property(assign) unsigned int connectionTimeout;

-(id)initWithHost:(NSString *)inHost andUser:(NSString *)inUser andPassword:(NSString *)inPassword andSchema:(NSString *)inSchema;

@end
