//
//  AppDelegate.m
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 11/26/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import "AppDelegate.h"
#import "DictionaryTerm.h"
#import "DrugProduct.h"
#import "MainViewController.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    [self migrateDb];
//    [self setupDb:@"database.sqlite"];

    MainViewController *mainViewController = [[MainViewController alloc] init];
    self.window.rootViewController = mainViewController;
    
    [self.window makeKeyAndVisible];

    return YES;
}

- (void) migrateDb
{
    NSArray *mappingModelNames = @[@"2to3"];
    NSDictionary *sourceStoreOptions = nil;
    
    NSURL *sourceStoreURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"database.sqlite"];
    
    NSURL *destinationStoreURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"databaseNew.sqlite"];
    
    NSString *sourceStoreType = NSSQLiteStoreType;
    NSString *destinationStoreType = NSSQLiteStoreType;
    
    NSDictionary *destinationStoreOptions = nil;
    
    for (NSString *mappingModelName in mappingModelNames)
    {
        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:mappingModelName withExtension:@"cdm"];
        
        NSMappingModel *mappingModel = [[NSMappingModel alloc] initWithContentsOfURL:fileURL];
        ;
//        NSManagedObjectModel *sourceModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"2" withExtension:@"momd"]];
        NSDictionary *sourceMetadata =
        [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:sourceStoreType
                                                                   URL:sourceStoreURL
                                                                 error:&error];
        NSManagedObjectModel *sourceModel = [NSManagedObjectModel mergedModelFromBundles:@[@"2"]
                                    forStoreMetadata:sourceMetadata];
        
        NSManagedObjectModel *destinationModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"3" withExtension:@"momd"]];
        
        NSMigrationManager *migrationManager = [[NSMigrationManager alloc] initWithSourceModel:sourceModel
                                                                              destinationModel:destinationModel];
        NSError *error;
        
        BOOL ok = [migrationManager migrateStoreFromURL:sourceStoreURL
                                                   type:sourceStoreType
                                                options:sourceStoreOptions
                                       withMappingModel:mappingModel
                                       toDestinationURL:destinationStoreURL
                                        destinationType:destinationStoreType
                                     destinationOptions:destinationStoreOptions
                                                  error:&error];
    }
}

- (void) setupDb:(NSString*) dbname
{
    NSArray *paths = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentPath = [paths lastObject];
    NSURL *storeURL = [documentPath URLByAppendingPathComponent:dbname];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[storeURL path]])
    {
        NSURL *preloadURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[dbname stringByDeletingPathExtension] ofType:@"sqlite"]];
        NSError* err = nil;
        
        if (![[NSFileManager defaultManager] copyItemAtURL:preloadURL toURL:storeURL error:&err])
        {
            NSLog(@"Error: Unable to copy preloaded database.");
        }
    }
    
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:dbname];
    
    NSLog(@"DictionaryTerm=%tu", [DictionaryTerm MR_countOfEntities]);
    NSLog(@"DrugProduct=%tu", [DrugProduct MR_countOfEntities]);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.

//    [[Database sharedInstance] saveContext];
    [MagicalRecord cleanUp];

}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
