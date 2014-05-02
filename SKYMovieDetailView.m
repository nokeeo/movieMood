//
//  SKYMovieDetailView.m
//  MovieMood
//
//  Created by Eric Lee on 2/19/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import "SKYMovieDetailView.h"

@interface SKYMovieDetailView ()

@end

@implementation SKYMovieDetailView

@synthesize buttonResponseDelegate = _buttonResponseDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        self.userInteractionEnabled = YES;
        self.alwaysBounceVertical = YES;
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    _artworkImage.layer.cornerRadius = 10;
    _artworkImage.layer.borderWidth = 1;
    _artworkImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _artworkImage.layer.masksToBounds = YES;
    
}

- (IBAction)iTunesButtonPressed:(id)sender {
    [_buttonResponseDelegate iTunesButtonPressedResponse: sender];
}
@end
