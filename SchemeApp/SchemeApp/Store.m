//
//  Store.m
//  
//
//  Created by Henrik on 2013-09-09.
//
//

#import "Store.h"
#import "User.h"
#import "EventWrapper.h"
#import "Event.h"
#import "Location.h"

@implementation Store

+ (id)allocWithZone:(NSZone *)zone
{
    return self.mainStore;
}
+ (DatabaseConnection *)dbConnection
{
    static DatabaseConnection *dbConnection = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      dbConnection = [[DatabaseConnection alloc] init];
                  });
    
    return dbConnection;
}
+ (Store *)mainStore
{
    static Store *mainStore = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      mainStore = [[super allocWithZone:nil] init];
                  });
    
    return mainStore;
}
+ (AdminStore *)adminStore
{
    static AdminStore *adminStore = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      adminStore = [[AdminStore alloc] init];
                  });
    
    return adminStore;
}
+ (SuperAdminStore *)superAdminStore
{
    static SuperAdminStore *superAdminStore = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      superAdminStore = [[SuperAdminStore alloc] init];
                  });
    
    return superAdminStore;
}
+ (StudentStore *)studentStore
{
    static StudentStore *studentStore = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      studentStore = [[StudentStore alloc] init];
                  });
    
    return studentStore;
}


/**
 *  LoginController sets currentUser if successful login
 *  sendAuthenticationRequestForEmail: password: completion:
 */
+ (void)setCurrentUserToUserWithEmail:(NSString *)email andPassword:(NSString *)password completion:(void (^)(BOOL success))completion
{
    [Store.dbConnection getPath:[NSString stringWithFormat:@"%@/email/%@", DB_TYPE_USER, email]
                            withParams:nil
                         andCompletion:^(id responseBody, id response, NSError *error)
     {
         if (error)
         {
             NSLog(@"setCurrentUserToUserWithEmail:andPassword:completion: got response: %@ and error: %@", response, error.userInfo);
             completion(NO);
         }
         else
         {
             Store.mainStore.currentUser = [[User alloc] initWithUserDictionary:responseBody];
             completion(YES);
         }
     }];
}

+ (void)sendAuthenticationRequestForEmail:(NSString *)email password:(NSString *)password completion:(authentication)completion
{
    [Store.dbConnection postContent:@{@"email":email, @"password":password} toPath:@"users/login" withCompletion:^(id responseBody, id response, NSError *error) {
        
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        NSInteger statusCode = [httpResponse statusCode];
        
        if (statusCode == 200) {
            Store.mainStore.currentUser = [[User alloc] initWithUserDictionary:responseBody];
            completion(YES, responseBody);
        } else {
            completion(NO, nil);
        }
    }];
}

+ (void)fetchLocationCompletion:(void (^)(Location *location))completion
{
    [Store.dbConnection getPath:DB_TYPE_LOCATION
                            withParams:nil
                         andCompletion:^(id responseBody, id response, NSError *error)
     {
         if (error)
         {
             NSLog(@"setCurrentLocation got response: %@ and error: %@", response, error.userInfo);
         }
         else
         {
             if ([responseBody count])
             {
                 completion([[Location alloc]initWithLocationDictionary:responseBody[0]]);
             } else {
                 completion(nil);
             }
         }
     }];
}

@end
