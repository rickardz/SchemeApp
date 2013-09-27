//
//  MasterMessageViewController.m
//  SchemeAppAdmin
//
//  Created by Marcus Norling on 9/25/13.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import "MasterMessageViewController.h"
#import "CreateMessageViewController.h"

@interface MasterMessageViewController () <UITableViewDataSource, UITableViewDelegate, CreateMessageViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MasterMessageViewController
{
    NSMutableArray *messages;
    UIPopoverController *createMessagePopover;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[Store studentStore]messagesForUser:[Store mainStore].currentUser completion:^(NSArray *messagesForUser) {
        messages = [messagesForUser mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    Message *message = messages[indexPath.row];
    cell.textLabel.text = [message.from name];
    cell.detailTextLabel.text = message.text;   
    
    return cell;
}


- (IBAction)didPressAdd:(id)sender {
    UIStoryboard *createMessageStoryboard = [UIStoryboard storyboardWithName:@"CreateMessage" bundle:nil];
    CreateMessageViewController *createMessageView = [createMessageStoryboard instantiateInitialViewController];
    createMessageView.delegate = self;
    createMessagePopover = [[UIPopoverController alloc] initWithContentViewController:createMessageView];
    [createMessagePopover setPopoverContentSize:CGSizeMake(300, 500)];
    [createMessagePopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

-(void)didCreateMessage
{
    [createMessagePopover dismissPopoverAnimated:YES];
}

-(void)didCreateAndGetMessage:(Message *)message
{
    [messages addObject:message];
    [createMessagePopover dismissPopoverAnimated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
