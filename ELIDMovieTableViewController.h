//
//  ELIDMovieTableViewController.h
//  MovieMood
//
//  Created by Eric Lee on 9/21/14.
//  Copyright (c) 2014 Eric Lee Productions. All rights reserved.
//

#import "ELMovieTableViewController.h"

@interface ELIDMovieTableViewController : ELMovieTableViewController

@property NSArray *movieIDs;

-(void) reloadTable;

@end
