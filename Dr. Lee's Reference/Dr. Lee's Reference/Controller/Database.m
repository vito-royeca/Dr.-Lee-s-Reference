//
//  Database.m
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 2/3/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import "Database.h"
#import "DictionaryTerm.h"
#import "Product.h"

@implementation Database
{
//    JJJCoreData *_coreData;
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
//        _coreData = [JJJCoreData sharedInstanceWithModel:@"database"];
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
            NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"%K CONTAINS[cd] %@", @"dictionaryDefinition.definition", query];
            predicate = [NSCompoundPredicate orPredicateWithSubpredicates:[NSArray arrayWithObjects:pred1, pred2, nil]];
        }
    }
//
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"term" ascending:YES];
//    [fetchRequest setSortDescriptors:@[sortDescriptor]];
//    [fetchRequest setEntity:entity];
//    [fetchRequest setPredicate:predicate];
//    [fetchRequest setFetchBatchSize:kFetchBatchSize];
//    
//    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
//                                                                          managedObjectContext:[_coreData managedObjectContext]
//                                                                            sectionNameKeyPath:nil
//                                                                                     cacheName:nil];
//    return frc;
    
    return [DictionaryTerm MR_fetchAllSortedBy:@"term"
                                     ascending:YES
                                 withPredicate:predicate
                                       groupBy:nil
                                      delegate:nil];

}

- (NSFetchedResultsController*)searchDrugs:(NSString*)query narrowSearch:(BOOL)narrow
{
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
    
//    NSFetchRequest *fetchRequest = [Product MR_requestAllWithPredicate:predicate];
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"drugName" ascending:YES];
//    [fetchRequest setSortDescriptors:@[sortDescriptor]];
//    [fetchRequest setFetchBatchSize:kFetchBatchSize];
//    fetchRequest.propertiesToFetch = [NSArray arrayWithObjects:@"drugName", @"activeIngred", nil];
//    fetchRequest.returnsDistinctResults = YES;
//    
//    return [Product MR_fetchController:fetchRequest
//                              delegate:nil
//                          useFileCache:YES
//                             groupedBy:nil
//                             inContext:[NSManagedObjectContext MR_defaultContext]];

    
//        
//    return [Product MR_fetchAllSortedBy:@"drugName"
//                              ascending:YES
//                          withPredicate:predicate
//                                groupBy:nil
//                               delegate:nil];
//
    NSFetchRequest *fetchRequest = [Product MR_requestAllSortedBy:@"drugName" ascending:NO];
//    [fetchRequest setFetchLimit:100];
    [fetchRequest setFetchBatchSize:kFetchBatchSize];
    [fetchRequest setReturnsDistinctResults:YES];
    [fetchRequest setPredicate:predicate];

    
    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                          managedObjectContext:[NSManagedObjectContext MR_contextForCurrentThread]
                                                                            sectionNameKeyPath:nil
                                                                                     cacheName:@"ProductCache"];
    return frc;
}

@end
