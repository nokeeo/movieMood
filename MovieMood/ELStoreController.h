//
//  ELStoreController.h
//  MovieMood
//
//  Created by Eric Lee on 9/21/14.
//  Copyright (c) 2014 Eric Lee Productions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "ELMovieMediaEntity.h"

@interface ELStoreController : NSObject <SKStoreProductViewControllerDelegate>

-(id) initWithVC: (UIViewController *) parentViewController;
-(void) openStoreWithEntity: (ELMediaEntity *) movie;

@end
