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
#import "SKYMovieDetailView.h"

@interface SKYMovieViewController ()
@property (nonatomic, retain) SKYActivityIndicator *activityIndicatorView;
@property (nonatomic, retain) UIView *coverView;
@property (nonatomic, retain) SKYMovieDetailView *contentView;
@end

@implementation SKYMovieViewController

@synthesize movie = _movie;
@synthesize activityIndicatorView = _activityIndicatorView;
@synthesize selectedColor = _selectedColor;
@synthesize contentView = _contentView;

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
    _contentView = (SKYMovieDetailView *)[[[NSBundle mainBundle] loadNibNamed:@"MovieView" owner:self options:nil] objectAtIndex:0];
    _contentView.frame = CGRectMake(0.f, 60.f, _contentView.frame.size.width, _contentView.frame.size.height);
    
    [_coverView addSubview:_activityIndicatorView];
    [self.view addSubview:_contentView];
    [self.view addSubview:_coverView];
    [_activityIndicatorView fadeInView];
    
    SKYColorAnalyser *analyser = [[SKYColorAnalyser alloc] init];
    UIColor *tintColor = [analyser tintColor:_selectedColor withTintConst: - .25];
    _activityIndicatorView.activityIndicator.color = tintColor;
    self.navigationController.navigationBar.tintColor = tintColor;
    
    NSURL *artworkURL = [NSURL URLWithString: _movie.coverImage170];
    _contentView.artworkImage.image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:artworkURL]];
    
    
    _contentView.movieTitle.text = _movie.title;
    _contentView.genreLabel.text = _movie.genre;
    _contentView.buyLabel.text = [NSString stringWithFormat: @"%@ %@", _contentView.buyLabel.text ,_movie.purchasePrice];
    _contentView.releaseDateLabel.text = [NSString stringWithFormat:@"%@ %@", _contentView.releaseDateLabel.text, _movie.releaseDate];
    _contentView.directorLabel.text = [NSString stringWithFormat:@"%@ %@", _contentView.directorLabel.text, _movie.director];
    _contentView.summaryLabel.text = _movie.description;
    
    if(!_movie.rentalPrice)
        _contentView.rentLabel.text = @": Not Available";
    else
        _contentView.rentLabel.text = [NSString stringWithFormat:@"%@ %@", _contentView.rentLabel.text, _movie.rentalPrice];
    
    _contentView.iTunesButton.color = tintColor;
    _contentView.trailerButton.color = tintColor;
    
    [SKYMovieRequests getMovieDetailData: _movie successCallback:^(id requestResponse){
        _movie = (SKYMovie*) requestResponse;
        [_activityIndicatorView fadeOutView];
        [UIView animateWithDuration: .75 animations:^{
            _coverView.alpha = 0.f;
        }];
        
    } failCallBack:^(NSError * error){
        //
    }];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
