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

@end

@implementation SKYViewController

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
	// Do any additional setup after loading the view.
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

@end
