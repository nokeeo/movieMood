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
-(float) calcColorDifferenceWithColor:(UIColor *) color1 withColor:(UIColor *) color2;
@end

@implementation SKYColorAnalyser

@synthesize genreIds = _genreIds;

-(id) init {
    self = [super init];
    if (self)
    {
        NSArray *ids = [NSArray arrayWithObjects:@"28", @"12", @"16", @"35", @"80", @"105", @"99", @"18", @"14", @"10753", @"10769", @"36", @"27", @"10756", @"9648", @"10754", @"1115", @"10749", @"878", @"9805", @"53", @"10752", @"37", nil];
        NSArray *genres = [NSArray arrayWithObjects:@"Action", @"Adventure", @"Animation", @"Comedy", @"Crime", @"Disaster", @"Documentary", @"Drama", @"Fantasy", @"Film Noir", @"Foreign", @"History", @"Horror", @"Indie", @"Mystery", @"Neo-noir", @"Road Movie", @"Romance", @"Science Fiction", @"Suspense", @"Thriller", @"War", @"Western", nil];
        
        _genreIds = [NSDictionary dictionaryWithObjects:ids forKeys:genres];
    }
    return self;
}

-(NSDictionary *) analyzeColor:(UIColor *)color {
    UIColor *color1 = [UIColor colorWithRed:255/255.f green:0/255.f blue:0/255.f alpha:1.0];
    UIColor *color2 = [UIColor colorWithRed:0/255.f green:255/255.f blue:0/255.f alpha:1.0];
    
    NSLog(@"%f", [self calcColorDifferenceWithColor:color1 withColor:color2]);
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

-(float) calcColorDifferenceWithColor:(UIColor *) color1 withColor:(UIColor *) color2 {
    
    CGFloat red1;
    CGFloat green1;
    CGFloat blue1;
    
    CGFloat red2;
    CGFloat green2;
    CGFloat blue2;
    
    [color1 getRed: &red1 green: &green1 blue: &blue1 alpha: nil];
    [color2 getRed: &red2 green: &green2 blue: &blue2 alpha: nil];
    
    NSArray *xyz1 = [self rgbToXyzWithRed: red1 withGreen: green1 withBlue: blue1];
    NSArray *xyz2 = [self rgbToXyzWithRed: red2 withGreen: green2 withBlue: blue2];
    
    NSArray *lab1 = [self xyzToLabWithX: [[xyz1 objectAtIndex: 0] floatValue] withY: [[xyz1 objectAtIndex: 1] floatValue] withZ: [[xyz1 objectAtIndex: 2] floatValue]];
    NSArray *lab2 = [self xyzToLabWithX: [[xyz2 objectAtIndex: 0] floatValue] withY: [[xyz2 objectAtIndex: 1] floatValue] withZ: [[xyz2 objectAtIndex: 2] floatValue]];
    
    float lCalc = pow([[lab2 objectAtIndex: 0] floatValue] - [[lab1 objectAtIndex: 0] floatValue], 2);
    float aCalc = pow([[lab2 objectAtIndex: 1] floatValue] - [[lab1 objectAtIndex: 1] floatValue], 2);
    float bCalc = pow([[lab2 objectAtIndex: 2] floatValue] - [[lab1 objectAtIndex: 2] floatValue], 2);
    
    float deltaE = sqrt(lCalc + aCalc + bCalc);
    
    return deltaE;
}
@end
