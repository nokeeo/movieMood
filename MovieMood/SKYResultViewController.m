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
#import "SKYMovieRequests.h"

@interface SKYResultViewController ()
@property (nonatomic, retain) NSString *selectedMovidId;
@property (nonatomic, retain) NSMutableDictionary *imageCache;
@property (nonatomic, retain) NSMutableArray *movieSource;
@property int currentPageNumber;
@property bool refresing;
@end

@implementation SKYResultViewController {
}

@synthesize movieProps = _movieProps;
@synthesize movieSource = _movieSource;
@synthesize selectedMovidId = _selectedMovidId;
@synthesize imageCache = _imageCache;
@synthesize refresing = _refresing;
@synthesize currentPageNumber = _currentPageNumber;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _currentPageNumber = 1;
    _refresing = NO;
    _imageCache = [[NSMutableDictionary alloc] init];
    
    [SKYMovieRequests getMoviesWithGenres:[_movieProps allKeys] page: _currentPageNumber successCallback:^(id requestResponse) {
        _movieSource = [[NSMutableArray alloc] initWithArray:[self createListWithProps:_movieProps withSourceLists:requestResponse]];
        [self.tableView reloadData];
    } failCallBack:^(NSError *error) {
    }];
    
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
    UIImage *currentImage = [_imageCache objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
    
    if(!currentImage) {
        NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", @"http://image.tmdb.org/t/p/w185/",[currentMovie valueForKey:@"poster_path"]]];
        currentImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
        [_imageCache setObject:currentImage forKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
    }
    
    cell.title.text = [currentMovie valueForKey:@"title"];
    cell.artwork.image = currentImage;
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

-(NSArray *) createListWithProps:(NSDictionary *) colorProps withSourceLists:(NSDictionary *) sourceList {
    NSMutableArray *movies = [[NSMutableArray alloc] init];
    for(id genreCode in colorProps) {
        float currentProp = [[colorProps objectForKey:genreCode] floatValue];
        int numberOfMovies = floor(currentProp * 20);
        NSLog(@"%@ %@", colorProps, sourceList);
        NSMutableArray *currentMovieResponses = [[NSMutableArray alloc] initWithArray:[sourceList objectForKey: genreCode]];
        for(int i = 0; (i < numberOfMovies) && ([currentMovieResponses count] != 0); i++) {
            int randomIndex = arc4random() % [currentMovieResponses count];
            while([_movieSource containsObject:[currentMovieResponses objectAtIndex:randomIndex]] || [movies containsObject:[currentMovieResponses objectAtIndex:randomIndex]]) {
                [currentMovieResponses removeObjectAtIndex:randomIndex];
                if([currentMovieResponses count] == 0)
                    break;
                else
                    randomIndex = arc4random() % [currentMovieResponses count];
            }
            if([currentMovieResponses count] != 0)
                [movies addObject:[currentMovieResponses objectAtIndex:randomIndex]];
        }
    }
    return movies;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(_movieSource != 0) {
        CGPoint point = CGPointMake(scrollView.contentOffset.x, (scrollView.contentOffset.y + scrollView.bounds.size.height - 5));
        NSIndexPath *currentPath = [self.tableView indexPathForRowAtPoint: point];
        if(!_refresing && currentPath.row == ([_movieSource count] - 1)) {
            [SKYMovieRequests getMoviesWithGenres:[_movieProps allKeys] page: _currentPageNumber successCallback:^(id requestResponse) {
                NSArray *newMovies = [self createListWithProps:_movieProps withSourceLists:requestResponse];
                [_movieSource addObjectsFromArray:newMovies];
                [self.tableView reloadData];
                _currentPageNumber++;
                _refresing = NO;
            } failCallBack:^(NSError *error) {
                NSLog(@"error");
            }];
            _refresing = YES;
        }
    }
}

@end
