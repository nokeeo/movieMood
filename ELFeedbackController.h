//
//  ELFeedbackController.h
//  MovieMood
//
//  Created by Eric Lee on 9/21/14.
//  Copyright (c) 2014 Eric Lee Productions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

@interface ELFeedbackController : NSObject <UIAlertViewDelegate, MFMailComposeViewControllerDelegate>

-(id) initWithParentVC: (UIViewController *) parent;

-(void) presentEmailFeedbackVC;
-(void) beginFeedbackFlow;
-(void) openExternalAppStore;

@end
