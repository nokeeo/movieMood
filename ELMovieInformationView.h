//
//  SKYMovieInformationView.h
//  MovieMood
//
//  Created by Eric Lee on 5/2/14.
//  Copyright (c) 2014 Eric Lee Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ELInformationViewDelegate <NSObject>

-(void) doNotShowMeButtonPressed: (id) sender;

@end

@interface ELMovieInformationView : UIView
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *directorLabel;
@property (weak, nonatomic) IBOutlet UIButton *doNotShowMovieButton;
@property (weak, nonatomic) IBOutlet UILabel *releaseDateLabel;
@property (nonatomic, strong) id<ELInformationViewDelegate> delegate;
@end
