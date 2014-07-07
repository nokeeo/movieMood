//
//  SKYResultMovieCell.h
//  MovieMood
//
//  Created by Eric Lee on 2/1/14.
//  Copyright (c) 2014 Eric Lee Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ELResultMovieCell : UITableViewCell <UIScrollViewDelegate>

@property (nonatomic, retain) UIImageView *artwork;
@property (nonatomic, retain) UILabel *title;
@property BOOL rightSlideMenuEnabled;
@property UIColor *backgroundShadeColor;
@property BOOL isFavOn;
@property id favButtonDelegate;

-(void)resetFavScrollView;

@end

@protocol favButtonProtocol <NSObject>

-(void)favButtonPressed:(ELResultMovieCell *) sender;

@end
