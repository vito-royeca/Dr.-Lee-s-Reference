//
//  Database.m
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 2/3/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import "Database.h"
#import "DictionaryTerm.h"
#import "DrugProduct.h"

@implementation Database
{

}

static Database *_me;

+(id) sharedInstance
{
    if (!_me)
    {
        _me = [[Database alloc] init];
    }
    
    return _me;
}

-(id) init
{
    if (self = [super init])
    {

    }
    
    return self;
}

- (void) setupDb
{
#if defined(_OS_IPHONE) || defined(_OS_IPHONE_SIMULATOR)
    NSArray *paths = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentPath = [paths lastObject];
    NSURL *storeURL = [documentPath URLByAppendingPathComponent:kDatabaseStore];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[storeURL path]])
    {
        NSURL *preloadURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[kDatabaseStore stringByDeletingPathExtension] ofType:@"sqlite"]];
        NSError* err = nil;
        
        if (![[NSFileManager defaultManager] copyItemAtURL:preloadURL toURL:storeURL error:&err])
        {
            NSLog(@"Error: Unable to copy preloaded database.");
        }
    }
#endif

//    MigrationManager *manager = [[MigrationManager alloc] init];
//    NSLog(@"needs migration? %@", [manager isMigrationNeeded] ? @"YES":@"NO");
    
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:kDatabaseStore];
}

- (void) closeDb
{
    [MagicalRecord cleanUp];
}

#if defined(_OS_IPHONE) || defined(_OS_IPHONE_SIMULATOR)
- (NSFetchedResultsController*)search:(DataSource)dataSource
                                query:(NSString*)query
                         narrowSearch:(BOOL)narrow
{
    switch (dataSource)
    {
        case DictionaryDataSource:
        {
            return [self searchDictionary:query narrowSearch:narrow];
        }
        case DrugsDataSource:
        {
            return [self searchDrugs:query narrowSearch:narrow];
        }
        case ICD10CMDataSource:
        case ICD10PCSDataSource:
        default:
        {
            return nil;
        }
    }
}
#endif

- (NSArray*) searchRange:(DataSource)dataSource
              startQuery:(NSString*)startQuery
                endQuery:(NSString*)endQuery
              limit:(int)limit
{
    NSArray *all = [DictionaryTerm MR_findAll];
    int count500s = (int) all.count / 500;
    int mod500s   = all.count% 500;
//
//    
//    NSArray *arrResult = [[NSArray alloc] init];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K BEGINSWITH[cd] %@", @"term", startQuery];
//    
//    
//    NSManagedObjectContext *moc = [NSManagedObjectContext MR_contextForCurrentThread];
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"term"
//                                                                    ascending:YES
//                                                                     selector:@selector(localizedCaseInsensitiveCompare:)];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DictionaryTerm"
//                                              inManagedObjectContext:moc];
//    
//    [fetchRequest setPredicate:predicate];
//    [fetchRequest setEntity:entity];
//    [fetchRequest setSortDescriptors:@[sortDescriptor]];
//    [fetchRequest setFetchBatchSize:kFetchBatchSize];
//    
//    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
//                                                                          managedObjectContext:moc
//                                                                            sectionNameKeyPath:@"term"
//                                                                                     cacheName:@"DictionaryCache"];
//    
//    NSError *error;
//    if ([frc performFetch:&error])
//    {
//        arrResult = [frc fetchedObjects];
//    }
//    return arrResult;
    return nil;
}

#if defined(_OS_IPHONE) || defined(_OS_IPHONE_SIMULATOR)
- (NSFetchedResultsController*)searchDictionary:(NSString*)query narrowSearch:(BOOL)narrow
{
    // Delete cache first, if a cache is used
//    [NSFetchedResultsController deleteCacheWithName:@"DictionaryCache"];
    
    NSPredicate *predicate;
    
    if (query.length == 0)
    {
        return nil;
    }
    else if (query.length == 1)
    {
        predicate = [NSPredicate predicateWithFormat:@"%K BEGINSWITH[cd] %@", @"term", query];
    }
    else
    {
        if (narrow)
        {
            predicate = [NSPredicate predicateWithFormat:@"%K BEGINSWITH[cd] %@", @"term", query];
        }
        else
        {
            NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"%K CONTAINS[cd] %@", @"term", query];
            NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"%K CONTAINS[cd] %@", @"definition", query];
            predicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[pred1, pred2]];
        }
    }

    NSManagedObjectContext *moc = [NSManagedObjectContext MR_defaultContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"termInitial"
                                                                   ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"term"
                                                                    ascending:YES
                                                                     selector:@selector(localizedCaseInsensitiveCompare:)];
    NSArray *sortDescriptors = @[sortDescriptor, sortDescriptor2];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DictionaryTerm"
                                              inManagedObjectContext:moc];
    
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setFetchBatchSize:kFetchBatchSize];
    
    return [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                               managedObjectContext:moc
                                                 sectionNameKeyPath:@"termInitial"
                                                          cacheName:@"DictionaryCache"];
}
#endif

#if defined(_OS_IPHONE) || defined(_OS_IPHONE_SIMULATOR)
- (NSFetchedResultsController*)searchDrugs:(NSString*)query narrowSearch:(BOOL)narrow
{
    // Delete cache first, if a cache is used
    [NSFetchedResultsController deleteCacheWithName:@"DrugCache"];
    
    NSPredicate *predicate;
    
    if (query.length == 0)
    {
        return nil;
    }
    else if (query.length == 1)
    {
        predicate = [NSPredicate predicateWithFormat:@"%K BEGINSWITH[cd] %@", @"drugName", query];
    }
    else
    {
        if (narrow)
        {
            predicate = [NSPredicate predicateWithFormat:@"%K BEGINSWITH[cd] %@", @"drugName", query];
        }
        else
        {
            NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"%K CONTAINS[cd] %@", @"drugName", query];
            NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"%K CONTAINS[cd] %@", @"activeIngred", query];
            predicate = [NSCompoundPredicate orPredicateWithSubpredicates:[NSArray arrayWithObjects:pred1, pred2, nil]];
        }
    }

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"drugName"
                                                                   ascending:YES
                                                                    selector:@selector(localizedCaseInsensitiveCompare:)];
    NSArray *sortDescriptors = @[sortDescriptor];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DrugProduct"
                                              inManagedObjectContext:[NSManagedObjectContext MR_contextForCurrentThread]];

    [fetchRequest setFetchBatchSize:kFetchBatchSize];
//    [fetchRequest setReturnsDistinctResults:YES];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    return [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                               managedObjectContext:[NSManagedObjectContext MR_contextForCurrentThread]
                                                 sectionNameKeyPath:@"drugName"
                                                          cacheName:@"DrugCache"];
}
#endif

@end
