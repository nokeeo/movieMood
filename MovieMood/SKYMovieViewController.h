//
//  SKYMovieViewController.h
//  MovieMood
//
//  Created by Eric Lee on 2/1/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKYMovie.h"
#import "SKYMovieDetailView.h"

@interface SKYMovieViewController : UIViewController <MovieDetailButtonResponse>
@property (nonatomic, retain) SKYMovie *movie;
@property (nonatomic, retain) UIColor *selectedColor;
@end
