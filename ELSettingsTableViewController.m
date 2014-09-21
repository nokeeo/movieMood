//
//  ELSettingsTableViewController.m
//  MovieMood
//
//  Created by Eric Lee on 9/20/14.
//  Copyright (c) 2014 Eric Lee Productions. All rights reserved.
//

#import "ELSettingsTableViewController.h"

static const NSString *EMAIL_ADDRESS = @"feedback@moviemoodapp.com";
static const NSString *STORE_URL = @"https://itunes.apple.com/us/app/moviemood/id877461524?mt=8&uo=4&at=11lu3P";


@interface ELSettingsTableViewController () {
    NSDictionary *_cellTitles;
}

@property (nonatomic, strong) MFMailComposeViewController * mailVC;

@end

@implementation ELSettingsTableViewController


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


#pragma mark - MailComposeDelegate
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    if(!error)
        [_mailVC dismissViewControllerAnimated:YES completion:nil];
    else {
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                             message:@"We were not able to send your message please try again."
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles: nil];
        [errorAlert show];
    }
}

#pragma mark - ELMainTabBarProtocol
-(BOOL) shouldShowNavBar {
    return YES;
}

#pragma mark - Helper Functions 

-(void) handleContactPressed {
    if([MFMailComposeViewController canSendMail]) {
        _mailVC = [[MFMailComposeViewController alloc] init];
        _mailVC.mailComposeDelegate = self;
        [_mailVC setSubject:@"MovieMood Feedback"];
        [_mailVC setToRecipients:[NSArray arrayWithObjects: EMAIL_ADDRESS, nil]];
    
        [self presentViewController: _mailVC animated:YES completion: nil];
    }
    else {
        UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"This device cannot send mail"
                                                               message: [[NSString alloc] initWithFormat:@"%@%@", @"We still want to hear from you. Email us at ", EMAIL_ADDRESS]
                                                              delegate:nil cancelButtonTitle: @"Done" otherButtonTitles: nil];
        [errorMessage show];
    }
}

-(void) handleRateButtonPressed {
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: (NSString *)STORE_URL]];
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
