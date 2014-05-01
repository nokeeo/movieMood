//
//  SKYMovieRequests.h
//  MovieMood
//
//  Created by Eric Lee on 2/2/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import "SKYMovie.h"

@interface SKYMovieRequests : NSObject
+(void) getMoviesWithGenres: (NSArray *) genreList page:(int) pageNum successCallback: (void (^)(id requestResponse)) successCallback failCallBack: (void (^)(NSError *error)) errorCallback;
+(void) getMovieDetailData:(SKYMovie *) movie successCallback:(void (^)(id requestResponse))successCallback failCallBack: (void (^)(NSError * error)) errorCallback;
+(void) getTrailerWithMovieTitle:(NSString *) title successCallback:(void (^) (id requestResponse))successCallback failCallBack: (void (^)(NSError *error)) errorCallback;
+(void) loadImageWithURL: (NSURL *)url successCallback:(void (^) (id requestResponse))successCallback failCallcack:(void (^) (NSError *error)) errorCallback;
@end
