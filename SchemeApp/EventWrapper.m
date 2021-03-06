//
//  EventWrapper.m
//  SchemeApp
//
//  Created by Johan Thorell on 2013-09-10.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "EventWrapper.h"
#import "Helpers.h"
#import "Event.h"
#import "User.h"


@implementation EventWrapper

- (id)initWithEventWrapperDictionary:(NSDictionary *)eventWrapperDictionary
{


    self = [super init];
    if (self)
    {
        self.name = [eventWrapperDictionary objectForKey:@"name"];
        self.user = [[User alloc] initWithUserDictionary:eventWrapperDictionary[@"owner"]];
        self.litterature = [eventWrapperDictionary objectForKey:@"litterature"];
        self.startDate = [Helpers dateFromString:[eventWrapperDictionary objectForKey:@"startDate"]];
        self.endDate = [Helpers dateFromString:[eventWrapperDictionary objectForKey:@"endDate"]];
        _docID = [eventWrapperDictionary objectForKey:@"_id"];

        NSMutableArray *newEvents = NSMutableArray.array;        
        for (id event in [eventWrapperDictionary objectForKey:@"events"])
        {
            if ([event isKindOfClass:NSDictionary.class])
            {
                Event *newEvent = [[Event alloc] initWithEventDictionary:event];
                [newEvents addObject:newEvent];
            }
            else if ([event isKindOfClass:NSString.class])
            {
                [newEvents addObject:event];
            }
        }
        self.events = newEvents;
    }
    return self;
}

- (NSDictionary *)asDictionary
{
    NSMutableDictionary *jsonEventWrapper = [[NSMutableDictionary alloc]init];
    
    NSMutableArray *jsonEvents = [[NSMutableArray alloc]init];
    for (NSString *eventDocID in self.events) {
        [jsonEvents addObject:eventDocID];
    }
    
    [jsonEventWrapper setObject:jsonEvents forKey:@"events"];
    [jsonEventWrapper setObject:self.user.docID forKey:@"owner"];
    [jsonEventWrapper setObject:self.litterature forKey:@"litterature"];
    [jsonEventWrapper setObject:[Helpers stringFromNSDate:self.startDate] forKey:@"startDate"];
    [jsonEventWrapper setObject:[Helpers stringFromNSDate:self.endDate] forKey:@"endDate"];
    [jsonEventWrapper setObject:self.name forKey:@"name"];
    
    if (self.docID) {
        [jsonEventWrapper setObject:self.docID forKey:@"_id"];
    }
    
    return jsonEventWrapper;
}

@end
