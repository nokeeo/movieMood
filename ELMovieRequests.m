//
//  SKYMovieRequests.m
//  MovieMood
//
//  Created by Eric Lee on 2/2/14.
//  Copyright (c) 2014 Eric Lee Productions. All rights reserved.
//

#import "ELMovieRequests.h"
#import "AFHTTPRequestOperation.h"
#import "ELMovieMediaEntity.h"
#import "ELTVShowMediaEntity.h"

@implementation ELMovieRequests

+(void) generalMediaRequestWithGenres: (NSArray *)genreList successCallback:(void (^)(id))successCallback failCallBack:(void (^)(NSError *))errorCallback dataStructureCreation: (ELMediaEntity* (^)(id)) creationBlock requestURL: (NSURL *) baseUrl {
    __block int requestsSent = 0;
    __block int requestsRecieved = 0;
    __block BOOL errorCallbackCalled = NO;
    
    __block NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    
    for(NSString *genre in genreList) {
        requestsSent++;
        NSURL *url = [ELMovieRequests getURLWithGenreCode: genre];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest: request];
        [requestOperation setResponseSerializer:[AFJSONResponseSerializer serializer]];
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            requestsRecieved++;
            id feed = [responseObject objectForKey:@"feed"];
            id entries = [feed objectForKey:@"entry"];
            NSMutableArray *movies = [[NSMutableArray alloc] init];
            for(id entry in entries) {
                NSLog(@"%@", entry);
                ELMediaEntity *newMediaEntity;
                NSString *genreCode = [[[entry objectForKey: @"category"] objectForKey: @"attributes"] objectForKey: @"im:id"];
                if([genreCode hasPrefix: @"44"]) {
                     newMediaEntity = [[ELMovieMediaEntity alloc] initWithEntry: entry];
                }
                else {
                    newMediaEntity = [[ELTVShowMediaEntity alloc] initWithEntry: entry];
                }
                [movies addObject: newMediaEntity];
            }
            [data setObject:movies forKey:genre];
            
            if(requestsSent == requestsRecieved)
                successCallback(data);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(!errorCallbackCalled) {
                errorCallbackCalled = YES;
                errorCallback(error);
            }
        }];
        [requestOperation start];
    }
}

+(void) getMoviesWithGenres:(NSArray *)genreList successCallback:(void (^)(id))successCallback failCallBack:(void (^)(NSError *))errorCallback {
    NSURL *url = [NSURL URLWithString: @"https://itunes.apple.com/us/rss/topmovies/limit=100"];
    [ELMovieRequests generalMediaRequestWithGenres: genreList successCallback: successCallback failCallBack: errorCallback dataStructureCreation:^ELMediaEntity *(id entry) {
        return [[ELMovieMediaEntity alloc] initWithEntry: entry];
    } requestURL: url];
}

+(void) getMovieDetailData:(ELMediaEntity *) movie successCallback:(void (^)(id requestResponse))successCallback failCallBack: (void (^)(NSError * error)) errorCallback {
    NSString *movieURL = [[NSString alloc] initWithFormat:@"%@%@%@", @"https://itunes.apple.com/lookup?id=", movie.entityID, @"&entity=movie"];
    NSURL *url = [NSURL URLWithString:movieURL];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [requestOperation setResponseSerializer: [AFJSONResponseSerializer serializer]];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        id results = [responseObject objectForKey: @"results"];
        if([results count] > 0) {
            id targetMovie = [results objectAtIndex: 0];
            movie.rating = [targetMovie objectForKey:@"contentAdvisoryRating"];
        }
        successCallback(movie);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorCallback(error);
    }];
    [requestOperation start];
}

+(void) getMoviesWithIDs: (NSArray *)ids successCallback:(void (^)(id movies)) successCallback failCallback: (void(^)(NSError *error)) errorCallback {
    NSMutableString *movieURL = [[NSMutableString alloc] initWithString:@"https://itunes.apple.com/lookup?id="];
    
    //Build URL
    for(int i = 0; i < [ids count]; i++) {
        [movieURL appendString: [ids objectAtIndex: i]];
        
        if(i != [ids count] - 1)
            [movieURL appendString: @","];
    }
    [movieURL appendString: @"&entity=movie"];
    
    NSURL *url = [NSURL URLWithString: movieURL];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest: request];
    [requestOperation setResponseSerializer: [AFJSONResponseSerializer serializer]];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        id results = [responseObject objectForKey: @"results"];
        NSMutableArray *movies = [[NSMutableArray alloc] init];
        for(int i = 0; i < [results count]; i++) {
            ELMediaEntity *movie = [[ELMovieMediaEntity alloc] initWithLookupData: [results objectAtIndex: i]];
            [movies addObject: movie];
        }
        successCallback(movies);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorCallback(error);
    }];
    [requestOperation start];
}

+(void) loadImageWithURL: (NSURL *)url successCallback:(void (^) (id requestResponse))successCallback failCallcack:(void (^) (NSError *error)) errorCallback {
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL: url]];
    operation.responseSerializer = [AFImageResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        successCallback(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorCallback(error);
    }];
    [operation start];
}

#pragma mark - Helper functions 
+(NSURL *) getURLWithGenreCode: (NSString *) genre {
    NSString *urlString;
    if([genre hasPrefix: @"44"])
        urlString = @"https://itunes.apple.com/us/rss/topmovies/limit=100";
    else
        urlString = @"https://itunes.apple.com/us/rss/toptvseasons/limit=100";
    return [NSURL URLWithString: [NSString stringWithFormat: @"%@/genre=%@/json", urlString, genre]];
}
@end
