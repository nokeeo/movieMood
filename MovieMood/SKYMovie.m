//
//  SKYMovie.m
//  MovieMood
//
//  Created by Eric Lee on 2/13/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import "SKYMovie.h"
#import "SKYMovieRequests.h"

const NSString *AFFILIATE_KEY = @"11lu3P";

@implementation SKYMovie

-(id)initWithEntry:(id)entry {
    self = [super init];
    if(self) {
        _movieId = [[[entry objectForKey:@"id"] objectForKey:@"attributes"] objectForKey:@"im:id"];
        _title = [[entry objectForKey:@"im:name"] objectForKey:@"label"];
        _purchasePrice = [[entry objectForKey:@"im:price"] objectForKey:@"label"];
        _rentalPrice = [[entry objectForKey:@"im:rentalPrice"] objectForKey:@"label"];
        _description = [[entry objectForKey:@"summary"] objectForKey:@"label"];
        _genre = [[[entry objectForKey:@"category"] objectForKey:@"attributes"] objectForKey:@"label"];
        _director = [[entry objectForKey:@"im:artist"] objectForKey:@"label"];
        _releaseDate = [[[entry objectForKey:@"im:releaseDate"] objectForKey:@"attributes"] objectForKey:@"label"];
        
        //Get URls
        id links = [entry objectForKey:@"link"];
        for(id link in links) {
            if([[[link objectForKey:@"attributes"] objectForKey:@"type"] isEqualToString:@"text/html"])
                _storeURL = [[NSString alloc] initWithFormat:@"%@&at=%@", [[link objectForKey:@"attributes"] objectForKey:@"href"], AFFILIATE_KEY ];
            else if([[[link objectForKey:@"attributes"] objectForKey:@"type"] isEqualToString:@"video/x-m4v"])
                _trailerURL = [[link objectForKey:@"attributes"] objectForKey:@"href"];
        }
        
        //Get the images
        id imageList = [entry objectForKey:@"im:image"];
        for(id image in imageList) {
            id imageHeight = [[image objectForKey:@"attributes"] objectForKey:@"height"];
            if([imageHeight isEqualToString:@"60"]) {
                _coverImage60 = [image objectForKey:@"label"];
            }
            else if([imageHeight isEqualToString:@"170"])
                _coverImage170 = [image objectForKey:@"label"];
        }
    }
    return self;
}

-(id)initWithLookupData: (id) entry {
    self = [super init];
    if(self) {
        _movieId = [entry objectForKey: @"trackId"];
        _title = [entry objectForKey: @"trackName"];
        
        _purchasePrice = [entry objectForKey: @"trackHdPrice"];
        if([_purchasePrice isEqual: @""])
            _purchasePrice = [entry objectForKey: @"trackPrice"];
        
        _rentalPrice = [entry objectForKey: @"trackHdRentalPrice"];
        if([_rentalPrice isEqual:@""])
            _rentalPrice = [entry objectForKey: @"trackRentalPrice"];
        
        _description = [entry objectForKey: @"longDescription"];
        _genre = [entry objectForKey: @"primaryGenreName"];
        _director = [entry objectForKey: @"artistName"];
        _releaseDate = [entry objectForKey: @"releaseDate"];
        _storeURL = [[NSString alloc] initWithFormat:@"%@&at=%@", [entry objectForKey: @"trackViewUrl"], AFFILIATE_KEY ];
        _trailerURL = [entry objectForKey:@"previewUrl"];
        _coverImage170 = [entry objectForKey: @"artworkUrl100"];
        _coverImage60 = [entry objectForKey: @"artworkUrl60"];
        _rating = [entry objectForKey: @"contentAdvisoryRating"];
    }
    return self;
}
@end
