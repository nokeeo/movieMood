//
//  SKYColorAnalyser.m
//  MovieMood
//
//  Created by Eric Lee on 1/30/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//
#import <math.h>
#import "SKYColorAnalyser.h"
@interface SKYColorAnalyser()
@property (nonatomic, retain) NSDictionary *genreIds;
@property (nonatomic, retain) NSDictionary *descriptionIds;

-(NSArray *) rgbToXyzWithRed:(float) red withGreen:(float) green withBlue: (float) blue;
-(NSArray *) xyzToLabWithX:(float) x withY:(float) y withZ:(float) z;
-(float) calcColorDifferenceWithColor:(UIColor *) color1 withColor:(UIColor *) color2;
-(UIColor *) getColorWithGenre:(NSString *) genre;
-(NSDictionary *) getGenreColorDifferenceWithColor:(UIColor *) compareColor;
-(NSDictionary *) getRelatedGenresWithColorDiffs: (NSDictionary *) colorDiffs;
-(NSDictionary *) calcDisplayProportions:(NSDictionary *) genreDiffs;

@end

@implementation SKYColorAnalyser

@synthesize genreIds = _genreIds;
@synthesize descriptionIds = _descriptionIds;

-(id) init {
    self = [super init];
    if (self)
    {
        NSArray *ids = [[NSArray alloc] initWithObjects:@"4401", @"4404", @"4405", @"4406", @"4407", @"4408", @"4409", @"4410", @"4412", @"4413", @"4416", @"4418", nil];
        NSArray *genres = [NSArray arrayWithObjects: @"Action/Adventure", @"Comedy", @"Documentary", @"Drama", @"Foreign", @"Horror", @"Independent", @"Kids & Family", @"Romance",@"Sci-Fi & Fantasy", @"Thriller", @"Western", nil];
        
        NSArray *descriptions = [NSArray arrayWithObjects: @"Aggressive, Violent, Heated", @"Happy, Funny, Carefree", @"Thought-Provoking, Serious", @"Thought-Provoking, Serious", @"Eclectic, Eccentric", @"Aggressive, Violent, Heated", @"Eclectic, Eccentric", @"Fresh, Kid-Friendly", @"", @"Mysterious, Wondrous", @"Aggressive, Violent, Heated", @"Energetic, Exciting", nil];
        
        _genreIds = [NSDictionary dictionaryWithObjects:ids forKeys:genres];
        _descriptionIds = [NSDictionary dictionaryWithObjects: descriptions forKeys: ids];
    }
    return self;
}

/*---------------------------------------------------------------------------
* Generates the genres and proportions associated with genre.
* Returns dictionary with genre id as the key and the values as the proportions.
 ---------------------------------------------------------------------------*/
-(NSDictionary *) analyzeColor:(UIColor *)color {
    NSDictionary *genreDiff = [self getGenreColorDifferenceWithColor:color];
    
    NSDictionary *relatedGenres = [self getRelatedGenresWithColorDiffs:genreDiff];
    
    NSArray *sortedKeys = [relatedGenres keysSortedByValueUsingComparator: ^(id obj1, id obj2) {
        NSNumber *num1 = (NSNumber *)obj1;
        NSNumber *num2 = (NSNumber *)obj2;
        return (NSComparisonResult)[num1 compare: num2];
    }];
    
    NSMutableDictionary *bestFitGenres = [[NSMutableDictionary alloc] init];
    for(int i = 0; (i < [sortedKeys count] && i < 3); i++) {
        [bestFitGenres setObject:[relatedGenres objectForKey:[sortedKeys objectAtIndex:i]] forKey: [sortedKeys objectAtIndex:i]];
    }
    
    NSDictionary *displayProps = [self calcDisplayProportions:bestFitGenres];
    NSMutableDictionary *returnProps = [[NSMutableDictionary alloc] init];
    for(id genreName in displayProps) {
        [returnProps setObject:[displayProps objectForKey:genreName] forKey:[_genreIds objectForKey:genreName]];
    }
    return returnProps;
}

