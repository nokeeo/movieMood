//
//  SKYInfoViewController.h
//  MovieMood
//
//  Created by Eric Lee on 2/2/14.
//  Copyright (c) 2014 Eric Lee Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ELInfoViewController : UIPageViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>
@property (nonatomic, retain) NSArray *data;
@end
