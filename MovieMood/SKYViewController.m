//
//  SKYViewController.m
//  MovieMood
//
//  Created by Aaron Sky on 1/30/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import "SKYViewController.h"
#import "SKYResultViewController.h"
#import "SKYColorAnalyser.h"
#import "SKYInfoViewController.h"
#import "SKYInfoViewController.h"
#import "SKYDeveloperViewController.h"
#import "SKYInfoContainerViewController.h"
#import "SKYFavViewController.h"

@interface SKYViewController ()
@property (nonatomic, retain) SKYColorAnalyser *colorAnalyser;
@property (nonatomic, retain) SKYColorPickerScrollView *contentScrollView;
@property (nonatomic, retain) NSDictionary *currentPorps;
@property (nonatomic, retain) SKYInfoViewController *infoPage;
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
    CGSize infoButtonSize = CGSizeMake(50, 50);
    CGSize questionSize = CGSizeMake(size.width * .9,  66);
    
    _contentScrollView = [[SKYColorPickerScrollView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x,
                                                                        self.view.bounds.origin.y,
                                                                        size.width,
                                                                        size.height)];
    
    _contentScrollView.colorViewDelegate = self;
    _contentScrollView.delegate = self;
    
    UILabel *questionLabel = [[UILabel alloc] initWithFrame:CGRectMake((size.width - questionSize.width) / 2,
                                                                       size.height * .05,
                                                                       questionSize.width,
                                                                       questionSize.height)];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    
    UIFont *questionFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18];
    NSDictionary *questionAttrs = [NSDictionary dictionaryWithObjects: [NSArray arrayWithObjects:questionFont, paragraphStyle, nil]
                                                              forKeys: [NSArray arrayWithObjects: NSFontAttributeName, NSParagraphStyleAttributeName, nil]];
    
    NSAttributedString *questionText = [[NSAttributedString alloc] initWithString:@"What kind of movie are you feeling?" attributes: questionAttrs];
    questionLabel.numberOfLines = 2;
    [questionLabel setAttributedText:questionText];
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [infoButton setFrame:CGRectMake(15,
                                    _contentScrollView.frame.size.height * .85 - infoButtonSize.height,
                                    infoButtonSize.width, infoButtonSize.height)];
    [infoButton addTarget:self action:@selector(infoButtonPressed:) forControlEvents:UIControlEventTouchDown];
    
    [_contentScrollView addSubview:infoButton];
    [_contentScrollView addSubview:questionLabel];
    [self.view addSubview:_contentScrollView];
    _colorAnalyser = [[SKYColorAnalyser alloc] init];
    [self colorDidChange: self];
}

-(void) viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.tintColor = self.view.tintColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)colorDidChange:(id) sender {
    _contentScrollView.alwaysBounceVertical = false;
    [_contentScrollView changeIndicatorColor: _contentScrollView.colorWheel.currentColor];
    UIColor *complement = [_colorAnalyser calculateComplementaryWithColor: _contentScrollView.colorWheel.currentColor];
    [_contentScrollView changeSelectButtonColorWithColor: complement];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowResults"]) {
        SKYResultViewController* resultVC = [segue destinationViewController];
        resultVC.movieProps = _currentPorps;
        resultVC.selectedColor = _contentScrollView.colorWheel.currentColor;
    }
    
    else if([[segue identifier] isEqualToString:@"InfoSegue"]){
        SKYInfoContainerViewController *nextVC = (SKYInfoContainerViewController *)[segue destinationViewController];
        
        
        _infoPage = [[SKYInfoViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
            
        [viewControllers addObject:[[UIViewController alloc] initWithNibName:@"ColorTheoryView" bundle:nil]];
        [_infoPage setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        [viewControllers addObject:[[UIViewController alloc] initWithNibName:@"AboutView" bundle:nil]];
            
        SKYDeveloperViewController *developerPage = [[SKYDeveloperViewController alloc] initWithNibName:@"DevelopersView" bundle:nil];
        [viewControllers addObject: developerPage];
        developerPage.delegate = nextVC;
        [viewControllers addObject:[[UIViewController alloc] initWithNibName:@"ImageCredits" bundle:nil]];
        
        _infoPage.data = viewControllers;
        
        [nextVC.view addSubview:_infoPage.view];
    }
}

-(void)selectButtonPressed:(id)sender {
    _currentPorps = [_colorAnalyser analyzeColor: _contentScrollView.colorWheel.currentColor];
    [self performSegueWithIdentifier:@"ShowResults" sender:self];
}

-(void)infoButtonPressed:(id) sender {
    [self performSegueWithIdentifier:@"InfoSegue" sender:self];
}
@end
