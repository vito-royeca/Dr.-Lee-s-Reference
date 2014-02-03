//
//  Database.m
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 2/3/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import "Database.h"

@implementation Database
{
    JJJCoreData *_coreData;
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
        _coreData = [JJJCoreData sharedInstanceWithModel:@"database"];
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
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DictionaryTerm"
                                              inManagedObjectContext:[_coreData managedObjectContext]];
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
            NSArray *relationshipKeys = [NSArray arrayWithObject:@"dictionaryDefinition"];
            
            [fetchRequest setRelationshipKeyPathsForPrefetching:relationshipKeys];
        }
    }
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"term" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setFetchBatchSize:kFetchBatchSize];
    
    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                          managedObjectContext:[_coreData managedObjectContext]
                                                                            sectionNameKeyPath:nil
                                                                                     cacheName:nil];
    return frc;
}

- (NSFetchedResultsController*)searchDrugs:(NSString*)query narrowSearch:(BOOL)narrow
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Product"
                                              inManagedObjectContext:[_coreData managedObjectContext]];
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
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"drugName" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setFetchBatchSize:kFetchBatchSize];
    
    fetchRequest.resultType = NSDictionaryResultType;
    fetchRequest.propertiesToFetch = [NSArray arrayWithObjects:@"drugName", @"activeIngred", nil];
    fetchRequest.returnsDistinctResults = YES;
    
    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                          managedObjectContext:[_coreData managedObjectContext]
                                                                            sectionNameKeyPath:nil
                                                                                     cacheName:nil];
    return frc;
    
    //    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    //
    //    for (Product *p in fetchedObjects)
    //    {
    //        NSMutableDictionary *dict;
    //        NSString *applNoString = [NSString stringWithFormat:@"%@ # %@", [p.applNo applTypeString], p.applNo.applNo];
    //
    //        for (NSMutableDictionary *d in arrDrugs)
    //        {
    //            if ([[d objectForKey:@"Drug Name"] isEqualToString:p.drugName])
    //            {
    //                dict = d;
    //                break;
    //            }
    //        }
    //
    //        if (dict)
    //        {
    //            NSMutableArray *arrForms = [dict objectForKey:@"Forms and Strengths"];
    //            BOOL bHasForm = NO;
    //            for (NSMutableDictionary *dictForms in arrForms)
    //            {
    //                if ([dictForms objectForKey:p.form])
    //                {
    //                    NSMutableArray *forms = [dictForms objectForKey:p.form];
    //
    //                    if (![forms containsObject:p.dosage])
    //                    {
    //                        [forms addObject:p.dosage];
    //                    }
    //                    bHasForm = YES;
    //                }
    //            }
    //            if (!bHasForm)
    //            {
    //                NSMutableDictionary *dictForms = [[NSMutableDictionary alloc] init];
    //                NSMutableArray *forms = [[NSMutableArray alloc] init];
    //                [forms addObject:p.dosage];
    //                [dictForms setObject:forms forKey:p.form];
    //                [arrForms addObject:dictForms];
    //            }
    //
    //            NSMutableArray *arrDetails = [dict objectForKey:@"Details"];
    //            BOOL bHasDetail = NO;
    //            for (NSMutableDictionary *dictDetails in arrDetails)
    //            {
    //                if ([[dictDetails objectForKey:@"ApplNo"] isEqualToString:applNoString])
    //                {
    //                    NSMutableArray *drugs = [dictDetails objectForKey:@"Drugs"];
    //
    //                    if (![drugs containsObject:p])
    //                    {
    //                        [drugs addObject:p];
    //                    }
    //                    bHasDetail = YES;
    //                }
    //            }
    //            if (!bHasDetail)
    //            {
    //                NSMutableDictionary *dictDetails = [[NSMutableDictionary alloc] init];
    //                [dictDetails setObject:p.drugName forKey:@"Drug Name"];
    //                [dictDetails setObject:applNoString forKey:@"ApplNo"];
    //                [dictDetails setObject:p.activeIngred forKey:@"Active Ingredient(s)"];
    //                [dictDetails setObject:p.applNo.sponsorApplicant forKey:@"Company"];
    //                [dictDetails setObject:p.applNo.sponsorApplicant forKey:@"Date"];
    //                NSMutableArray *drugs = [[NSMutableArray alloc] init];
    //                [drugs addObject:p];
    //                [dictDetails setObject:drugs forKey:@"Drugs"];
    //                [arrDetails addObject:dictDetails];
    //            }
    //        }
    //        else
    //        {
    //            dict = [[NSMutableDictionary alloc] init];
    //
    //            [dict setObject:p.drugName forKey:@"Drug Name"];
    //            [dict setObject:p.activeIngred forKey:@"Active Ingredient(s)"];
    //
    //            NSMutableDictionary *dictForms = [[NSMutableDictionary alloc] init];
    //            NSMutableArray *forms = [[NSMutableArray alloc] init];
    //            [forms addObject:p.dosage];
    //            [dictForms setObject:forms forKey:p.form];
    //            NSMutableArray *arrForms = [[NSMutableArray alloc] init];
    //            [arrForms addObject:dictForms];
    //            [dict setObject:arrForms forKey:@"Forms and Strengths"];
    //
    //            NSMutableDictionary *dictDetails = [[NSMutableDictionary alloc] init];
    //            [dictDetails setObject:p.drugName forKey:@"Drug Name"];
    //            [dictDetails setObject:applNoString forKey:@"ApplNo"];
    //            [dictDetails setObject:p.activeIngred forKey:@"Active Ingredient(s)"];
    //            [dictDetails setObject:p.applNo.sponsorApplicant forKey:@"Company"];
    //            [dictDetails setObject:p.applNo.sponsorApplicant forKey:@"Date"];
    //            NSMutableArray *drugs = [[NSMutableArray alloc] init];
    //            [drugs addObject:p];
    //            [dictDetails setObject:drugs forKey:@"Drugs"];
    //            NSMutableArray *arrDetails = [[NSMutableArray alloc] init];
    //            [arrDetails addObject:dictDetails];
    //            [dict setObject:arrDetails forKey:@"Details"];
    //
    //            [arrDrugs addObject:dict];
    //        }
    //    }
    //
    //    return nil;
}

- (void)saveContext
{
    [_coreData save];
}

@end
