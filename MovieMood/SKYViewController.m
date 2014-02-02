//
//  SKYViewController.m
//  MovieMood
//
//  Created by Aaron Sky on 1/30/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import "SKYViewController.h"
#import "SKYResultViewController.h"
#import "JLTMDbClient.h"
#import "SKYColorAnalyser.h"
#import "TLAlertView.h"

@interface SKYViewController ()
@property (nonatomic, retain) SKYColorAnalyser *colorAnalyser;
@property (nonatomic, retain) SKYColorPickerScrollView *contentScrollView;
@property (nonatomic, retain) NSDictionary *currentPorps;
@end

@implementation SKYViewController {
    UIDynamicAnimator* _animator;
    NSDictionary* results;
}

@synthesize colorAnalyser = _colorAnalyser;
@synthesize contentScrollView = _contentScrollView;
@synthesize currentPorps = _currentPorps;


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
    
    _contentScrollView = [[SKYColorPickerScrollView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x,
                                                                        self.view.bounds.origin.y,
                                                                        size.width,
                                                                        size.height)];
    _contentScrollView.colorViewDelegate = self;
    _contentScrollView.delegate = self;
    
    _colorAnalyser = [[SKYColorAnalyser alloc] init];
    [self.view addSubview:_contentScrollView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    //results = [self getMoviesByGenre:searchBar.text];
    [self performSegueWithIdentifier: @"ShowResults" sender: self];
}

- (NSDictionary*)getMoviesByGenre:(NSString *) genre callback:(void (^)(id requestResponse))sucessCallback {
    
    __block NSDictionary* fetchedData = [[NSDictionary alloc] init];
    __block TLAlertView *errorAlertView = [[TLAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"") message:NSLocalizedString(@"Please try again later", @"") buttonTitle:NSLocalizedString(@"OK",@"")];
    [[JLTMDbClient sharedAPIInstance] GET:kJLTMDbGenreMovies withParameters:@{@"id":genre} andResponseBlock:^(id response, NSError *error) {
        if(!error) {
            sucessCallback([response objectForKey:@"results"]);
        }
        else
            [errorAlertView show];
    }];
    return fetchedData;
}

-(void)colorDidChange:(id) sender {
    _contentScrollView.alwaysBounceVertical = false;
    _contentScrollView.colorIndicator.backgroundColor = _contentScrollView.colorWheel.currentColor;
    UIColor *complement = [_colorAnalyser calculateComplementaryWithColor: _contentScrollView.colorWheel.currentColor];
    [_contentScrollView changeSelectButtonColorWithColor: complement];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowResults"])
    {
        SKYResultViewController* resultVC = [segue destinationViewController];
        resultVC.movieProps = _currentPorps;
    }
}

-(void)selectButtonPressed:(id)sender {
    _currentPorps = [_colorAnalyser analyzeColor: _contentScrollView.colorWheel.currentColor];
    [self performSegueWithIdentifier:@"ShowResults" sender:self];
    /*for(id key in colorProps) {
        [self getMoviesByGenre: key callback:^(id requestResponse) {
            [searchResults setObject:requestResponse forKey: key];
            
            if(_requestsRecieved == _requestsSent) {
                NSMutableArray *movies = [[NSMutableArray alloc] init];
                for(id genreCode in searchResults) {
                    float currentProp = [[colorProps objectForKey:genreCode] floatValue];
                    int numberOfMovies = floor(currentProp * 20);
                    int numberOfResponses = [requestResponse count];
                    
                    for(int i = 0; i < numberOfMovies; i++) {
                        int randomIndex = arc4random() % numberOfResponses;
                        while([movies containsObject:[requestResponse objectAtIndex:randomIndex]])
                            randomIndex = arc4random() % numberOfResponses;
                        [movies addObject:[requestResponse objectAtIndex:randomIndex]];
                    }
                }
                _moviesForColor = movies;
                [self performSegueWithIdentifier:@"ShowResults" sender:self];
            }
        }];
    
    }*/
}
@end
