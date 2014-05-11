//
//  SKYResultMovieCell.m
//  MovieMood
//
//  Created by Eric Lee on 2/1/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import "SKYResultMovieCell.h"
#import "SKYMovieCellScrollView.h"

#define SLIDE_WIDTH 60

@interface SKYResultMovieCell() {
    CGFloat slideMenuCatch;
}

@end

@implementation SKYResultMovieCell

@synthesize artwork = _artwork;
@synthesize title = _title;
@synthesize rightSlideMenuEnabled = _rightSlideMenuEnabled;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) awakeFromNib {
    _artwork = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, 46, self.bounds.size.height)];
    _title = [[UILabel alloc] initWithFrame: CGRectMake(64, 22, 223, 21)];
    
    self.backgroundColor = [UIColor redColor];
    self.contentView.backgroundColor = [UIColor redColor];
    
    SKYMovieCellScrollView *slideScrollView = [[SKYMovieCellScrollView alloc] initWithFrame: CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    slideScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) + SLIDE_WIDTH,  CGRectGetHeight(self.bounds));
    slideScrollView.delegate = self;
    slideScrollView.contentOffset = CGPointMake(SLIDE_WIDTH, 0);
    slideScrollView.showsHorizontalScrollIndicator = NO;
    
    [self.contentView addSubview: slideScrollView];
    
    UIView *buttonView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, SLIDE_WIDTH, CGRectGetHeight(self.bounds))];
    buttonView.backgroundColor = [UIColor redColor];
    [slideScrollView addSubview: buttonView];
    
    UIView *scrollViewContent = [[UIView alloc] initWithFrame: CGRectMake(SLIDE_WIDTH, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    scrollViewContent.backgroundColor = [UIColor whiteColor];
    [slideScrollView addSubview:scrollViewContent];
    
    [scrollViewContent addSubview: _artwork];
    [scrollViewContent addSubview:_title];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
