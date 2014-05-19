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

-(NSArray*) treeStructureForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    NSMutableArray *tree = [[NSMutableArray alloc] init];
    RADataObject *object = item;
    
    switch (treeNodeInfo.treeDepthLevel)
    {
        case 0:
        {
            NSFetchedResultsController *frc = [[Database sharedInstance] search:DictionaryDataSource
                                                                          query:object.name
                                                                   narrowSearch:NO];
            NSError *error;
            if ([frc performFetch:&error])
            {
                for (DictionaryTerm *dict in [frc fetchedObjects])
                {
                    RADataObject *ra = [[RADataObject alloc] initWithName:dict.term details:nil parent:object children:nil object:dict];
                    [tree addObject:ra];
                }
            }

            break;
        }
    }
    
    return tree;
}

@end
