//
//  SKYDeveloperViewController.h
//  MovieMood
//
//  Created by Eric Lee on 5/2/14.
//  Copyright (c) 2014 Eric Lee Productions. All rights reserved.
//

#import <StoreKit/StoreKit.h>
#import <UIKit/UIKit.h>


@protocol AppFeedbackProtocol <NSObject>

-(void)dislikePressed;
-(void)appStorePressed;

@end

@interface ELDeveloperViewController : UIViewController <UIAlertViewDelegate>
@property (nonatomic, retain) id delegate;

@end
