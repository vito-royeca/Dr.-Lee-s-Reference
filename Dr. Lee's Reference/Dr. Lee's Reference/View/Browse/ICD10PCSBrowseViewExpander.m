//
//  ICD10PCSBrowseViewExpander.m
//  Dr. Lee's Reference
//
//  Created by Jovit Royeca on 5/8/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import "ICD10PCSBrowseViewExpander.h"
#import "RADataObject.h"

@implementation ICD10PCSBrowseViewExpander

-(NSArray*) treeStructure:(int) depthLevel
{
    NSMutableArray *tree = [[NSMutableArray alloc] init];
    
    switch (depthLevel)
    {
        case 0:
        {
            [tree addObjectsFromArray:@[[RADataObject dataObjectWithName:@"Tabular" children:nil],
                                        [RADataObject dataObjectWithName:@"Index" children:nil],
                                        [RADataObject dataObjectWithName:@"Definitions" children:nil]]];

            break;
        }
    }
    
    return tree;
}

@end
