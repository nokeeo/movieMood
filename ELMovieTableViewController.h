//
//  SKYMovieTableViewController.h
//  MovieMood
//
//  Created by Eric Lee on 5/3/14.
//  Copyright (c) 2014 Eric Lee Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELMediaEntity.h"

@interface ELMovieTableViewController : UITableViewController
@property (nonatomic, retain) NSMutableArray *movieSource;
@property (nonatomic, retain) ELMediaEntity *selectedMovie;
@property (nonatomic, retain) NSMutableDictionary *imageCache;
@end
