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

@interface SKYResultViewController ()
@property NSString *selectedMovidId;
@property NSMutableDictionary *imageCache;
@end

@implementation SKYResultViewController {
}

@synthesize movieSource = _movieSource;
@synthesize selectedMovidId = _selectedMovidId;
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
    
    NSLog(@"%@", currentImage);
<<<<<<< HEAD
    
    if(!currentImage) {
        NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", @"http://image.tmdb.org/t/p/w185/",[currentMovie valueForKey:@"poster_path"]]];
        currentImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
        [_imageCache setObject:currentImage forKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
        NSLog(@"FIRE!");
    }
    
    cell.title.text = [currentMovie valueForKey:@"title"];
    cell.artwork.image = currentImage;
    
    [self checkColor];
    [[cell title] setTextColor:_chosenColor];
=======
>>>>>>> 76815ba40e7826e2f6ea867fdb8d57089e73b1ca
    
    if(!currentImage) {
        NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", @"http://image.tmdb.org/t/p/w185/",[currentMovie valueForKey:@"poster_path"]]];
        currentImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
        [_imageCache setObject:currentImage forKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
        NSLog(@"FIRE!");
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
<<<<<<< HEAD
}

-(void)checkColor
{
    CGFloat hue, sat, brightness, alpha;
    [_chosenColor getHue:&hue saturation:&sat brightness:&brightness alpha:&alpha];
    //NSLog(@"hue: %f", hue);
    if(hue < 0.55f && hue >= 0.5f)
    {
        hue = 0.55f;
    }
    else if(hue < 0.5f && hue > 0.45f)
    {
        hue = 0.45f;
    }
    _chosenColor = [_chosenColor initWithHue:hue saturation:sat brightness:brightness alpha:alpha];
=======
>>>>>>> 76815ba40e7826e2f6ea867fdb8d57089e73b1ca
}

@end
