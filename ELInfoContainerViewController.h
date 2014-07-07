//
//  SKYInfoContainerViewController.h
//  MovieMood
//
//  Created by Eric Lee on 5/3/14.
//  Copyright (c) 2014 Eric Lee Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "ELDeveloperViewController.h"

@interface ELInfoContainerViewController : UIViewController <MFMailComposeViewControllerDelegate, AppFeedbackProtocol, SKStoreProductViewControllerDelegate>

@end
