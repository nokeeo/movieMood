//
//  ELMainTabBarViewController.m
//  MovieMood
//
//  Created by Eric Lee on 9/20/14.
//  Copyright (c) 2014 Eric Lee Productions. All rights reserved.
//

#import "ELMainTabBarViewController.h"
#import "ELMainTabProtocol.h"
#import "ELMainTabAnimator.h"

@interface ELMainTabBarViewController ()

@end

@implementation ELMainTabBarViewController

-(void) awakeFromNib {
    [super awakeFromNib];
    self.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

-(void) viewWillAppear:(BOOL)animated {
    UIViewController<ELMainTabProtocol> *controller = (UIViewController<ELMainTabProtocol> *) self.selectedViewController;
    [self hideNavBarWithVC: controller];
    [super viewWillAppear: animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITabViewControllerDelegate

-(void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    UIViewController<ELMainTabProtocol> *controller = (UIViewController<ELMainTabProtocol>* )viewController;
    [self hideNavBarWithVC: controller];
    
    NSLog(@"%@", viewController.view);
    NSLog(@"%@", self.selectedViewController.view);
}

-(id<UIViewControllerAnimatedTransitioning>) tabBarController:(UITabBarController *)tabBarController animationControllerForTransitionFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    ELMainTabAnimator *animator = [[ELMainTabAnimator alloc] init];
    
    return animator;
}
     
#pragma mark - Helper Functions

-(void) hideNavBarWithVC: (id<ELMainTabProtocol>) controller {
    /*if([controller shouldShowNavBar]) {
        self.navigationController.navigationBar.alpha = 1;
    }
    else {
        self.navigationController.navigationBar.alpha = 0;
    }*/
    
    [self.navigationController setNavigationBarHidden: ![controller shouldShowNavBar] animated: YES];
}
@end
