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
#import "SKYMovieViewController.h"
#import "SKYActivityIndicator.h"


@interface SKYFavViewController ()

@property (nonatomic, retain) SKYActivityIndicator *activityIndicator;

@end

@implementation SKYFavViewController

@synthesize activityIndicator = _activityIndicator;

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
}

-(void)viewWillAppear:(BOOL)animated {
    SKYDataManager *dataManager = [[SKYDataManager alloc] init];
    
    CGSize size = self.view.bounds.size;
    CGSize activityViewSize = CGSizeMake(size.width * .2, size.width * .2);
    _activityIndicator = [[SKYActivityIndicator alloc] initWithFrame:CGRectMake((size.width - activityViewSize.width) / 2,
                                                                                (size.height - activityViewSize.height) / 2,
                                                                                activityViewSize.width,
                                                                                activityViewSize.height)];
    [_activityIndicator.activityIndicator startAnimating];
    [self.parentViewController.view addSubview: _activityIndicator];
    
    NSArray *movies = [dataManager getFavMovies];
    NSMutableArray *movieIds = [[NSMutableArray alloc] init];
    for(int i = 0; i < [movies count]; i++) {
        NSManagedObject *movie = [movies objectAtIndex: i];
        [movieIds addObject: [movie valueForKey:@"iTunesID"]];
    }
    
    [SKYMovieRequests getMoviesWithIDs:movieIds successCallback:^(id responesMovies) {
        self.movieSource = responesMovies;
        [self.tableView reloadData];
        [_activityIndicator fadeOutView];
        [UIView commitAnimations];
    } failCallback:^(NSError *error) {
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Uh oh!"
                                                             message:@"There was an error retrieving your favorite movies! Please try again soon"
                                                            delegate:self
                                                   cancelButtonTitle:@"Ok"
                                                   otherButtonTitles: nil];
        _activityIndicator.alpha = 0.f;
        [errorAlert show];
    }];

}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SKYResultMovieCell *cell = (SKYResultMovieCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.favButtonDelegate = self;
    cell.rightSlideMenuEnabled = YES;
    cell.backgroundShadeColor = self.view.tintColor;
    [cell resetFavScrollView];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqual:@"selectMovieSegue"]) {
        SKYMovieViewController *nextVC = [segue destinationViewController];
        nextVC.movie = [self.movieSource objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        nextVC.selectedColor = self.navigationController.navigationBar.tintColor;
    }
}

- (IBAction)closeButtonPressed:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void) favButtonPressed:(SKYResultMovieCell *)sender {
    SKYDataManager *dataManager = [[SKYDataManager alloc] init];
    NSIndexPath *indexPath = [self.tableView indexPathForCell: sender];
    SKYMovie *deleteMovie = [self.movieSource objectAtIndex: indexPath.row];
    [self.movieSource removeObjectAtIndex: indexPath.row];
    [dataManager deleteMovie: deleteMovie];
    
    //Animate delete
    if(indexPath.row != [self.movieSource count])
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects: indexPath, nil] withRowAnimation: UITableViewRowAnimationRight];
    else
        [self.tableView reloadData];
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
