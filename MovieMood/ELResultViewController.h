//
//  SKYResultViewController.h
//  MovieMood
//
//  Created by Aaron Sky on 1/31/14.
//  Copyright (c) 2014 Eric Lee Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELMovieTableViewController.h"
#import "ELResultMovieCell.h"

@interface ELResultViewController : ELMovieTableViewController <UIAlertViewDelegate, favButtonProtocol>
@property (nonatomic,retain) NSDictionary* movieProps;
@property (nonatomic, retain) UIColor *selectedColor;
@end
