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
@synthesize movieInformationView = _movieInformationView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void)awakeFromNib {
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MovieInformationView" owner:self options:nil];
    _movieInformationView = [nib objectAtIndex: 0];
    CGPoint informationOrigin = CGPointMake(_summaryLabel.frame.origin.x ,
                                            _summaryLabel.frame.origin.y + _summaryLabel.frame.size.height);
    CGRect informationRect = CGRectMake(informationOrigin.x,
                                        informationOrigin.y,
                                        _summaryLabel.frame.size.width,
                                        200);
    [self addSubview: _movieInformationView];
    [_movieInformationView setFrame: informationRect];
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
