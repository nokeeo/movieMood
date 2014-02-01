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

@interface SKYViewController ()
@property (nonatomic, retain) ISColorWheel *colorWheel;
@property (nonatomic, retain) SKYColorAnalyser *colorAnalyser;
@property (nonatomic, retain) UIView *colorIndicator;
@property int requestsSent;
@property int requestsRecieved;
@property (nonatomic, retain) NSArray *moviesForColor;
@end

@implementation SKYViewController {
    UIDynamicAnimator* _animator;
    NSDictionary* results;
}

@synthesize colorWheel = _colorWheel;
@synthesize colorAnalyser = _colorAnalyser;
@synthesize colorIndicator = _colorIndicator;
@synthesize requestsRecieved = _requestsRecieved;
@synthesize requestsSent = _requestsSent;

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
    
    CGSize wheelSize = CGSizeMake(size.width * .75, size.width * .75);
    CGSize centerWheelSize = CGSizeMake(size.width * .50, size.width * .50);
    CGSize indicatorSize = CGSizeMake(size.width * .40, size.width * .40);
    
    
    UIView *centerWheel = [[UIView alloc] initWithFrame:CGRectMake(size.width / 2 - centerWheelSize.width / 2,
                                                                      (size.height * .3) + (wheelSize.height - centerWheelSize.height) / 2,
                                                                      centerWheelSize.width,
                                                                      centerWheelSize.height)];
    centerWheel.backgroundColor = [UIColor colorWithRed:(77/255.0) green:(77/255.0) blue:(77/225.0) alpha:1.0];
    centerWheel.layer.cornerRadius = 80;
    centerWheel.layer.borderColor = [UIColor darkGrayColor].CGColor;
    centerWheel.layer.borderWidth = 1.f;
    
    _colorWheel = [[ISColorWheel alloc] initWithFrame:CGRectMake(size.width / 2 - wheelSize.width / 2,
                                                                 size.height * .3,
                                                                 wheelSize.width,
                                                                 wheelSize.height)];
    
    _colorIndicator = [[UIView alloc] initWithFrame:CGRectMake(size.width / 2 - indicatorSize.width / 2,
                                                               (size.height * .3) + (wheelSize.height - indicatorSize.height) / 2,
                                                               indicatorSize.height,
                                                               indicatorSize.width)];
    _colorIndicator.layer.cornerRadius = 64;
    _colorIndicator.backgroundColor = _colorWheel.currentColor;
    
    _colorWheel.delegate = self;
    _colorWheel.continuous = true;
    _colorAnalyser = [[SKYColorAnalyser alloc] init];
    [self.view addSubview:_colorWheel];
    [self.view addSubview:centerWheel];
    [self.view addSubview:_colorIndicator];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //results = [self getMoviesByGenre:searchBar.text];
    [self performSegueWithIdentifier: @"ShowResults" sender: self];
}

- (NSDictionary*)getMoviesByGenre:(NSString *) genre callback:(void (^)(id requestResponse))sucessCallback {
    _requestsSent++;
    
    __block NSDictionary* fetchedData = [[NSDictionary alloc] init];
    __block UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"") message:NSLocalizedString(@"Please try again later", @"") delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Ok", @""), nil];
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
    _colorIndicator.backgroundColor = _colorWheel.currentColor;
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
    NSDictionary *colorProps = [_colorAnalyser analyzeColor: _colorWheel.currentColor];
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
                [self performSegueWithIdentifier:@"ShowResults" sender:self];
            }
        }];
    }
}
@end
