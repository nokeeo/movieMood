//
//  SKYFavViewController.m
//  MovieMood
//
//  Created by Eric Lee on 5/3/14.
//  Copyright (c) 2014 Eric Lee Productions. All rights reserved.
//

#import "ELFavViewController.h"
#import "ELDataManager.h"
#import "ELMovieRequests.h"
#import "ELMovieViewController.h"
#import "ELActivityIndicator.h"


@interface ELFavViewController ()

@end

@implementation ELFavViewController

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
    CGFloat heightOffset = CGRectGetHeight(self.navigationController.navigationBar.frame) + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    CGFloat bottomOffset = CGRectGetHeight(self.tabBarController.tabBar.frame);
    self.tableView.contentInset = UIEdgeInsetsMake(heightOffset, 0, bottomOffset, 0);
    [self setTitle: @"Favorites"];
}

-(void)viewWillAppear:(BOOL)animated {
    ELDataManager *dataManager = [[ELDataManager alloc] init];
    NSArray *movies = [dataManager getFavMovies];
    NSMutableArray *movieIds = [[NSMutableArray alloc] init];
    for(int i = 0; i < [movies count]; i++) {
        NSManagedObject *movie = [movies objectAtIndex: i];
        [movieIds addObject: [movie valueForKey:@"iTunesID"]];
    }
    self.movieIDs = movieIds;
    [self reloadTable];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ELResultMovieCell *cell = (ELResultMovieCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.rightSlideMenuEnabled = YES;
    [cell resetFavScrollView];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void) favButtonPressed:(ELResultMovieCell *)sender {
    ELDataManager *dataManager = [[ELDataManager alloc] init];
    NSIndexPath *indexPath = [self.tableView indexPathForCell: sender];
    ELMediaEntity *deleteMovie = [self.movieSource objectAtIndex: indexPath.row];
    [self.movieSource removeObjectAtIndex: indexPath.row];
    [dataManager deleteMovie: deleteMovie];
    
    //Animate delete
    if(indexPath.row != [self.movieSource count])
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects: indexPath, nil] withRowAnimation: UITableViewRowAnimationRight];
    else
        [self.tableView reloadData];
}

-(void) doNotShowButtonPressed:(id)sender {
    [super doNotShowButtonPressed: sender];
    
    ELDataManager *dataManager = [[ELDataManager alloc] init];
    NSIndexPath *indexPath = [self.tableView indexPathForCell: sender];
    ELMediaEntity *movieEntity = [self.movieSource objectAtIndex: indexPath.row];
    
    [dataManager deleteMovie: movieEntity];
}

#pragma mark - MainTabBarProtocol
-(BOOL) shouldShowNavBar {
    return YES;
}

@end
