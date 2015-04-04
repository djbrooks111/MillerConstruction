//
//  MysqlServer.m
//  mysql_connector
//
//  Created by Karl Kraft on 3/19/11.
//  Copyright 2011-2015 Karl Kraft. All rights reserved.
//

#import "MysqlServer.h"
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wpadded"

#import "mysql.h"
#pragma clang diagnostic pop


@implementation MysqlServer
{
  NSString *host;
  NSString *user;
  NSString *password;
  NSString *schema;
  unsigned short port;
  unsigned long flags;
  unsigned int connectionTimeout;
}

@synthesize host,user,password,schema;
@synthesize port,flags,connectionTimeout;


- (id)init
{
  self=[super init];
  self.host=@"localhost";
  self.user=@"username";
  self.password=@"password";
  self.schema=nil;
  self.port=3306;
  self.flags=CLIENT_FOUND_ROWS;
  self.connectionTimeout=30;
  return self;
}

-(id)initWithHost:(NSString *)inHost andUser:(NSString *)inUser andPassword:(NSString *)inPassword andSchema:(NSString *)inSchema {
    if (self = [super init]) {
        self.host = inHost;
        self.user = inUser;
        self.password = inPassword;
        self.schema = inSchema;
        self.port = 3306;
        self.flags = CLIENT_FOUND_ROWS;
        self.connectionTimeout = 30;
    }
    return self;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"MysqlServer: %@:%d as user %@",host,port,user];
}
@end
