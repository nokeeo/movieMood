//
//  SKYColorPickerScrollView.m
//  MovieMood
//
//  Created by Eric Lee on 2/1/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import "SKYColorPickerScrollView.h"
#import "SKYColorAnalyser.h"

@interface SKYColorPickerScrollView() <ISColorWheelDelegate>
@property (nonatomic, retain) UIButton *selectButton;
@end

@implementation SKYColorPickerScrollView

@synthesize colorIndicator = _colorIndicator;
@synthesize colorWheel = _colorWheel;
@synthesize colorViewDelegate = _colorViewDelegate;
@synthesize selectButton = _selectButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = true;
        self.alwaysBounceVertical = false;
        
        CGSize size = self.bounds.size;
        CGSize indicatorSize = CGSizeMake(size.width * .40, size.width * .40);
        CGSize wheelSize = CGSizeMake(size.width * .8, size.width * .8);
        CGSize centerWheelSize = CGSizeMake(size.width * .50, size.width * .50);
        CGSize selectButtonSize = CGSizeMake(size.width * .3, size.width * .3);
        
        UIView *centerWheel = [[UIView alloc] initWithFrame:CGRectMake(size.width / 2 - centerWheelSize.width / 2,
                                                                       (size.height * .2) + (wheelSize.height - centerWheelSize.height) / 2,
                                                                       centerWheelSize.width,
                                                                       centerWheelSize.height)];
        centerWheel.layer.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.2].CGColor;
        centerWheel.layer.cornerRadius = 80;
        centerWheel.layer.borderColor = [UIColor darkGrayColor].CGColor;
        centerWheel.layer.borderWidth = .5;
        
        _colorWheel = [[ISColorWheel alloc] initWithFrame:CGRectMake(size.width / 2 - wheelSize.width / 2,
                                                                     size.height * .2,
                                                                     wheelSize.width,
                                                                     wheelSize.height)];
        _colorWheel.continuous = YES;
        _colorWheel.delegate = self;
        
        _colorIndicator = [[UIView alloc] initWithFrame:CGRectMake(size.width / 2 - indicatorSize.width / 2,
                                                                   (size.height * .2) + (wheelSize.height - indicatorSize.height) / 2,
                                                                   indicatorSize.height,
                                                                   indicatorSize.width)];
        _colorIndicator.layer.cornerRadius = 64;
        [self changeIndicatorColor: _colorWheel.currentColor];
        //_colorIndicator.layer.borderColor = [UIColor colorWithRed:157/255.f green:157/255.f blue:157/255.f alpha:1].CGColor;
        _colorIndicator.layer.borderColor = [UIColor darkGrayColor].CGColor;
        _colorIndicator.layer.borderWidth = .3;
        
        _selectButton = [[UIButton alloc] initWithFrame:CGRectMake(size.width / 2 - selectButtonSize.width / 2,
                                                                            (size.height * .2) + (wheelSize.height - selectButtonSize.height) / 2,
                                                                            selectButtonSize.width,
                                                                            selectButtonSize.height)];
        [_selectButton setTitle:@"Go" forState:UIControlStateNormal];
        [_selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_selectButton addTarget:self action:@selector(selectButtonPressed:) forControlEvents:UIControlEventTouchDown];
        [_selectButton.titleLabel setFont:[UIFont fontWithName: @"HelveticaNeue-Thin" size:25]];
        
        [self addSubview:_colorWheel];
        [self addSubview:centerWheel];
        [self addSubview:_colorIndicator];
        [self addSubview:_selectButton];
    }
    return self;
}

-(void) colorWheelDidChangeColor:(ISColorWheel *)colorWheel {
    colorWheel.knobView.alpha = 1.f;
    [_colorViewDelegate colorDidChange:self];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.alwaysBounceVertical = true;
}

-(void)selectButtonPressed:(id) sender {
    [_colorViewDelegate selectButtonPressed:self];
}

-(void)changeSelectButtonColorWithColor:(UIColor *)color {
    [_selectButton setTitleColor: color forState: UIControlStateNormal];
}

-(void)changeIndicatorColor:(UIColor *)color {
    UIColor *backgroundColor = [_colorWheel.currentColor colorWithAlphaComponent:.4];
    [_colorIndicator setBackgroundColor: backgroundColor];
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
