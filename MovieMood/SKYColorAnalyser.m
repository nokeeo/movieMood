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
-(NSArray *) xyzToLabWithX:(float) x withY:(float) y withZ:(float) z;
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
    NSLog(@"%@", [self xyzToLabWithX:.7 withY:.3 withZ:.9]);
    //NSLog(@"%@", [self rgbToXyzWithRed:red withGreen:green withBlue:blue]);
    return nil;
}

-(NSArray *) rgbToXyzWithRed:(float)red withGreen:(float)green withBlue:(float)blue {
    if (red > 0.04045)
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

-(NSArray *) xyzToLabWithX:(float)x withY:(float)y withZ:(float)z {
    x = x / 95.047;
    y = y / 100.0;
    z = z / 108.883;
    
    if (x > 0.008856)
        x = pow(x, (1/3.f));
    else
        x = (7.787 * x ) + (16 / 116.f);
        
    if (y > 0.008856)
        y = pow(y, (1/3.f));
    else
        y = (7.787 * y) + (16 / 116.f);
        
    if (z > 0.008856)
        z = pow(z, (1/3.f));
    else
        z = (7.787 * z) + (16 / 116.f);
    
    float l = (116 * y) - 16;
    float a = 500 * (x - y);
    float b = 200 * (y - z);
    
    return [NSArray arrayWithObjects: [NSNumber numberWithFloat:l], [NSNumber numberWithFloat:a], [NSNumber numberWithFloat:b], nil];
}
@end
