//
//  SKYInfoContainerViewController.m
//  MovieMood
//
//  Created by Eric Lee on 5/3/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import "SKYInfoContainerViewController.h"

@interface SKYInfoContainerViewController ()

@property (nonatomic, retain) MFMailComposeViewController *mailVC;
@property (nonatomic, retain) NSString *emailAddress;
@end

@implementation SKYInfoContainerViewController

@synthesize emailAddress = _emailAddress;
@synthesize mailVC = _mailVC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _emailAddress = @"eric.lee.edl@gmail.com";
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dislikePressed {
    if([MFMailComposeViewController canSendMail]) {
        _mailVC = [[MFMailComposeViewController alloc] init];
        _mailVC.mailComposeDelegate = self;
        [_mailVC setSubject:@"MovieMood Feedback"];
        [_mailVC setToRecipients:[NSArray arrayWithObjects: _emailAddress, nil]];

        [self presentViewController: _mailVC animated:YES completion: nil];
    }
    else {
        UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"This device cannot send mail"
                                                               message: [[NSString alloc] initWithFormat:@"%@%@", @"We still want to hear from you. Email us at", _emailAddress]
                                                              delegate:nil cancelButtonTitle: nil otherButtonTitles: nil];
        [errorMessage show];
    }
}

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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
