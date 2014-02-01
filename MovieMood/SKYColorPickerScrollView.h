//
//  SKYColorPickerScrollView.h
//  MovieMood
//
//  Created by Eric Lee on 2/1/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISColorWheel.h"

@interface SKYColorPickerScrollView : UIScrollView
@property (nonatomic, retain) UIView *colorIndicator;
@property (nonatomic, retain) ISColorWheel *colorWheel;
@end
