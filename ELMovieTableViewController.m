//
//  SKYMovieTableViewController.m
//  MovieMood
//
//  Created by Eric Lee on 5/3/14.
//  Copyright (c) 2014 Eric Lee Productions. All rights reserved.
//

#import "ELMovieTableViewController.h"
#import "ELResultMovieCell.h"
#import "ELMovieRequests.h"
#import "ELDataManager.h"

@interface ELMovieTableViewController ()
@end

@implementation ELMovieTableViewController

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
    [self.tableView setSeparatorInset: UIEdgeInsetsMake(0, 50, 0, 0)];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ELDataManager *dataManager = [[ELDataManager alloc] init];
    static NSString *CellIdentifier = @"MovieCell";
    ELResultMovieCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    ELMediaEntity *currentMovie = [_movieSource objectAtIndex:indexPath.row];
    [cell.artwork setImage: [UIImage imageNamed:@"defaultMoviePoster.png"]];
    cell.isFavOn = [dataManager isMovieFav: currentMovie];
    
    if([_imageCache objectForKey:[NSString stringWithFormat:@"%@", currentMovie.entityID]])
        cell.artwork.image = [_imageCache objectForKey: [NSString stringWithFormat:@"%@", currentMovie.entityID]];
    else {
        NSURL *imageURL = [NSURL URLWithString: currentMovie.coverImage170];
        [ELMovieRequests loadImageWithURL:imageURL successCallback:^(id requestResponse) {
            [_imageCache setObject:requestResponse forKey:[NSString stringWithFormat:@"%@", currentMovie.entityID]];
            NSArray *visibleRows = [tableView indexPathsForVisibleRows];
            for(int i = 0; i < [visibleRows count]; i++) {
                if(((NSIndexPath *)[visibleRows objectAtIndex: i]).row == indexPath.row)
                    cell.artwork.image = requestResponse;;
            }
        } failCallcack:^(NSError *error) {
            NSLog(@"%@", error);
        }];
    }
    
    
    cell.title.text = currentMovie.title;
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SKYSwipeCellShouldRetract" object:self userInfo:nil];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ELMediaEntity *movie = [_movieSource objectAtIndex: indexPath.row];
    _selectedMovie = movie;
}

-(void) doNotShowButtonPressed:(id)sender {
    NSIndexPath *cellIndex = [self.tableView indexPathForCell: sender];
    ELDataManager *dataManager = [[ELDataManager alloc] init];
    if(![dataManager doNotShowMovie: [self.movieSource objectAtIndex: cellIndex.row]]) {
        [self removeCellAtIndex: cellIndex];
    }
}

-(void) removeCellAtIndex: (NSIndexPath *) indexPath {
    [self.movieSource removeObjectAtIndex: indexPath.row];
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths: @[indexPath] withRowAnimation: UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

@end
