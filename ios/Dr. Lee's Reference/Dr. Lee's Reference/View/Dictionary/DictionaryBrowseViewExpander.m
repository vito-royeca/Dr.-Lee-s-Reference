//
//  DictionaryBrowseViewExpander.m
//  Dr. Lee's Reference
//
//  Created by Jovit Royeca on 5/8/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import "DictionaryBrowseViewExpander.h"
#import "JJJ/JJJ.h"
#import "Database.h"
#import "DictionaryTerm.h"
#import "RADataObject.h"

@implementation DictionaryBrowseViewExpander

-(NSArray*) initialTreeStructure
{
    NSMutableArray *tree = [[NSMutableArray alloc] init];
    
    for (NSString *alpha in [JJJUtil alphabetWithWildcard])
    {
        [tree addObject:[[RADataObject alloc] initWithName:alpha details:nil parent:nil children:nil object:nil]];
    }
    return tree;
}

-(NSArray*) treeStructureForItem:(id)item
{
    NSMutableArray *tree = [[NSMutableArray alloc] init];
    RADataObject *object = item;
    NSString *name = object.name;
    NSArray *children;
    
    BOOL isAlpha = NO;
    for (NSString *x in [JJJUtil alphabetWithWildcard])
    {
        if ([name isEqualToString:x])
        {
            isAlpha = YES;
            break;
        }
    }
    
    if (isAlpha)
    {
        NSArray *terms = [self fetchByAlphaInitial:name];
        int count = (int)terms.count;
        int mod = count / 10;
        int i = 0;
        DictionaryTerm *first, *last;
        
        while (i < count)
        {
            DictionaryTerm *term = [terms objectAtIndex:i];
            
            if ([JJJUtil stringContainsSpace:term.term])
            {
                i++;
                continue;
            }
            
            if (!first)
            {
                first = term;
                i += mod;
                continue;
            }
            if (!last)
            {
                last = term;
            }
            
            if (first && last)
            {
                NSString *range = [NSString stringWithFormat:@"%@ - %@",
                                   first.term.length < 5 ? first.term : [first.term substringToIndex:5],
                                   last.term.length < 5 ? last.term : [last.term substringToIndex:5]];
                RADataObject *ra = [[RADataObject alloc] initWithName:range details:nil parent:nil children:nil object:@[first, last]];
                [tree addObject:ra];
                
                i++;
                first = nil;
                last = nil;
            }
        }
    }
    else
    {
//        int level = 0;
//        RADataObject *parent = object.parent;
//        while (parent)
//        {
//            parent = parent.parent;
//            level++;
//        }
//        
//        NSArray *terms = [self fetchByFirst:@"" andLast:@""];
//        
//        switch (level)
//        {
//            case 0:
//            {
//                break;
//            }
//            case 1:
//            {
//                break;
//            }
//        }
        NSArray *array = object.object;
        NSArray *terms = [self fetchByFirst:[array firstObject] andLast:[array lastObject]];
        NSLog(@"%@", terms);
    }
    
    return tree;
}

-(NSArray*) fetchByAlphaInitial:(NSString*) initial
{
    NSManagedObjectContext *moc = [NSManagedObjectContext MR_defaultContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K BEGINSWITH[cd] %@", @"termInitial", initial];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"termInitial"
                                                                   ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"term"
                                                                    ascending:YES
                                                                     selector:@selector(localizedCaseInsensitiveCompare:)];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DictionaryTerm"
                                              inManagedObjectContext:moc];
    
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:@[sortDescriptor, sortDescriptor2]];
    
    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                          managedObjectContext:moc
                                                                            sectionNameKeyPath:nil
                                                                                     cacheName:nil];
    NSArray *arrResults = @[];
    
    NSError *error;
    if ([frc performFetch:&error])
    {
        arrResults = [frc fetchedObjects];
    }
    
    return arrResults;
}

-(NSArray*) fetchByFirst:(DictionaryTerm*) first andLast:(DictionaryTerm*) last
{
    NSManagedObjectContext *moc = [NSManagedObjectContext MR_defaultContext];
//    NSString *regex = [NSString stringWithFormat:@"(?i)(%@).*|(?i)(%@).*",
//                       first.term.length <5 ? first.term : [first.term substringToIndex:5],
//                       last.term.length <5 ? last.term : [last.term substringToIndex:5]];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K MATCHES '%@'", @"term", regex];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K BEGINSWITH[cd] %@ AND %K <= %@",
                              @"term",
                              first.term.length <5 ? first.term : [first.term substringToIndex:5],
                              @"term",
                              last.term.length <5 ? last.term : [last.term substringToIndex:5]];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"termInitial"
                                                                   ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"term"
                                                                    ascending:YES
                                                                     selector:@selector(localizedCaseInsensitiveCompare:)];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DictionaryTerm"
                                              inManagedObjectContext:moc];
    
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:@[sortDescriptor2]];
    
    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                          managedObjectContext:moc
                                                                            sectionNameKeyPath:nil
                                                                                     cacheName:nil];
    NSArray *arrResults = @[];
    
    NSError *error;
    if ([frc performFetch:&error])
    {
        arrResults = [frc fetchedObjects];
    }
    
    return arrResults;
}

@end
