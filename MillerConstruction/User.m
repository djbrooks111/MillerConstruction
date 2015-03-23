//
//  User.m
//  MillerConstruction
//
//  Created by David Brooks on 3/15/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import "User.h"
#import "DatabaseConnector.h"
#import <CommonCrypto/CommonDigest.h>

@implementation User

/**
 *  Custom initializer
 *
 *  @param username User's username
 *  @param password User's password
 *
 *  @return Initialized User
 */
-(id)initWithUsername:(NSString *)username andPassword:(NSString *)password {
    if (self = [super init]) {
        [self setUsername:username];
        [self setPassword:password];
        [self hashPassword];
    }
    
    return self;
}

/**
 *  Calls the login method of the DatabaseConnector
 *
 *  @return UserLoginType
 */
-(UserLoginType)login {
    DatabaseConnector *database = [DatabaseConnector sharedDatabaseConnector];
    
    return [database loginUserToDatabase:self];
}

/**
 *  Takes a plain text password and encrypts it using a SHA256 hash
 */
-(void)hashPassword {
    NSData *plainTextData = [self.password dataUsingEncoding:NSASCIIStringEncoding];
    NSMutableData *hashData = [NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH];
    CC_SHA256([plainTextData bytes], (CC_LONG)[plainTextData length], [hashData mutableBytes]);
    NSString *hash = [hashData description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    NSLog(@"%@ is %@", self.password, hash);
    
    [self setPassword:hash];
}

/**
 *  Checks if the provided password hash is equal to this User's password hash
 *
 *  @param otherPassword Hashed password retrieved from the database
 *
 *  @return true if the passwords match, false otherwise
 */
-(BOOL)isPasswordEqual:(NSString *)otherPassword {
    NSLog(@"%@ and %@", self.password, otherPassword);
    if ([self.password isEqualToString:otherPassword]) {
        // Same passwords, allow user
        return true;
    } else {
        // Wrong password, do not allow
        return false;
    }
}

@end
