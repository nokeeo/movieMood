//
//  SKYColorAnalyser.h
//  MovieMood
//
//  Created by Eric Lee on 1/30/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKYColorAnalyser : NSObject
- (NSDictionary *) analyzeColor:(UIColor *) color;
-(UIColor *) calculateComplementaryWithColor:(UIColor *) originalColor;
-(UIColor *) tintColor:(UIColor *) originalColor withTintConst:(float) tintConst;
@end
