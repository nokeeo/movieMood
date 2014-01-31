//
//  SKYViewController.m
//  MovieMood
//
//  Created by Aaron Sky on 1/30/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import "SKYViewController.h"
#import "JLTMDbClient.h"

@interface SKYViewController ()
@property (nonatomic, retain) ISColorWheel *colorWheel;
@end

@implementation SKYViewController

@synthesize colorWheel = _colorWheel;

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
}

- (void)getMoviesByGenre:(NSString *) genre
{
    // Aaron: still not grabbing by genre, needs fixing
    [[JLTMDbClient sharedAPIInstance] GET:kJLTMDbMoviePopular withParameters:nil andResponseBlock:^(id response, NSError *error) {
        if(!error){
            // Aaron: still having trouble parsing the response, the client deserializes for us (unconfirmed).
            NSDictionary* fetchedData = response;
            NSArray* movieNames = [fetchedData objectForKey:@"title"];
            NSLog(@"movie name: %@", movieNames);
            //NSLog(@"Popular Movies: %@",fetchedData);
        }
    }];
}

-(void)colorWheelDidChangeColor:(ISColorWheel *)colorWheel {
}

@end
