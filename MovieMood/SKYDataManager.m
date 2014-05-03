//
//  SKYDataManager.m
//  MovieMood
//
//  Created by Eric Lee on 5/3/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import "SKYDataManager.h"
#import "SKYAppDelegate.h"

@interface SKYDataManager()
@property (nonatomic, retain) NSManagedObjectContext *context;
@end

@implementation SKYDataManager

@synthesize context = _context;

-(id)init {
    self = [super init];
    
    if(self) {
        SKYAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        _context = [delegate managedObjectContext];
    }
    
    return self;
}

-(NSError *)saveMovie:(SKYMovie *)movie {
    
    NSFetchRequest *favMovieRequest = [self createFavMovieRequest];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"iTunesID = %@", movie.movieId];
    [favMovieRequest setPredicate: pred];
    
    NSError *error;
    NSArray *fetchedMovies = [_context executeFetchRequest: favMovieRequest error: &error];
    
    if(error)
        return error;
    
    else if([fetchedMovies count] == 0) {
        NSManagedObject *newMovie = [NSEntityDescription insertNewObjectForEntityForName:@"FavMovie" inManagedObjectContext:_context];
        [newMovie setValue: movie.movieId forKeyPath:@"iTunesID"];
        
        [_context save: &error];
    }
    
    return error;
}

-(NSError *)deleteMovie:(SKYMovie *) movie {
    NSManagedObject *movieObject = [self getFavMovie: movie];
    NSError *error;
    
    if(movieObject) {
        [_context deleteObject: movieObject];
        [_context save: &error];
    }
    
    return error;
}

-(NSArray *)getFavMovies {
    NSFetchRequest *favMovieRequest = [self createFavMovieRequest];
    
    NSError *error;
    NSArray *fetchedMovies = [_context executeFetchRequest: favMovieRequest error: &error];
    
    NSLog(@"%@", fetchedMovies);
    
    return fetchedMovies;
}

-(BOOL)isMovieFav:(SKYMovie *) movie {
    if([self getFavMovie: movie])
        return true;
    else
        return false;
}

-(NSManagedObject *)getFavMovie:(SKYMovie *) movie{
    NSFetchRequest *favMovieRequest = [self createFavMovieRequest];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"iTunesID = %@", movie.movieId];
    [favMovieRequest setPredicate: pred];
    
    NSError *error;
    NSArray *fetchedMovies = [_context executeFetchRequest: favMovieRequest error: &error];

    if([fetchedMovies count] > 0)
        return [fetchedMovies objectAtIndex: 0];
    else
        return nil;
    
}

-(NSFetchRequest *)createFavMovieRequest {
    NSEntityDescription *movieDescription = [NSEntityDescription entityForName:@"FavMovie" inManagedObjectContext:_context];
    NSFetchRequest *favMovieRequest = [[NSFetchRequest alloc] init];
    [favMovieRequest setEntity:movieDescription];

    return favMovieRequest;
}
@end
