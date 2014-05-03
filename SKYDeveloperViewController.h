//
//  SKYDeveloperViewController.h
//  MovieMood
//
//  Created by Eric Lee on 5/2/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol AppFeedbackProtocol <NSObject>

-(void)dislikePressed;

@end

@interface SKYDeveloperViewController : UIViewController <UIAlertViewDelegate>
@property (nonatomic, retain) id delegate;

@end
