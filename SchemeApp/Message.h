//
//  Messages.h
//  SchemeApp
//
//  Created by Johan Thorell on 2013-09-10.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import <Foundation/Foundation.h>
@class User;
@interface Message : NSObject

@property (nonatomic, readonly) NSString *docID;
@property (nonatomic, strong) User *from;
@property (nonatomic, strong) NSMutableArray *receiverIDs;
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, copy) NSString *text;

+ (id)messageWithText:(NSString*)text receivers:(NSArray *)receivers;
- (NSDictionary *)asDictionary;
- (id)initWithMsgDictionary:(NSDictionary *)msgDictionary;

@end
