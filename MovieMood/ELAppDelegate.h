//
//  SKYAppDelegate.h
//  MovieMood
//
//  Created by Eric Lee on 1/29/14.
//  Copyright (c) 2014 Eric Lee Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ELAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) NSDictionary *movieIdsForGenre;
@property (nonatomic, strong) NSDictionary *movieDescriptionsForId;

@property (nonatomic, strong) NSDictionary *tvShowIdsForGenre;
@property (nonatomic, strong) NSDictionary *tvShowDescriptionForId;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
