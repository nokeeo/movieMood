//
//  ELIDMovieTableViewController.m
//  MovieMood
//
//  Created by Eric Lee on 9/21/14.
//  Copyright (c) 2014 Eric Lee Productions. All rights reserved.
//

#import "ELIDMovieTableViewController.h"
#import "ELActivityIndicator.h"
#import "ELMovieRequests.h"

@interface ELIDMovieTableViewController ()

@property (nonatomic, retain) ELActivityIndicator *activityIndicator;

@end

@implementation ELIDMovieTableViewController

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

-(void) reloadTable {
    if(_movieIDs) {
        CGSize size = self.view.bounds.size;
        CGSize activityViewSize = CGSizeMake(size.width * .2, size.width * .2);
        _activityIndicator = [[ELActivityIndicator alloc] initWithFrame:CGRectMake((size.width - activityViewSize.width) / 2,
                                                                                   (size.height - activityViewSize.height) / 2,
                                                                                   activityViewSize.width,
                                                                                   activityViewSize.height)];
        _activityIndicator.activityIndicator.color = self.navigationController.navigationBar.tintColor;
        [_activityIndicator.activityIndicator startAnimating];
        [self.parentViewController.view addSubview: _activityIndicator];
        
        [ELMovieRequests getMoviesWithIDs:_movieIDs successCallback:^(id responesMovies) {
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
}

@end
