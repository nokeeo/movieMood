//
//  SKYMovieViewController.m
//  MovieMood
//
//  Created by Eric Lee on 2/1/14.
//  Copyright (c) 2014 Eric Lee Productions. All rights reserved.
//

#import <MediaPlayer/MPMoviePlayerController.h>
#import "ELMovieViewController.h"
#import "ELActivityIndicator.h"
#import "ELColorAnalyser.h"
#import "ELMovieRequests.h"
#import "ELBorderButton.h"
#import "ELDataManager.h"
#import "ELStoreController.h"

@interface ELMovieViewController ()
@property (nonatomic, retain) ELActivityIndicator *activityIndicatorView;
@property (nonatomic, retain) UIView *coverView;
@property (nonatomic, retain) ELMovieDetailView *contentView;
@property (nonatomic, retain) UIScrollView *contentScrollView;
@property (nonatomic, retain) ELStoreController *storeController;
@end

@implementation ELMovieViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void) awakeFromNib {
    [super awakeFromNib];
    _storeController = [[ELStoreController alloc] initWithVC: self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGSize size = self.view.bounds.size;
    CGSize activityViewSize = CGSizeMake(size.width * .2, size.width * .2);
    ELDataManager *dataManager = [[ELDataManager alloc] init];
    
    _activityIndicatorView = [[ELActivityIndicator alloc] initWithFrame:CGRectMake((size.width - activityViewSize.width) / 2,
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
    
    _contentView = (ELMovieDetailView *)[[[NSBundle mainBundle] loadNibNamed:@"MovieView" owner:self options:nil] objectAtIndex:0];
    _contentView.frame = contentSize;
    
    UIColor *tintColor = self.navigationController.navigationBar.tintColor;
    _activityIndicatorView.activityIndicator.color = tintColor;
    _selectedColor = self.navigationController.navigationBar.tintColor;
    
    NSURL *artworkURL = [NSURL URLWithString: _movie.coverImage170];
    _contentView.artworkImage.image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:artworkURL]];
    
    
    _contentView.movieTitle.text = _movie.title;
    _contentView.genreLabel.text = _movie.genre;
    _contentView.buyLabel.text = [NSString stringWithFormat: @"%@ %@", _contentView.buyLabel.text ,_movie.purchasePrice];
    _contentView.movieInformationView.delegate = self;
    _contentView.movieInformationView.doNotShowMovieButton.titleLabel.textColor = _selectedColor;
    [self updateDoNotShowButtonText];
    _contentView.movieInformationView.releaseDateLabel.text = [NSString stringWithFormat:@"%@ %@", _contentView.movieInformationView.releaseDateLabel.text, _movie.releaseDate];
    _contentView.movieInformationView.directorLabel.text = [NSString stringWithFormat:@"%@ %@", _contentView.movieInformationView.directorLabel.text, _movie.director];
    
    if(!_movie.rentalPrice)
        _contentView.rentLabel.text = @": Not Available";
    else
        _contentView.rentLabel.text = [NSString stringWithFormat:@"%@ %@", _contentView.rentLabel.text, _movie.rentalPrice];
    
    _contentView.iTunesButton.color = tintColor;
    _contentView.favButton.color = tintColor;
    _contentView.buttonResponseDelegate = self;
    
    [ELMovieRequests getMovieDetailData: _movie successCallback:^(id requestResponse){
        _movie = (ELMediaEntity*) requestResponse;
        _contentView.movieInformationView.ratingLabel.text = [NSString stringWithFormat:@"%@ %@", _contentView.movieInformationView.ratingLabel.text, _movie.rating];
        [_activityIndicatorView fadeOutView];
        [UIView animateWithDuration: .75 animations:^{
            _coverView.alpha = 0.f;
        }];
        
    } failCallBack:^(NSError * error){
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Uh oh!"
                                                             message:@"There was an error retrieving your movie! Please try again soon"
                                                            delegate:self
                                                   cancelButtonTitle:@"Ok"
                                                   otherButtonTitles: nil];
        _activityIndicatorView.alpha = 0.f;
        [errorAlert show];
    }];
    
    //Toggle Favbutton image
    [self setFavImage: [dataManager isMovieFav: _movie]];
    
    [_coverView addSubview:_activityIndicatorView];
    [_contentScrollView addSubview: _contentView];
    [self.view addSubview: _contentScrollView];
    [self.view addSubview:_coverView];
    [_activityIndicatorView fadeInView];
}

-(void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [_contentView setSummaryText: _movie.entityDescription];
    [_contentScrollView setContentSize: [_contentView getSizeOfContent]];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)iTunesButtonPressedResponse:(id)sender {
    [_storeController openStoreWithEntity: _movie];
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:_movie.storeURL]];
}

-(void)favButtonPressedResponse:(id)sender {
    ELDataManager *dataManager = [[ELDataManager alloc] init];
    
    if(![dataManager isMovieFav: _movie]) {
        [self setFavImage: YES];
        [dataManager saveMovie: _movie];
    }
    else {
        [self setFavImage: NO];
        [dataManager deleteMovie: _movie];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated: YES];
}

-(void)setFavImage:(BOOL) flag {
    NSString *imageName;
    if(flag)
        imageName = @"favFill.png";
    else
        imageName = @"fav.png";
    
    UIImage *favImage = [UIImage imageNamed: imageName];
    favImage = [favImage imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
    [_contentView.favButton setImage: favImage forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) doNotShowMeButtonPressed:(id)sender {
    ELDataManager *manager = [[ELDataManager alloc] init];
    if([manager canShowMovie: self.movie]) {
        [manager doNotShowMovie: self.movie];
        [self updateDoNotShowButtonText];
    }
    else {
        [manager doShowMovie: self.movie];
        [self updateDoNotShowButtonText];
    }
        
}

-(void) updateDoNotShowButtonText {
    ELDataManager *manager = [[ELDataManager alloc] init];
    UIButton *doNotShowButton = _contentView.movieInformationView.doNotShowMovieButton;
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithAttributedString: [doNotShowButton attributedTitleForState: UIControlStateNormal]];
    
    if([manager canShowMovie: self.movie]) {
        [title.mutableString setString: @"Do Not Show Me This Movie"];
    }
    else {
        [title.mutableString setString: @"Show Me This Movie"];
    }
    
    [doNotShowButton setAttributedTitle: title forState: UIControlStateNormal];
}
@end
