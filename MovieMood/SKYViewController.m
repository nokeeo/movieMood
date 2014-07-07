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
#import "SKYAppDelegate.h"

@interface SKYViewController () {
    BOOL moodTextAnimating;
}
@property (nonatomic, retain) SKYColorAnalyser *colorAnalyser;
@property (nonatomic, retain) SKYColorPickerScrollView *contentScrollView;
@property (nonatomic, retain) NSDictionary *currentPorps;
@property (nonatomic, retain) SKYInfoViewController *infoPage;
@property UILabel *colorText;
@end

@implementation SKYViewController {
    UIDynamicAnimator* _animator;
    NSDictionary* results;
}

@synthesize colorAnalyser = _colorAnalyser;
@synthesize contentScrollView = _contentScrollView;
@synthesize currentPorps = _currentPorps;
@synthesize colorText = _colorText;


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
    
    SKYAppDelegate *appDelegate = (SKYAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    CGSize size = self.view.bounds.size;
    CGSize questionSize = CGSizeMake(size.width * .9,  66);
    moodTextAnimating = NO;
    
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
    
    _colorText = [[UILabel alloc] initWithFrame: CGRectMake(0,
                                                            CGRectGetHeight(_contentScrollView.bounds) * .78,
                                                            CGRectGetWidth(_contentScrollView.bounds),
                                                            30)];
    
    [_colorText setTextAlignment: NSTextAlignmentCenter];
    [_colorText setFont: questionFont];
    
    [_contentScrollView addSubview:questionLabel];
    [_contentScrollView addSubview: _colorText];
    [self.view addSubview:_contentScrollView];
    _colorAnalyser = [[SKYColorAnalyser alloc] initWithIdsForGenre: appDelegate.tvShowIdsForGenre descriptionForIds: appDelegate.tvShowDescriptionForId];
    
    NSLog(@"%@", appDelegate.tvShowIdsForGenre);
    NSLog(@"%@", appDelegate.movieIdsForGenre);
    
    [self colorDidChange: self];
}

-(void) viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.tintColor = self.view.tintColor;
}

-(void)colorDidChange:(id) sender {
    
    //Text change animation
    NSString *colorDescription = [_colorAnalyser descriptionForColor: _contentScrollView.colorWheel.currentColor];
    if(!moodTextAnimating || ![_colorText.text isEqual: colorDescription]) {
        moodTextAnimating = YES;
        CATransition *textAnimation = [CATransition animation];
        textAnimation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
        textAnimation.type = kCATransitionFade;
        textAnimation.duration = .25;
        textAnimation.delegate = self;
        
        [_colorText.layer addAnimation: textAnimation forKey: @"fadeAnimation"];
        _colorText.text = colorDescription;
    }
    
    _contentScrollView.alwaysBounceVertical = false;
    [_contentScrollView changeIndicatorColor: _contentScrollView.colorWheel.currentColor];
    UIColor *complement = [_colorAnalyser calculateComplementaryWithColor: _contentScrollView.colorWheel.currentColor];
    [_contentScrollView changeSelectButtonColorWithColor: complement];
    _colorText.textColor = [_colorAnalyser tintColor: _contentScrollView.colorWheel.currentColor withTintConst: -.35];
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

-(IBAction)infoButtonPressed:(id) sender {
    [self performSegueWithIdentifier:@"InfoSegue" sender:self];
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    if(flag) {
        moodTextAnimating = NO;
    }
}
@end
