//
//  DetailUserViewController.m
//  SchemeAppAdmin
//
//  Created by Marcus Norling on 9/25/13.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import "DetailUserViewController.h"
#import "MasterUserViewController.h"
#import "UIButton+CustomButton.h"
#import "PopoverUserViewController.h"
@interface DetailUserViewController ()<MasterUserDelegate, PopoverUserDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *roleLabel;

@end

@implementation DetailUserViewController
{
    UIButton *addButton;
    UIButton *editButton;
    UIPopoverController *userInfoPopover;
    PopoverUserViewController *puvc;
    User *currentUser;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        puvc = [[PopoverUserViewController alloc] init];
        puvc.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    addButton = [UIButton customButtonWithIconImage:[UIImage imageNamed:@"newIcon"] tag:1];
    [addButton addTarget:self action:@selector(addNewUser:) forControlEvents:UIControlEventTouchUpInside];
    [addButton setFrame:CGRectMake(500, 24, 50, 50)];
    [self.view addSubview:addButton];
    
    editButton = [UIButton customButtonWithIconImage:[UIImage imageNamed:@"editIcon"] tag:2];
    [editButton addTarget:self action:@selector(editUser:) forControlEvents:UIControlEventTouchUpInside];
    [editButton setFrame:CGRectMake(600, 20, 50, 50)];
    [self.view addSubview:editButton];
}

- (void)addNewUser:(id)sender
{
    [self showPopover:sender for:@"add"];
}

- (void)editUser:(id)sender
{
    [self showPopover:sender for:@"edit"];
}

-(User *)currentUser
{
    return currentUser;
}

-(void)showPopover:(id)sender for:(NSString *)method
{
    
    if ([method isEqualToString:@"edit"]) {
        puvc.isInEditingMode = YES;
    } else if ([method isEqualToString:@"add"]) {
        puvc.isInEditingMode = NO;
    }
    
    userInfoPopover = [[UIPopoverController alloc] initWithContentViewController:puvc];
    UIButton *senderButton = (UIButton *)sender;
    [userInfoPopover setPopoverContentSize:CGSizeMake(300, 555)];
    [userInfoPopover presentPopoverFromRect:senderButton.bounds inView:senderButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

-(void)masterUserDidSelectUser:(User *)user
{

    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstname, user.lastname];
    self.emailLabel.text = user.email;
    self.roleLabel.text = [User stringFromRoleType:user.role];
    currentUser = user;
    
}
-(void)dismissPopover
{
    [userInfoPopover dismissPopoverAnimated:YES];
}

@end