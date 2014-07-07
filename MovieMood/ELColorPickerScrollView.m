//
//  SKYColorPickerScrollView.m
//  MovieMood
//
//  Created by Eric Lee on 2/1/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import "ELColorPickerScrollView.h"
#import "ELColorAnalyser.h"

@interface ELColorPickerScrollView() <ISColorWheelDelegate>
@property (nonatomic, retain) UIButton *selectButton;
@property (nonatomic, retain) UIView *centerWheel;
@end

@implementation ELColorPickerScrollView

@synthesize colorIndicator = _colorIndicator;
@synthesize colorWheel = _colorWheel;
@synthesize colorViewDelegate = _colorViewDelegate;
@synthesize selectButton = _selectButton;
@synthesize centerWheel = _centerWheel;

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
        
        _centerWheel = [[UIView alloc] initWithFrame:CGRectMake(size.width / 2 - centerWheelSize.width / 2,
                                                                       (size.height * .2) + (wheelSize.height - centerWheelSize.height) / 2,
                                                                       centerWheelSize.width,
                                                                       centerWheelSize.height)];
        _centerWheel.layer.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.2].CGColor;
        _centerWheel.layer.cornerRadius = 80;
        _centerWheel.layer.borderColor = [UIColor darkGrayColor].CGColor;
        _centerWheel.layer.borderWidth = .5;
        
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
        _colorIndicator.layer.borderColor = [UIColor darkGrayColor].CGColor;
        _colorIndicator.layer.borderWidth = .3;
        
        _selectButton = [[UIButton alloc] initWithFrame:CGRectMake(size.width / 2 - selectButtonSize.width / 2,
                                                                            (size.height * .2) + (wheelSize.height - selectButtonSize.height) / 2,
                                                                            selectButtonSize.width,
                                                                            selectButtonSize.height)];
        [_selectButton setTitle:@"Go" forState:UIControlStateNormal];
        [_selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_selectButton addTarget:self action:@selector(selectButtonPressed:) forControlEvents: UIControlEventTouchUpInside];
        [_selectButton addTarget: self action: @selector(selectButtonTouched:) forControlEvents: UIControlEventTouchDown];
        [_selectButton.titleLabel setFont:[UIFont fontWithName: @"HelveticaNeue-Thin" size:25]];
        
        [self addSubview:_colorWheel];
        [self addSubview:_centerWheel];
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
    [UIView animateWithDuration: .15 animations:^{
        _colorIndicator.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
        _colorWheel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
        _centerWheel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
    } completion:^(BOOL finished) {
        [_colorViewDelegate selectButtonPressed:self];
    }];
}

-(void) selectButtonTouched: (id) sender {
    //Start growth animations
    [UIView animateWithDuration: .35 animations:^{
        CGFloat scale = 1.15;
        CGFloat colorWheelScale  = ((scale - 1) / 3) + 1;
        _colorIndicator.transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
        _centerWheel.transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
        _colorWheel.transform = CGAffineTransformScale(CGAffineTransformIdentity, colorWheelScale, colorWheelScale);
    }];
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
