//
//  SKYMovieCellScrollView.m
//  MovieMood
//
//  Created by Eric Lee on 5/10/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import "ELMovieCellScrollView.h"

@implementation ELMovieCellScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.dragging)
        [self.superview touchesCancelled: touches withEvent:event];
    else
        [super touchesCancelled: touches withEvent: event];
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.dragging) {
        [super touchesMoved:touches withEvent:event];
    }
    else {
        if ([self.delegate isKindOfClass:[UITableViewCell class]]) {
            [(UITableViewCell *)self.delegate touchesCancelled:touches withEvent:event];
        }
        [self.superview touchesMoved:touches withEvent:event];
    }
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.dragging)
        [self.superview touchesBegan: touches withEvent:event];
    else
        [super touchesBegan: touches withEvent: event];
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.dragging)
        [self.superview touchesEnded: touches withEvent:event];
    else
        [super touchesEnded: touches withEvent: event];
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
