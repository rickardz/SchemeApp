//
//  AwesomeUI.m
//  SchemeAppAdmin
//
//  Created by Erik Österberg on 2013-10-04.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import "AwesomeUI.h"
#import "NavigationBar.h"
static NSArray *colors;
static UIColor *tintColor;
static UIColor *barColor;
static UIColor *tableViewBackgroundColor;
static UIColor *coverViewBackgroundColor;
static UIFont *coverViewFont;
static UIColor *fontColorForCoverViews;

@implementation AwesomeUI

+ (void)initialize
{
    [super initialize];
    
    /**
     *  TableView row colors
     */
    colors = @[[UIColor colorWithRed:239/255.0f green:148/255.0f blue:71/255.0f alpha:1.0f], [UIColor colorWithRed:243/255.0f green:82/255.0f blue:66/255.0f alpha:1.0f], [UIColor colorWithRed:221/255.0f green:49/255.0f blue:91/255.0f alpha:1.0f], [UIColor colorWithRed:155/255.0f green:49/255.0f blue:97/255.0f alpha:1.0f], [UIColor colorWithRed:67/255.0f green:46/255.0f blue:56/255.0f alpha:1.0f]];
    
    /**
     *  Theme colors
     */
    tintColor = [UIColor whiteColor];
    barColor = [UIColor colorWithRed:0.07 green:0.18 blue:0.36 alpha:1.0];
    tableViewBackgroundColor = [UIColor colorWithRed:220/255.0f green:46/255.0f blue:77/255.0f alpha:1.0f];
    coverViewBackgroundColor = [UIColor darkGrayColor];
    fontColorForCoverViews = [UIColor whiteColor];
    
    /**
     *  CoverView font
     */
    coverViewFont = [UIFont fontWithName:@"Avenir-Heavy" size:22];
         
}

#pragma mark - GLOBAL THEME
+(void)setGlobalStylingTo:(UIWindow *)window
{
//    window.tintColor = tintColor;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

+(void)setStyleToBar:(id)bar {
    if ([bar isKindOfClass:[NavigationBar class]]) {
        NavigationBar *navBar = (NavigationBar*)bar;
        navBar.barStyle = UIBarStyleBlack;
    } else if ([bar isKindOfClass:[UIToolbar class]]) {
        UIToolbar *toolBar = (UIToolbar*)bar;
        toolBar.barStyle = UIBarStyleBlack;
    } else if (![bar isKindOfClass:[UITabBar class]]) {
        
        return;
    }
    
//    [bar performSelector:@selector(setTranslucent:) withObject:nil];
    
    [bar performSelector:@selector(setBarTintColor:) withObject:barColor];
    
    [bar performSelector:@selector(setTintColor:) withObject:tintColor];
}

#pragma mark - THEME COLORS
+ (UIColor *)backgroundColorForEmptyTableView
{
    return tableViewBackgroundColor;
}

+ (UIColor *)backgroundColorForCoverViews;
{
    return coverViewBackgroundColor;
}

+ (UIColor *)fontColorForCoverViews
{
    return fontColorForCoverViews;
}
+ (UIColor *)barColor
{
    return barColor;
}
+ (void)setTabBarTintColor
{
    [[UITabBar appearance] setTintColor:tintColor];
};
+ (UIView*)viewForTabBarTranslucent:(UITabBar *)tabBar
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tabBar.frame.size.width + 260, tabBar.frame.size.height)];
    view.backgroundColor = [AwesomeUI barColor];
    [view setAlpha:0.5];
    return view;
}
#pragma mark - THEME FONTS
+ (UIFont *)fontForCoverViews
{
    return coverViewFont;
}

#pragma mark - TABLE VIEWS
/**
 *  Color for row in tableView
 */
+ (UIColor *)colorForIndexPath:(NSIndexPath *)indexPath
{
    return colors[indexPath.row % 5];
}

/**
 *  Set style to tableView
 */
+ (void)setGGstyleTo:(UITableView *)tableView
{
    tableView.separatorColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.contentInset = UIEdgeInsetsMake(60, 0, 140, 0);
}

/**
 *  Default cellHeight / headerHeight
 */
+ (NSInteger)tableViewCellHeight
{
    return 100;
}

+ (NSUInteger)tableViewHeaderHeight
{
    return 40;
}

#pragma mark - TABLE VIEW CELLS
/**
 *  Sets cell to default styling
 */
+ (void)addDefaultStyleTo:(UITableViewCell*)cell
{
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:22];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

+(void)addColorAndDefaultStyleTo:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    [self addDefaultStyleTo:cell];
    cell.backgroundColor = [self colorForIndexPath:indexPath];
}

/**
 *  Sets cell to selected/highlighted state
 */
+ (void)setStateSelectedfor:(UITableViewCell*)cell
{
    cell.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.layer.borderWidth = 1;
    cell.layer.cornerRadius = 2;
}

/**
 *  Sets cell to unselected/unhighlighted state
 */
+ (void)setStateUnselectedfor:(UITableViewCell*)cell
{
    cell.layer.borderColor = [UIColor clearColor].CGColor;
    cell.layer.borderWidth = 0;
}

#pragma mark - TAB BAR ITEMS
+(void)setGGStyleToTabBarItems:(NSArray*)viewControllers
{
    for (UIViewController *viewController in viewControllers){
        [viewController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    }
}


@end