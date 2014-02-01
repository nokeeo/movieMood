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
#import "SKYColorPickerScrollView.h"

@interface SKYViewController ()
@property (nonatomic, retain) SKYColorAnalyser *colorAnalyser;
@property (nonatomic, retain) NSArray *moviesForColor;
@property (nonatomic, retain) SKYColorPickerScrollView *contentScrollView;
@property int requestsSent;
@property int requestsRecieved;
@end

@implementation SKYViewController {
    UIDynamicAnimator* _animator;
    NSDictionary* results;
}

@synthesize colorAnalyser = _colorAnalyser;
@synthesize requestsRecieved = _requestsRecieved;
@synthesize requestsSent = _requestsSent;
@synthesize contentScrollView = _contentScrollView;

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
    
    _requestsSent = 0;
    _requestsRecieved = 0;
    
	CGSize size = self.view.bounds.size;
    _contentScrollView = [[SKYColorPickerScrollView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x,
                                                                        self.view.bounds.origin.y,
                                                                        size.width,
                                                                        size.height)];
    _contentScrollView.colorWheel.delegate = self;
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
    _requestsSent++;
    
    __block NSDictionary* fetchedData = [[NSDictionary alloc] init];
    __block TLAlertView *errorAlertView = [[TLAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"") message:NSLocalizedString(@"Please try again later", @"") buttonTitle:NSLocalizedString(@"OK",@"")];
    UIGravityBehavior *gravityBehaviour = [[UIGravityBehavior alloc] initWithItems:@[errorAlertView]];
    gravityBehaviour.gravityDirection = CGVectorMake(0, 10);
    [_animator addBehavior:gravityBehaviour];
    
    UIDynamicItemBehavior *itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[errorAlertView]];
    [itemBehaviour addAngularVelocity:-M_PI_2 forItem:errorAlertView];
    [_animator addBehavior:itemBehaviour];
    [[JLTMDbClient sharedAPIInstance] GET:kJLTMDbGenreMovies withParameters:@{@"id":genre} andResponseBlock:^(id response, NSError *error) {
        if(!error) {
            _requestsRecieved++;
            sucessCallback([response objectForKey:@"results"]);
        }
        else
            [errorAlertView show];
    }];
    return fetchedData;
}

-(void)colorWheelDidChangeColor:(ISColorWheel *)colorWheel {
    _contentScrollView.alwaysBounceVertical = false;
    _contentScrollView.colorIndicator.backgroundColor = _contentScrollView.colorWheel.currentColor;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowResults"])
    {
        SKYResultViewController* resultVC = [segue destinationViewController];
        resultVC.movieSource = _moviesForColor;
    }
}

- (IBAction)colorWheelButtonPressed:(id)sender {
    __block UIActivityIndicatorView* progress = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    progress.hidesWhenStopped = YES;
    [progress startAnimating];
    NSDictionary *colorProps = [_colorAnalyser analyzeColor: _contentScrollView.colorWheel.currentColor];
    NSMutableDictionary *searchResults = [[NSMutableDictionary alloc] init];
    for(id key in colorProps) {
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
                [progress stopAnimating];
                [self performSegueWithIdentifier:@"ShowResults" sender:self];
            }
        }];
    }
    [progress stopAnimating];
}
@end
