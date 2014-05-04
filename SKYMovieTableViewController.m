//
//  SKYMovieTableViewController.m
//  MovieMood
//
//  Created by Eric Lee on 5/3/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import "SKYMovieTableViewController.h"
#import "SKYResultMovieCell.h"
#import "SKYMovieRequests.h"

@interface SKYMovieTableViewController ()
@end

@implementation SKYMovieTableViewController

@synthesize movieSource = _movieSource;
@synthesize selectedMovie = _selectedMovie;
@synthesize imageCache = _imageCache;

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
    _imageCache = [[NSMutableDictionary alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_movieSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MovieCell";
    SKYResultMovieCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    SKYMovie *currentMovie = [_movieSource objectAtIndex:indexPath.row];
    [cell.artwork setImage: [UIImage imageNamed:@"defaultMoviePoster.png"]];
    if([_imageCache objectForKey:[NSString stringWithFormat:@"%@", currentMovie.movieId]])
        cell.artwork.image = [_imageCache objectForKey: [NSString stringWithFormat:@"%@", currentMovie.movieId]];
    else {
        NSURL *imageURL = [NSURL URLWithString: currentMovie.coverImage170];
        [SKYMovieRequests loadImageWithURL:imageURL successCallback:^(id requestResponse) {
            [_imageCache setObject:requestResponse forKey:[NSString stringWithFormat:@"%@", currentMovie.movieId]];
            cell.artwork.image = requestResponse;
        } failCallcack:^(NSError *error) {
            NSLog(@"%@", error);
        }];
    }
    
    
    cell.title.text = currentMovie.title;
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SKYMovie *movie = [_movieSource objectAtIndex: indexPath.row];
    _selectedMovie = movie;
}

@end
