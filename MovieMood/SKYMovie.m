//
//  SKYMovie.m
//  MovieMood
//
//  Created by Eric Lee on 2/13/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import "SKYMovie.h"

@implementation SKYMovie

-(id)initWithEntry:(id)entry {
    self = [super init];
    if(self) {
        _movieId = [[[entry objectForKey:@"id"] objectForKey:@"attributes"] objectForKey:@"im:id"];
        _title = [[entry objectForKey:@"im:name"] objectForKey:@"label"];
        _purchasePrice = [[entry objectForKey:@"im:price"] objectForKey:@"label"];
        _rentalPrice = [[entry objectForKey:@"im:rentalPrice"] objectForKey:@"label"];
        _description = [[entry objectForKey:@"summary"] objectForKey:@"label"];
        
        //Get URls
        id links = [entry objectForKey:@"link"];
        for(id link in links) {
            if([[[link objectForKey:@"attributes"] objectForKey:@"type"] isEqualToString:@"text/html"])
                _storeURL = [[link objectForKey:@"attributes"] objectForKey:@"href"];
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
@end
