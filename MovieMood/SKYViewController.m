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

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self getMoviesByGenre:searchBar.text];
}

- (void)getMoviesByGenre:(NSString *) genre
{
    [[JLTMDbClient sharedAPIInstance] GET:kJLTMDbMoviePopular withParameters:nil andResponseBlock:^(id response, NSError *error) {
        if(!error){
            id fetchedData = response;
            NSData* movies = [fetchedData dataUsingEncoding:NSUTF8StringEncoding];
            [self deserializeMovieJson:movies];
        }
    }];
}

- (void)deserializeMovieJson:(NSData *) movieJson
{
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:movieJson //1
                          
                          options:kNilOptions
                          error:&error];
    
    NSArray* movieNames = [json objectForKey:@"title"]; //2
    
    NSLog(@"movie name: %@", movieNames); //3
}

@end
