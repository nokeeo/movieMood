//
//  SKYMovieDetailView.m
//  MovieMood
//
//  Created by Eric Lee on 2/19/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import "SKYMovieDetailView.h"

@interface SKYMovieDetailView ()
@property (nonatomic, retain) UILabel *summaryLabel;
@end

@implementation SKYMovieDetailView

@synthesize buttonResponseDelegate = _buttonResponseDelegate;
@synthesize movieInformationView = _movieInformationView;
@synthesize summaryLabel = _summaryLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void)awakeFromNib {
    CGRect summaryRect = CGRectMake(_artworkImage.frame.origin.x,
                                    _artworkImage.frame.origin.y + _artworkImage.frame.size.height + 10,
                                    277, 98);
    _summaryLabel = [[UILabel alloc] initWithFrame:summaryRect];
    [self addSubview: _summaryLabel];
    
    //Create information view
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

-(void) setSummaryText:(NSString *)text {
    _summaryLabel.text = text;
    _summaryLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:15];
    _summaryLabel.numberOfLines = 0;
    CGFloat oldSumHeight = _summaryLabel.frame.size.height;
    //Check if more button in summary is needed.
    CGSize maxSummarySize = [self getFullSummarySizeWithText: _summaryLabel.text];
    if(maxSummarySize.height > _summaryLabel.frame.size.height) {
        CGRect newFrame = CGRectMake(_summaryLabel.frame.origin.x,
                                     _summaryLabel.frame.origin.y,
                                     _summaryLabel.frame.size.width,
                                     maxSummarySize.height + 30);
        [_summaryLabel setFrame: newFrame];
    }
    
    //Adjust the information view
    CGRect newInfoFrame = CGRectMake(_movieInformationView.frame.origin.x,
                                        _movieInformationView.frame.origin.y + (_summaryLabel.frame.size.height -  oldSumHeight) + 10,
                                        _movieInformationView.frame.size.width,
                                        _movieInformationView.frame.size.height);
    [_movieInformationView setFrame: newInfoFrame];
    
    //Adjust contentsize
    //CGSize newContentSize = CGSizeMake(self.contentSize.width, 9999);
    //self.contentSize = newContentSize;
}

-(CGSize)getFullSummarySizeWithText: (NSString *) text {
    CGSize maxSize = CGSizeMake(self.frame.size.width, 9999);
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:_summaryLabel.font, NSFontAttributeName, nil];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text attributes: attributes];
    
    CGRect requiredSize = [attrString boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    return requiredSize.size;
}
@end
