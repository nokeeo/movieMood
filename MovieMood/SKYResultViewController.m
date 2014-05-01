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
#import "SKYActivityIndicator.h"
#import "SKYColorAnalyser.h"
#import "SKYMovie.h"

@interface SKYResultViewController ()
@property (nonatomic, retain) SKYMovie *selectedMovie;
@property (nonatomic, retain) NSMutableDictionary *imageCache;
@property (nonatomic, retain) NSMutableArray *movieSource;
@property (nonatomic, retain) SKYActivityIndicator *activityIndicatorView;
@property (nonatomic, retain) NSDictionary *movieRequestCache;
@property (nonatomic, retain) dispatch_queue_t dispatchQueue;
@property int currentPageNumber;
@property bool refresing;
@end

@implementation SKYResultViewController

@synthesize movieProps = _movieProps;
@synthesize selectedMovie = _selectedMovie;
@synthesize imageCache = _imageCache;
@synthesize refresing = _refresing;
@synthesize currentPageNumber = _currentPageNumber;
@synthesize activityIndicatorView = _activityIndicatorView;
@synthesize  movieRequestCache = _movieRequestCache;

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
    
    CGSize size = self.view.bounds.size;
    CGSize activityViewSize = CGSizeMake(size.width * .2, size.width * .2);
    
    _activityIndicatorView = [[SKYActivityIndicator alloc] initWithFrame:CGRectMake((size.width - activityViewSize.width) / 2,
                                                                                    (size.height - activityViewSize.height) / 2,
                                                                                    activityViewSize.width,
                                                                                    activityViewSize.height)];

    [self.parentViewController.view addSubview:_activityIndicatorView];
    [_activityIndicatorView.activityIndicator startAnimating];
    [SKYMovieRequests getMoviesWithGenres:[_movieProps allKeys] page: _currentPageNumber successCallback:^(id requestResponse) {
        _movieSource = [[NSMutableArray alloc] initWithArray:[self createListWithProps:_movieProps withSourceLists:requestResponse]];
        _movieRequestCache = requestResponse;
        [self.tableView reloadData];
        [_activityIndicatorView fadeOutView];
        [UIView commitAnimations];
    } failCallBack:^(NSError *error) {
    }];
    
    SKYColorAnalyser *colorAnalyser = [[SKYColorAnalyser alloc] init];
    UIColor *tintColor = [colorAnalyser tintColor:_selectedColor withTintConst: -.25];
    _activityIndicatorView.activityIndicator.color = tintColor;
    self.navigationController.navigationBar.tintColor = tintColor;
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
    SKYMovie *currentMovie = [_movieSource objectAtIndex:indexPath.row];
    [cell.artwork setImage: [UIImage imageNamed:@"defaultMoviePoster.png"]];
    if([_imageCache objectForKey:[NSString stringWithFormat:@"%@", currentMovie.movieId]])
        cell.artwork.image = [_imageCache objectForKey: [NSString stringWithFormat:@"%@", currentMovie.movieId]];
    else {
        NSURL *imageURL = [NSURL URLWithString: currentMovie.coverImage170];
        [SKYMovieRequests loadImageWithURL:imageURL successCallback:^(id requestResponse) {
            [_imageCache setObject:requestResponse forKey:[NSString stringWithFormat:@"%@", currentMovie.movieId]];
            cell.artwork.image = requestResponse;
            NSLog(@"FIRE");
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
    [self performSegueWithIdentifier:@"MovieDetail" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"MovieDetail"]) {
        SKYMovieViewController *movieVC = segue.destinationViewController;
        movieVC.movie = _selectedMovie;
        movieVC.selectedColor = _selectedColor;
    }
}

-(NSArray *) createListWithProps:(NSDictionary *) colorProps withSourceLists:(NSDictionary *) sourceList {
    NSMutableArray *movies = [[NSMutableArray alloc] init];
    for(id genreCode in colorProps) {
        float currentProp = [[colorProps objectForKey:genreCode] floatValue];
        int numberOfMovies = floor(currentProp * 20);
        NSMutableArray *currentMovieResponses = [[NSMutableArray alloc] initWithArray:[sourceList objectForKey: genreCode]];
        for(int i = 0; (i < numberOfMovies) && ([currentMovieResponses count] != 0); i++) {
            int randomIndex = arc4random() % [currentMovieResponses count];
            [movies addObject:[currentMovieResponses objectAtIndex:randomIndex]];
            [currentMovieResponses removeObjectAtIndex:randomIndex];
        }
    }
    return movies;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(_movieSource != 0) {
        CGPoint point = CGPointMake(scrollView.contentOffset.x, (scrollView.contentOffset.y + scrollView.bounds.size.height - 5));
        NSIndexPath *currentPath = [self.tableView indexPathForRowAtPoint: point];
        if(!_refresing && currentPath.row == ([_movieSource count] - 1)) {
            NSArray *newMovies = [self createListWithProps: _movieProps withSourceLists: _movieRequestCache];
            [_movieSource addObjectsFromArray: newMovies];
            [self.tableView reloadData];
            _currentPageNumber++;
        }
    }
}
@end
