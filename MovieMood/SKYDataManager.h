//
//  SKYDataManager.h
//  MovieMood
//
//  Created by Eric Lee on 5/3/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKYMovie.h"

@interface SKYDataManager : NSObject
-(NSError *)saveMovie:(SKYMovie *) movie;
-(NSError *)deleteMovie:(SKYMovie *) movie;
-(NSArray *)getFavMovies;
-(BOOL)isMovieFav:(SKYMovie *) movie;
@end
