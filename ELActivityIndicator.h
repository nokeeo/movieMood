//
//  SKYActivityIndicator.h
//  MovieMood
//
//  Created by Eric Lee on 2/2/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ELActivityIndicator : UIView
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

-(void) fadeInView;
-(void) fadeOutView;
@end
