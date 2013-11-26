//
//  DataLoader.m
//  Mobile Drugs@FDA
//
//  Created by Jovito Royeca on 11/20/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import "Database.h"
#import "AppDelegate.h"

@implementation Database

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (id)sharedInstance
{
    static Database *me = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        me = [[self alloc] init];
    });
    return me;
}

- (id)init
{
    if (self = [super init])
    {
//        self.persistentStoreCoordinator;
    }
    return self;
}

- (void)dealloc
{
    // Should never be called, but just here for clarity really.
}

- (BOOL) bIsTableEmpty:(NSString*)tableName
{
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName
                                              inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchLimit:1];
    
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects.count <= 0;
}

-(int) tableCount:(NSString*)tableName
{
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName
                                              inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    return fetchedObjects.count;
}

-(id) objectByName:(NSString*)tableName andIdName:(NSString*)idName andIdValue:(id)idValue
{
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName
                                              inManagedObjectContext:[self managedObjectContext]];
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"%K == %@", idName, idValue];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects.count > 0 ? [fetchedObjects objectAtIndex:0] : nil;
}

-(NSArray*) searchDrugs:(NSString*)query
{
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Product"
                                              inManagedObjectContext:[self managedObjectContext]];
    NSPredicate *predicate;
    NSMutableArray *arrDrugs = [[NSMutableArray  alloc] init];

    if (query.length == 0)
    {
        return arrDrugs;
    }
    else if (query.length == 1)
    {
        predicate = [NSPredicate
                     predicateWithFormat:@"%K BEGINSWITH[cd] %@",
                     @"drugName", query];
    }
    else
    {
        predicate = [NSPredicate
                     predicateWithFormat:@"%K CONTAINS[cd] %@ OR %K CONTAINS[cd] %@ OR %K CONTAINS[cd] %@",
                     @"drugName", query,
                     @"activeIngred", query,
                     @"applNo.sponsorApplicant", query];
    }
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"drugName" ascending:YES];
    
    NSArray *relationshipKeys = [NSArray arrayWithObject:@"applNo"];
    
    [fetchRequest setRelationshipKeyPathsForPrefetching:relationshipKeys];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    
    for (Product *p in fetchedObjects)
    {
        NSMutableDictionary *dict;
        
        for (NSMutableDictionary *d in arrDrugs)
        {
            if ([[d objectForKey:@"Drug Name"] isEqualToString:p.drugName])
            {
                dict = d;
                break;
            }
        }
        
        if (dict)
        {
//            NSMutableArray *drugs = [dict objectForKey:@"Products"];
//            
//            [drugs addObject:p];
            
            NSMutableArray *arrForms = [dict objectForKey:@"Forms and Strengths"];
            BOOL bHasForm = NO;
            for (NSMutableDictionary *dictForms in arrForms)
            {
                if ([dictForms objectForKey:p.form])
                {
                    NSMutableString *forms = [dictForms objectForKey:p.form];
                    
                    if (![Util string:forms containsString:p.dosage])
                    {
                        [forms appendFormat:@"%@%@", forms.length > 0 ? @"; ":@"", p.dosage];
                    }
                    bHasForm = YES;
                }
            }
            
            if (!bHasForm)
            {
                NSMutableDictionary *dictForms = [[NSMutableDictionary alloc] init];
                NSMutableString *forms = [[NSMutableString alloc] init];
                [forms appendFormat:@"%@", p.dosage];
                [dictForms setObject:forms forKey:p.form];
                [arrForms addObject:dictForms];
            }
        }
        else
        {
            dict = [[NSMutableDictionary alloc] init];
            
            [dict setObject:p.drugName forKey:@"Drug Name"];
            [dict setObject:p.activeIngred forKey:@"Active Ingredient(s)"];
            
            NSMutableDictionary *dictForms = [[NSMutableDictionary alloc] init];
            NSMutableString *forms = [[NSMutableString alloc] init];
            [forms appendFormat:@"%@", p.dosage];
            [dictForms setObject:forms forKey:p.form];
            NSMutableArray *arrForms = [[NSMutableArray alloc] init];
            [arrForms addObject:dictForms];
            [dict setObject:arrForms forKey:@"Forms and Strengths"];
            
            
            [arrDrugs addObject:dict];
        }
    }
    
    return arrDrugs;
}

-(NSArray*) searchAllDrugs
{
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Product"
                                              inManagedObjectContext:[self managedObjectContext]];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"drugName" ascending:YES];
    
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    [fetchRequest setEntity:entity];
    
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"database" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"database.sqlite"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[storeURL path]])
    {
        NSURL *preloadURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"database" ofType:@"sqlite"]];
        
        NSError* err = nil;
        
        if (![[NSFileManager defaultManager] copyItemAtURL:preloadURL toURL:storeURL error:&err])
        {
            NSLog(@"Oops, could copy preloaded data");
        }
    }
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
