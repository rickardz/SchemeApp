//
//  Store.h
//  
//
//  Created by Henrik on 2013-09-09.
//
//

#import <Foundation/Foundation.h>
#import "AdminStore.h"
#import "SuperAdminStore.h"
#import "StudentStore.h"

@class User;


@interface Store : NSObject

@property (nonatomic, strong) User *currentUser;
@property (nonatomic, strong) NSMutableSet *users;

@property (nonatomic, strong) NSMutableSet *events;
@property (nonatomic, strong) NSMutableSet *eventWrappers;

+ (Store *)mainStore;
+ (StudentStore *)studentStore;
+ (AdminStore *)adminStore;
+ (SuperAdminStore *)superAdminStore;

- (User *)userWithEmail:(NSString *)email andPassword:(NSString *)password;

@end
