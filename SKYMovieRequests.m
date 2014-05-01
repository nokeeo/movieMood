//
//  SKYMovieRequests.m
//  MovieMood
//
//  Created by Eric Lee on 2/2/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import "SKYMovieRequests.h"
#import "AFHTTPRequestOperation.h"

@implementation SKYMovieRequests

+(void) getMoviesWithGenres:(NSArray *)genreList page:(int) pageNum successCallback:(void (^)(id))successCallback failCallBack:(void (^)(NSError *))errorCallback {
    __block int requestsSent = 0;
    __block int requestsRecieved = 0;
    
    __block NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    
    for(NSString *genre in genreList) {
        requestsSent++;
        NSString *genreURL = [[NSString alloc] initWithFormat:@"%@%@%@", @"https://itunes.apple.com/us/rss/topmovies/limit=300/genre=", genre, @"/json"];
        NSURL *url = [NSURL URLWithString:genreURL];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        
        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest: request];
        [requestOperation setResponseSerializer:[AFJSONResponseSerializer serializer]];
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            requestsRecieved++;
            id feed = [responseObject objectForKey:@"feed"];
            id entries = [feed objectForKey:@"entry"];
            NSMutableArray *movies = [[NSMutableArray alloc] init];
            for(id entry in entries) {
                SKYMovie *newMovie = [[SKYMovie alloc] initWithEntry:entry];
                [movies addObject:newMovie];
            }
            [data setObject:movies forKey:genre];
            
            if(requestsSent == requestsRecieved)
                successCallback(data);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error);
            errorCallback(error);
        }];
        [requestOperation start];
    }
}

+(void) getMovieDetailData:(SKYMovie *) movie successCallback:(void (^)(id requestResponse))successCallback failCallBack: (void (^)(NSError * error)) errorCallback {
    NSString *movieURL = [[NSString alloc] initWithFormat:@"%@%@%@", @"https://itunes.apple.com/lookup?id=", movie.movieId, @"&entity=movie"];
    NSURL *url = [NSURL URLWithString:movieURL];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [requestOperation setResponseSerializer: [AFJSONResponseSerializer serializer]];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        movie.rating = [responseObject objectForKey:@"contentAdvisoryRating"];
        successCallback(movie);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorCallback(error);
    }];
    [requestOperation start];
}

+(void) getTrailerWithMovieTitle:(NSString *)title successCallback:(void (^)(id))successCallback failCallBack:(void (^)(NSError *error))errorCallback {
    NSString *formatTitle = [title stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    NSString *titleURL = [[NSString alloc] initWithFormat:@"%@film=%@", @"http://api.traileraddict.com/?", formatTitle ];
    NSURL *url = [NSURL URLWithString:titleURL];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [requestOperation setResponseSerializer: [AFXMLParserResponseSerializer serializer]];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
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
@end
