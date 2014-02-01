//
//  SKYIntroViewController.m
//  MovieMood
//
//  Created by Aaron Sky on 1/31/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import "SKYIntroViewController.h"
#import <sys/utsname.h>

@interface SKYIntroViewController ()

@end

@implementation SKYIntroViewController {
    UIDynamicAnimator* _animator;
    UIGravityBehavior* _gravity;
    UICollisionBehavior* _collision;
    NSMutableArray* smiles;
}
@synthesize bucket = _bucket;
@synthesize smilePile = _smilePile;

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
    smiles = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10; i++) {
        smiles[i] = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"smile.png"]];
        [smiles[i] setPosition:CGPointMake(self.view.bounds.size.width / 2, 200)];
        [self.view insertSubview:smiles[i] belowSubview:_smilePile];
    }
    
    [self becomeFirstResponder];
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    _gravity = [[UIGravityBehavior alloc] initWithItems:smiles];
    [_animator addBehavior:_gravity];
    
    _collision = [[UICollisionBehavior alloc]
                  initWithItems:smiles];
    _collision.translatesReferenceBoundsIntoBoundary = YES;
    //_collision.collisionMode = UICollisionBehaviorModeBoundaries;
    [_collision addBoundaryWithIdentifier:@"bottom" fromPoint:CGPointMake(0,self.view.bounds.size.height / 2) toPoint:CGPointMake(self.view.bounds.size.width, self.view.bounds.size.height / 2)];
    [_animator addBehavior:_collision];
    
    UIDynamicItemBehavior* itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:smiles];
    itemBehaviour.elasticity = 0.5;
    [_animator addBehavior:itemBehaviour];
    
    UIPushBehavior* pushBehaviour = [[UIPushBehavior alloc] initWithItems:smiles mode:UIPushBehaviorModeInstantaneous];
    //[pushBehaviour setAngle:atan2(-100, 100)];
    [pushBehaviour setMagnitude:arc4random() % 11];
    [pushBehaviour setActive:TRUE];
    [_animator addBehavior:pushBehaviour];
    
    [self performSelector:@selector(goToNextView) withObject:nil afterDelay:3];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        UIPushBehavior* push = [[UIPushBehavior alloc] initWithItems:smiles mode:UIPushBehaviorModeInstantaneous];
        [push setMagnitude:5];
        [_animator addBehavior:push];
    }
}

- (void) goToNextView
{
    [self performSegueWithIdentifier: @"StartApp" sender: self];
}

@end
