//
//  SKYDataManager.m
//  MovieMood
//
//  Created by Eric Lee on 5/3/14.
//  Copyright (c) 2014 Eric Lee Productions. All rights reserved.
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
    return [self saveMovieItem: movie withRequest: favMovieRequest];
}

-(NSError *) doNotShowMovie: (ELMediaEntity *) movie {
    NSFetchRequest *doNotShowRequest = [self createDoNotShowMovieRequest];
    NSError *error = [self saveMovieItem: movie withRequest:doNotShowRequest];
    
    return error;
}

-(NSError *)deleteMovie:(ELMediaEntity *) movie {
    NSManagedObject *movieObject = [self getFavMovie: movie];
    return [self deleteManagedItem: movieObject];
}

-(NSError *) doShowMovie: (ELMediaEntity *) movie {
    NSManagedObject *movieObject = [self getDoNotShowMovie: movie];
    return [self deleteManagedItem: movieObject];
}

-(NSArray *)getFavMovies {
    NSFetchRequest *favMovieRequest = [self createFavMovieRequest];
    
    NSError *error;
    NSArray *fetchedMovies = [_context executeFetchRequest: favMovieRequest error: &error];
    
    return fetchedMovies;
}

-(NSArray *) getDoNotShowMovies {
    NSFetchRequest *doNotShowMovies = [self createDoNotShowMovieRequest];
    
    NSError *error;
    NSArray *fetchedMovies = [_context executeFetchRequest: doNotShowMovies error: &error];
    
    return fetchedMovies;
}

-(BOOL)isMovieFav:(ELMediaEntity *) movie {
    if([self getFavMovie: movie])
        return YES;
    return NO;
}

-(BOOL) canShowMovie: (ELMediaEntity *) movie {
    if([self getDoNotShowMovie: movie])
        return NO;
    return YES;
}

-(NSManagedObject *) getDoNotShowMovie: (ELMediaEntity *) movie {
    NSFetchRequest *request = [self createDoNotShowMovieRequest];
    return [self getMovieItem: movie withRequest: request];
}

-(NSManagedObject *)getFavMovie:(ELMediaEntity *) movie{
    NSFetchRequest *favMovieRequest = [self createFavMovieRequest];
    return [self getMovieItem: movie withRequest: favMovieRequest];
}

#pragma mark - Helper functions

-(NSError *) deleteManagedItem: (NSManagedObject *) item {
    NSError *error;
    if(item) {
        [_context deleteObject: item];
        [_context save: &error];
    }
    return error;
}

-(NSError *) saveMovieItem: (ELMediaEntity *) movie withRequest: (NSFetchRequest *) request {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"iTunesID = %@", movie.entityID];
    [request setPredicate: pred];
    
    NSError *error;
    NSArray *fetchedMovies = [_context executeFetchRequest: request error: &error];
    
    if(error)
        return error;
    
    else if([fetchedMovies count] == 0) {
        NSManagedObject *newMovie = [NSEntityDescription insertNewObjectForEntityForName:@"FavMovie" inManagedObjectContext:_context];
        [newMovie setValue: movie.entityID forKeyPath:@"iTunesID"];
        
        [_context save: &error];
    }
    
    return error;
}

-(NSManagedObject *) getMovieItem:(ELMediaEntity *) movie withRequest: (NSFetchRequest *) request {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"iTunesID = %@", movie.entityID];
    [request setPredicate: pred];
    
    NSError *error;
    NSArray *fetchedMovies = [_context executeFetchRequest: request error: &error];
    
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

-(NSFetchRequest *) createDoNotShowMovieRequest {
    NSEntityDescription *movieDescription = [NSEntityDescription entityForName: @"DoNotShowMovie" inManagedObjectContext:_context];
    NSFetchRequest *doNotShowMovieRequest = [[NSFetchRequest alloc] init];
    [doNotShowMovieRequest setEntity: movieDescription];
    
    return doNotShowMovieRequest;
}
@end
