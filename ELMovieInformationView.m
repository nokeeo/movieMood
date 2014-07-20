//
//  SKYMovieInformationView.m
//  MovieMood
//
//  Created by Eric Lee on 5/2/14.
//  Copyright (c) 2014 Eric Lee Productions. All rights reserved.
//

#import "ELMovieInformationView.h"

@implementation ELMovieInformationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (IBAction)doNotShowMoviePressed:(id)sender {
    [_delegate doNotShowMeButtonPressed: self];
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
