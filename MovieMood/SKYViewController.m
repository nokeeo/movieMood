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
@end

@implementation SKYViewController

@synthesize colorWheel = _colorWheel;
@synthesize colorAnalyser = _colorAnalyser;
@synthesize colorIndicator = _colorIndicator;

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
    NSDictionary* results = [self getMoviesByGenre:searchBar.text];
    SKYResultViewController* resultVC = [[SKYResultViewController alloc] init];
    resultVC.source = results;
    [self.navigationController pushViewController:resultVC animated:YES];
}

- (NSDictionary*)getMoviesByGenre:(NSString *) genre
{
    __block NSDictionary* fetchedData = [[NSDictionary alloc] init];
    // Aaron: still not grabbing by genre, needs fixing
    __block UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"") message:NSLocalizedString(@"Please try again later", @"") delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Ok", @""), nil];
    [[JLTMDbClient sharedAPIInstance] GET:kJLTMDbGenreMovies withParameters:@{@"id":genre} andResponseBlock:^(id response, NSError *error) {
        if(!error){
            // Aaron: still having trouble parsing the response, the client deserializes for us (unconfirmed).
            fetchedData = response;
        }else
        {
            [errorAlertView show];
        }
    }];
    return fetchedData;
}

-(void)colorWheelDidChangeColor:(ISColorWheel *)colorWheel {
    [_colorAnalyser analyzeColor:colorWheel.currentColor];
    _colorIndicator.backgroundColor = _colorWheel.currentColor;
}

@end