/*---------------------------------------------------------------------------
 * Returns the text desription of the color given
 ---------------------------------------------------------------------------*/
-(NSString *) descriptionForColor: (UIColor *) color {
    NSDictionary *closeColors = [self analyzeColor: color];
    
    NSString *closestGenreCode;
    CGFloat highestVal = -1;
    
    for(NSString *genreCode in closeColors) {
        CGFloat value = [[closeColors valueForKey: genreCode] floatValue];
        if(value > highestVal) {
            closestGenreCode = genreCode;
            highestVal = value;
        }
    }
    return [_descriptionIds objectForKey: closestGenreCode];
}

#pragma mark - Private Methods

/*---------------------------------------------------------------------------
* Calculates the xyz color values from rgb color values
* Returns array with x, y, z values respectively
 ---------------------------------------------------------------------------*/
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

/*---------------------------------------------------------------------------
 * Calculates the CEI lab color values from xyz color values
 * Returns array with l, a, b values respectively
 ---------------------------------------------------------------------------*/
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

/*---------------------------------------------------------------------------
* Calculates the color difference value using the CEI76.
* This is not the most favorable formula, however it is suficiant for this
* project.
* Returns the difference between the colors as a float value.
 ---------------------------------------------------------------------------*/
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

/*---------------------------------------------------------------------------
* Gets the UIColor associated with a genre.
 ---------------------------------------------------------------------------*/
-(UIColor *) getColorWithGenre:(NSString *)genre {
    UIColor *returnColor = nil;
    if([genre isEqualToString:@"Thriller"])
        returnColor = [UIColor colorWithRed:255/255.f green:0/255.f blue:0.f alpha:1.f];
    else if([genre isEqualToString:@"Action/Adventure"] || [genre isEqualToString:@"Western"])
        returnColor = [UIColor colorWithRed:255/255.f green:174/255.f blue:0.f alpha:1.f];
    else if([genre isEqualToString:@"Animation"] || [genre isEqualToString:@"Anime"])
        returnColor = [UIColor colorWithRed:162/225.f green:255/255.f blue:0/255.f alpha:1.f];
    else if([genre isEqualToString:@"Comedy"])
        returnColor = [UIColor colorWithRed:255/255.f green:255.f blue:0.f alpha:1.f];
    else if([genre isEqualToString:@"Documentary"])
        returnColor = [UIColor colorWithRed:0.f green:0.f blue:1.f alpha:1.f];
    else if([genre isEqualToString: @"Drama"])
        returnColor = [UIColor colorWithRed:0.f green:123/255.f blue:1.f alpha:1.f];
    else if([genre isEqualToString:@"Kids & Family"])
        returnColor = [UIColor colorWithRed:0.f green:1.f blue:0.f alpha:1.f];
    else if([genre isEqualToString:@"Sci-Fi & Fantasy"])
        returnColor = [UIColor colorWithRed:1.f green:0.f blue:1.f alpha:1.f];
    else if([genre isEqualToString:@"Foreign"])
        returnColor = [UIColor colorWithRed:0.f green:1.f blue:1.f alpha:1.f];
    else if([genre isEqualToString:@"Horror"])
        returnColor = [UIColor colorWithRed:255.f green:0.f blue:127/255.f alpha:1.f];
    else if([genre isEqualToString:@"Independent"])
        returnColor = [UIColor colorWithRed:0.f green:127/255.f blue:1.f alpha:1.f];
    
    return returnColor;
}

/*---------------------------------------------------------------------------
* Gets a dictionary of color differences for all genres.
* Returns a dictionary where the key is the genre and value is the 
* difference between the the genre's color and the given color
 ---------------------------------------------------------------------------*/
-(NSDictionary *) getGenreColorDifferenceWithColor:(UIColor *)compareColor {
    NSMutableDictionary *returnDictionary = [[NSMutableDictionary alloc] init];
    for(id genre in _genreIds) {
        UIColor *genreColor = [self getColorWithGenre: genre];
        NSNumber *difference = [NSNumber numberWithFloat: [self calcColorDifferenceWithColor: genreColor withColor: compareColor]];
        
        [returnDictionary setObject:difference forKey: genre];
    }
    
    return returnDictionary;
}

