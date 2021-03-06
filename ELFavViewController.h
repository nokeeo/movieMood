//
//  SKYFavViewController.h
//  MovieMood
//
//  Created by Eric Lee on 5/3/14.
//  Copyright (c) 2014 Eric Lee Productions. All rights reserved.
//

#import "ELMovieTableViewController.h"
#import "ELResultMovieCell.h"
#import "ELMainTabProtocol.h"
#import "ELIDMovieTableViewController.h"

@interface ELFavViewController : ELIDMovieTableViewController <UIAlertViewDelegate, ELMainTabProtocol>

@end
