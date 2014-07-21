//
//  SKYDataManager.h
//  MovieMood
//
//  Created by Eric Lee on 5/3/14.
//  Copyright (c) 2014 Eric Lee Productions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ELMediaEntity.h"

@interface ELDataManager : NSObject

-(NSError *)saveMovie:(ELMediaEntity *) movie;
-(NSError *)deleteMovie:(ELMediaEntity *) movie;
-(NSArray *)getFavMovies;
-(BOOL)isMovieFav:(ELMediaEntity *) movie;

-(BOOL) canShowMovie: (ELMediaEntity *) movie;
-(NSError *) doNotShowMovie: (ELMediaEntity *) movie;
-(NSError *) doShowMovie: (ELMediaEntity *) movie;
-(NSArray *) getDoNotShowMovies;
@end
