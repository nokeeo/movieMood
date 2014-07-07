//
//  SKYMovieViewController.h
//  MovieMood
//
//  Created by Eric Lee on 2/1/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELMediaEntity.h"
#import "ELMovieDetailView.h"

@interface ELMovieViewController : UIViewController <MovieDetailButtonResponse, UIAlertViewDelegate>
@property (nonatomic, retain) ELMediaEntity *movie;
@property (nonatomic, retain) UIColor *selectedColor;
@end
