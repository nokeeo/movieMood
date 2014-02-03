//
//  SKYMovieViewController.m
//  MovieMood
//
//  Created by Eric Lee on 2/1/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import "SKYMovieViewController.h"
#import "JLTMDbClient.h"
#import "TLAlertView.h"
#import "SKYActivityIndicator.h"
#import "AutoScrollLabel.h"
#import "SKYColorAnalyser.h"

@interface SKYMovieViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet AutoScrollLabel *movieTitle;
@property (weak, nonatomic) IBOutlet UILabel *releaseDate;
@property (weak, nonatomic) IBOutlet UILabel *runtime;
@property (weak, nonatomic) IBOutlet UILabel *ratingOutOfTen;
@property (weak, nonatomic) IBOutlet UITextView *description;
@property (weak, nonatomic) IBOutlet UIImageView *rating;
@property (nonatomic, retain) SKYActivityIndicator *activityIndicatorView;
@property (nonatomic, retain) UIView *coverView;
@property id movieData;

-(id)getMovidWithId: (NSString *) movidId;
@end

@implementation SKYMovieViewController

@synthesize movieId = _movieId;
@synthesize movieData = _movieData;
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
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    
    _movieData = [self getMovidWithId: _movieId];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(id)getMovidWithId:(NSString *) movidId{
    __block TLAlertView *errorAlertView = [[TLAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"") message:NSLocalizedString(@"Please try again later", @"") buttonTitle:NSLocalizedString(@"OK",@"")];
    [[JLTMDbClient sharedAPIInstance] GET:kJLTMDbMovie withParameters:@{@"id": movidId} andResponseBlock:^(id response, NSError *error) {
        if(!error) {
            _movieData = response;
            
            NSURL *headerURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", @"http://image.tmdb.org/t/p/w185/", [_movieData objectForKey:@"backdrop_path"]]];
            self.headerImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:headerURL]];
            
            self.movieTitle.text = [_movieData objectForKey:@"title"];
            NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd"];
            NSString* release = [_movieData objectForKey:@"release_date"];
            NSDate* released = [dateFormat dateFromString:release];
            NSDateComponents* components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:released];
            self.releaseDate.text = [NSString stringWithFormat:@"%d", (int)[components year]];
            self.runtime.text = [NSString stringWithFormat:@"%@ %@", [_movieData objectForKey:@"runtime"], @"minutes"];
            NSString* rating = [NSString stringWithFormat:@"%@",[_movieData objectForKey:@"vote_average"]];
            if ([rating length] > 3)
                rating = [rating substringToIndex:3];
            self.ratingOutOfTen.text = [NSString stringWithFormat:@"%@/10",rating];
            self.description.text = [_movieData objectForKey:@"overview"];
            self.description.selectable = NO;
            
            [_activityIndicatorView fadeOutView];
            [UIView animateWithDuration: .75 animations:^{
                _coverView.alpha = 0.f;
            }];
        } else
            [errorAlertView show];
    }];
    [[JLTMDbClient sharedAPIInstance] GET:kJLTMDbMovieReleases withParameters:@{@"id": movidId} andResponseBlock:^(id response, NSError *error) {
        if(!error) {
            _movieData = [[response objectForKey:@"countries"] objectAtIndex:0];
            
            if ([[_movieData objectForKey:@"iso_3166_1"] isEqualToString:@"US"]) {
                NSString* rating = [_movieData objectForKey:@"certification"];
                rating = [rating isEqualToString:@""] ? @"Unrated" : rating;
                UIImage* ratingImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", rating]];
                self.rating.image = ratingImage;
            } else
                self.rating.image = [UIImage imageNamed:@"Unrated.png"];
            
        }
        else
            [errorAlertView show];
    }];
    return nil;
}
@end
