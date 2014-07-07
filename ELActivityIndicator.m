//
//  SKYActivityIndicator.m
//  MovieMood
//
//  Created by Eric Lee on 2/2/14.
//  Copyright (c) 2014 Eric Lee Productions. All rights reserved.
//

#import "ELActivityIndicator.h"

@implementation ELActivityIndicator

@synthesize activityIndicator = _activityIndicator;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGSize indicatorSize = CGSizeMake(frame.size.height * .7, frame.size.height * .7);
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((frame.size.width - indicatorSize.width) / 2,
                                                                                   (frame.size.height - indicatorSize.height) / 2,
                                                                                   indicatorSize.width, indicatorSize.height)];
        
        [self setBackgroundColor: [UIColor colorWithRed:242/255.f green:242/255.f blue:242/255.f alpha:.7]];
        self.layer.cornerRadius = 10;
        
        [self addSubview:_activityIndicator];
    }
    return self;
}

-(void) fadeInView {
    [self.activityIndicator startAnimating];
    [UIView beginAnimations:@"activityFade" context:nil];
    self.alpha = 0.f;
    self.alpha = 1.f;
    [UIView commitAnimations];
}

-(void) fadeOutView {
    [UIView beginAnimations:@"activityFade" context:nil];
    self.alpha = 1.f;
    self.alpha = 0.f;
    [UIView commitAnimations];
}
@end
