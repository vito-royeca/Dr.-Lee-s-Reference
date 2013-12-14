//
//  DataLoader.m
//  Mobile Drugs@FDA
//
//  Created by Jovito Royeca on 11/20/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import "Database.h"

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
    return (int)fetchedObjects.count;
}

-(NSArray*) find:(NSString*)tableName
      columnName:(NSString*)columnName
     columnValue:(id)columnValue
       relationshipKeys:(NSArray*)relationshipKeys
         sorters:(NSArray*)sorters
{
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName
                                              inManagedObjectContext:[self managedObjectContext]];
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"%K == %@", columnName, columnValue];
    
    if (relationshipKeys)
    {
        [fetchRequest setRelationshipKeyPathsForPrefetching:relationshipKeys];
    }
    if (sorters)
    {
        NSMutableArray *arrSorters = [[NSMutableArray alloc] initWithCapacity:sorters.count];
        
        for (NSDictionary *dict in sorters)
        {
            NSString *key = [[dict allKeys] objectAtIndex:0];
            NSSortDescriptor *descriptor = [[NSSortDescriptor alloc]
                                                 initWithKey:key ascending:[[dict objectForKey:key] boolValue]];
            [arrSorters addObject:descriptor];
        }
        [fetchRequest setSortDescriptors:arrSorters];
    }
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    if (error)
    {
        NSLog(@"fetch error: %@ : %@", error, [error userInfo]);
        return [NSArray arrayWithObjects:nil, nil];
    }
    else
    {
        return fetchedObjects;
    }
}

-(NSArray*) findAll:(NSString*)tableName
            sorters:(NSArray*)sorters
{
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName
                                              inManagedObjectContext:[self managedObjectContext]];
    if (sorters)
    {
        NSMutableArray *arrSorters = [[NSMutableArray alloc] initWithCapacity:sorters.count];
        
        for (NSDictionary *dict in sorters)
        {
            NSString *key = [[dict allKeys] objectAtIndex:0];
            NSSortDescriptor *descriptor = [[NSSortDescriptor alloc]
                                            initWithKey:key ascending:[[dict objectForKey:key] boolValue]];
            [arrSorters addObject:descriptor];
        }
        [fetchRequest setSortDescriptors:arrSorters];
    }
    [fetchRequest setEntity:entity];
    
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    if (error)
    {
        NSLog(@"fetch error: %@ : %@", error, [error userInfo]);
        return [NSArray arrayWithObjects:nil, nil];
    }
    else
    {
        return fetchedObjects;
    }
}

-(NSArray*) search:(DataSource)dataSource query:(NSString*)query
{
    switch (dataSource)
    {
        case DictionaryDataSource:
        {
            return [self searchDictionary:query];
        }
        case DrugsDataSource:
        {
            return [self searchDrugs:query];
        }
        case ICD10DataSource:
        default:
        {
            return  [NSArray array];
        }
    }
}

