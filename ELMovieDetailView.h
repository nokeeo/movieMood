//
//  SKYMovieDetailView.h
//  MovieMood
//
//  Created by Eric Lee on 2/19/14.
//  Copyright (c) 2014 Eric Lee Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELBorderButton.h"

@protocol MovieDetailButtonResponse
-(void)iTunesButtonPressedResponse:(id) sender;
-(void)favButtonPressedResponse:(id) sender;
@end

@interface ELMovieDetailView : UIView
@property (weak, nonatomic) IBOutlet UILabel *movieTitle;
@property (weak, nonatomic) IBOutlet UIImageView *artworkImage;
@property (weak, nonatomic) IBOutlet UILabel *genreLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyLabel;
@property (weak, nonatomic) IBOutlet UILabel *rentLabel;
@property (weak, nonatomic) IBOutlet ELBorderButton *iTunesButton;
@property (weak, nonatomic) IBOutlet ELBorderButton *favButton;
@property (nonatomic, retain) id buttonResponseDelegate;

@property (weak, nonatomic) IBOutlet UITextView *summaryBox;
@property (weak, nonatomic) IBOutlet UILabel *directorLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *doNotShowMovieButton;

-(void)setSummaryText:(NSString *) text;
-(CGSize) getSizeOfContent;
@end
