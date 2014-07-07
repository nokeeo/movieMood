//
//  SKYDataManager.m
//  MovieMood
//
//  Created by Eric Lee on 5/3/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import "ELDataManager.h"
#import "ELAppDelegate.h"

@interface ELDataManager()
@property (nonatomic, retain) NSManagedObjectContext *context;
@end

@implementation ELDataManager

@synthesize context = _context;

-(id)init {
    self = [super init];
    
    if(self) {
        ELAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        _context = [delegate managedObjectContext];
    }
    
    return self;
}

-(NSError *)saveMovie:(ELMediaEntity *)movie {
    
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

-(NSError *)deleteMovie:(ELMediaEntity *) movie {
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
    
    return fetchedMovies;
}

-(BOOL)isMovieFav:(ELMediaEntity *) movie {
    if([self getFavMovie: movie])
        return true;
    else
        return false;
}

-(NSManagedObject *)getFavMovie:(ELMediaEntity *) movie{
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
