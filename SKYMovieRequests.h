//
//  SKYMovieRequests.h
//  MovieMood
//
//  Created by Eric Lee on 2/2/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//


@interface SKYMovieRequests : NSObject
+(void) getMoviesWithGenres: (NSArray *) genreList page:(int) pageNum successCallback: (void (^)(id requestResponse)) successCallback failCallBack: (void (^)(NSError *error)) errorCallback;
@end