-(NSArray*) searchDictionary:(NSString*)query
{
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Dictionary"
                                              inManagedObjectContext:[self managedObjectContext]];
    NSPredicate *predicate;
    NSMutableArray *arrDictionary = [[NSMutableArray  alloc] init];
    
    if (query.length == 0)
    {
        return arrDictionary;
    }
    else if (query.length == 1)
    {
        predicate = [NSPredicate
                     predicateWithFormat:@"%K BEGINSWITH[cd] %@",
                     @"term", query];
    }
    else
    {
        predicate = [NSPredicate
                     predicateWithFormat:@"%K CONTAINS[cd] %@ OR %K CONTAINS[cd] %@",
                     @"term", query,
                     @"definition", query];
    }
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                         initWithKey:@"term" ascending:YES];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
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
                     predicateWithFormat:@"%K CONTAINS[cd] %@ OR %K CONTAINS[cd] %@",
                     @"drugName", query,
                     @"activeIngred", query];
    }
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"drugName" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    for (Product *p in fetchedObjects)
    {
        NSMutableDictionary *dict;
        NSString *applNoString = [NSString stringWithFormat:@"%@ # %@", [p.applNo applTypeString], p.applNo.applNo];
        
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
            NSMutableArray *arrForms = [dict objectForKey:@"Forms and Strengths"];
            BOOL bHasForm = NO;
            for (NSMutableDictionary *dictForms in arrForms)
            {
                if ([dictForms objectForKey:p.form])
                {
                    NSMutableArray *forms = [dictForms objectForKey:p.form];
                    
                    if (![forms containsObject:p.dosage])
                    {
                        [forms addObject:p.dosage];
                    }
                    bHasForm = YES;
                }
            }
            if (!bHasForm)
            {
                NSMutableDictionary *dictForms = [[NSMutableDictionary alloc] init];
                NSMutableArray *forms = [[NSMutableArray alloc] init];
                [forms addObject:p.dosage];
                [dictForms setObject:forms forKey:p.form];
                [arrForms addObject:dictForms];
            }
            
            NSMutableArray *arrDetails = [dict objectForKey:@"Details"];
            BOOL bHasDetail = NO;
            for (NSMutableDictionary *dictDetails in arrDetails)
            {
                if ([[dictDetails objectForKey:@"ApplNo"] isEqualToString:applNoString])
                {
                    NSMutableArray *drugs = [dictDetails objectForKey:@"Drugs"];
                    
                    if (![drugs containsObject:p])
                    {
                        [drugs addObject:p];
                    }
                    bHasDetail = YES;
                }
            }
            if (!bHasDetail)
            {
                NSMutableDictionary *dictDetails = [[NSMutableDictionary alloc] init];
                [dictDetails setObject:p.drugName forKey:@"Drug Name"];
                [dictDetails setObject:applNoString forKey:@"ApplNo"];
                [dictDetails setObject:p.activeIngred forKey:@"Active Ingredient(s)"];
                [dictDetails setObject:p.applNo.sponsorApplicant forKey:@"Company"];
                [dictDetails setObject:p.applNo.sponsorApplicant forKey:@"Date"];
                NSMutableArray *drugs = [[NSMutableArray alloc] init];
                [drugs addObject:p];
                [dictDetails setObject:drugs forKey:@"Drugs"];
                [arrDetails addObject:dictDetails];
            }
        }
        else
        {
            dict = [[NSMutableDictionary alloc] init];
            
            [dict setObject:p.drugName forKey:@"Drug Name"];
            [dict setObject:p.activeIngred forKey:@"Active Ingredient(s)"];
            
            NSMutableDictionary *dictForms = [[NSMutableDictionary alloc] init];
            NSMutableArray *forms = [[NSMutableArray alloc] init];
            [forms addObject:p.dosage];
            [dictForms setObject:forms forKey:p.form];
            NSMutableArray *arrForms = [[NSMutableArray alloc] init];
            [arrForms addObject:dictForms];
            [dict setObject:arrForms forKey:@"Forms and Strengths"];
            
            NSMutableDictionary *dictDetails = [[NSMutableDictionary alloc] init];
            [dictDetails setObject:p.drugName forKey:@"Drug Name"];
            [dictDetails setObject:applNoString forKey:@"ApplNo"];
            [dictDetails setObject:p.activeIngred forKey:@"Active Ingredient(s)"];
            [dictDetails setObject:p.applNo.sponsorApplicant forKey:@"Company"];
            [dictDetails setObject:p.applNo.sponsorApplicant forKey:@"Date"];
            NSMutableArray *drugs = [[NSMutableArray alloc] init];
            [drugs addObject:p];
            [dictDetails setObject:drugs forKey:@"Drugs"];
            NSMutableArray *arrDetails = [[NSMutableArray alloc] init];
            [arrDetails addObject:dictDetails];
            [dict setObject:arrDetails forKey:@"Details"];
            
            [arrDrugs addObject:dict];
        }
    }
    
    return arrDrugs;
}

-(id) createManagedObject:(NSString*)name
{
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:name
                                                            inManagedObjectContext:self.managedObjectContext];
    return object;
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

#if defined(_OS_IPHONE) || defined(_OS_IPHONE_SIMULATOR)
    if (![[NSFileManager defaultManager] fileExistsAtPath:[storeURL path]])
    {
        NSURL *preloadURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"database" ofType:@"sqlite"]];
        NSError* error = nil;
        
        if (![[NSFileManager defaultManager] copyItemAtURL:preloadURL toURL:storeURL error:&error])
        {
            NSLog(@"Error copying database.sqlite: %@", error);
        }
    }
#endif

    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],
                          NSMigratePersistentStoresAutomaticallyOption,
                          [NSNumber numberWithBool:YES],
                          NSInferMappingModelAutomaticallyOption, nil];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
                                                             URL:storeURL
                                                         options:dict
                                                           error:&error])
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
