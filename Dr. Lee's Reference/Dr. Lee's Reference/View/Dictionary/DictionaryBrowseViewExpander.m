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
    
    BOOL isAplha = NO;
    for (NSString *x in [JJJUtil alphabetWithWildcard])
    {
        if ([name isEqualToString:x])
        {
            isAplha = YES;
            break;
        }
    }
    
    if (isAplha)
    {
        NSManagedObjectContext *moc = [NSManagedObjectContext MR_defaultContext];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K BEGINSWITH[cd] %@", @"termInitial", name];
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
        NSError *error;
        if ([frc performFetch:&error])
        {
            NSArray *terms = [frc fetchedObjects];
            int count = (int)terms.count;
            int mod = count / 10;
            int i = 0;
            DictionaryTerm *first, *last;
            
            while (i < count)
            {
                if (!first)
                {
                    first = [terms objectAtIndex:i];
                    i += mod;
                    continue;
                }
                if (!last)
                {
                    last = [terms objectAtIndex:i];
                }
                
                if (first && last)
                {
                    NSString *range = [NSString stringWithFormat:@"%@ - %@",
                                       first.term.length < 8 ? first.term : [first.term substringToIndex:8],
                                       last.term.length < 8 ? last.term : [last.term substringToIndex:8]];
                    RADataObject *ra = [[RADataObject alloc] initWithName:range details:nil parent:nil children:nil object:@[first, last]];
                    [tree addObject:ra];
                    
                    i += 1;
                    first = nil;
                    last = nil;
                }
            }
        }
    }
    else
    {
//        NSManagedObjectContext *moc = [NSManagedObjectContext MR_defaultContext];
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K BEGINSWITH[cd] %@", @"termInitial", name];
//        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"termInitial"
//                                                                       ascending:YES];
//        NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"term"
//                                                                        ascending:YES
//                                                                         selector:@selector(localizedCaseInsensitiveCompare:)];
//        NSEntityDescription *entity = [NSEntityDescription entityForName:@"DictionaryTerm"
//                                                  inManagedObjectContext:moc];
//        
//        [fetchRequest setPredicate:predicate];
//        [fetchRequest setEntity:entity];
//        [fetchRequest setSortDescriptors:@[sortDescriptor, sortDescriptor2]];
//        
//        NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
//                                                                              managedObjectContext:moc
//                                                                                sectionNameKeyPath:nil
//                                                                                         cacheName:nil];
    }
    
    return tree;
}

@end
