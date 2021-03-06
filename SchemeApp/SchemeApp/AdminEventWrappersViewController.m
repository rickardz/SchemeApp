//
//  AdminCoursesViewController.m
//  SchemeApp
//
//  Created by Marcus Norling on 9/12/13.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "AdminEventWrappersViewController.h"
#import "EventWrapperCell.h"
#import "AdminEventWrapperTableViewController.h"
#import "EventWrapper.h"

@interface AdminEventWrappersViewController ()
@property (strong) UIActivityIndicatorView *activityView;

@end
@implementation AdminEventWrappersViewController
{
    NSMutableArray *eventWrappers;
    EventWrapper *selectedEventWrapper;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Courses";
    [self.navigationController.tabBarItem setSelectedImage:[UIImage imageNamed:@"courses_selected"]];
    self.activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityView.frame = CGRectMake(150, 150, 20, 20);
    
    [self.view addSubview:self.activityView];
    if (!eventWrappers) {
        [self.activityView startAnimating];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [Store.adminStore eventWrappersCompletion:^(NSArray *allEventWrappers)
     {
         eventWrappers = [NSMutableArray arrayWithArray:allEventWrappers];
         [NSOperationQueue.mainQueue addOperationWithBlock:^
         {
                     [self.activityView stopAnimating];
             [self.tableView reloadData];
         }];
     }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddEventWrapper"])
    {
        return;
    }
    else if ([segue.identifier isEqualToString:@"EditEventWrapper"])
    {
        AdminEventWrapperTableViewController *vc = segue.destinationViewController;
        vc.selectedEventWrapper = selectedEventWrapper;
    }
}


#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return eventWrappers.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventWrapper *eventWrapper = eventWrappers[indexPath.row];
    
    EventWrapperCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventWrapperCellIdentifier"];
    
    cell.eventWrapperName.text = eventWrapper.name;
    cell.eventWrapperStartDate.text = [Helpers dateStringFromNSDate:eventWrapper.startDate];
    cell.eventWrapperEndDate.text = [Helpers dateStringFromNSDate:eventWrapper.endDate];
    cell.eventWrapperOwnerName.text = eventWrapper.user.fullName;
    
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *url = [NSString stringWithFormat:@"%@/%@", DB_TYPE_EVENTWRAPPER, [eventWrappers[indexPath.row]docID]];
        [[Store dbConnection] deletePath:url withCompletion:^(id jsonObject, id response, NSError *error) {
            [self.tableView reloadData];
        }];
        [eventWrappers removeObject:eventWrappers[indexPath.row]];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedEventWrapper = eventWrappers[indexPath.row];
}

@end
