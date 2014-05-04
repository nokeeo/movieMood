//
//  SKYMovieTableViewController.h
//  MovieMood
//
//  Created by Eric Lee on 5/3/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKYMovie.h"

@interface SKYMovieTableViewController : UITableViewController
@property (nonatomic, retain) NSMutableArray *movieSource;
@property (nonatomic, retain) SKYMovie *selectedMovie;
@property (nonatomic, retain) NSMutableDictionary *imageCache;
@end
