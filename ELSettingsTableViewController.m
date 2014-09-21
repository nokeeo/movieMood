//
//  ELSettingsTableViewController.m
//  MovieMood
//
//  Created by Eric Lee on 9/20/14.
//  Copyright (c) 2014 Eric Lee Productions. All rights reserved.
//

#import "ELSettingsTableViewController.h"
#import "ELFeedbackController.h"

@interface ELSettingsTableViewController () {
    NSDictionary *_cellTitles;
}

@property (nonatomic, strong) ELFeedbackController *feedbackController;

@end

@implementation ELSettingsTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    _feedbackController = [[ELFeedbackController alloc] initWithParentVC: self];
    CGFloat topOffset = CGRectGetHeight(self.navigationController.navigationBar.frame) + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    CGFloat bottomOffset = CGRectGetHeight(self.tabBarController.tabBar.frame);
    self.tableView.contentInset = UIEdgeInsetsMake( topOffset, 0, bottomOffset, 0);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - ELMainTabBarProtocol
-(BOOL) shouldShowNavBar {
    return YES;
}

#pragma mark - Helper Functions 

-(void) handleContactPressed {
    [_feedbackController presentEmailFeedbackVC];
}

-(void) handleRateButtonPressed {
    [_feedbackController openExternalAppStore];
}

-(BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if([identifier isEqualToString: @"contact"]) {
        [self handleContactPressed];
        return NO;
    }
    else if([identifier isEqualToString: @"rate"]) {
        [self handleRateButtonPressed];
    }
    
    return YES;
}

@end
