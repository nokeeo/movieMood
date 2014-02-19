//
//  SKYBorderButton.m
//  MovieMood
//
//  Created by Eric Lee on 2/19/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import "SKYBorderButton.h"

@implementation SKYBorderButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    self.layer.cornerRadius = 5;
    self.layer.borderWidth = 1;
    self.layer.borderColor = self.tintColor.CGColor;
}

-(void)setColor:(UIColor *) color {
    self.tintColor = color;
    [self drawRect:self.frame];
}
@end
