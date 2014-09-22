//
//  SKYMovie.h
//  MovieMood
//
//  Created by Eric Lee on 2/13/14.
//  Copyright (c) 2014 Eric Lee Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const NSString *AFFILIATE_KEY;

//  ABSTRACT CLASS
@interface ELMediaEntity : NSObject
@property (nonatomic, retain) NSString *entityID;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *coverImage60;
@property (nonatomic, retain) NSString *coverImage170;
@property (nonatomic, retain) NSString *purchasePrice;
@property (nonatomic, retain) NSString *rentalPrice;
@property (nonatomic, retain) NSString *entityDescription;
@property (nonatomic, retain) NSString *storeURL;
@property (nonatomic, retain) NSString *trailerURL;
@property (nonatomic, retain) NSString *rating;
@property (nonatomic, retain) NSString *genre;
@property (nonatomic, retain) NSString *director;
@property (nonatomic, retain) NSString *releaseDate;

-(id) initWithEntry:(id) entry;
-(id)initWithLookupData: (id) entry;
@end
