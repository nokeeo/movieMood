//
//  SKYMovieViewController.m
//  MovieMood
//
//  Created by Eric Lee on 2/1/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import <MediaPlayer/MPMoviePlayerController.h>
#import "SKYMovieViewController.h"
#import "SKYActivityIndicator.h"
#import "AutoScrollLabel.h"
#import "SKYColorAnalyser.h"
#import "SKYMovieRequests.h"
#import "SKYBorderButton.h"
#import "SKYDataManager.h"

@interface SKYMovieViewController ()
@property (nonatomic, retain) SKYActivityIndicator *activityIndicatorView;
@property (nonatomic, retain) UIView *coverView;
@property (nonatomic, retain) SKYMovieDetailView *contentView;
@property (nonatomic, retain) UIScrollView *contentScrollView;
@end

@implementation SKYMovieViewController

@synthesize movie = _movie;
@synthesize activityIndicatorView = _activityIndicatorView;
@synthesize selectedColor = _selectedColor;
@synthesize contentView = _contentView;
@synthesize contentScrollView = _contentScrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGSize size = self.view.bounds.size;
    CGSize activityViewSize = CGSizeMake(size.width * .2, size.width * .2);
    
    _activityIndicatorView = [[SKYActivityIndicator alloc] initWithFrame:CGRectMake((size.width - activityViewSize.width) / 2,
                                                                                    (size.height - activityViewSize.height) / 2,
                                                                                    activityViewSize.width,
                                                                                    activityViewSize.height)];
    _coverView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f,
                                                          size.width,
                                                          size.height)];
    _coverView.backgroundColor = [UIColor whiteColor];
    
    CGRect contentSize = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _contentScrollView = [[UIScrollView alloc] initWithFrame: contentSize];
    _contentScrollView.userInteractionEnabled = YES;
    _contentScrollView.bounces = YES;
    _contentScrollView.scrollEnabled = YES;
    
    _contentView = (SKYMovieDetailView *)[[[NSBundle mainBundle] loadNibNamed:@"MovieView" owner:self options:nil] objectAtIndex:0];
    _contentView.frame = contentSize;
    
    UIColor *tintColor = _selectedColor;
    _activityIndicatorView.activityIndicator.color = _selectedColor;
    self.navigationController.navigationBar.tintColor = _selectedColor;
    
    NSURL *artworkURL = [NSURL URLWithString: _movie.coverImage170];
    _contentView.artworkImage.image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:artworkURL]];
    
    
    _contentView.movieTitle.text = _movie.title;
    _contentView.genreLabel.text = _movie.genre;
    _contentView.buyLabel.text = [NSString stringWithFormat: @"%@ %@", _contentView.buyLabel.text ,_movie.purchasePrice];
    _contentView.movieInformationView.releaseDateLabel.text = [NSString stringWithFormat:@"%@ %@", _contentView.movieInformationView.releaseDateLabel.text, _movie.releaseDate];
    _contentView.movieInformationView.directorLabel.text = [NSString stringWithFormat:@"%@ %@", _contentView.movieInformationView.directorLabel.text, _movie.director];
    
    if(!_movie.rentalPrice)
        _contentView.rentLabel.text = @": Not Available";
    else
        _contentView.rentLabel.text = [NSString stringWithFormat:@"%@ %@", _contentView.rentLabel.text, _movie.rentalPrice];
    
    _contentView.iTunesButton.color = tintColor;
    _contentView.buttonResponseDelegate = self;
    
    [SKYMovieRequests getMovieDetailData: _movie successCallback:^(id requestResponse){
        _movie = (SKYMovie*) requestResponse;
        [_activityIndicatorView fadeOutView];
        [UIView animateWithDuration: .75 animations:^{
            _coverView.alpha = 0.f;
        }];
        
    } failCallBack:^(NSError * error){
        //
    }];
    
    [_coverView addSubview:_activityIndicatorView];
    [_contentScrollView addSubview: _contentView];
    [self.view addSubview: _contentScrollView];
    [self.view addSubview:_coverView];
    [_activityIndicatorView fadeInView];
}

-(void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [_contentView setSummaryText: _movie.description];
    [_contentScrollView setContentSize: [_contentView getSizeOfContent]];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)iTunesButtonPressedResponse:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_movie.storeURL]];
}

-(void)favButtonPressedResponse:(id)sender {
    SKYDataManager *dataManager = [[SKYDataManager alloc] init];
    
    if(![dataManager isMovieFav: _movie])
        [dataManager saveMovie: _movie];
    else
        [dataManager deleteMovie: _movie];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
