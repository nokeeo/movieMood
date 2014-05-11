//
//  SKYResultMovieCell.h
//  MovieMood
//
//  Created by Eric Lee on 2/1/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKYResultMovieCell : UITableViewCell <UIScrollViewDelegate>
//@property (weak, nonatomic) IBOutlet UILabel *title;
//@property (weak, nonatomic) IBOutlet UIImageView *artwork;

@property (nonatomic, retain) UIImageView *artwork;
@property (nonatomic, retain) UILabel *title;
@property BOOL rightSlideMenuEnabled;

@end
