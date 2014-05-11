//
//  SKYResultViewController.m
//  MovieMood
//
//  Created by Aaron Sky on 1/31/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import "SKYResultViewController.h"
#import "SKYMovieViewController.h"
#import "SKYMovieRequests.h"
#import "SKYActivityIndicator.h"
#import "SKYColorAnalyser.h"
#import "SKYMovie.h"
#import "SKYDataManager.h"

@interface SKYResultViewController ()
@property (nonatomic, retain) SKYActivityIndicator *activityIndicatorView;
@property (nonatomic, retain) NSDictionary *movieRequestCache;
@property (nonatomic, retain) dispatch_queue_t dispatchQueue;
@property int currentPageNumber;
@property bool refresing;
@end

@implementation SKYResultViewController

@synthesize movieProps = _movieProps;
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
    
    CGSize size = self.view.bounds.size;
    CGSize activityViewSize = CGSizeMake(size.width * .2, size.width * .2);
    
    _activityIndicatorView = [[SKYActivityIndicator alloc] initWithFrame:CGRectMake((size.width - activityViewSize.width) / 2,
                                                                                    (size.height - activityViewSize.height) / 2,
                                                                                    activityViewSize.width,
                                                                                    activityViewSize.height)];

    [self.parentViewController.view addSubview:_activityIndicatorView];
    [_activityIndicatorView.activityIndicator startAnimating];
    [SKYMovieRequests getMoviesWithGenres:[_movieProps allKeys] page: _currentPageNumber successCallback:^(id requestResponse) {
        _movieRequestCache = requestResponse;
        self.movieSource = [[NSMutableArray alloc] initWithArray:[self createListWithProps:_movieProps withSourceLists:requestResponse]];
        [self.tableView reloadData];
        [_activityIndicatorView fadeOutView];
        [UIView commitAnimations];
    } failCallBack:^(NSError *error) {
        _activityIndicatorView.alpha = 0.f;
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Uh oh!"
                                                             message:@"There was an error getting your movies! Try again soon"
                                                            delegate:self
                                                   cancelButtonTitle:@"Ok"
                                                   otherButtonTitles:nil];
        [errorAlert show];
    }];
    
    SKYColorAnalyser *colorAnalyser = [[SKYColorAnalyser alloc] init];
    UIColor *tintColor = [colorAnalyser tintColor:_selectedColor withTintConst: -.10];
    _activityIndicatorView.activityIndicator.color = tintColor;
    self.navigationController.navigationBar.tintColor = tintColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView: tableView didSelectRowAtIndexPath: indexPath];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SKYSwipeCellShouldRetract" object:self userInfo:nil];
    [self performSegueWithIdentifier:@"MovieDetail" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"MovieDetail"]) {
        SKYColorAnalyser *analyser = [[SKYColorAnalyser alloc] init];
        SKYMovieViewController *movieVC = segue.destinationViewController;
        movieVC.movie = self.selectedMovie;
        movieVC.selectedColor = [analyser tintColor:_selectedColor withTintConst:-.10];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SKYColorAnalyser *analyser = [[SKYColorAnalyser alloc] init];
    SKYResultMovieCell *cell = (SKYResultMovieCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundShadeColor = [analyser tintColor: _selectedColor withTintConst: -.10];
    cell.favButtonDelegate = self;
    cell.rightSlideMenuEnabled = YES;
    [cell resetFavScrollView];
    return cell;
}

-(NSArray *) createListWithProps:(NSDictionary *) colorProps withSourceLists:(NSDictionary *) sourceList {
    NSMutableArray *movies = [[NSMutableArray alloc] init];
    for(id genreCode in colorProps) {
        float currentProp = [[colorProps objectForKey:genreCode] floatValue];
        int numberOfMovies = floor(currentProp * 20);
        NSMutableArray *currentMovieResponses = [_movieRequestCache objectForKey: genreCode];
        for(int i = 0; (i < numberOfMovies) && ([currentMovieResponses count] != 0); i++) {
            int randomIndex = arc4random() % [currentMovieResponses count];
            SKYMovie *randomMovie = [currentMovieResponses objectAtIndex:randomIndex];
            
            while([self movieDisplayed: randomMovie] && [currentMovieResponses count] > 1) {
                [currentMovieResponses removeObjectAtIndex: randomIndex];
                
                if([currentMovieResponses count] > 0) {
                    randomIndex = arc4random() % [currentMovieResponses count];
                    randomMovie = [currentMovieResponses objectAtIndex:randomIndex];
                }
            }
            
            if([currentMovieResponses count] > 0) {
                [movies addObject: randomMovie];
                [currentMovieResponses removeObjectAtIndex:randomIndex];
            }
        }
    }
    return movies;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [super scrollViewDidScroll: scrollView];
    if(self.movieSource != 0) {
        CGPoint point = CGPointMake(scrollView.contentOffset.x, (scrollView.contentOffset.y + scrollView.bounds.size.height - 5));
        NSIndexPath *currentPath = [self.tableView indexPathForRowAtPoint: point];
        if(!_refresing && currentPath.row == ([self.movieSource count] - 1)) {
            NSArray *newMovies = [self createListWithProps: _movieProps withSourceLists: _movieRequestCache];
            [self.movieSource addObjectsFromArray: newMovies];
            [self.tableView reloadData];
            _currentPageNumber++;
        }
    }
}

-(BOOL) movieDisplayed:(SKYMovie *) movie {
    for(int i = 0; i < [self.movieSource count]; i++) {
        SKYMovie *currentMovie = [self.movieSource objectAtIndex: i];
        if([currentMovie.movieId isEqualToString: movie.movieId])
            return true;
    }
    return false;
}


-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated: YES];
}

-(void)favButtonPressed:(SKYResultMovieCell *)sender {
    NSIndexPath *cellIndex = [self.tableView indexPathForCell: sender];
    SKYDataManager *dataManager = [[SKYDataManager alloc] init];
    if(sender.isFavOn) {
        [dataManager saveMovie: [self.movieSource objectAtIndex: cellIndex.row]];
    }
    else {
        [dataManager deleteMovie: [self.movieSource objectAtIndex: cellIndex.row]];
    }
}
@end
