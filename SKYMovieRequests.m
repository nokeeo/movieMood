//
//  SKYMovieRequests.m
//  MovieMood
//
//  Created by Eric Lee on 2/2/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import "SKYMovieRequests.h"
#import "JLTMDbClient.h"

@implementation SKYMovieRequests

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(void) getMoviesWithGenres:(NSArray *)genreList page:(int) pageNum successCallback:(void (^)(id))successCallback failCallBack:(void (^)(NSError *))errorCallback{
    __block int requestsSent = 0;
    __block int requestsRecieved = 0;
    
    __block NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    
    for(NSString *genre in genreList) {
        requestsSent++;
        NSLog(@"%d", pageNum);
        [[JLTMDbClient sharedAPIInstance] GET:kJLTMDbGenreMovies withParameters:@{@"id":genre, @"page":[NSString stringWithFormat:@"%d", pageNum]} andResponseBlock:^(id response, NSError *error) {
            if(!error) {
                requestsRecieved++;
                [data setObject:[response objectForKey:@"results"] forKey:genre];
                if(requestsSent == requestsRecieved) {
                    successCallback(data);
                }
                    
            }
            else
                errorCallback(error);
        }];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
