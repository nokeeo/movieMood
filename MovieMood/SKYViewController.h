//
//  SKYViewController.h
//  MovieMood
//
//  Created by Aaron Sky on 1/30/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISColorWheel.h"

@interface SKYViewController : UIViewController <ISColorWheelDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@end
