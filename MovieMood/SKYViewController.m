//
//  SKYViewController.m
//  MovieMood
//
//  Created by Aaron Sky on 1/30/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import "SKYViewController.h"
#import "SKYResultViewController.h"
#import "JLTMDbClient.h"
#import "SKYColorAnalyser.h"
#import "TLAlertView.h"

@interface SKYViewController ()
@property (nonatomic, retain) SKYColorAnalyser *colorAnalyser;
@property (nonatomic, retain) SKYColorPickerScrollView *contentScrollView;
@property (nonatomic, retain) NSDictionary *currentPorps;
@end

@implementation SKYViewController {
    UIDynamicAnimator* _animator;
    NSDictionary* results;
}

@synthesize colorAnalyser = _colorAnalyser;
@synthesize contentScrollView = _contentScrollView;
@synthesize currentPorps = _currentPorps;


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
    
    CGSize size = self.view.bounds.size;
    
    _contentScrollView = [[SKYColorPickerScrollView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x,
                                                                        self.view.bounds.origin.y,
                                                                        size.width,
                                                                        size.height)];
    _contentScrollView.colorViewDelegate = self;
    _contentScrollView.delegate = self;
    
    _colorAnalyser = [[SKYColorAnalyser alloc] init];
    [self.view addSubview:_contentScrollView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    //results = [self getMoviesByGenre:searchBar.text];
    [self performSegueWithIdentifier: @"ShowResults" sender: self];
}

-(void)colorDidChange:(id) sender {
    _contentScrollView.alwaysBounceVertical = false;
    _contentScrollView.colorIndicator.backgroundColor = _contentScrollView.colorWheel.currentColor;
    UIColor *complement = [_colorAnalyser calculateComplementaryWithColor: _contentScrollView.colorWheel.currentColor];
    [_contentScrollView changeSelectButtonColorWithColor: complement];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowResults"])
    {
        SKYResultViewController* resultVC = [segue destinationViewController];
        resultVC.movieProps = _currentPorps;
        resultVC.selectedColor = _contentScrollView.colorWheel.currentColor;
    }
}

-(void)selectButtonPressed:(id)sender {
    _currentPorps = [_colorAnalyser analyzeColor: _contentScrollView.colorWheel.currentColor];
    [self performSegueWithIdentifier:@"ShowResults" sender:self];
}
@end
