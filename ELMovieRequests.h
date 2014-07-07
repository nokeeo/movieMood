//
//  SKYMovieRequests.h
//  MovieMood
//
//  Created by Eric Lee on 2/2/14.
//  Copyright (c) 2014 Eric Lee Productions. All rights reserved.
//

#import "ELMediaEntity.h"

@interface ELMovieRequests : NSObject
+(void) getMoviesWithGenres: (NSArray *) genreList successCallback: (void (^)(id requestResponse)) successCallback failCallBack: (void (^)(NSError *error)) errorCallback;
+(void) getMovieDetailData:(ELMediaEntity *) movie successCallback:(void (^)(id requestResponse))successCallback failCallBack: (void (^)(NSError * error)) errorCallback;
+(void) getTrailerWithMovieTitle:(NSString *) title successCallback:(void (^) (id requestResponse))successCallback failCallBack: (void (^)(NSError *error)) errorCallback;
+(void) loadImageWithURL: (NSURL *)url successCallback:(void (^) (id requestResponse))successCallback failCallcack:(void (^) (NSError *error)) errorCallback;
+(void) getMoviesWithIDs: (NSArray *)ids successCallback:(void (^)(id movies)) successCallback failCallback: (void(^)(NSError *error)) errorCallback;
@end
