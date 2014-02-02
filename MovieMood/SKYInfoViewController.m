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
@end

@implementation SKYInfoViewController

@synthesize index = _index;

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
    
    CGSize size = self.view.bounds.size;
    UIView *background = [[UIView alloc] initWithFrame: CGRectMake(0,
                                              0,
                                              size.width,
                                              size.height)];
    //[self.view addSubview:background];
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
        return [[UIViewController alloc] initWithNibName:@"AboutView" bundle:nil];
    }
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if(_index == 1) {
        return nil;
    }
    else {
        return [[UIViewController alloc] initWithNibName:@"ColorTheoryView" bundle:nil];
    }
}

-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return 2;
}

-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}

-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    if(_index == 0)
        _index++;
    else
        _index--;
}
@end
