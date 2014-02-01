//
//  SKYColorPickerScrollView.m
//  MovieMood
//
//  Created by Eric Lee on 2/1/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import "SKYColorPickerScrollView.h"

@interface SKYColorPickerScrollView() <ISColorWheelDelegate>
@end

@implementation SKYColorPickerScrollView

@synthesize colorIndicator = _colorIndicator;
@synthesize colorWheel = _colorWheel;
@synthesize colorViewDelegate = _colorViewDelegate;

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
        CGSize selectButtonSize = CGSizeMake(size.width * .3, size.width * .3);
        
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
        _colorWheel.delegate = self;
        
        _colorIndicator = [[UIView alloc] initWithFrame:CGRectMake(size.width / 2 - indicatorSize.width / 2,
                                                                   (size.height * .2) + (wheelSize.height - indicatorSize.height) / 2,
                                                                   indicatorSize.height,
                                                                   indicatorSize.width)];
        _colorIndicator.layer.cornerRadius = 64;
        _colorIndicator.backgroundColor = _colorWheel.currentColor;
        
        UIButton *selectButton = [[UIButton alloc] initWithFrame:CGRectMake(size.width / 2 - selectButtonSize.width / 2,
                                                                            (size.height * .2) + (wheelSize.height - selectButtonSize.height) / 2,
                                                                            selectButtonSize.width,
                                                                            selectButtonSize.height)];
        [selectButton setTitle:@"GO" forState:UIControlStateNormal];
        [selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [selectButton addTarget:self action:@selector(selectButtonPressed:) forControlEvents:UIControlEventTouchDown];
        
        [self addSubview:_colorWheel];
        [self addSubview:centerWheel];
        [self addSubview:_colorIndicator];
        [self addSubview:selectButton];
    }
    return self;
}

-(void) colorWheelDidChangeColor:(ISColorWheel *)colorWheel {
    [_colorViewDelegate colorDidChange:self];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.alwaysBounceVertical = true;
}

-(void)selectButtonPressed:(id) sender {
    [_colorViewDelegate selectButtonPressed:self];
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
