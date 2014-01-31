//
//  SKYColorAnalyser.m
//  MovieMood
//
//  Created by Eric Lee on 1/30/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import "SKYColorAnalyser.h"
@interface SKYColorAnalyser()
@property (nonatomic, retain) NSDictionary* genreIds;

-(NSArray *) rgbToXyzWithRed:(float) red withGreen:(float) green withBlue: (float) blue;
@end

@implementation SKYColorAnalyser

@synthesize genreIds = _genreIds;

-(id) init {
    self = [super init];
    if (self)
    {
        NSArray *ids = [NSArray arrayWithObjects:@"28", @"12", @"16", @"35", @"80", @"105", @"99", @"18", @"82", @"2916", @"10751", @"10750", @"14", @"10753", @"10769", @"36", @"10595", @"27", @"10756", @"10402", @"22", @"9648", @"10754", @"1115", @"10749", @"878", @"10755", @"9805", @"10758", @"10757", @"10748", @"10770", @"53", @"10752", @"37", nil];
        NSArray *genres = [NSArray arrayWithObjects:@"Action", @"Adventure", @"Animation", @"Comedy", @"Crime", @"Disaster", @"Documentary", @"Drama", @"Eastern", @"Erotic", @"Family", @"Fan Film", @"Fantasy", @"Film Noir", @"Foreign", @"History", @"Holiday", @"Horror", @"Indie", @"Music", @"Musical", @"Mystery", @"Neo-noir", @"Road Movie", @"Romance", @"Science Fiction", @"Short", @"Sport", @"Sporting Event", @"Sports Film", @"Suspense", @"TV movie", @"Thriller", @"War", @"Western", nil];
        
        _genreIds = [NSDictionary dictionaryWithObjects:ids forKeys:genres];
    }
    return self;
}

-(NSDictionary *) analyzeColor:(UIColor *)color {
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    [color getRed:&red green:&green blue:&blue alpha:0];
    NSLog(@"%@", [self rgbToXyzWithRed:10/255.f withGreen:40 / 255.f withBlue:190 / 255.f]);
    //NSLog(@"%@", [self rgbToXyzWithRed:red withGreen:green withBlue:blue]);
    return nil;
}

-(NSArray *) rgbToXyzWithRed:(float)red withGreen:(float)green withBlue:(float)blue {
    if ( red > 0.04045 )
        red = pow((red + 0.055) / 1.055, 2.4);
    else
        red = red / 12.92;
    
    if(green > 0.04045)
        green = pow(((green + 0.055) / 1.055), 2.4);
    else
        green = green / 12.92;
    
    if(blue > 0.04045)
        blue = pow(((blue + 0.055) / 1.055), 2.4);
    else
        blue = blue / 12.92;
    
    red *= 100;
    blue *= 100;
    green *= 100;
    
    float x = red * 0.4124 + green * 0.3576 + blue * 0.1805;
    float y = red * 0.2126 + green * 0.7152 + blue * 0.0722;
    float z = red * 0.0193 + green * 0.1192 + blue * 0.9505;
    
    return [NSArray arrayWithObjects:[NSNumber numberWithFloat:x], [NSNumber numberWithFloat:y], [NSNumber numberWithFloat:z], nil];
}

@end
