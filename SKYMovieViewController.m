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

@interface SKYMovieViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *movieTitle;
@property (weak, nonatomic) IBOutlet UILabel *releaseDate;
@property (weak, nonatomic) IBOutlet UILabel *runtime;
@property (weak, nonatomic) IBOutlet UILabel *ratingOutOfTen;
@property (weak, nonatomic) IBOutlet UITextView *description;
@property (weak, nonatomic) IBOutlet UIImageView *rating;
@property id movieData;

-(id)getMovidWithId: (NSString *) movidId;
@end

@implementation SKYMovieViewController

@synthesize movieId = _movieId;
@synthesize movieData = _movieData;

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

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
            self.releaseDate.text = [NSString stringWithFormat:@"%d", [components year]];
            self.runtime.text = [NSString stringWithFormat:@"%@ %@", [_movieData objectForKey:@"runtime"], @"minutes"];
            self.ratingOutOfTen.text = [NSString stringWithFormat:@"%@/%@",[_movieData objectForKey:@"vote_average"], @"10"];
            self.description.text = [_movieData objectForKey:@"overview"];
        } else
            [errorAlertView show];
    }];
    [[JLTMDbClient sharedAPIInstance] GET:kJLTMDbMovieReleases withParameters:@{@"id": movidId} andResponseBlock:^(id response, NSError *error) {
        if(!error) {
            _movieData = [[response objectForKey:@"countries"] objectAtIndex:0];
            
            if ([[_movieData objectForKey:@"iso_3166_1"] isEqualToString:@"US"]) {
                NSString* rating = [_movieData objectForKey:@"certification"];
                UIImage* ratingImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", rating]];
                self.rating.image = ratingImage;
            }
            
        }
        else
            [errorAlertView show];
    }];
    return nil;
}
@end
