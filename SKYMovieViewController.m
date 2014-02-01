//
//  SKYMovieViewController.m
//  MovieMood
//
//  Created by Eric Lee on 2/1/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import "SKYMovieViewController.h"
#import "JLTMDbClient.h"

@interface SKYMovieViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *movieTitle;
@property (weak, nonatomic) IBOutlet UITextView *description;
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
    [[JLTMDbClient sharedAPIInstance] GET:kJLTMDbMovie withParameters:@{@"id": movidId} andResponseBlock:^(id response, NSError *error) {
        if(!error) {
            _movieData = response;
            
            NSURL *headerURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", @"http://image.tmdb.org/t/p/w185/", [_movieData objectForKey:@"backdrop_path"]]];
            self.headerImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:headerURL]];
            
            self.movieTitle.text = [_movieData objectForKey:@"title"];
            self.description.text = [_movieData objectForKey:@"overview"];
        }
    }];
    return nil;
}
@end