/*---------------------------------------------------------------------------
* Gets the closely related genre(s) based on the given color
* Returns a dictionary with the key as the genre and the value as the 
* difference
 ---------------------------------------------------------------------------*/
-(NSDictionary *) getRelatedGenresWithColorDiffs:(NSDictionary *)colorDiffs {
    NSMutableDictionary *relatedGenres = [[NSMutableDictionary alloc] init];
    for(id key in colorDiffs) {
        NSNumber *currentDiff = [colorDiffs objectForKey:key];
        if([currentDiff floatValue] <= 50.0)
            [relatedGenres setObject:currentDiff forKey:key];
    }
    
    //If no values are in the 50 range find the closest value
    if([[relatedGenres allKeys] count] == 0) {
        NSString *closestKey;
        NSNumber *closestValue = [NSNumber numberWithFloat:1000.f];
        
        for(id key in colorDiffs) {
            NSNumber *currentDiff = [colorDiffs objectForKey: key];
            if([currentDiff floatValue] < [closestValue floatValue]) {
                closestKey = key;
                closestValue = currentDiff;
            }
            else if([currentDiff floatValue] == [closestValue floatValue]) {
                if(arc4random() % 2) {
                    closestKey = key;
                    closestValue = currentDiff;
                }
            }
        }
        [relatedGenres setObject:closestValue forKey:closestKey];
    }
    return relatedGenres;
}

/*---------------------------------------------------------------------------
* Calcualtes the proportions for each genre as the movies should appear
* in a search result
* Returns a dictionary where the key is the genre and proportions as values.
 ---------------------------------------------------------------------------*/
-(NSDictionary *) calcDisplayProportions:(NSDictionary *) genreDiffs {
    NSMutableDictionary *inverseProportions = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *finalProportions = [[NSMutableDictionary alloc] init];
    float diffSum = 0.f;
    for(id genre in genreDiffs) {
        diffSum += [[genreDiffs objectForKey:genre] floatValue] + 1;
    }
    
    for(id genre in genreDiffs) {
        float currentValue = [[genreDiffs objectForKey:genre] floatValue] + 1;
        float prop = 1 / (currentValue / diffSum);
        
        [inverseProportions setObject:[NSNumber numberWithFloat:prop] forKey:genre];
    }
    
    diffSum = 0.f;
    for(id genre in inverseProportions) {
        diffSum += [[inverseProportions objectForKey:genre] floatValue];
    }
    
    for(id genre in inverseProportions) {
        float currentValue = [[inverseProportions objectForKey:genre] floatValue];
        float prop = (currentValue / diffSum);
        
        [finalProportions setObject:[NSNumber numberWithFloat:prop] forKey:genre];
    }
    return finalProportions;
}

/*---------------------------------------------------------------------------
* Calculates the complimentary color of given color
 ---------------------------------------------------------------------------*/
-(UIColor *) calculateComplementaryWithColor:(UIColor *)originalColor {
    CGFloat hue;
    CGFloat saturation;
    CGFloat brightness;
    
    [originalColor getHue:&hue saturation:&saturation brightness:&brightness alpha: nil];
    
    float degreeValue = 360 * hue;
    degreeValue += 215;
    degreeValue = fmod(degreeValue, 360);
    
    return [UIColor colorWithHue:degreeValue / 360 saturation:saturation brightness:brightness - .3 alpha:1.f];
}

/*---------------------------------------------------------------------------
* Makes the given color lighter or darker based on the tint const
 ---------------------------------------------------------------------------*/
-(UIColor *) tintColor:(UIColor *)originalColor withTintConst:(float) tintConst{
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    
    [originalColor getRed:&red green:&green blue:&blue alpha:nil];
    
    return [UIColor colorWithRed:red + tintConst green:green + tintConst blue:blue + tintConst alpha:1.f];
}
@end
