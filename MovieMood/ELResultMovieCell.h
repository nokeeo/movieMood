//
//  SKYResultMovieCell.h
//  MovieMood
//
//  Created by Eric Lee on 2/1/14.
//  Copyright (c) 2014 Eric Lee Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ResultMovieCellProtocol <NSObject>

-(void) favButtonPressed: (id) sender;
-(void) doNotShowButtonPressed: (id) sender;

@end

@interface ELResultMovieCell : UITableViewCell <UIScrollViewDelegate>

@property (nonatomic, retain) UIImageView *artwork;
@property (nonatomic, retain) UILabel *title;
@property BOOL rightSlideMenuEnabled;
@property UIColor *backgroundShadeColor;
@property BOOL isFavOn;
@property id<ResultMovieCellProtocol> delegate;

-(void)resetFavScrollView;

@end
