//
//  ELMovieMediaEntity.m
//  MovieMood
//
//  Created by Eric Lee on 7/6/14.
//  Copyright (c) 2014 Eric Lee Productions. All rights reserved.
//

#import "ELMovieMediaEntity.h"

@implementation ELMovieMediaEntity

-(id)initWithEntry:(id)entry {
    self = [super init];
    if(self) {
        self.entityID = [[[entry objectForKey:@"id"] objectForKey:@"attributes"] objectForKey:@"im:id"];
        self.title = [[entry objectForKey:@"im:name"] objectForKey:@"label"];
        self.purchasePrice = [[entry objectForKey:@"im:price"] objectForKey:@"label"];
        self.rentalPrice = [[entry objectForKey:@"im:rentalPrice"] objectForKey:@"label"];
        self.description = [[entry objectForKey:@"summary"] objectForKey:@"label"];
        self.genre = [[[entry objectForKey:@"category"] objectForKey:@"attributes"] objectForKey:@"label"];
        self.director = [[entry objectForKey:@"im:artist"] objectForKey:@"label"];
        self.releaseDate = [[[entry objectForKey:@"im:releaseDate"] objectForKey:@"attributes"] objectForKey:@"label"];
        
        //Get URls
        id links = [entry objectForKey:@"link"];
        for(id link in links) {
            if([[[link objectForKey:@"attributes"] objectForKey:@"type"] isEqualToString:@"text/html"])
                self.storeURL = [[NSString alloc] initWithFormat:@"%@&at=%@", [[link objectForKey:@"attributes"] objectForKey:@"href"], AFFILIATE_KEY ];
            else if([[[link objectForKey:@"attributes"] objectForKey:@"type"] isEqualToString:@"video/x-m4v"])
                self.trailerURL = [[link objectForKey:@"attributes"] objectForKey:@"href"];
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
    }
    return self;
}

-(id)initWithLookupData: (id) entry {
    self = [super init];
    if(self) {
        self.entityID = [[NSString alloc] initWithFormat:@"%@", [entry objectForKey: @"trackId"]];
        self.title = [entry objectForKey: @"trackName"];
        
        if([entry objectForKey: @"trackHdPrice"])
            self.purchasePrice = [[NSString alloc] initWithFormat:@"%@%@", @"$", [entry objectForKey: @"trackHdPrice"] ];
        else if([entry objectForKey: @"trackPrice"] != nil)
            self.purchasePrice = [[NSString alloc] initWithFormat:@"%@%@", @"$", [entry objectForKey: @"trackPrice"]];
        else
            self.purchasePrice = @"Not Available";
        
        if([entry objectForKey: @"trackHdRentalPrice"] != nil)
            self.rentalPrice = [[NSString alloc] initWithFormat: @"%@%@", @"$", [entry objectForKey: @"trackHdRentalPrice"]];
        else if([entry objectForKey: @"trackRentalPrice"] != nil)
            self.rentalPrice = [[NSString alloc] initWithFormat:@"%@%@", @"$", [entry objectForKey: @"trackRentalPrice"]];
        else
            self.rentalPrice = @"Not available";
        
        self.description = [entry objectForKey: @"longDescription"];
        self.genre = [entry objectForKey: @"primaryGenreName"];
        self.director = [entry objectForKey: @"artistName"];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat: @"yyyy-MM-dd"];
        if([[entry objectForKey:@"releaseDate"] length] >= 10) {
            NSString *dateString = [[entry objectForKey:@"releaseDate"] substringToIndex: 10];
            NSDate *releaseDate = [formatter dateFromString: dateString];
            [formatter setDateFormat:@"MMMM dd, yyyy"];
            self.releaseDate = [formatter stringFromDate:releaseDate];
        }
        else {
            self.releaseDate = [entry objectForKey:@"releaseDate"];
        }
        
        
        self.storeURL = [[NSString alloc] initWithFormat:@"%@&at=%@", [entry objectForKey: @"trackViewUrl"], AFFILIATE_KEY ];
        self.trailerURL = [entry objectForKey:@"previewUrl"];
        self.coverImage170 = [entry objectForKey: @"artworkUrl100"];
        self.coverImage60 = [entry objectForKey: @"artworkUrl60"];
        self.rating = [entry objectForKey: @"contentAdvisoryRating"];
    }
    return self;
}

@end
