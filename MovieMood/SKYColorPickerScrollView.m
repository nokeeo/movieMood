//
//  SKYColorPickerScrollView.m
//  MovieMood
//
//  Created by Eric Lee on 2/1/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import "SKYColorPickerScrollView.h"

@interface SKYColorPickerScrollView()
@end

@implementation SKYColorPickerScrollView

@synthesize colorIndicator = _colorIndicator;
@synthesize colorWheel = _colorWheel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = true;
        self.alwaysBounceVertical = false;
        
        CGSize size = self.bounds.size;
        CGSize indicatorSize = CGSizeMake(size.width * .40, size.width * .40);
        CGSize wheelSize = CGSizeMake(size.width * .75, size.width * .75);
        CGSize centerWheelSize = CGSizeMake(size.width * .50, size.width * .50);
        
        UIView *centerWheel = [[UIView alloc] initWithFrame:CGRectMake(size.width / 2 - centerWheelSize.width / 2,
                                                                       (size.height * .2) + (wheelSize.height - centerWheelSize.height) / 2,
                                                                       centerWheelSize.width,
                                                                       centerWheelSize.height)];
        centerWheel.backgroundColor = [UIColor colorWithRed:(77/255.0) green:(77/255.0) blue:(77/225.0) alpha:1.0];
        centerWheel.layer.cornerRadius = 80;
        centerWheel.layer.borderColor = [UIColor darkGrayColor].CGColor;
        centerWheel.layer.borderWidth = 1.f;
        
        _colorWheel = [[ISColorWheel alloc] initWithFrame:CGRectMake(size.width / 2 - wheelSize.width / 2,
                                                                     size.height * .2,
                                                                     wheelSize.width,
                                                                     wheelSize.height)];
        _colorWheel.continuous = true;
        
        _colorIndicator = [[UIView alloc] initWithFrame:CGRectMake(size.width / 2 - indicatorSize.width / 2,
                                                                   (size.height * .2) + (wheelSize.height - indicatorSize.height) / 2,
                                                                   indicatorSize.height,
                                                                   indicatorSize.width)];
        _colorIndicator.layer.cornerRadius = 64;
        _colorIndicator.backgroundColor = _colorWheel.currentColor;
        
        [self addSubview:_colorWheel];
        [self addSubview:centerWheel];
        [self addSubview:_colorIndicator];
    }
    return self;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    self.alwaysBounceVertical = true;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
