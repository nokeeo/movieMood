//
//  SKYIntroViewController.m
//  MovieMood
//
//  Created by Aaron Sky on 1/31/14.
//  Copyright (c) 2014 Eric Lee Productions. All rights reserved.
//

#import "ELIntroViewController.h"
#import <sys/utsname.h>

@interface ELIntroViewController ()

@end

@implementation ELIntroViewController {
    UIDynamicAnimator* _animator;
    UIGravityBehavior* _gravity;
    UICollisionBehavior* _collision;
    NSArray* smiles;
    UIDynamicItemBehavior *itemBehaviour;
    
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
    smiles = @[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"smile.png"]]];
    [smiles[0] setPosition:CGPointMake(self.view.bounds.size.width / 2, 200)];
    [self.view insertSubview:smiles[0] belowSubview:_smilePile];
    
    [self becomeFirstResponder];
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    _gravity = [[UIGravityBehavior alloc] init];
    [_gravity addItem:smiles[0]];
    [_animator addBehavior:_gravity];
    
    _collision = [[UICollisionBehavior alloc] init];
    [_collision addItem:smiles[0]];
    _collision.translatesReferenceBoundsIntoBoundary = NO;
    //_collision.collisionMode = UICollisionBehaviorModeBoundaries;
    [_collision addBoundaryWithIdentifier:@"bottom" fromPoint:CGPointMake(0,self.view.bounds.size.height / 2) toPoint:CGPointMake(self.view.bounds.size.width, self.view.bounds.size.height / 2)];
    [_animator addBehavior:_collision];
    
    itemBehaviour = [[UIDynamicItemBehavior alloc] init];
    itemBehaviour.elasticity = 0.5;
    [itemBehaviour addItem:smiles[0]];
    [_animator addBehavior:itemBehaviour];
    
    UIPushBehavior *pushBehaviour = [[UIPushBehavior alloc] init];
    pushBehaviour = [[UIPushBehavior alloc] initWithItems:smiles mode:UIPushBehaviorModeInstantaneous];
    [pushBehaviour setAngle:atan2(-100, 100)];
    [pushBehaviour setMagnitude:1.5];
    [pushBehaviour setActive:TRUE];
    [_animator addBehavior:pushBehaviour];
    
    for(int i = 0; i < 10; i++) {
        [self performSelector:@selector(spawnMoreSmiles) withObject:nil afterDelay:.5 * i + 1];
    }
    [self performSelector:@selector(goToNextView) withObject:nil afterDelay:3];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        /*UIPushBehavior* push = [[UIPushBehavior alloc] initWithItems:smiles mode:UIPushBehaviorModeInstantaneous];
        [push setMagnitude:5];
        [_animator addBehavior:push];*/
    }
}

- (void) goToNextView
{
    [self performSegueWithIdentifier: @"StartApp" sender: self];
}

-(void) spawnMoreSmiles {
    UIImageView *newSmile = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width / 5,
                                                                          200,
                                                                          50,
                                                                          50)];
    [self.view insertSubview:newSmile belowSubview: _smilePile];
    newSmile.image = [UIImage imageNamed:@"smile.png"];
    [_gravity addItem: newSmile];
    [_collision addItem:newSmile];
    [itemBehaviour addItem:newSmile];
    
    UIPushBehavior *pushBehaviour = [[UIPushBehavior alloc] init];
    pushBehaviour = [[UIPushBehavior alloc] initWithItems:smiles mode:UIPushBehaviorModeInstantaneous];
    [pushBehaviour setAngle: [self getRandomAngle]];
    [pushBehaviour setMagnitude:1.75];
    [pushBehaviour setActive:TRUE];
    [_animator addBehavior:pushBehaviour];
    
    [pushBehaviour addItem:newSmile];
}

-(float) getRandomAngle {
    float randomDegree = arc4random() %  90;
    return atan2f(randomDegree  * -1, randomDegree / ((arc4random() % 5) + 5));
}

@end
