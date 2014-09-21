//
//  ELMainTabAnimator.m
//  MovieMood
//
//  Created by Eric Lee on 9/21/14.
//  Copyright (c) 2014 Eric Lee Productions. All rights reserved.
//

#import "ELMainTabAnimator.h"
#import "ELMainTabProtocol.h"

@implementation ELMainTabAnimator

-(NSTimeInterval) transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return .15;
}

-(void) animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController<ELMainTabProtocol> *toVC = (UIViewController<ELMainTabProtocol>*)[transitionContext viewControllerForKey: UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey: UITransitionContextFromViewControllerKey];
    
    toVC.view.alpha = 1;
    
    [[transitionContext containerView] insertSubview: toVC.view belowSubview: fromVC.view];
    
    
    [UIView animateWithDuration: [self transitionDuration: transitionContext]
                     animations:^{
                         toVC.view.alpha = 1;
                         fromVC.view.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [fromVC.view removeFromSuperview];
                         [transitionContext completeTransition: YES];
                     }];
    [toVC.navigationController setNavigationBarHidden: ![toVC shouldShowNavBar] animated: YES];
}

@end
