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
        case ICD10DataSource:
        default:
        {
            return nil;
        }
    }
}

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
            predicate = [NSCompoundPredicate orPredicateWithSubpredicates:[NSArray arrayWithObjects:pred1, pred2, nil]];
        }
    }

    NSManagedObjectContext *moc = [NSManagedObjectContext MR_contextForCurrentThread];
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Product"
                                              inManagedObjectContext:[NSManagedObjectContext MR_contextForCurrentThread]];

    [fetchRequest setFetchBatchSize:kFetchBatchSize];
//    [fetchRequest setReturnsDistinctResults:YES];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    return [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                               managedObjectContext:[NSManagedObjectContext MR_contextForCurrentThread]
                                                 sectionNameKeyPath:@"drugNameInitial"
                                                          cacheName:@"DrugCache"];
}

@end
