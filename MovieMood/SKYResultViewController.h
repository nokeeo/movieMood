//
//  SKYResultViewController.h
//  MovieMood
//
//  Created by Aaron Sky on 1/31/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKYMovieTableViewController.h"
#import "SKYResultMovieCell.h"

@interface SKYResultViewController : SKYMovieTableViewController <UIAlertViewDelegate, favButtonProtocol>
@property (nonatomic,retain) NSDictionary* movieProps;
@property (nonatomic, retain) UIColor *selectedColor;
@end
