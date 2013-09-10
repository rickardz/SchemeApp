//
//  Student.h
//  SchemeApp
//
//  Created by Johan Thorell on 2013-09-10.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Role;
@interface User : NSObject

@property (nonatomic, readonly) NSString *role;
@property (nonatomic, copy) NSString *firstname;
@property (nonatomic, copy) NSString *lastname;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSMutableArray *messages;
@property (nonatomic, copy) NSMutableArray *eventWrappers;

-initWithRole:(RoleType)role firstname:(NSString *)firstname lastname:(NSString *)lastname email:(NSString *)email password:(NSString *)password;
@end