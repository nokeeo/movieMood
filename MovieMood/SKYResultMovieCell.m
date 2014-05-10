//
//  SKYResultMovieCell.m
//  MovieMood
//
//  Created by Eric Lee on 2/1/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import "SKYResultMovieCell.h"

@implementation SKYResultMovieCell

@synthesize artwork = _artwork;
@synthesize title = _title;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) awakeFromNib {
    _artwork = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, 46, self.bounds.size.height)];
    _title = [[UILabel alloc] initWithFrame: CGRectMake(64, 22, 223, 21)];
    
    [self addSubview: _artwork];
    [self addSubview:_title];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
