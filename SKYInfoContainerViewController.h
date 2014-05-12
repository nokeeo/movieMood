//
//  SKYInfoContainerViewController.h
//  MovieMood
//
//  Created by Eric Lee on 5/3/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "SKYDeveloperViewController.h"

@interface SKYInfoContainerViewController : UIViewController <MFMailComposeViewControllerDelegate, AppFeedbackProtocol, SKStoreProductViewControllerDelegate>

@end
