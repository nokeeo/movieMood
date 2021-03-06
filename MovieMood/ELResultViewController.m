//
//  SKYResultViewController.m
//  MovieMood
//
//  Created by Aaron Sky on 1/31/14.
//  Copyright (c) 2014 Eric Lee Productions. All rights reserved.
//

#import "ELResultViewController.h"
#import "ELMovieViewController.h"
#import "ELMovieRequests.h"
#import "ELActivityIndicator.h"
#import "ELColorAnalyser.h"
#import "ELMediaEntity.h"
#import "ELDataManager.h"

@interface ELResultViewController ()
@property (nonatomic, retain) ELActivityIndicator *activityIndicatorView;
@property (nonatomic, retain) NSDictionary *movieRequestCache;
@property (nonatomic, retain) dispatch_queue_t dispatchQueue;
@property bool refresing;
@end

@implementation ELResultViewController

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
    
    _refresing = NO;
    
    CGSize size = self.view.bounds.size;
    CGSize activityViewSize = CGSizeMake(size.width * .2, size.width * .2);
    
    _activityIndicatorView = [[ELActivityIndicator alloc] initWithFrame:CGRectMake((size.width - activityViewSize.width) / 2,
                                                                                    (size.height - activityViewSize.height) / 2,
                                                                                    activityViewSize.width,
                                                                                    activityViewSize.height)];
    
    [self.parentViewController.view addSubview:_activityIndicatorView];
    [_activityIndicatorView.activityIndicator startAnimating];
    [ELMovieRequests getMoviesWithGenres:[_movieProps allKeys] successCallback:^(id requestResponse) {
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
    
    UIColor *tintColor = self.navigationController.navigationBar.tintColor;
    _activityIndicatorView.activityIndicator.color = tintColor;
}

#pragma mark - Table view data source

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView: tableView didSelectRowAtIndexPath: indexPath];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SKYSwipeCellShouldRetract" object:self userInfo:nil];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ELResultMovieCell *cell = (ELResultMovieCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.rightSlideMenuEnabled = YES;
    [cell resetFavScrollView];
    return cell;
}

-(NSArray *) createListWithProps:(NSDictionary *) colorProps withSourceLists:(NSDictionary *) sourceList {
    NSMutableArray *movies = [[NSMutableArray alloc] init];
    ELDataManager *dataManager = [[ELDataManager alloc] init];
    for(id genreCode in colorProps) {
        float currentProp = [[colorProps objectForKey:genreCode] floatValue];
        int numberOfMovies = floor(currentProp * 20);
        NSMutableArray *currentMovieResponses = [_movieRequestCache objectForKey: genreCode];
        for(int i = 0; (i < numberOfMovies) && ([currentMovieResponses count] != 0); i++) {
            int randomIndex = arc4random() % [currentMovieResponses count];
            ELMediaEntity *randomMovie = [currentMovieResponses objectAtIndex:randomIndex];
            
            while([self movieDisplayed: randomMovie] && [currentMovieResponses count] > 1 && ![dataManager canShowMovie: randomMovie]) {
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
        }
    }
}

-(BOOL) movieDisplayed:(ELMediaEntity *) movie {
    for(int i = 0; i < [self.movieSource count]; i++) {
        ELMediaEntity *currentMovie = [self.movieSource objectAtIndex: i];
        if([currentMovie.entityID isEqualToString: movie.entityID])
            return true;
    }
    return false;
}


-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated: YES];
}

-(void)favButtonPressed:(ELResultMovieCell *)sender {
    NSIndexPath *cellIndex = [self.tableView indexPathForCell: sender];
    ELDataManager *dataManager = [[ELDataManager alloc] init];
    if(sender.isFavOn) {
        [dataManager saveMovie: [self.movieSource objectAtIndex: cellIndex.row]];
    }
    else {
        [dataManager deleteMovie: [self.movieSource objectAtIndex: cellIndex.row]];
    }
}
@end
