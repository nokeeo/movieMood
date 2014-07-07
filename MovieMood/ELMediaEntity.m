//
//  SKYMovie.m
//  MovieMood
//
//  Created by Eric Lee on 2/13/14.
//  Copyright (c) 2014 Eric Lee Productions. All rights reserved.
//

#import "ELMediaEntity.h"
#import "ELMovieRequests.h"

const NSString *AFFILIATE_KEY = @"11lu3P";

@implementation ELMediaEntity

-(id) initWithEntry:(id)entry {
    self = [super init];
    
    //General init
    self.entityID = [[[entry objectForKey:@"id"] objectForKey:@"attributes"] objectForKey:@"im:id"];
    self.title = [[entry objectForKey:@"im:name"] objectForKey:@"label"];
    self.purchasePrice = [[entry objectForKey:@"im:price"] objectForKey:@"label"];
    self.genre = [[[entry objectForKey:@"category"] objectForKey:@"attributes"] objectForKey:@"label"];
    self.releaseDate = [[[entry objectForKey:@"im:releaseDate"] objectForKey:@"attributes"] objectForKey:@"label"];
    
    //Get URls
    id links = [entry objectForKey:@"link"];
    for(id link in links) {
        if([[[link objectForKey:@"attributes"] objectForKey:@"type"] isEqualToString:@"text/html"])
            self.storeURL = [[NSString alloc] initWithFormat:@"%@&at=%@", [[link objectForKey:@"attributes"] objectForKey:@"href"], AFFILIATE_KEY ];
    }

    //Get the images
    id imageList = [entry objectForKey:@"im:image"];
    for(id image in imageList) {
        id imageHeight = [[image objectForKey:@"attributes"] objectForKey:@"height"];
        if([imageHeight isEqualToString:@"60"]) {
            self.coverImage60 = [image objectForKey:@"label"];
        }
        else if([imageHeight isEqualToString:@"170"])
            self.coverImage170 = [image objectForKey:@"label"];
    }
    
    return self;
}

-(id) initWithLookupData:(id)entry {
    self = [super init];
    
    return self;
}

@end
