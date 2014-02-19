//
//  SKYMovieViewController.h
//  MovieMood
//
//  Created by Eric Lee on 2/1/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKYMovie.h"

@interface SKYMovieViewController : UIViewController
@property (nonatomic, retain) SKYMovie *movie;
@property (nonatomic, retain) UIColor *selectedColor;
@end
