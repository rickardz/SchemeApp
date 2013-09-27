//
//  StudentMessageViewController.m
//  SchemeApp
//
//  Created by Johan Thorell on 2013-09-13.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "StudentMessageViewController.h"
#import "MessageCell.h"
#import "Message.h"
#import "User.h"
#import "Helpers.h"
#import "StudentMessageDetailsViewController.h"
#import "StudentAutomaticPresence.h"

@interface StudentMessageViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation StudentMessageViewController
{
    NSArray *messages;
    StudentAutomaticPresence *sap;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[Store studentStore]messagesForUser:[Store mainStore].currentUser completion:^(NSArray *messagesForUser) {
        messages = messagesForUser;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    
    [self.navigationController.tabBarItem setSelectedImage:[UIImage imageNamed:@"messages_selected.png"]];
    self.navigationItem.title = @"Messages";
    
    UIBarButtonItem *signOutButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(signOut)];
    self.navigationItem.rightBarButtonItem = signOutButton;
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(59.34511573, 17.97674040);
    sap = [[StudentAutomaticPresence alloc] init];
    [sap setCenterForRegion:center];
}

-(void)signOut
{
    UIStoryboard *loginSb = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
    UIViewController *initialLoginVC = [loginSb instantiateInitialViewController];
    initialLoginVC.modalTransitionStyle = UIModalPresentationFullScreen;
    [self presentViewController:initialLoginVC animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [messages count]; // returnera antalet meddelanden som finns tillgängliga för eleven. MessageStore?
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Skapa en custom cell. Lärarens namn, datum och början av meddelandet.
    
    static NSString *cellId = @"MessageCell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    Message *message = messages[indexPath.row];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@",  message.from.firstname, message.from.lastname];
    cell.dateLabel.text = [Helpers stringFromNSDate:message.date];
    cell.messageTextView.text = message.text;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StudentMessageDetailsViewController *studentMessageDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StudentMessageDetailsViewController"];
    
    MessageCell *cell = (MessageCell *)[tableView cellForRowAtIndexPath:indexPath];
    studentMessageDetailsViewController.message = cell.messageTextView.text;
    studentMessageDetailsViewController.from = cell.nameLabel.text;
    studentMessageDetailsViewController.date = [Helpers dateFromString:cell.dateLabel.text];
    
    
    [self.navigationController pushViewController:studentMessageDetailsViewController animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 81;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0f;
}


@end
