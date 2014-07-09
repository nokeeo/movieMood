//
//  ELTVShowMediaEntity.m
//  MovieMood
//
//  Created by Eric Lee on 7/6/14.
//  Copyright (c) 2014 Eric Lee Productions. All rights reserved.
//

#import "ELTVShowMediaEntity.h"

@implementation ELTVShowMediaEntity

-(id) initWithEntry:(id)entry {
    self = [super initWithEntry: entry];
    self.storeURL = [[[entry objectForKey:@"link"] objectForKey: @"attributes"] objectForKey: @"href"];
    
    return self;
}

@end
