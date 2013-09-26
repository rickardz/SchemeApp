//
//  MasterEventWrapperViewController.m
//  SchemeAppAdmin
//
//  Created by Marcus Norling on 9/25/13.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import "MasterEventWrapperViewController.h"
#import "EventWrapper.h"
#import "PopoverEventWrapperViewController.h"

@interface MasterEventWrapperViewController () <UITableViewDelegate>
{
    NSMutableArray *eventWrappers;
    UIPopoverController *addEventWrapperPopover;
    PopoverEventWrapperViewController *pewvc;
}


@property (weak, nonatomic) IBOutlet UITableView *eventWrappersTableView;

@end

@implementation MasterEventWrapperViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [Store.adminStore eventWrappersCompletion:^(NSArray *allEventWrappers)
     {
         eventWrappers = [NSMutableArray arrayWithArray:allEventWrappers];
         [NSOperationQueue.mainQueue addOperationWithBlock:^
          {
              [self.eventWrappersTableView reloadData];
              NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
              [self.eventWrappersTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
              [self tableView:self.eventWrappersTableView didSelectRowAtIndexPath:indexPath];
          }];
     }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    pewvc = [[PopoverEventWrapperViewController alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [eventWrappers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    EventWrapper *eventWrapper = eventWrappers[indexPath.row];
    cell.textLabel.text = eventWrapper.name;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate masterEventWrapperDidSelectEventWrapper:eventWrappers[indexPath.row]];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *url = [NSString stringWithFormat:@"%@/%@", DB_TYPE_EVENTWRAPPER, [eventWrappers[indexPath.row]docID]];
        [[Store dbSessionConnection] deletePath:url withCompletion:^(id jsonObject, id response, NSError *error) {
            [self.eventWrappersTableView reloadData];
        }];
        [eventWrappers removeObject:eventWrappers[indexPath.row]];
        [self.eventWrappersTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

- (IBAction)addEventWrapper:(id)sender
{
    [self showPopover:sender];
}

-(void)showPopover:(id)sender
{
    pewvc.isInEditingMode = NO;
    
    addEventWrapperPopover = [[UIPopoverController alloc] initWithContentViewController:pewvc];
    [addEventWrapperPopover setPopoverContentSize:CGSizeMake(300, 400)];
    [addEventWrapperPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

@end