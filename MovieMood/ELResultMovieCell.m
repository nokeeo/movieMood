//
//  SKYResultMovieCell.m
//  MovieMood
//
//  Created by Eric Lee on 2/1/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import "ELResultMovieCell.h"
#import "ELDataManager.h"
#import "ELMovieCellScrollView.h"

#define SLIDE_WIDTH 49.85

@interface ELResultMovieCell() {
    CGFloat slideMenuCatch;
}

@property (nonatomic, retain) UIView *buttonView;
@property (nonatomic) UIButton *favButton;
@property (nonatomic, retain) ELMovieCellScrollView *slideScrollView;
@end

@implementation ELResultMovieCell

@synthesize artwork = _artwork;
@synthesize title = _title;
@synthesize rightSlideMenuEnabled = _rightSlideMenuEnabled;
@synthesize buttonView = _buttonView;
@synthesize backgroundShadeColor = _backgroundShadeColor;
@synthesize isFavOn = _isFavOn;
@synthesize favButtonDelegate = _favButtonDelegate;
@synthesize slideScrollView = _slideScrollView;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

-(void) awakeFromNib {
    _artwork = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, SLIDE_WIDTH, self.frame.size.height)];
    _title = [[UILabel alloc] initWithFrame: CGRectMake(64, 25, 223, 21)];
    
     _slideScrollView = [[ELMovieCellScrollView alloc] initWithFrame: CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    _slideScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) + SLIDE_WIDTH,  CGRectGetHeight(self.bounds));
    _slideScrollView.delegate = self;
    _slideScrollView.contentOffset = CGPointMake(SLIDE_WIDTH, 0);
    _slideScrollView.showsHorizontalScrollIndicator = NO;
    
    [self.contentView addSubview: _slideScrollView];
    
    _buttonView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, SLIDE_WIDTH, CGRectGetHeight(self.bounds))];
    
    [_slideScrollView addSubview: _buttonView];
    CGSize buttonSize = CGSizeMake(SLIDE_WIDTH, SLIDE_WIDTH);
    _favButton = [[UIButton alloc] initWithFrame: CGRectMake(0,
                                                            (self.bounds.size.height / 2) - (SLIDE_WIDTH / 2),
                                                            buttonSize.width,
                                                            buttonSize.height)];
    _favButton.tintColor = [UIColor whiteColor];
    [_favButton addTarget: self action:@selector(favButtonPressed:) forControlEvents: UIControlEventTouchUpInside];
    [_buttonView addSubview: _favButton];
    
    UIView *scrollViewContent = [[UIView alloc] initWithFrame: CGRectMake(SLIDE_WIDTH, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    scrollViewContent.backgroundColor = [UIColor whiteColor];
    [_slideScrollView addSubview:scrollViewContent];
    
    [scrollViewContent addSubview: _artwork];
    [scrollViewContent addSubview:_title];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enclosingTableViewDidScroll) name:@"SKYSwipeCellShouldRetract" object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView {
    if(scrollView.contentOffset.x > SLIDE_WIDTH || !_rightSlideMenuEnabled)
        scrollView.contentOffset = CGPointMake(SLIDE_WIDTH, 0);
    _buttonView.frame = CGRectMake(_buttonView.bounds.origin.x + scrollView.contentOffset.x,
                                   0,
                                   SLIDE_WIDTH,
                                   CGRectGetHeight(self.bounds));
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SKYSwipeCellShouldRetract" object:self userInfo:nil];
}


-(void) scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if(scrollView.contentOffset.x > SLIDE_WIDTH)
        scrollView.contentOffset = CGPointMake(SLIDE_WIDTH, 0);
    else
        [scrollView setContentOffset: CGPointMake(SLIDE_WIDTH, 0) animated:YES];
}

-(void)setIsFavOn:(BOOL)isFavOn {
    _isFavOn = isFavOn;
    [self toggleFavButton: _isFavOn];
}

-(BOOL)isFavOn {
    return _isFavOn;
}

-(void)setBackgroundShadeColor:(UIColor *)backgroundShadeColor {
    _backgroundShadeColor = backgroundShadeColor;
    //self.backgroundColor = backgroundShadeColor;
    _buttonView.backgroundColor = backgroundShadeColor;
}

-(UIColor *)backgroundShadeColor {
    return _backgroundShadeColor;
}

-(void)toggleFavButton:(BOOL) setting {
    if(setting) {
        UIImage *favButtonImage = [UIImage imageNamed:@"favFill.png"];
        favButtonImage = [favButtonImage imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
        [_favButton setImage: favButtonImage forState:UIControlStateNormal];
    }
    else {
        UIImage *favButtonImage = [UIImage imageNamed:@"fav.png"];
        favButtonImage = [favButtonImage imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
        [_favButton setImage: favButtonImage forState:UIControlStateNormal];
    }
}

-(void)favButtonPressed:(UIButton *) sender {
    [self setIsFavOn: !_isFavOn];
    [_favButtonDelegate favButtonPressed: self];
}

-(void)enclosingTableViewDidScroll {
    if(!_slideScrollView.dragging) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_slideScrollView setContentOffset: CGPointMake(SLIDE_WIDTH, 0) animated:YES];
        });
    }
}

-(void)resetFavScrollView {
    [_slideScrollView setContentOffset: CGPointMake(SLIDE_WIDTH, 0)];
}
@end
