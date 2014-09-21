//
//  SKYViewController.h
//  MovieMood
//
//  Created by Aaron Sky on 1/30/14.
//  Copyright (c) 2014 Eric Lee Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISColorWheel.h"
#import "ELColorPickerScrollView.h"
#import "ELMainTabProtocol.h"

@interface ELViewController : UIViewController <ColorPickerViewProtocol, UIScrollViewDelegate, ELMainTabProtocol>
@end
