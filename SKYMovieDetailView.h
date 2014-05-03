//
//  SKYMovieDetailView.h
//  MovieMood
//
//  Created by Eric Lee on 2/19/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKYBorderButton.h"
#import "SKYMovieInformationView.h"

@protocol MovieDetailButtonResponse
-(void)iTunesButtonPressedResponse:(id) sender;
-(void)favButtonPressedResponse:(id) sender;
@end

@interface SKYMovieDetailView : UIView
@property (weak, nonatomic) IBOutlet UILabel *movieTitle;
@property (weak, nonatomic) IBOutlet UIImageView *artworkImage;
@property (weak, nonatomic) IBOutlet UILabel *genreLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyLabel;
@property (weak, nonatomic) IBOutlet UILabel *rentLabel;
@property (weak, nonatomic) IBOutlet SKYBorderButton *iTunesButton;
@property (weak, nonatomic) SKYMovieInformationView *movieInformationView;
@property (nonatomic, retain) id buttonResponseDelegate;

-(void)setSummaryText:(NSString *) text;
-(CGSize) getSizeOfContent;
@end
