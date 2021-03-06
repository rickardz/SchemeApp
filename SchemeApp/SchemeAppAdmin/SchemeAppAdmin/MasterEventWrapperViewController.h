//
//  MasterEventWrapperViewController.h
//  SchemeAppAdmin
//
//  Created by Marcus Norling on 9/25/13.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EventWrapper;
@class DetailEventWrapperViewController;

@protocol MasterEventWrapperDelegate <NSObject>
- (void)masterEventWrapperDidSelectEventWrapper:(EventWrapper*)eventWrapper;
- (void)masterEventWrapperHasNoData;
@end


@interface MasterEventWrapperViewController : UIViewController

@property (nonatomic, weak) DetailEventWrapperViewController *detailEventWrapperViewController;
@property (weak) id <MasterEventWrapperDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end