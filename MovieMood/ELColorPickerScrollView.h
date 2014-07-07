//
//  SKYColorPickerScrollView.h
//  MovieMood
//
//  Created by Eric Lee on 2/1/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISColorWheel.h"
@protocol ColorPickerViewProtocol
-(void) colorDidChange:(id) sender;
-(void) selectButtonPressed:(id) sender;
@end

@interface ELColorPickerScrollView : UIScrollView
@property (nonatomic, retain) UIView *colorIndicator;
@property (nonatomic, retain) ISColorWheel *colorWheel;
@property id colorViewDelegate;

-(void) changeSelectButtonColorWithColor:(UIColor *) color;
-(void) changeIndicatorColor:(UIColor *) color;
@end
