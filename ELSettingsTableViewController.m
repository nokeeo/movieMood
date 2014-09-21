//
//  ELSettingsTableViewController.m
//  MovieMood
//
//  Created by Eric Lee on 9/20/14.
//  Copyright (c) 2014 Eric Lee Productions. All rights reserved.
//

#import "ELSettingsTableViewController.h"

@interface ELSettingsTableViewController ()

@end

@implementation ELSettingsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGFloat topOffset = CGRectGetHeight(self.navigationController.navigationBar.frame) + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    CGFloat bottomOffset = CGRectGetHeight(self.tabBarController.tabBar.frame);
    self.tableView.contentInset = UIEdgeInsetsMake( topOffset, 0, bottomOffset, 0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

#pragma mark - ELMainTabBarProtocol
-(BOOL) shouldShowNavBar {
    return YES;
}

@end
