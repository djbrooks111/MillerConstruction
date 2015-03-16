//
//  User.h
//  MillerConstruction
//
//  Created by David Brooks on 3/15/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

#pragma mark - UserLoginType

typedef NS_ENUM(NSInteger, UserLoginType) {
    SuccessfulLogin,
    IncorrectPassword,
    WrongUsername
};

@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;

-(id)initWithUsername:(NSString *)username andPassword:(NSString *)password;
-(UserLoginType)login;
-(BOOL)isPasswordEqual:(NSString *)otherPassword;

@end
