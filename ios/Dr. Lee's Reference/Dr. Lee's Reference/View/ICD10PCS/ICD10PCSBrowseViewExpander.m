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

-(NSArray*) initialTreeStructure
{
    NSMutableArray *tree = [[NSMutableArray alloc] init];

    [tree addObjectsFromArray:@[ [[RADataObject alloc] initWithName:@"Tabular"
                                                            details:nil
                                                             parent:nil
                                                           children:nil
                                                             object:nil],
                                 [[RADataObject alloc] initWithName:@"Index"
                                                            details:nil
                                                             parent:nil
                                                           children:nil
                                                             object:nil],
                                 [[RADataObject alloc] initWithName:@"Definitions"
                                                            details:nil
                                                             parent:nil
                                                           children:nil
                                                             object:nil]]];
    return tree;
}

-(NSArray*) treeStructureForItem:(id)item
{
    NSMutableArray *tree = [[NSMutableArray alloc] init];
    
    return tree;
}

@end
