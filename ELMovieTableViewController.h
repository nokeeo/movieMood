//
//  SKYMovieTableViewController.h
//  MovieMood
//
//  Created by Eric Lee on 5/3/14.
//  Copyright (c) 2014 Eric Lee Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELMediaEntity.h"
#import "ELResultMovieCell.h"

@interface ELMovieTableViewController : UITableViewController <ResultMovieCellProtocol>
@property (nonatomic, retain) NSMutableArray *movieSource;
@property (nonatomic, retain) ELMediaEntity *selectedMovie;
@property (nonatomic, retain) NSMutableDictionary *imageCache;

-(void) removeCellAtIndex: (NSIndexPath *) indexPath;

@end
