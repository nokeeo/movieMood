//
//  SKYViewController.m
//  MovieMood
//
//  Created by Aaron Sky on 1/30/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import "SKYViewController.h"
#import "JLTMDbClient.h"
#import "SKYColorAnalyser.h"

@interface SKYViewController ()
@property NSDictionary *results;
@property (nonatomic, retain) ISColorWheel *colorWheel;
@property (nonatomic, retain) SKYColorAnalyser *colorAnalyser;
@end

@implementation SKYViewController

@synthesize colorWheel = _colorWheel;
@synthesize colorAnalyser = _colorAnalyser;

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
    
    CGSize wheelSize = CGSizeMake(size.width * .75, size.width * .75);
    CGSize indicatorSize = CGSizeMake(size.width * .50, size.width * .50);
    
    
    UIView *colorIndicator = [[UIView alloc] initWithFrame:CGRectMake(size.width / 2 - indicatorSize.width / 2,
                                                                      (size.height * .3) + (wheelSize.height - indicatorSize.height) / 2,
                                                                      indicatorSize.width,
                                                                      indicatorSize.height)];
    colorIndicator.backgroundColor = [UIColor colorWithRed:(77/255.0) green:(77/255.0) blue:(77/225.0) alpha:1.0];
    colorIndicator.layer.cornerRadius = 80;
    
    _colorWheel = [[ISColorWheel alloc] initWithFrame:CGRectMake(size.width / 2 - wheelSize.width / 2,
                                                                 size.height * .3,
                                                                 wheelSize.width,
                                                                 wheelSize.height)];
    
    _colorWheel.delegate = self;
    _colorWheel.continuous = true;
    _colorAnalyser = [[SKYColorAnalyser alloc] init];
    [self.view addSubview:_colorWheel];
    [self.view addSubview:colorIndicator];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self getMoviesByGenre:searchBar.text];
//    if(!self.results)
//    {
//        SKYResultViewController* resultVC = [[SKYResultViewController alloc]initWithNibName:Nil bundle:Nil];
//        [self.navigationController pushViewController:resultVC animated:YES];
//    }
}

- (void)getMoviesByGenre:(NSString *) genre
{
    // Aaron: still not grabbing by genre, needs fixing
    __block UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"") message:NSLocalizedString(@"Please try again later", @"") delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Ok", @""), nil];
    [[JLTMDbClient sharedAPIInstance] GET:kJLTMDbGenreMovies withParameters:@{@"id":genre} andResponseBlock:^(id response, NSError *error) {
        if(!error){
            // Aaron: still having trouble parsing the response, the client deserializes for us (unconfirmed).
            NSDictionary* fetchedData = response;
            self.results = fetchedData;
            NSArray* movies  = fetchedData[@"results"];
            NSLog(@"Popular Movies: %@",movies);
        }else
        {
            [errorAlertView show];
        }
    }];
}

-(void)colorWheelDidChangeColor:(ISColorWheel *)colorWheel {
    [_colorAnalyser analyzeColor:colorWheel.currentColor];
}

@end
