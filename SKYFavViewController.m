//
//  SKYFavViewController.m
//  MovieMood
//
//  Created by Eric Lee on 5/3/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import "SKYFavViewController.h"
#import "SKYDataManager.h"
#import "SKYMovieRequests.h"

@interface SKYFavViewController ()

@end

@implementation SKYFavViewController

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
    
    SKYDataManager *dataManager = [[SKYDataManager alloc] init];
    
    NSArray *movies = [dataManager getFavMovies];
    NSMutableArray *movieIds = [[NSMutableArray alloc] init];
    for(int i = 0; i < [movies count]; i++) {
        NSManagedObject *movie = [movies objectAtIndex: i];
        [movieIds addObject: [movie valueForKey:@"iTunesID"]];
    }
    
    [SKYMovieRequests getMoviesWithIDs:movieIds successCallback:^(id responesMovies) {
        self.movieSource = responesMovies;
        [self.tableView reloadData];
    } failCallback:^(NSError *error) {
        //
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
