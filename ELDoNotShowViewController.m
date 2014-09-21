//
//  ELDoNotShowViewController.m
//  MovieMood
//
//  Created by Eric Lee on 9/21/14.
//  Copyright (c) 2014 Eric Lee Productions. All rights reserved.
//

#import "ELDoNotShowViewController.h"
#import "ELDataManager.h"

@interface ELDoNotShowViewController ()

@end

@implementation ELDoNotShowViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    [self setTitle: @" Do not Show"];
    
    ELDataManager *dataManager = [[ELDataManager alloc] init];
    NSArray *movies = [dataManager getDoNotShowMovies];
    
    NSMutableArray *movieIds = [NSMutableArray array];
    for(int i = 0; i < [movies count]; i++) {
        NSManagedObject *movie = [movies objectAtIndex: i];
        [movieIds addObject: [movie valueForKey:@"iTunesID"]];
    }
    self.movieIDs = movieIds;
    [self reloadTable];
}

-(void) favButtonPressed:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell: sender];
    ELMediaEntity *movie = [self.movieSource objectAtIndex: indexPath.row];
    
    ELDataManager *dataManager = [[ELDataManager alloc] init];
    [dataManager saveMovie: movie];
    [dataManager doShowMovie: movie];
    
    [self removeCellAtIndex: indexPath];
}

-(void) doNotShowButtonPressed:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell: sender];
    ELMediaEntity *movie = [self.movieSource objectAtIndex: indexPath.row];
    
    ELDataManager *dataManager = [[ELDataManager alloc] init];
    [dataManager doShowMovie: movie];
    
    [self removeCellAtIndex: indexPath];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
