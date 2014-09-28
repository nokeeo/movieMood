//
//  ELFeedbackController.m
//  MovieMood
//
//  Created by Eric Lee on 9/21/14.
//  Copyright (c) 2014 Eric Lee Productions. All rights reserved.
//

#import "ELFeedbackController.h"
#import "ELAppDelegate.h"
#import "Flurry.h"

@interface ELFeedbackController()

@property (nonatomic, weak) UIViewController *parentVC;

@property (nonatomic, retain) UIAlertView *appFeelingAlert;
@property (nonatomic, retain) UIAlertView *reviewAlert;
@property (nonatomic, retain) UIAlertView *emailFeedbackAlert;

@property (nonatomic, strong) MFMailComposeViewController * mailVC;

@end

static const NSString *EMAIL_ADDRESS = @"feedback@moviemoodapp.com";
static const NSString *STORE_URL = @"https://itunes.apple.com/us/app/moviemood/id877461524?mt=8&uo=4&at=11lu3P";

@implementation ELFeedbackController


-(id) initWithParentVC: (UIViewController *) parent {
    self = [super init];
    if(self) {
        _parentVC = parent;
    }
    
    return self;
}

-(void) beginFeedbackFlow {
    [Flurry logEvent: @"Prompted_Feedback"];
    _appFeelingAlert = [[UIAlertView alloc] initWithTitle:@"Do you love MovieMood?" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Absolutely", @"Not Quite", nil];
    [_appFeelingAlert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0 && [alertView  isEqual: _appFeelingAlert]) {
        _reviewAlert = [[UIAlertView alloc] initWithTitle:@"That's Great!"
                                                  message:@"We'd really appreciate it if you rate our app"
                                                 delegate:self
                                        cancelButtonTitle:nil
                                        otherButtonTitles:@"Sure", @"Maybe Later", nil];
        [_reviewAlert show];
    }
    else if(buttonIndex == 1 && [alertView isEqual: _appFeelingAlert]){
        _emailFeedbackAlert = [[UIAlertView alloc] initWithTitle: @"Ah man..."
                                                         message:@"We'd really appreciate it if you give us feedback"
                                                        delegate:self
                                               cancelButtonTitle:nil
                                               otherButtonTitles: @"Sure" , @"Maybe Later", nil];
        [_emailFeedbackAlert show];
    }
    
    else if(buttonIndex == 0 && [_reviewAlert isEqual: alertView]) {
        [self openExternalAppStore];
    }
    
    else if((buttonIndex == 0 && [alertView isEqual: _emailFeedbackAlert])) {
        [self presentEmailFeedbackVC];
    }
    
    ELAppDelegate *appDelegate = (ELAppDelegate *) [[UIApplication sharedApplication] delegate];
    appDelegate.shouldShowFeedbackForSession = NO;
}

-(void) presentEmailFeedbackVC {
    if([MFMailComposeViewController canSendMail]) {
        _mailVC = [[MFMailComposeViewController alloc] init];
        _mailVC.mailComposeDelegate = self;
        [_mailVC setSubject:@"MovieMood Feedback"];
        [_mailVC setToRecipients:[NSArray arrayWithObjects: EMAIL_ADDRESS, nil]];
        
        [_parentVC presentViewController: _mailVC animated:YES completion: nil];
    }
    else {
        UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"This device cannot send mail"
                                                               message: [[NSString alloc] initWithFormat:@"%@%@", @"We still want to hear from you. Email us at ", EMAIL_ADDRESS]
                                                              delegate:nil cancelButtonTitle: @"Done" otherButtonTitles: nil];
        [errorMessage show];
    }
    [self setUserGaveFeedback];
}

-(void) openExternalAppStore {
    [self setUserGaveFeedback];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: (NSString *)STORE_URL]];
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

-(void) setUserGaveFeedback {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [Flurry logEvent: @"Gave_Feedback"];
    [userDefaults setObject: [NSNumber numberWithBool: YES] forKey: @"haveGivenFeedback"];
}

@end
