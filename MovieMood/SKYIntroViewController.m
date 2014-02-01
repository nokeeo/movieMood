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
}
@synthesize bucket = _bucket;

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
    NSMutableArray* smiles = [[NSMutableArray alloc] init];
    NSLog(@"%@",machineName());
    int count = ([machineName() isEqualToString:@"iPhone5,1"] || [machineName() isEqualToString:@"iPhone5,2"] || [machineName() isEqualToString:@"x86_64"] ? 50 : 10 );
    for (int i = 0; i < count; i++) {
        smiles[i] = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"smile.png"]];
        [self.view insertSubview:smiles[i] belowSubview:_bucket];
    }
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    _gravity = [[UIGravityBehavior alloc] initWithItems:smiles];
    [_animator addBehavior:_gravity];
    
    _collision = [[UICollisionBehavior alloc]
                  initWithItems:smiles];
    _collision.translatesReferenceBoundsIntoBoundary = YES;
    [_animator addBehavior:_collision];
    
    UIDynamicItemBehavior* itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:smiles];
    itemBehaviour.elasticity = 1.0;
    [_animator addBehavior:itemBehaviour];
    
    UIPushBehavior* pushBehaviour = [[UIPushBehavior alloc] initWithItems:smiles mode:UIPushBehaviorModeInstantaneous];
    [pushBehaviour setAngle:atan2(-100,0)];
    [pushBehaviour setMagnitude:10.0];
    [pushBehaviour setActive:TRUE];
    [_animator addBehavior:pushBehaviour];
    
    [self performSelector:@selector(goToNextView) withObject:nil afterDelay:3];
}

NSString*
machineName()
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

- (void) goToNextView
{
    [self performSegueWithIdentifier: @"StartApp" sender: self];
}

@end
