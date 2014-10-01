//
//  ELStoreController.m
//  MovieMood
//
//  Created by Eric Lee on 9/21/14.
//  Copyright (c) 2014 Eric Lee Productions. All rights reserved.
//

#import "ELStoreController.h"

const NSString *AFFILIATE_KEY = @"11lu3P";

@interface ELStoreController()

@property (nonatomic, strong) SKStoreProductViewController *appStoreVC;
@property (nonatomic, weak) UIViewController *parentVC;

@end

@implementation ELStoreController

-(id) initWithVC: (UIViewController *) parentViewController {
    self = [super init];
    if(self) {
        _parentVC = parentViewController;
    }
    
    return self;
}

-(void) openStoreWithEntity: (ELMediaEntity *) movie {
    if(&SKStoreProductParameterAffiliateToken) {
        _appStoreVC = [[SKStoreProductViewController alloc] init];
        [_appStoreVC setDelegate: self];
        [_appStoreVC loadProductWithParameters:@{ SKStoreProductParameterITunesItemIdentifier : movie.entityID,
                                                  SKStoreProductParameterAffiliateToken : AFFILIATE_KEY
                                                 }
                               completionBlock:^(BOOL result, NSError *error) {
                                   if(error) {
                                        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Uh-oh!" message:@"There was an error loading the App Store. Please try again later" delegate: nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                        [errorAlert show];
                                   }
                                   else {
                                        [_parentVC presentViewController: _appStoreVC animated:YES completion:nil];
                                   }
        }];
    }
    else {
        NSString *iTunesURL = [[NSString alloc] initWithFormat:@"%@&at=%@", movie.storeURL, AFFILIATE_KEY ];
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: iTunesURL]];
    }
}

-(void) productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [_appStoreVC dismissViewControllerAnimated: YES completion: nil];
}

@end
