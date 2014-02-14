//
//  SKYMovie.h
//  MovieMood
//
//  Created by Eric Lee on 2/13/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKYMovie : NSObject
@property (nonatomic, retain) NSString *movieId;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *coverImage60;
@property (nonatomic, retain) NSString *purchasePrice;
@property (nonatomic, retain) NSString *rentalPrice;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *storeURL;
@property (nonatomic, retain) NSString *trailerURL;
@property (nonatomic, retain) NSString *rating;

-(id) initWithEntry:(id) entry;
@end