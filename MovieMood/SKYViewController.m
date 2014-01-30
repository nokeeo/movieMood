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
    
    _colorWheel = [[ISColorWheel alloc] initWithFrame:CGRectMake(size.width / 2 - wheelSize.width / 2,
                                                                 size.height * .3,
                                                                 wheelSize.width,
                                                                 wheelSize.height)];
    _colorWheel.delegate = self;
    _colorWheel.continuous = true;
    [self.view addSubview:_colorWheel];
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
    NSLog(@"%@", _colorWheel.currentColor);
}

@end
