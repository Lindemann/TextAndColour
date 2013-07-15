//
//  AppDelegate.h
//  Text&Colour
//
//  Created by Judith Lindemann on 08.06.12.
//  Copyright (c) 2012 LINDEMANN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Settings.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


// Returns 0 if no SearchDisplayController in the ViewController Hierarchy is active
// Returns number > 0 when a SearchDisplayController is active some where
// Become used to decide whether the drop ore the magnifier is used in the NavBar
// 0 -> Drop
// n > 0 -> Magnifier
@property (nonatomic) int searchDisplayControllerIsActive;

@property (nonatomic, strong) Settings *settings;

@end
