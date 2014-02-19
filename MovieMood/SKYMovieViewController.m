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

@interface SKYMovieViewController ()
@property (nonatomic, retain) SKYActivityIndicator *activityIndicatorView;
@property (nonatomic, retain) UIView *coverView;
@property (weak, nonatomic) IBOutlet UIImageView *artworkImage;
@property (weak, nonatomic) IBOutlet UILabel *movieTitle;
@property (weak, nonatomic) IBOutlet UILabel *genreLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyLabel;
@property (weak, nonatomic) IBOutlet UILabel *rentLabel;
@property (weak, nonatomic) IBOutlet SKYBorderButton *iTunesButton;
@property (weak, nonatomic) IBOutlet SKYBorderButton *trailerButton;
@property (weak, nonatomic) IBOutlet UILabel *directorLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseDateLabel;
@property (weak, nonatomic) IBOutlet UITextView *summaryTextView;

@end

@implementation SKYMovieViewController

@synthesize movie = _movie;
@synthesize activityIndicatorView = _activityIndicatorView;
@synthesize selectedColor = _selectedColor;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    
    [_coverView addSubview:_activityIndicatorView];
    [self.view addSubview:_coverView];
    [_activityIndicatorView fadeInView];
    
    SKYColorAnalyser *analyser = [[SKYColorAnalyser alloc] init];
    UIColor *tintColor = [analyser tintColor:_selectedColor withTintConst: - .25];
    _activityIndicatorView.activityIndicator.color = tintColor;
    self.navigationController.navigationBar.tintColor = tintColor;
    
    NSURL *artworkURL = [NSURL URLWithString: _movie.coverImage170];
    _artworkImage.image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:artworkURL]];
    _artworkImage.layer.cornerRadius = 10;
    _artworkImage.layer.borderWidth = 1;
    _artworkImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _artworkImage.layer.masksToBounds = YES;
    
    _movieTitle.text = _movie.title;
    _genreLabel.text = _movie.genre;
    _buyLabel.text = [NSString stringWithFormat: @"%@ %@", _buyLabel.text ,_movie.purchasePrice];
    _releaseDateLabel.text = [NSString stringWithFormat:@"%@ %@", _releaseDateLabel.text, _movie.releaseDate];
    _directorLabel.text = [NSString stringWithFormat:@"%@ %@", _directorLabel.text, _movie.director];
    _summaryTextView.text = _movie.description;
    
    if(!_movie.rentalPrice)
        _rentLabel.text = @": Not Available";
    else
        _rentLabel.text = [NSString stringWithFormat:@"%@ %@", _rentLabel.text, _movie.rentalPrice];
    
    _iTunesButton.color = tintColor;
    _trailerButton.color = tintColor;
    
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
