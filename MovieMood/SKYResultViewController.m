//
//  SKYResultViewController.m
//  MovieMood
//
//  Created by Aaron Sky on 1/31/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import "SKYResultViewController.h"
#import "SKYResultMovieCell.h"
#import "SKYMovieViewController.h"

@interface SKYResultViewController ()
@property NSString *selectedMovidId;
@end

@implementation SKYResultViewController {
}
@synthesize movieSource = _movieSource;
@synthesize selectedMovidId = _selectedMovidId;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_movieSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MovieCell";
    SKYResultMovieCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    id currentMovie = [_movieSource objectAtIndex:indexPath.row];
    cell.title.text = [currentMovie valueForKey:@"title"];
    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", @"http://image.tmdb.org/t/p/w185/",[currentMovie valueForKey:@"poster_path"]]];
    cell.artwork.image = [UIImage imageWithData:[NSData dataWithContentsOfURL: imageURL]];
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id movie = [_movieSource objectAtIndex: indexPath.row];
    _selectedMovidId = [movie objectForKey:@"id"];
    [self performSegueWithIdentifier:@"MovieDetail" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"MovieDetail"]) {
        SKYMovieViewController *movieVC = segue.destinationViewController;
        movieVC.movieId = _selectedMovidId;
    }
}

@end
