//
//  ICD10CMBrowseViewExpander.m
//  Dr. Lee's Reference
//
//  Created by Jovit Royeca on 5/8/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import "ICD10CMBrowseViewExpander.h"
#import "RADataObject.h"

@implementation ICD10CMBrowseViewExpander

-(NSArray*) treeStructure:(int) depthLevel
{
    NSMutableArray *tree = [[NSMutableArray alloc] init];
    
    switch (depthLevel)
    {
        case 0:
        {
            [tree addObjectsFromArray:@[[RADataObject dataObjectWithName:@"Tabular" children:nil],
                                        [RADataObject dataObjectWithName:@"Neoplasm" children:nil],
                                        [RADataObject dataObjectWithName:@"Drugs" children:nil],
                                        [RADataObject dataObjectWithName:@"Index" children:nil],
                                        [RADataObject dataObjectWithName:@"Extended Index" children:nil]]];
            break;
        }
    }
    
    return tree;
}

@end
