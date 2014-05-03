//
//  SKYInfoViewController.m
//  MovieMood
//
//  Created by Eric Lee on 2/2/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import "SKYInfoViewController.h"

@interface SKYInfoViewController ()
@property int index;
@property int previousIndex;
@end

@implementation SKYInfoViewController

@synthesize index = _index;
@synthesize data = _data;

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
    self.dataSource = self;
    self.delegate = self;
    
    _index = 0;
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    for(int i = 0; i < [self.view.subviews count]; i++) {
        if([[self.view.subviews objectAtIndex:i] isKindOfClass:[UIPageControl class]]) {
            UIPageControl *pageControl = [self.view.subviews objectAtIndex:i];
            
            CGFloat red;
            CGFloat green;
            CGFloat blue;
            
            [self.view.tintColor getRed:&red green:&green blue:&blue alpha:nil];
            
            pageControl.currentPageIndicatorTintColor = self.view.tintColor;
            pageControl.pageIndicatorTintColor = [UIColor colorWithRed:red green:green blue:blue alpha:.2];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if(_index == 0)
        return nil;
    else {
        return [_data objectAtIndex: _index - 1];
        //return [[UIViewController alloc] initWithNibName:@"AboutView" bundle:nil];
    }
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if(_index == [_data count] - 1) {
        return nil;
    }
    else {
        //return [[UIViewController alloc] initWithNibName:@"ColorTheoryView" bundle:nil];
        return [_data objectAtIndex: _index + 1];
    }
}

-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return [_data count];
}


-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}

-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    _index = [_data indexOfObject:[self.viewControllers lastObject]];
}
@end
