//
//  SKYIntroViewController.m
//  MovieMood
//
//  Created by Aaron Sky on 1/31/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import "SKYIntroViewController.h"

@interface SKYIntroViewController ()

@end

@implementation SKYIntroViewController {
    UIDynamicAnimator* _animator;
    UIGravityBehavior* _gravity;
    UICollisionBehavior* _collision;
}

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
	// Do any additional setup after loading the view.
    UIView* square = [[UIView alloc] initWithFrame:
                      CGRectMake(100, 100, 100, 100)];
    square.backgroundColor = [UIColor grayColor];
    [self.view addSubview:square];
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    _gravity = [[UIGravityBehavior alloc] initWithItems:@[square]];
    [_animator addBehavior:_gravity];
    
    _collision = [[UICollisionBehavior alloc]
                  initWithItems:@[square]];
    _collision.translatesReferenceBoundsIntoBoundary = YES;
    [_animator addBehavior:_collision];
    
    UIDynamicItemBehavior* itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[square]];
    itemBehaviour.elasticity = 0.6;
    [_animator addBehavior:itemBehaviour];
    
    UIPushBehavior* pushBehaviour = [[UIPushBehavior alloc] initWithItems:@[square] mode:UIPushBehaviorModeInstantaneous];
    [pushBehaviour setPushDirection:CGVectorMake(-0.1, 0.1)];
    
    [self performSelector:@selector(goToNextView) withObject:nil afterDelay:3];
}

- (void) goToNextView
{
    [self performSegueWithIdentifier: @"StartApp" sender: self];
}

@end
